package com.spring.semi.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.spring.semi.dao.MemberDao;
import com.spring.semi.dto.MemberDto;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/member")
public class MemberController {
	@Autowired
	private MemberDao memberDao;
	
	@GetMapping("/join")
	public String join() {
		return "/WEB-INF/views/member/join.jsp";
	}
	
	@PostMapping("/join")
	public String join(
			@ModelAttribute MemberDto memberDto
			) {
		memberDao.insert(memberDto);
		
		return "redirect:joinFinish";
	}
	
	@GetMapping("/joinFinish")
	public String joinFinish() {
		return "/WEB-INF/views/member/joinFinish.jsp";
	}
	
	@GetMapping("/login")
	public String login() {
		return "/WEB-INF/views/member/login.jsp";
	}
	
	@PostMapping("/login")
	public String login(
			@ModelAttribute MemberDto memberDto,
			HttpSession session
			) {
		MemberDto findDto = memberDao.selectOne(memberDto.getMemberId());
		if(findDto == null) return "redirct:login?error";
		if(findDto.getMemberPw().equals(memberDto.getMemberPw()) == false) return "redirct:login?error";
		
		session.setAttribute("login_id", findDto.getMemberId());
		session.setAttribute("login_level", findDto.getMemberLevel());
		
		return "/WEB-INF/views/home.jsp";
	}
}
