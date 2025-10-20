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
import com.spring.semi.dao.MemberDao;
import com.spring.semi.dto.BoardDto;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/info/board")
public class InfoBoardController {
	@Autowired
	private BoardDao boardDao;
	@Autowired
	private MemberDao memberDao;
	
	//등록 매핑
	@GetMapping("/write")
	public String insert()
	{
		return "/WEB-INF/views/info/board/write.jsp";
	}

	@PostMapping("/write")
	public String insert(@ModelAttribute BoardDto boardDto, HttpSession session)
	{
		int boardNo = boardDao.sequence();
		boardDto.setBoardNo(boardNo);
		
		boardDao.insert(boardDto);
		return "redirect:/list";
	}
	//목록 매핑
	@RequestMapping("/list")
	public String list(Model model) {
		List<BoardDto> boardList = boardDao.selectList();
		model.addAttribute("boardList", boardList);
		return "/WEB-INF/views/info/board/list.jsp";
	}
	
	
}
