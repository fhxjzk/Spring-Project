package com.project.app.expert.service;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.project.app.expert.model.ExpertCardDto;
import com.project.app.expert.model.ExpertCareerDto;
import com.project.app.expert.model.ExpertPortfolioDto;
import com.project.app.expert.model.ExpertProfileDto;
import com.project.app.expert.model.ExpertTalentDto;
import com.project.app.expert.repository.ExpertDao;
import com.project.app.search.model.RegionDto;
import com.project.app.search.service.SearchService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ExpertService {

	//경력은 최대 20줄까지
	private static final int MAX_CAREERS = 20;

	//프로필 사진으로 받을 수 있는 확장자
	private static final Set<String> IMAGE_EXT = Set.of("jpg", "jpeg", "png");

	private final ExpertDao expertDao;

	//활동 가능 지역(tbl_expert_region) 저장과 지역 목록은 ⑥에서 만든 것을 그대로 쓴다
	private final SearchService searchService;

	//프로필 정보 받아오기
	public ExpertProfileDto getProfile(Long expertSeq) {
		ExpertProfileDto edto = expertDao.getProfile(expertSeq);
		return edto;
	}

	//경력 목록 받아오기 (최근 경력이 위로)
	public List<ExpertCareerDto> getCareerList(Long expertSeq) {
		List<ExpertCareerDto> careerList = expertDao.getCareerList(expertSeq);
		return careerList;
	}

	//활동 가능 지역 이름 목록 (서울, 경기, ...)
	public List<String> getRegionNameList(Long expertSeq) {
		List<String> regionNameList = expertDao.getRegionNameList(expertSeq);
		return regionNameList;
	}

	//제공 서비스 목록 (사용 중인 것만)
	public List<ExpertTalentDto> getTalentList(Long expertSeq) {
		List<ExpertTalentDto> talentList = expertDao.getTalentList(expertSeq);
		return talentList;
	}

	//포트폴리오 목록
	public List<ExpertPortfolioDto> getPortfolioList(Long expertSeq) {
		List<ExpertPortfolioDto> portfolioList = expertDao.getPortfolioList(expertSeq);
		return portfolioList;
	}

	//메인 인기 고수 (평균 별점 높은 순 4명)
	public List<ExpertCardDto> getPopularExpertList() {
		List<ExpertCardDto> expertList = expertDao.getPopularExpertList();
		return expertList;
	}

	// 프로필 주인이 로그인 한 사용자인지 체크
	public boolean ownerCheck(Long memberSeq, Long expertSeq) {

		// memberSeq가 null일 수 있기 때문에 expertSeq에서 equals() 호출하기
		if(expertSeq.equals(memberSeq)) {
			return true;
		}
		return false;
	}

	//===== 프로필 작성·수정 (②-02) =====

	/**
	 * 프로필 작성
	 * 사진 저장 → 프로필 INSERT → 경력 INSERT → 활동 지역 저장을 한 번에 처리한다. 중간에 실패하면 DB는 전부 취소된다.
	 * @return 1: 성공, 0: 소개·위치 잘못됨, -1: 경력 잘못됨, -2: 지역 잘못됨, -3: 이미지가 아닌 파일, -4: 이미 프로필이 있음
	 */
	@Transactional
	public int add(ExpertProfileDto dto, MultipartFile image, String uploadPath) {

		//프로필은 고수 한 명당 하나 (PK = 회원 번호). 두 번 작성하면 PK 오류가 나기 전에 막는다
		if (expertDao.getProfile(dto.getExpertSeq()) != null) {
			return -4;
		}

		int result = checkInput(dto, image);

		if (result != 1) {
			return result;
		}

		//폼에서 profileImage 라는 이름으로 아무 문자열이나 보낼 수 있어서, 실제로 저장한 파일 이름으로 덮어쓴다
		String fileName = saveImage(image, uploadPath);
		dto.setProfileImage(fileName);

		try {
			expertDao.addProfile(dto);
			saveCareers(dto);
			searchService.saveExpertRegions(dto.getExpertSeq(), dto.getRegionSeqs());

		} catch (RuntimeException e) {
			//DB는 @Transactional 이 되돌리지만 파일은 남으니 직접 지우고, 예외는 다시 던져서 롤백되게 한다
			deleteImage(fileName, uploadPath);
			throw e;
		}

		return 1;
	}

	/**
	 * 프로필 수정
	 * 사진을 새로 올리지 않으면 기존 사진을 그대로 둔다. 경력, 활동 지역은 지우고 화면에 있는 값으로 다시 넣는다.
	 * @return 1: 성공, 0: 소개·위치 잘못됨, -1: 경력 잘못됨, -2: 지역 잘못됨, -3: 이미지가 아닌 파일, -4: 프로필이 없음
	 */
	@Transactional
	public int edit(ExpertProfileDto dto, MultipartFile image, String uploadPath) {

		ExpertProfileDto original = expertDao.getProfile(dto.getExpertSeq());

		if (original == null) {
			return -4;
		}

		int result = checkInput(dto, image);

		if (result != 1) {
			return result;
		}

		//새 사진이 없으면 null → Mapper 에서 사진 컬럼을 건드리지 않는다
		String fileName = saveImage(image, uploadPath);
		dto.setProfileImage(fileName);

		try {
			expertDao.editProfile(dto);

			expertDao.deleteCareers(dto.getExpertSeq());
			saveCareers(dto);

			//기존 지역을 지우고 다시 넣는 것까지 ⑥ SearchService 가 해 준다 (같은 트랜잭션으로 묶인다)
			searchService.saveExpertRegions(dto.getExpertSeq(), dto.getRegionSeqs());

		} catch (RuntimeException e) {
			deleteImage(fileName, uploadPath);
			throw e;
		}

		//DB 작업이 다 끝난 뒤에 예전 사진 파일을 지운다 (포트폴리오 수정과 같은 순서)
		if (fileName != null) {
			deleteImage(original.getProfileImage(), uploadPath);
		}

		return 1;
	}

	//경력 줄 INSERT. checkInput 에서 빈 줄을 걸러 둔 목록을 쓴다
	private void saveCareers(ExpertProfileDto dto) {

		for (ExpertCareerDto career : dto.getCareerList()) {
			career.setExpertSeq(dto.getExpertSeq());
			expertDao.addCareer(career);
		}
	}

	/**
	 * 입력값 확인. 화면에서도 막지만, 화면을 거치지 않고 보내는 경우가 있어서 서버에서 다시 본다
	 * 컬럼 크기는 바이트 기준이다 (한글 한 글자 = 3바이트)
	 */
	private int checkInput(ExpertProfileDto dto, MultipartFile image) {

		//소개, 서비스 제공 위치
		dto.setIntro(trim(dto.getIntro()));
		dto.setServiceAddress(trim(dto.getServiceAddress()));

		if (dto.getIntro().isEmpty() || byteLength(dto.getIntro()) > 2000
				|| dto.getServiceAddress().isEmpty() || byteLength(dto.getServiceAddress()) > 300) {
			return 0;
		}

		//위도·경도는 [주소 검색]을 해야 채워진다. 비어 있거나 말이 안 되는 값이면 막는다
		Double lat = dto.getServiceLatitude();
		Double lng = dto.getServiceLongitude();

		if (lat == null || lng == null || lat < -90 || lat > 90 || lng < -180 || lng > 180) {
			return 0;
		}

		if (!checkCareers(dto)) {
			return -1;
		}

		if (!checkRegions(dto)) {
			return -2;
		}

		if (image != null && !image.isEmpty() && !isImage(image)) {
			return -3;
		}

		return 1;
	}

	/**
	 * 경력 확인. 통째로 빈 줄은 빼고, 나머지는 활동/회사명과 시작 연월이 꼭 있어야 한다
	 * 확인이 끝나면 dto.careerList 를 저장할 줄만 남긴 목록으로 바꿔 둔다
	 */
	private boolean checkCareers(ExpertProfileDto dto) {

		List<ExpertCareerDto> careers = new ArrayList<>();

		if (dto.getCareerList() != null) {

			for (ExpertCareerDto career : dto.getCareerList()) {

				//화면에서 줄을 지우면 번호가 비어서 null 이 끼어 올 수 있다
				if (career == null) {
					continue;
				}

				career.setTitle(trim(career.getTitle()));
				career.setDescription(trim(career.getDescription()));

				boolean empty = career.getTitle().isEmpty() && career.getDescription().isEmpty()
						&& career.getStartDate() == null && career.getEndDate() == null;

				if (empty) {
					continue;
				}

				if (career.getTitle().isEmpty() || byteLength(career.getTitle()) > 100
						|| career.getStartDate() == null
						|| byteLength(career.getDescription()) > 1000) {
					return false;
				}

				//종료가 시작보다 앞이면 안 된다. 같은 달은 괜찮다
				if (career.getEndDate() != null && career.getEndDate().before(career.getStartDate())) {
					return false;
				}

				//설명을 비우면 null 로 저장한다
				if (career.getDescription().isEmpty()) {
					career.setDescription(null);
				}

				careers.add(career);
			}
		}

		dto.setCareerList(careers);

		return careers.size() <= MAX_CAREERS;
	}

	//체크한 지역이 tbl_region 에 있는 번호인지. 없는 번호를 넣으면 FK 오류가 나기 전에 막는다
	private boolean checkRegions(ExpertProfileDto dto) {

		if (dto.getRegionSeqs() == null) {
			dto.setRegionSeqs(new ArrayList<>());
			return true;
		}

		Set<Integer> valid = new HashSet<>();

		for (RegionDto region : searchService.getRegionList()) {
			valid.add(region.getRegionSeq());
		}

		//같은 번호가 두 번 오면 PK 오류가 나서 한 번만 남긴다
		List<Integer> regionSeqs = new ArrayList<>(new LinkedHashSet<>(dto.getRegionSeqs()));

		if (!valid.containsAll(regionSeqs)) {
			return false;
		}

		dto.setRegionSeqs(regionSeqs);

		return true;
	}

	/**
	 * 사진 파일 저장. 파일 이름은 UUID_원래이름 (CONVENTION.md "업로드 파일")
	 * @return 저장한 파일 이름, 사진을 안 골랐으면 null
	 */
	private String saveImage(MultipartFile image, String uploadPath) {

		if (image == null || image.isEmpty()) {
			return null;
		}

		File dir = new File(uploadPath);

		if (!dir.exists()) {
			dir.mkdirs();
		}

		//경로가 섞여 들어와도 파일 이름만 쓴다
		String originName = Paths.get(image.getOriginalFilename()).getFileName().toString();
		String fileName = UUID.randomUUID() + "_" + originName;

		try {
			image.transferTo(new File(dir, fileName));
		} catch (IOException e) {
			throw new IllegalStateException("프로필 사진 저장 실패", e);
		}

		return fileName;
	}

	private void deleteImage(String fileName, String uploadPath) {

		if (fileName != null) {
			new File(uploadPath, fileName).delete();
		}
	}

	//확장자와 Content-Type 이 둘 다 이미지여야 한다 (포트폴리오 사진과 같은 기준)
	private boolean isImage(MultipartFile file) {

		String name = file.getOriginalFilename() == null ? "" : file.getOriginalFilename();
		int dot = name.lastIndexOf('.');
		String ext = dot < 0 ? "" : name.substring(dot + 1).toLowerCase();

		return IMAGE_EXT.contains(ext) && file.getContentType() != null && file.getContentType().startsWith("image/");
	}

	//null 이면 빈 문자열, 아니면 앞뒤 공백 제거
	private String trim(String value) {

		return value == null ? "" : value.trim();
	}

	private int byteLength(String value) {

		return value.getBytes(StandardCharsets.UTF_8).length;
	}

}
