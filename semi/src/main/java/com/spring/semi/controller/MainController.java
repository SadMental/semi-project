package com.spring.semi.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.spring.semi.dao.BoardDao;
import com.spring.semi.dto.BoardDto;

@Controller
public class MainController 
{
	@Autowired
	private BoardDao boardDao;
	
	@RequestMapping("/")
	public String home(Model model)
	{
		List<BoardDto> free_board_list = boardDao.selectListWithPagingForMailPage(1, 1, 8);		
		
		model.addAttribute("free_board_list", free_board_list);
		
		return "/WEB-INF/views/home.jsp";
	}
}