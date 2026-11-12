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
import com.project.app.expert.model.ExpertTalentDto;
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
	private static final Set<String> IMAGE_EXT = Set.of("jpg", "jpeg", "png");

	private final PortfolioDao portfolioDao;

	public ExpertPortfolioDto getPortfolio(Long portfolioSeq) {
		ExpertPortfolioDto pdto = portfolioDao.getPortfolio(portfolioSeq);
		return pdto;
	}

	public List<PortfolioImageDto> getPortfolioImages(Long portfolioSeq) {
		List<PortfolioImageDto> imgList = portfolioDao.getPortfolioImages(portfolioSeq);
		return imgList;
	}

	//이 포트폴리오를 연결한 서비스 (포트폴리오 상세의 버튼)
	public List<ExpertTalentDto> getLinkedTalentList(Long portfolioSeq) {
		List<ExpertTalentDto> talentList = portfolioDao.getLinkedTalentList(portfolioSeq);
		return talentList;
	}

	/**
	 * 포트폴리오 작성
	 * 글 INSERT → 사진 파일 저장 → 사진 INSERT 를 한 번에 처리한다. 중간에 실패하면 전부 취소된다.
	 * 사진은 필수가 아니다 (0 ~ 5장)
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

		saveImages(dto.getPortfolioSeq(), images, 1, uploadPath);

		return 1;
	}

	/**
	 * 포트폴리오 수정
	 * 화면의 사진 칸에서 남긴 기존 사진(keepImageSeqs, 화면 순서)과 새로 올린 사진을 합쳐
	 * 남긴 사진 → 새 사진 순서로 slot 1 번부터 다시 매긴다. 뺀 사진은 행과 파일을 지운다.
	 * 사진은 합쳐서 0 ~ 5장이다 (필수가 아니라서 전부 지워도 된다).
	 * @param keepImageSeqs 남길 기존 사진 번호. 이 글의 사진이 아닌 번호, 겹친 번호는 무시한다
	 * @return 1: 성공, 0: 잘못된 입력, -1: 사진 5장 초과, -2: 이미지가 아닌 파일
	 */
	@Transactional
	public int edit(ExpertPortfolioDto dto, List<Long> keepImageSeqs, List<MultipartFile> files, String uploadPath) {

		if (!isValidText(dto)) {
			return 0;
		}

		List<MultipartFile> images = new ArrayList<>();
		int imageResult = checkImages(files, images);

		if (imageResult != 1) {
			return imageResult;
		}

		//지금 이 글의 사진 중에서, 화면이 보낸 순서대로 남길 사진을 고른다
		List<PortfolioImageDto> oldImages = portfolioDao.getPortfolioImages(dto.getPortfolioSeq());
		List<PortfolioImageDto> keep = new ArrayList<>();

		if (keepImageSeqs != null) {
			for (Long seq : keepImageSeqs) {
				for (PortfolioImageDto image : oldImages) {
					if (image.getImageSeq().equals(seq) && !keep.contains(image)) {
						keep.add(image);
					}
				}
			}
		}

		if (keep.size() + images.size() > MAX_IMAGES) {
			return -1;
		}

		//where 에 expert_seq 까지 걸려 있어서, 내 글이 아니면 0줄이 바뀐다
		if (portfolioDao.editPortfolio(dto) == 0) {
			return 0;
		}

		//사진 행을 전부 지우고, 남긴 사진 → 새 사진 순서로 다시 넣는다
		//(slot 에 (portfolio_seq, slot) UNIQUE 가 걸려 있어서, 하나씩 순서를 바꾸면 중간에 번호가 겹친다)
		portfolioDao.deletePortfolioImages(dto.getPortfolioSeq());

		int slot = 1;
		for (PortfolioImageDto image : keep) {
			image.setSlot(slot++);
			portfolioDao.addPortfolioImage(image);
		}

		saveImages(dto.getPortfolioSeq(), images, slot, uploadPath);

		//뺀 사진의 파일은 DB 작업이 다 끝난 뒤에 지운다 (중간에 실패하면 DB는 되돌아가는데 파일만 사라지는 걸 막는다)
		List<PortfolioImageDto> removed = new ArrayList<>(oldImages);
		removed.removeAll(keep);
		deleteFiles(removed, uploadPath);

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
	 * 올린 순서대로 startSlot 번부터 매긴다 (작성은 1번부터, 수정은 남긴 사진 다음 번호부터). 1번이 대표 사진
	 */
	private void saveImages(Long portfolioSeq, List<MultipartFile> images, int startSlot, String uploadPath) {

		List<File> saved = new ArrayList<>();

		try {
			File dir = new File(uploadPath);

			if (!dir.exists()) {
				dir.mkdirs();
			}

			int slot = startSlot;

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
