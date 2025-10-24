package com.spring.semi.controller;

import java.util.HashSet;
import java.util.Set;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;
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
import com.spring.semi.dto.BoardDto;
import com.spring.semi.dto.HeaderDto;
import com.spring.semi.dto.MemberDto;
import com.spring.semi.error.TargetNotfoundException;
import com.spring.semi.service.MediaService;
import com.spring.semi.vo.PageVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/board/free")
public class BoardController {
	private final MediaService mediaService;
	@Autowired
	private BoardDao boardDao;
	@Autowired
	private MemberDao memberDao;
	@Autowired
	private HeaderDao headerDao;
	
    BoardController(MediaService mediaService) {
        this.mediaService = mediaService;
    }
	
//	@RequestMapping("/list")
//	public String list(Model model) 
//	{	
//		List<BoardDto> boardList = boardDao.selectList(1);
//		model.addAttribute("boardList", boardList);
//		
//		return "/WEB-INF/views/board/free/list.jsp";
//	}
	
	@RequestMapping("/list")
	public String list(Model model, @ModelAttribute(value = "pageVO") PageVO pageVO) 
	{		
		model.addAttribute("boardList", boardDao.selectListWithPaging(pageVO, 1));
		pageVO.setDataCount(boardDao.count(pageVO, 1));
		model.addAttribute("pageVO", pageVO);
			
		return "/WEB-INF/views/board/free/list.jsp";
	}

	
	@GetMapping("/write")
	public String write() 
	{
		return "/WEB-INF/views/board/free/write.jsp";
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
		
		boardDao.insert(boardDto, 1);
		return "redirect:detail?boardNo=" + boardNo;
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
	
	@GetMapping("/edit")
	public String edit(Model model,
			@RequestParam int boardNo)
	{
		BoardDto boardDto = boardDao.selectOne(boardNo);
		if (boardDto == null) 
			throw new TargetNotfoundException("존재하지 않는 게시글 번호");
		model.addAttribute("boardDto", boardDto);
		return "/WEB-INF/views/board/free/edit.jsp";
	}
	
	@PostMapping("/edit")
	public String edit(@ModelAttribute BoardDto boardDto) 
	{
		BoardDto beforeDto = boardDao.selectOne(boardDto.getBoardNo());
		if (beforeDto == null) 
			throw new TargetNotfoundException("존재하지 않는 게시글 번호");		
		
		Set<Integer> before = new HashSet<>();
		Document beforeDocument = Jsoup.parse(beforeDto.getBoardContent());
		Elements beforeElements = beforeDocument.select(".custom-image");
		for(Element element : beforeElements) {
			int mediaNo = Integer.parseInt(element.attr("data-pk"));
			before.add(mediaNo);
		}
		
		Set<Integer> after = new HashSet<>();
		Document afterDocument = Jsoup.parse(boardDto.getBoardContent());
		Elements afterElements = afterDocument.select(".custom-image");
		for(Element element : afterElements) {
			int mediaNo = Integer.parseInt(element.attr("data-pk"));
			after.add(mediaNo);
		}
		
		Set<Integer> minus= new HashSet<>(before);
		minus.removeAll(after);
		for(int mediaNo : minus)
			mediaService.delete(mediaNo);
		
		boardDao.update(boardDto);
		return "redirect:detail?boardNo=" + boardDto.getBoardNo();
	}
	
	@RequestMapping("/delete")
	public String delete(@RequestParam int boardNo)
	{
		BoardDto boardDto = boardDao.selectOne(boardNo);
		if (boardDto == null) 
			throw new TargetNotfoundException("존재하지 않는 게시글 번호");		
		
		Document document = Jsoup.parse(boardDto.getBoardContent());
		Elements elements = document.select(".custom-image");
		for(Element element : elements) {
			int mediaNo = Integer.parseInt(element.attr("data-pk"));
			mediaService.delete(mediaNo);		
		}
		boardDao.delete(boardNo);
		return "redirect:list";
	}
	
}
