package com.spring.semi.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.semi.dao.MemberDao;
import com.spring.semi.dto.MemberDto;

@Controller
public class MainController 
{
	@Autowired
	private MemberDao memberDao;
	
	@RequestMapping("/")
	public String home(Model model)
	{
		List<MemberDto> memberList = memberDao.selectListByMemberPoint(1, 10);
		model.addAttribute("memberList", memberList);
		
		return "/WEB-INF/views/home.jsp";
	}
}