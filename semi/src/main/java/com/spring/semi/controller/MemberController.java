package com.spring.semi.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.semi.dao.MemberDao;
import com.spring.semi.dto.MemberDto;
import com.spring.semi.error.NeedPermissionException;

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
		if(findDto == null) return "redirect:login?error";
		if(findDto.getMemberPw().equals(memberDto.getMemberPw()) == false) return "redirect:login?error";
		
		session.setAttribute("loginId", findDto.getMemberId());
		session.setAttribute("loginLevel", findDto.getMemberLevel());
		
		return "/WEB-INF/views/home.jsp";
	}
	
	@GetMapping("/logout")
	public String logout(
			HttpSession session
			) {
		session.removeAttribute("loginId");
		session.removeAttribute("loginLevel");
		
		return "redirect:/";
	}
	
	@GetMapping("/edit")
	public String edit(
			HttpSession session,
			Model model
			) {
		String login_id = (String) session.getAttribute("loginId");
		MemberDto memberDto = memberDao.selectOne(login_id);
		model.addAttribute("memberDto", memberDto);
		return "/WEB-INF/views/member/edit.jsp";
	}
	
	@PostMapping("/edit")
	public String edit(
			HttpSession session,
			@ModelAttribute MemberDto memberDto
			) {
		String login_id = (String) session.getAttribute("loginId");
		MemberDto originDto = memberDao.selectOne(login_id);
		if(originDto.getMemberPw().equals(memberDto.getMemberPw()) == false) return "redirect:edit?error";
		
		memberDto.setMemberId(login_id);
		memberDao.updateForUser(memberDto);
		
		return "redirect:mypage";
		
	}
	
	@GetMapping("/password")
	public String password() {
		return "/WEB-INF/views/member/password.jsp";
	}
	
	@PostMapping("/password")
	public String passwrod(
			HttpSession session,
			@RequestParam(name = "change_pw") String change_pw,
			@RequestParam(name = "current_pw") String member_pw
			) {
		String login_id = (String) session.getAttribute("loginId");
		MemberDto findDto = memberDao.selectOne(login_id);
		if(member_pw.equals(findDto.getMemberPw()) == false) return "redirect:password?error";
		memberDao.updateForUserPassword(change_pw, findDto.getMemberId());
		
		return "redirect:mypage";
	}
	
	@GetMapping("/mypage")
	public String mypage(
			Model model, 
			HttpSession session
			) {
		String login_id = (String) session.getAttribute("loginId");
		MemberDto memberDto = memberDao.selectOne(login_id);
		model.addAttribute("memberDto", memberDto);
		
		return "/WEB-INF/views/member/mypage.jsp";
	}
	
	@GetMapping("/drop")
	public String drop() {
		return "/WEB-INF/views/member/drop.jsp";
	}
	
	@PostMapping("/drop")
	public String drop(
			HttpSession session,
			@RequestParam String member_pw
			) {
		String login_id = (String) session.getAttribute("loginId");
		MemberDto findDto = memberDao.selectOne(login_id);
		if(member_pw.equals(findDto.getMemberPw()) == false) return "redirect:drop?error";
		memberDao.delete(login_id);
		session.removeAttribute("loginId");
		session.removeAttribute("loginLevel");
		return "/WEB-INF/views/member/thankyou.jsp";
	}
	
}
