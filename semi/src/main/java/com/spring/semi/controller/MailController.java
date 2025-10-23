package com.spring.semi.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.semi.dao.MailDao;
import com.spring.semi.dao.MemberDao;
import com.spring.semi.dto.MailDto;
import com.spring.semi.dto.MemberDto;
import com.spring.semi.error.NeedPermissionException;
import com.spring.semi.error.TargetNotfoundException;
import com.spring.semi.service.MailService;
import com.spring.semi.vo.PageVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/mail")
public class MailController {
	@Autowired
	private MailDao mailDao;
	@Autowired
	private MemberDao memberDao;
	@Autowired
	private MailService mailService;
	
	@GetMapping("/send")
	public String send(
			HttpSession session,
			Model model
			) {
		String loginId = (String) session.getAttribute("loginId");
		MemberDto memberDto = memberDao.selectOne(loginId);
		if(memberDto == null) throw new TargetNotfoundException("존재하지않는 회원");
		model.addAttribute("memberDto", memberDto);
		
		return "/WEB-INF/views/mail/send.jsp";
	}
	
	@PostMapping("/send")
	public String send(
			HttpSession session,
			@ModelAttribute MailDto mailDto,
			@RequestParam String memberNickname
			) {
		String loginId = (String) session.getAttribute("loginId");
		MemberDto senderDto = memberDao.selectOne(loginId);
		if(senderDto == null) throw new NeedPermissionException("잘못된 접근");
		MemberDto targetDto = memberDao.selectForNickname(memberNickname);
		if(targetDto == null) throw new TargetNotfoundException("존재하지않는 회원");
		
		mailDto.setMailSender(senderDto.getMemberId());
		mailDto.setMailTarget(targetDto.getMemberId());
		
		mailService.sendMail(mailDto);
		
		
		return "redirect:list";
	}
	
	@GetMapping("/list")
	public String list(
			HttpSession session,
			Model model,
			@ModelAttribute PageVO pageVO) {
		
		String loginId = (String) session.getAttribute("loginId");
		MemberDto memberDto = memberDao.selectOne(loginId);
		if(memberDto == null) throw new TargetNotfoundException("존재하지 않는 회원");
		List<MailDto> mailList = mailDao.selectList(memberDto.getMemberId());
		model.addAttribute("mailList", mailDao.selectListWithPaging(pageVO, 1));
		pageVO.setDataCount(mailDao.count(pageVO, 1));
		model.addAttribute("pageVO", pageVO);

		
		return "/WEB-INF/views/mail/list.jsp";
	}
	
	
	
}
