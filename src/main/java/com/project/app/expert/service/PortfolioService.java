package com.project.app.expert.service;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.project.app.expert.model.ExpertPortfolioDto;
import com.project.app.expert.model.PortfolioImageDto;
import com.project.app.expert.repository.PortfolioDao;

import lombok.RequiredArgsConstructor;

/**
 * 포트폴리오 글 + 사진
 */
@Service
@RequiredArgsConstructor
public class PortfolioService {

	//글 하나에 올릴 수 있는 사진 수 (tbl_portfolio_image.slot 1 ~ 5)
	private static final int MAX_IMAGES = 5;

	//사진으로 받을 수 있는 확장자
	private static final Set<String> IMAGE_EXT = Set.of("jpg", "jpeg", "png", "gif");

	private final PortfolioDao portfolioDao;

	public ExpertPortfolioDto getPortfolio(Long portfolioSeq) {
		ExpertPortfolioDto pdto = portfolioDao.getPortfolio(portfolioSeq);
		return pdto;
	}

	public List<PortfolioImageDto> getPortfolioImages(Long portfolioSeq) {
		List<PortfolioImageDto> imgList = portfolioDao.getPortfolioImages(portfolioSeq);
		return imgList;
	}

	/**
	 * 포트폴리오 작성
	 * 글 INSERT → 사진 파일 저장 → 사진 INSERT 를 한 번에 처리한다. 중간에 실패하면 전부 취소된다.
	 * @return 1: 성공, 0: 잘못된 입력, -1: 사진 5장 초과, -2: 이미지가 아닌 파일
	 */
	@Transactional
	public int add(ExpertPortfolioDto dto, List<MultipartFile> files, String uploadPath) {

		if (!isValidText(dto)) {
			return 0;
		}

		List<MultipartFile> images = new ArrayList<>();
		int imageResult = checkImages(files, images);

		if (imageResult != 1) {
			return imageResult;
		}

		//selectKey 가 dto.portfolioSeq 에 새 번호를 넣어 준다
		portfolioDao.addPortfolio(dto);

		saveImages(dto.getPortfolioSeq(), images, uploadPath);

		return 1;
	}

	/**
	 * 포트폴리오 수정
	 * 사진을 새로 올리지 않으면 기존 사진을 그대로 두고, 올리면 기존 사진을 전부 바꾼다.
	 * @return 1: 성공, 0: 잘못된 입력, -1: 사진 5장 초과, -2: 이미지가 아닌 파일
	 */
	@Transactional
	public int edit(ExpertPortfolioDto dto, List<MultipartFile> files, String uploadPath) {

		if (!isValidText(dto)) {
			return 0;
		}

		List<MultipartFile> images = new ArrayList<>();
		int imageResult = checkImages(files, images);

		if (imageResult != 1) {
			return imageResult;
		}

		//where 에 expert_seq 까지 걸려 있어서, 내 글이 아니면 0줄이 바뀐다
		if (portfolioDao.editPortfolio(dto) == 0) {
			return 0;
		}

		if (images.isEmpty()) {
			return 1;
		}

		//기존 사진 파일 이름은 DB 행을 지우기 전에 받아 둔다
		List<PortfolioImageDto> oldImages = portfolioDao.getPortfolioImages(dto.getPortfolioSeq());

		portfolioDao.deletePortfolioImages(dto.getPortfolioSeq());
		saveImages(dto.getPortfolioSeq(), images, uploadPath);

		//DB 작업이 다 끝난 뒤에 기존 파일을 지운다 (중간에 실패하면 DB는 되돌아가는데 파일만 사라지는 걸 막는다)
		deleteFiles(oldImages, uploadPath);

		return 1;
	}

	/**
	 * 포트폴리오 삭제
	 * 사진 행과 서비스 연결은 CASCADE 로 같이 지워지지만, 서버의 파일은 남아서 직접 지운다.
	 * @return 1: 성공, 0: 지운 글 없음 (없는 글이거나 내 글이 아님)
	 */
	@Transactional
	public int delete(ExpertPortfolioDto dto, String uploadPath) {

		//CASCADE 로 행이 사라지기 전에 파일 이름을 받아 둔다
		List<PortfolioImageDto> images = portfolioDao.getPortfolioImages(dto.getPortfolioSeq());

		if (portfolioDao.deletePortfolio(dto) == 0) {
			return 0;
		}

		deleteFiles(images, uploadPath);

		return 1;
	}

	//서버에 저장한 사진 파일 지우기 (수정, 삭제에서 같이 쓴다)
	private void deleteFiles(List<PortfolioImageDto> images, String uploadPath) {

		for (PortfolioImageDto image : images) {
			new File(uploadPath, image.getFileName()).delete();
		}
	}

	/**
	 * 사진 파일 저장 + 사진 INSERT (작성, 수정에서 같이 쓴다)
	 * 올린 순서대로 slot 1 ~ 5, 1번이 대표 사진
	 */
	private void saveImages(Long portfolioSeq, List<MultipartFile> images, String uploadPath) {

		List<File> saved = new ArrayList<>();

		try {
			File dir = new File(uploadPath);

			if (!dir.exists()) {
				dir.mkdirs();
			}

			int slot = 1;

			for (MultipartFile image : images) {
				//경로가 섞여 들어와도 파일 이름만 쓴다
				String originName = Paths.get(image.getOriginalFilename()).getFileName().toString();
				String fileName = UUID.randomUUID() + "_" + originName;

				File target = new File(dir, fileName);
				image.transferTo(target);
				saved.add(target);

				PortfolioImageDto imageDto = new PortfolioImageDto();
				imageDto.setPortfolioSeq(portfolioSeq);
				imageDto.setFileName(fileName);
				imageDto.setOriginName(originName);
				imageDto.setSlot(slot++);

				portfolioDao.addPortfolioImage(imageDto);
			}

		} catch (IOException | RuntimeException e) {
			//DB는 @Transactional 이 되돌리고, 이미 저장한 파일은 여기서 지운다
			for (File file : saved) {
				file.delete();
			}
			throw new IllegalStateException("포트폴리오 사진 저장 실패", e);
		}
	}

	/**
	 * 올린 파일 중 빈 칸은 빼고 images 에 담는다
	 * @return 1: 정상, -1: 5장 초과, -2: 이미지가 아닌 파일
	 */
	private int checkImages(List<MultipartFile> files, List<MultipartFile> images) {

		if (files == null) {
			return 1;
		}

		for (MultipartFile file : files) {
			//사진을 안 고르고 보내도 빈 파일 하나가 넘어온다
			if (file.isEmpty()) {
				continue;
			}
			if (!isImage(file)) {
				return -2;
			}
			images.add(file);
		}

		return images.size() > MAX_IMAGES ? -1 : 1;
	}

	private boolean isImage(MultipartFile file) {

		String name = file.getOriginalFilename() == null ? "" : file.getOriginalFilename();
		int dot = name.lastIndexOf('.');
		String ext = dot < 0 ? "" : name.substring(dot + 1).toLowerCase();

		return IMAGE_EXT.contains(ext) && file.getContentType() != null && file.getContentType().startsWith("image/");
	}

	//제목, 내용이 비어 있지 않고 컬럼 크기(바이트)를 넘지 않는지. 한글은 한 글자에 3바이트
	private boolean isValidText(ExpertPortfolioDto dto) {

		if (dto.getTitle() == null || dto.getContent() == null) {
			return false;
		}

		dto.setTitle(dto.getTitle().trim());
		dto.setContent(dto.getContent().trim());

		return !dto.getTitle().isEmpty() && byteLength(dto.getTitle()) <= 100
				&& !dto.getContent().isEmpty() && byteLength(dto.getContent()) <= 4000;
	}

	private int byteLength(String value) {

		return value.getBytes(StandardCharsets.UTF_8).length;
	}

}
