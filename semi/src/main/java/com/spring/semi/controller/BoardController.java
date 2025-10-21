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

import com.spring.semi.dao.BoardDao;
import com.spring.semi.dao.MemberDao;
import com.spring.semi.dto.BoardDto;
import com.spring.semi.dto.MemberDto;
import com.spring.semi.error.TargetNotfoundException;
import com.spring.semi.service.MediaService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/board/free")
public class BoardController {
	private final MediaService attachmentService;
	@Autowired
	private BoardDao boardDao;
	@Autowired
	private MemberDao memberDao;
	
    BoardController(MediaService attachmentService) {
        this.attachmentService = attachmentService;
    }
	
	@RequestMapping("/list")
	public String list(Model model) 
	{	
		List<BoardDto> boardList = boardDao.selectList(1);
		model.addAttribute("boardList", boardList);
		
		return "/WEB-INF/views/board/free/list.jsp";
	}
	
	@GetMapping("/write")
	public String write() 
	{
		return "/WEB-INF/views/board/free/write.jsp";
	}
	
	@PostMapping("/write")
	public String write(@ModelAttribute BoardDto boardDto, HttpSession session) 
	{
		System.out.println(boardDto);
		
		int boardNo = boardDao.sequence();
		boardDto.setBoardNo(boardNo);
		
		String loginId = (String)session.getAttribute("loginId");
		boardDto.setBoardWriter(loginId);
		
		boardDao.insert(boardDto, 1);
		return "redirect:/board/free/detail?boardNo=" + boardNo;
	}
	
	@RequestMapping("/detail")
	public String detail(HttpSession session,
			Model model, 
			@RequestParam int boardNo) {
		BoardDto boardDto = boardDao.selectOne(boardNo);
		if (boardDto == null) 
			throw new TargetNotfoundException("존재하지 않는 게시글 번호");
		
		if (boardDto.getBoardWriter() != null) 
		{			
			MemberDto memberDto = memberDao.selectOne(boardDto.getBoardWriter());
			model.addAttribute("memberDto", memberDto);
		}

		model.addAttribute("boardDto", boardDto);
		return "/WEB-INF/views/board/free/detail.jsp";
	}
	
	
}
