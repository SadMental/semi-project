package com.spring.semi.restcontroller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.spring.semi.dao.MailDao;
import com.spring.semi.dao.MemberDao;
import com.spring.semi.dto.MemberDto;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/rest/mail")
public class MailRestController {

	@Autowired
	private MemberDao memberDao;
	
	@PostMapping("/checkMember")
	public boolean checkMember(
			@RequestParam String memberNickname,
			HttpSession session
			) {
		String loginId = (String) session.getAttribute("loginId");
		MemberDto memberDto = memberDao.selectForNickname(memberNickname);
		if(memberDto == null) return false;
		if(memberDto.getMemberNickname().equals(loginId)) return false;
		
		return true;
	}
	
}
