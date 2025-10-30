package com.spring.semi.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.spring.semi.dao.BoardDao;
import com.spring.semi.vo.BoardVO;

@Controller
public class MainController 
{
	@Autowired
	private BoardDao boardDao;
	
	@RequestMapping("/")
	public String home(Model model)
	{
		List<BoardVO> community_board_list = boardDao.selectListWithPagingForMainPage(1, 1, 8);	
		List<BoardVO> petfluencer_board_list = boardDao.selectListWithPagingForMainPage(3, 1, 10);		
		List<BoardVO> fun_board_list = boardDao.selectListWithPagingForMainPage(24, 1, 8);			
		List<BoardVO> animal_wiki_board_list = boardDao.selectListWithPagingForMainPage(7, 1, 6);	
		List<BoardVO> temp = boardDao.selectListWithPagingForMainPage(5, 1, 3);
		List<BoardVO> review_board_scroll = new ArrayList<>();
		review_board_scroll.addAll(temp); // 3개는 개수가 너무 적어 무한루프가 안된단다. 
		review_board_scroll.addAll(temp); // 같은 걸 복사해서 수량을 맞춘다
		
		List<BoardVO> review_board_list = boardDao.selectListWithPagingForMainPage(5, 4, 7);
		
		model.addAttribute("community_board_list", community_board_list);
		model.addAttribute("petfluencer_board_list", petfluencer_board_list);
		model.addAttribute("fun_board_list", fun_board_list);
		model.addAttribute("animal_wiki_board_list", animal_wiki_board_list);
		model.addAttribute("review_board_scroll", review_board_scroll);
		model.addAttribute("review_board_list", review_board_list);
		
		return "/WEB-INF/views/home.jsp";
	}
}