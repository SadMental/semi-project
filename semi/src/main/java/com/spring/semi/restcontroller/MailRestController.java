package com.spring.semi.restcontroller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.spring.semi.dao.MailDao;
import com.spring.semi.dao.MemberDao;
import com.spring.semi.dto.MemberDto;

@RestController
@RequestMapping("/rest/mail")
public class MailRestController {

	@Autowired
	private MailDao mailDao;
	@Autowired
	private MemberDao memberDao;
	
	@PostMapping("/checkMember")
	public boolean checkMember(
			@RequestParam String memberNickname
			) {
		MemberDto memberDto = memberDao.selectForNickname(memberNickname);
		if(memberDto == null) return false;
		
		return true;
	}
	
}
