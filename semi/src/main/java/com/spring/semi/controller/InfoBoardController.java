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

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/board/info")
public class InfoBoardController {
	@Autowired
	private BoardDao boardDao;
	@Autowired
	private MemberDao memberDao;
	//등록
	@GetMapping("/write")
	public String write()
	{
      return "/WEB-INF/views/board/info/write.jsp";
	}
	@PostMapping("/write")
	public String write(@ModelAttribute BoardDto boardDto, HttpSession session)
	{
		int boardNo = boardDao.sequence();
		boardDto.setBoardNo(boardNo);		
		String logingId = (String)session.getAttribute("loginId");
		boardDto.setBoardWriter(logingId);
		
		boardDao.insert(boardDto, 2);
		return "redirect:list";
		
	}
	//목록
	@RequestMapping("/list")
	public String list(Model model) {
		List<BoardDto> boardList = boardDao.selectList(2);
		model.addAttribute("boardList", boardList);
		
		return "/WEB-INF/views/board/info/list.jsp";
		
	}
	//상세
	@RequestMapping("/detail")
	public String detail(Model model, @RequestParam int boardNo) {
		BoardDto boardDto = boardDao.selectOne(boardNo);
		model.addAttribute("boardDto", boardDto);
		
		if(boardDto.getBoardWriter() != null) {
			MemberDto memberDto = memberDao.selectOne(boardDto.getBoardWriter()); 
			model.addAttribute("memberDto", memberDto);
		}		
		return "/WEB-INF/views/board/info/detail.jsp";				
	}
	//삭제
	//수정
	

}
