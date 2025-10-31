package com.spring.semi.restcontroller;

import java.io.IOException;
import java.time.Duration;
import java.time.LocalDateTime;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.spring.semi.dao.CertDao;
import com.spring.semi.dao.MemberDao;
import com.spring.semi.dto.BoardDto;
import com.spring.semi.dto.CertDto;
import com.spring.semi.dto.MemberDto;
import com.spring.semi.service.EmailService;
import com.spring.semi.service.MediaService;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/rest/member")
public class MemberRestController {
	@Autowired
	private MemberDao memberDao;
	@Autowired
	private EmailService emailService;
	@Autowired
	private CertDao certDao;
	@Autowired
	private MediaService mediaService;

	// 이메일 인증 매핑
	@PostMapping("/certSend")
	public boolean certSend(@RequestParam String certEmail) {
		MemberDto findEmail = memberDao.selectForEmail(certEmail);
		if(findEmail == null) {			
			emailService.sendCertNumber(certEmail);
			return true;
		}
		return false;
	}
	// 이메일 보내기
	@PostMapping("/findSend")
	public boolean findSend(@RequestParam String memberEmail) {
		MemberDto findEmail = memberDao.selectForEmail(memberEmail);
		if(findEmail == null) {			
			return false;
		}
		return true;
	}

	// 인증 체크
	@PostMapping("/certCheck")
	public boolean certCheck(@ModelAttribute CertDto certDto) {
		CertDto findEmail = certDao.selectOne(certDto.getCertEmail());
		if (findEmail == null)
			return false;

		LocalDateTime current = LocalDateTime.now();
		LocalDateTime sent = findEmail.getCertTime().toLocalDateTime();// DB에 저장되어있던 발송 당시 시각 반환
		Duration duration = Duration.between(current, sent);
		if (duration.toSeconds() > 300)
			return false;

		boolean isValid = certDto.getCertNumber().trim().equals(findEmail.getCertNumber().trim());
		if (isValid == false)
			return false;

		certDao.delete(certDto.getCertEmail());
		return true;
	}
	
	@PostMapping("/profile")
	public void profile(HttpSession session, @RequestParam MultipartFile media) throws IllegalStateException, IOException {
		// 기존파일 삭제 (없을 수도 있음)
		String login_id = (String) session.getAttribute("loginId");
		try {
			int media_no = memberDao.findMediaNo(login_id);
			mediaService.delete(media_no);
		} catch (Exception e) {}
		
		// 신규파일 등록
		if(media.isEmpty() == false) {
			int media_no = mediaService.save(media);
			memberDao.connect(login_id, media_no);
		}
	}
	
	@PostMapping("/delete")
	public void delete(HttpSession session) {
		String login_id = (String) session.getAttribute("loginId");
		try {
			int media_no = memberDao.findMediaNo(login_id);
			mediaService.delete(media_no);
		} catch (Exception e) {}
	}
	
	// 아이디 체크
	@PostMapping("/checkId")
	public boolean checkId(@RequestParam String memberId) {
		MemberDto findDto = memberDao.selectOne(memberId);
		return findDto != null;
	}
	
	// 닉네임 체크
	@PostMapping("/checkNickname")
	public boolean checkNickname(@RequestParam String memberNickname) {
		MemberDto findDto = memberDao.selectForNickname(memberNickname);
		return findDto == null? false : true;
	}
	
	// 수정시 닉네임 중복 체크
	@PostMapping("/checkDuplication")
	public boolean checkDuplication(
			@RequestParam String memberId,
			@RequestParam String memberNickname
			) {
		MemberDto findDto = memberDao.selectOne(memberId);
		if(findDto.getMemberNickname().equals(memberNickname)) return false;
		return findDto == null? false : true;
	}
	
	// 동적 로그인
	@PostMapping("/login")
	public boolean login(
			@RequestParam String memberId,
			@RequestParam String memberPw,
			HttpSession session
			) {
		MemberDto findDto = memberDao.selectOne(memberId);
		
		if(findDto == null) return false;
		
		if(findDto.getMemberPw().equals(memberPw) == false) return false;
		
		session.setAttribute("loginId", findDto.getMemberId());
		session.setAttribute("loginLevel", findDto.getMemberLevel());
		
		return true;
			
	}
	
}
