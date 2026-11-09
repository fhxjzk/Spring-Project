package com.project.app.member.service;
import java.util.ArrayList;
import java.util.List;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.project.app.member.model.MemberDto;
import com.project.app.trade.service.TradeService;
import com.project.app.member.repository.MemberDao;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MemberService {
	
	private final MemberDao memberDao;
	private final TradeService tradeService;
	private final BCryptPasswordEncoder encoder;

	/**
	 * 회원가입
	 * @return 1: 성공, 0: 실패, -1: 아이디 중복, -2: 이메일 중복, -3: 위치 확인 실패, -4: 입력값 오류
	 */
	public int add(MemberDto dto) {

		//가입 화면에서 고를 수 있는 권한은 고객, 고수뿐이다 (화면을 조작해서 관리자로 가입하는 것을 막는다)
		if (!"ROLE_CUSTOMER".equals(dto.getRole()) && !"ROLE_EXPERT".equals(dto.getRole())) {
			return 0;
		}

		//아이디, 비밀번호 규칙을 서버에서도 확인한다 (화면 검사는 우회할 수 있다)
		if (dto.getId() == null || !dto.getId().matches("[A-Za-z0-9]{3,20}")
				|| dto.getPw() == null || dto.getPw().length() < 8) {
			return -4;
		}

		//이름, 이메일, 주소는 필수 항목이다
		if (dto.getName() == null || dto.getName().isBlank()
				|| dto.getEmail() == null || dto.getEmail().isBlank()
				|| dto.getAddress() == null || dto.getAddress().isBlank()) {
			return -4;
		}

		//DB 칸 크기를 넘는 값을 막는다 (한글은 1글자에 3바이트)
		if (dto.getName().length() > 16 || dto.getEmail().length() > 100 || dto.getAddress().length() > 100) {
			return -4;
		}

		if (memberDao.countById(dto.getId()) > 0) {
			return -1;
		}

		if (memberDao.countByEmail(dto.getEmail()) > 0) {
			return -2;
		}

		//좌표는 화면에서 오는 값이라 서버에서 값과 범위를 한 번 더 확인한다
		if (dto.getLatitude() == null || dto.getLongitude() == null
				|| !(dto.getLatitude() >= -90 && dto.getLatitude() <= 90)
				|| !(dto.getLongitude() >= -180 && dto.getLongitude() <= 180)) {
			return -3;
		}

		dto.setPw(encoder.encode(dto.getPw()));

		return memberDao.add(dto);
	}
	//--- 관리자 회원 관리 (E-01) ---

	public List<MemberDto> getList(String word, String role, String status) {

		return memberDao.getList(word, role, status);
	}
	
	public MemberDto getBySeq(Long memberSeq) {
		
		return memberDao.getBySeq(memberSeq);
	}
	//사용 중지(N) / 재개(Y). 관리자 계정과 탈퇴한 회원은 바꾸지 않는다
	public int updateEnabled(Long memberSeq, String enabled) {
		
		MemberDto member = memberDao.getBySeq(memberSeq);
		
		if (member == null) {
			return 0;
		}
		
		if ("ROLE_ADMIN".equals(member.getRole())) {
			return -1;
		}
		
		if (member.getWithdrawDate() != null) {
			return -2;
		}
		
		return memberDao.updateEnabled(memberSeq, enabled);
	}

	//마이페이지 정보 수정 (B-02-a)
	//@return 1: 성공, 0: 실패, -2: 이메일 중복, -4: 입력값 오류
	public int edit(MemberDto dto) {

		//이름, 이메일, 주소는 필수 항목이다
		if (dto.getName() == null || dto.getName().isBlank()
				|| dto.getEmail() == null || dto.getEmail().isBlank()
				|| dto.getAddress() == null || dto.getAddress().isBlank()) {
			return -4;
		}

		//DB 칸 크기를 넘는 값을 막는다
		if (dto.getName().length() > 16
				|| dto.getEmail().length() > 100
				|| dto.getAddress().length() > 100) {
			return -4;
		}
		
		//좌표 필수 여부와 유효 범위를 확인한다
		if (dto.getLatitude() == null || dto.getLongitude() == null
				|| !(dto.getLatitude() >= -90 && dto.getLatitude() <= 90)
				|| !(dto.getLongitude() >= -180 && dto.getLongitude() <= 180)) {
			return -3;
		}
		
		//내 이메일은 빼고 중복을 확인한다
		if (memberDao.countByEmailExceptMe(dto) > 0) {
			return -2;
		}
		
		//새 비밀번호를 입력한 경우에만 검사하고 BCrypt로 변환한다.
		if (dto.getPw() != null && !dto.getPw().isEmpty()) {
			
			if(dto.getPw().length() < 8) {
				return -4;
			}
			
			dto.setPw(encoder.encode(dto.getPw()));
		}
		return memberDao.edit(dto);
	}

	//탈퇴를 막는 항목 (B-02-b). 비어 있으면 탈퇴할 수 있다
	public List<String> getWithdrawBlocks(Long memberSeq, String role) {

		List<String> blocks = new ArrayList<>();

		if ("ROLE_CUSTOMER".equals(role)) {

			int count = memberDao.countActiveRequest(memberSeq);

			if (count > 0) {
				blocks.add("모집 중이거나 견적이 마감된 요청서 " + count + "건");
			}
		}

		if ("ROLE_EXPERT".equals(role)) {

			int waiting = memberDao.countWaitingQuote(memberSeq);
			int designated = memberDao.countDesignatedRequest(memberSeq);

			if (waiting > 0) {
				blocks.add("대기 중인 견적 " + waiting + "건");
			}

			if (designated > 0) {
				blocks.add("응답하지 않은 지정 요청 " + designated + "건");
			}
		}

		if (tradeService.hasOngoingTrade(memberSeq)) {
			blocks.add("구매 확정 또는 취소로 끝나지 않은 거래");
		}

		return blocks;
	}

	/**
	 * 회원 탈퇴 (B-02-b)
	 * @return 1: 성공, 0: 실패, -1: 비밀번호 불일치, -2: 탈퇴 제한 항목 있음
	 */
	public int withdraw(String id, String pw) {

		MemberDto member = memberDao.getById(id);

		//없는 회원, 이미 중지·탈퇴한 회원, 관리자는 탈퇴할 수 없다
		if (member == null || !"Y".equals(member.getEnabled()) || "ROLE_ADMIN".equals(member.getRole())) {
			return 0;
		}

		if (pw == null || !encoder.matches(pw, member.getPw())) {
			return -1;
		}

		//화면을 거치지 않은 요청도 막도록 처리 직전에 다시 확인한다
		if (!getWithdrawBlocks(member.getMemberSeq(), member.getRole()).isEmpty()) {
			return -2;
		}

		return memberDao.withdraw(member.getMemberSeq());
	}
}
