package com.spring.semi.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.semi.dao.BoardDao;
import com.spring.semi.dao.CategoryDao;
import com.spring.semi.dao.HeaderDao;
import com.spring.semi.dao.MemberDao;
import com.spring.semi.dto.HeaderDto;
import com.spring.semi.dto.BoardDto;
import com.spring.semi.dto.CategoryDto;
import com.spring.semi.dto.MemberDto;
import com.spring.semi.error.TargetNotfoundException;
import com.spring.semi.vo.PageVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/board/info")
public class InfoBoardController {
	@Autowired
	private BoardDao boardDao;
	@Autowired
	private MemberDao memberDao;
	 @Autowired
	 private HeaderDao headerDao;
	 @Autowired
	 private CategoryDao categoryDao;
	//등록
	@GetMapping("/write")
	public String write()
	{
      return "/WEB-INF/views/board/info/write.jsp";
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
    public String list(Model model, @ModelAttribute(value = "pageVO") PageVO pageVO) {		
        int categoryNo = 2; 
        
        // categoryNo에 해당하는 카테고리 정보 조회
        CategoryDto category = categoryDao.selectOne(categoryNo);
        if (category == null)
            throw new TargetNotfoundException("존재하지 않는 게시판입니다.");
        
        model.addAttribute("category", category);
        model.addAttribute("boardList", boardDao.selectListWithPaging(pageVO, categoryNo));
        
        pageVO.setDataCount(boardDao.count(pageVO, categoryNo));
        model.addAttribute("pageVO", pageVO);
        
        return "/WEB-INF/views/board/info/list.jsp";
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
		return "/WEB-INF/views/board/info/detail.jsp";				
	}
	//삭제
	@RequestMapping("/delete")
	public String delete(@RequestParam int boardNo) {
		BoardDto boardDto = boardDao.selectOne(boardNo);
		if(boardDto == null) throw new TargetNotfoundException("존재하지 않는 글");
		boardDao.delete(2, boardNo);
		return "redirect:list";
	}

	//수정
	@GetMapping("/edit")
	public String edit(Model model, @RequestParam int boardNo) {
		BoardDto boardDto = boardDao.selectOne(boardNo);
		if(boardDto == null) throw new TargetNotfoundException("존재하지 않는 글");
		model.addAttribute("boardDto", boardDto);
		return "/WEB-INF/views/board/info/edit.jsp";
	}
	@PostMapping("/edit")
	public String edit(@ModelAttribute BoardDto boardDto) {
		boardDao.update(boardDto);
		return "redirect:detail?boardNo="+boardDto.getBoardNo();
	}
	

}