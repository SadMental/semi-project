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
		List<BoardDto> community_board_list = boardDao.selectListWithPagingForMainPage(1, 1, 8);	
		List<BoardDto> petfluencer_board_list = boardDao.selectListWithPagingForMainPage(3, 1, 10);		
		List<BoardDto> fun_board_list = boardDao.selectListWithPagingForMainPage(24, 1, 8);			
		List<BoardDto> animal_wiki_board_list = boardDao.selectListWithPagingForMainPage(7, 1, 6);	
		List<BoardDto> review_board_scroll = boardDao.selectListWithPagingForMainPageReview(5, 1, 3);
		List<BoardDto> review_board_list = boardDao.selectListWithPagingForMainPageReview(5, 4, 7);
		
		
		model.addAttribute("community_board_list", community_board_list);
		model.addAttribute("petfluencer_board_list", petfluencer_board_list);
		model.addAttribute("fun_board_list", fun_board_list);
		model.addAttribute("animal_wiki_board_list", animal_wiki_board_list);
		model.addAttribute("review_board_scroll", review_board_scroll);
		model.addAttribute("review_board_list", review_board_list);
		
		return "/WEB-INF/views/home.jsp";
	}
}