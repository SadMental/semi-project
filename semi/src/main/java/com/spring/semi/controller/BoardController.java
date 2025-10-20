package com.spring.semi.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.spring.semi.dao.BoardDao;
import com.spring.semi.dto.BoardDto;

@Controller
@RequestMapping("/free/board")
public class BoardController {
	@Autowired
	private BoardDao boardDao;
	
	@RequestMapping("/list")
	public String list(Model model) 
	{	
		List<BoardDto> boardList = boardDao.selectList(1);
		model.addAttribute("boardList", boardList);
		
		return "/WEB-INF/views/board/list.jsp";
	}
	
	@GetMapping("/write")
	public String write() 
	{
		return "/WEB-INF/views/board/write.jsp";
	}
	
	@PostMapping("/write")
	public String write(@ModelAttribute BoardDto boardDto) 
	{
		int sequence = boardDao.sequence();
		boardDto.setBoardNo(sequence);
		
		boardDao.insert(boardDto, 1);
		return "redirect:/board/list";
	}
	
	
}
