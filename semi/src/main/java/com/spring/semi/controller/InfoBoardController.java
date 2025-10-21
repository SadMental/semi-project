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
@RequestMapping("/infoBoard")
public class InfoBoardController {
	@Autowired
	private BoardDao boardDao;
	@Autowired
	private MemberDao memberDao;
	//등록
	@GetMapping("/write")
	public String write()
	{
      return "/WEB-INF/views/infoBoard/write.jsp";
	}
	@PostMapping("/write")
	public String write(@ModelAttribute BoardDto boardDto, HttpSession session)
	{
		int boardNo = boardDao.sequence();
		boardDto.setBoardNo(boardNo);		
		String loginId = (String)session.getAttribute("loginId");
		boardDto.setBoardWriter(loginId);
		
		boardDao.insert(boardDto, 2);
		return "redirect:list";
		
	}
	//목록
	@RequestMapping("/list")
	public String list(Model model) {
		List<BoardDto> boardList = boardDao.selectList(2);
		model.addAttribute("boardList", boardList);
		
		return "/WEB-INF/views/infoBoard/list.jsp";
		
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
		return "/WEB-INF/views/infoBoard/detail.jsp";				
	}
	//삭제
	@GetMapping("/delete")
	public String showDeleteForm(@RequestParam int boardNo, Model model) {
	    BoardDto boardDto = boardDao.selectOne(boardNo);
	    model.addAttribute("boardDto", boardDto);
	    return "/WEB-INF/views/infoBoard/delete.jsp";
	}
	@PostMapping("/delete")
	public String doDelete(@RequestParam int boardNo) {
	    boardDao.delete(boardNo);
	    return "redirect:list";
	}

	//수정
	@GetMapping("/edit")
	public String edit(Model model, @RequestParam int boardNo) {
		BoardDto boardDto = boardDao.selectOne(boardNo);//후에 예외처리를 위한
		model.addAttribute("boardDto", boardDto);
		return "/WEB-INF/views/infoBoard/edit.jsp";
	}
	@PostMapping("/edit")
	public String edit(@ModelAttribute BoardDto boardDto) {
		boardDao.update(boardDto);
		return "redirect:detail?boardNo="+boardDto.getBoardNo();
	}
	

}
