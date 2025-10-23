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
import com.spring.semi.dao.HeaderDao;
import com.spring.semi.dao.MemberDao;
import com.spring.semi.dto.HeaderDto;
import com.spring.semi.dto.BoardDto;
import com.spring.semi.dto.MemberDto;
import com.spring.semi.error.TargetNotfoundException;
import com.spring.semi.vo.PageVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/infoBoard")
public class InfoBoardController {
	@Autowired
	private BoardDao boardDao;
	@Autowired
	private MemberDao memberDao;
	  @Autowired
	  private HeaderDao headerDao;
	//등록
	@GetMapping("/write")
	public String write()
	{
      return "/WEB-INF/views/infoBoard/write.jsp";
	}
    @PostMapping("/write")
    public String write(@ModelAttribute BoardDto boardDto,
                        @ModelAttribute HeaderDto headerDto,
                        HttpSession session) {
        String loginId = (String) session.getAttribute("loginId");
        boardDto.setBoardWriter(loginId);

        int boardNo = boardDao.sequence();
        boardDto.setBoardNo(boardNo);

        int headerNo = headerDao.sequence();
        headerDto.setHeaderNo(headerNo);
        headerDao.insert(headerDto);

        //  board와 header 연결
        boardDto.setBoardHeader(headerNo);
		
		boardDao.insert(boardDto, 2);
		return "redirect:list";
		
	}
    //목록
	@RequestMapping("/list")
	public String list(Model model, @ModelAttribute(value = "pageVO") PageVO pageVO) 
	{		
		model.addAttribute("boardList", boardDao.selectListWithPaging(pageVO, 2));
		pageVO.setDataCount(boardDao.count(pageVO, 2));
		model.addAttribute("pageVO", pageVO);
			
		return "/WEB-INF/views/infoBoard/list.jsp";
	}
	//상세
	@RequestMapping("/detail")
	public String detail(Model model, @RequestParam int boardNo) {
		BoardDto boardDto = boardDao.selectOne(boardNo);
		if(boardDto == null) throw new TargetNotfoundException("존재하지 않는 글");
		model.addAttribute("boardDto", boardDto);
		
		if(boardDto.getBoardWriter() != null) {
			MemberDto memberDto = memberDao.selectOne(boardDto.getBoardWriter()); 
			model.addAttribute("memberDto", memberDto);
		}		
		return "/WEB-INF/views/infoBoard/detail.jsp";				
	}
	//삭제
	@RequestMapping("/delete")
	public String delete(@RequestParam int boardNo) {
		BoardDto boardDto = boardDao.selectOne(boardNo);
		if(boardDto == null) throw new TargetNotfoundException("존재하지 않는 글");
		boardDao.delete(boardNo);
		return "redirect:list";
	}

	//수정
	@GetMapping("/edit")
	public String edit(Model model, @RequestParam int boardNo) {
		BoardDto boardDto = boardDao.selectOne(boardNo);
		if(boardDto == null) throw new TargetNotfoundException("존재하지 않는 글");
		model.addAttribute("boardDto", boardDto);
		return "/WEB-INF/views/infoBoard/edit.jsp";
	}
	@PostMapping("/edit")
	public String edit(@ModelAttribute BoardDto boardDto) {
		boardDao.update(boardDto);
		return "redirect:detail?boardNo="+boardDto.getBoardNo();
	}
	

}