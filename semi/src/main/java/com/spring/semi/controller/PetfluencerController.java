package com.spring.semi.controller;

import java.io.IOException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

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
@RequestMapping("/board/petfluencer")
public class PetfluencerController {
	private final MediaService mediaService;
	@Autowired
	private BoardDao boardDao;
	@Autowired
	private MemberDao memberDao;
	@Autowired
	private HeaderDao headerDao;
	
	PetfluencerController(MediaService mediaService) {
        this.mediaService = mediaService;
    }
	
	@RequestMapping("/list")
	public String list(Model model, @ModelAttribute(value = "pageVO") PageVO pageVO) 
	{
		pageVO.setSize(12);
		pageVO.fixPageRange(); // ★ 페이지 범위 보정
		
		model.addAttribute("boardList", boardDao.selectListWithPaging(pageVO, 3));
		pageVO.setDataCount(boardDao.count(pageVO, 3));
		model.addAttribute("pageVO", pageVO);
			
		return "/WEB-INF/views/board/petfluence/list.jsp";
	}

	
	@GetMapping("/write")
	public String write() 
	{
		return "/WEB-INF/views/board/petfluence/write.jsp";
	}
	
    @PostMapping("/write")
    public String write(@ModelAttribute BoardDto boardDto,
                        @ModelAttribute HeaderDto headerDto,
                        HttpSession session,
            			@RequestParam MultipartFile media,
            			@RequestParam(required = false) String remove) throws IllegalStateException, IOException 
    {
        String loginId = (String) session.getAttribute("loginId");
        boardDto.setBoardWriter(loginId);

        int boardNo = boardDao.sequence();
        boardDto.setBoardNo(boardNo);

        int headerNo = headerDao.sequence();
        headerDto.setHeaderNo(headerNo);
        headerDao.insert(headerDto);

        //  board와 header 연결
        boardDto.setBoardHeader(headerNo);
        boardDao.insert(boardDto, 3);
        
		if(!media.isEmpty()) 
		{
			int mediaNo = mediaService.save(media);
			boardDao.connect(boardNo, mediaNo);
		}
		
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
		return "/WEB-INF/views/board/petfluence/detail.jsp";
	}
	
	@GetMapping("/edit")
	public String edit(Model model,
			@RequestParam int boardNo)
	{
		BoardDto boardDto = boardDao.selectOne(boardNo);
		if (boardDto == null) 
			throw new TargetNotfoundException("존재하지 않는 게시글 번호");
		model.addAttribute("boardDto", boardDto);
		return "/WEB-INF/views/board/petfluence/edit.jsp";
	}
	
	@PostMapping("/edit")
	public String edit(@ModelAttribute BoardDto boardDto,
			@RequestParam MultipartFile media,
			@RequestParam(required = false) String remove) throws IllegalStateException, IOException 
	{
		if (!media.isEmpty())
		{
			try 
			{
				int mediaNo = boardDao.findMedia(boardDto.getBoardNo());
				mediaService.delete(mediaNo);
			}
			catch(Exception e) {}
			
			int mediaNo = mediaService.save(media);
			boardDao.connect(boardDto.getBoardNo(), mediaNo);
		}
		else 
		{
			if (remove != null) 
			{
				try 
				{
					int mediaNo = boardDao.findMedia(boardDto.getBoardNo());
					mediaService.delete(mediaNo);
				}
				catch(Exception e) { /*아무것도 안함*/ }
			}				
		}
		
		BoardDto beforeDto = boardDao.selectOne(boardDto.getBoardNo());
		if (beforeDto == null) 
			throw new TargetNotfoundException("존재하지 않는 게시글 번호");		

// 251024 이윤석. 주석 해제시 'java.lang.NullPointerException: Cannot invoke "String.length()" because "s" is null' 버그 발생하여 임시로 주석처리
//		Set<Integer> before = new HashSet<>();
//		Document beforeDocument = Jsoup.parse(beforeDto.getBoardContent());
//		Elements beforeElements = beforeDocument.select(".custom-image");
//		for(Element element : beforeElements) {
//			int mediaNo = Integer.parseInt(element.attr("data-pk"));
//			before.add(mediaNo);
//		}
//		
//		Set<Integer> after = new HashSet<>();
//		Document afterDocument = Jsoup.parse(boardDto.getBoardContent());
//		Elements afterElements = afterDocument.select(".custom-image");
//		for(Element element : afterElements) {
//			int mediaNo = Integer.parseInt(element.attr("data-pk"));
//			after.add(mediaNo);
//		}
//		
//		Set<Integer> minus= new HashSet<>(before);
//		minus.removeAll(after);
//		for(int mediaNo : minus)
//			mediaService.delete(mediaNo);
		
		boardDao.update(boardDto);
		return "redirect:detail?boardNo=" + boardDto.getBoardNo();
	}
	
	@RequestMapping("/delete")
	public String delete(@RequestParam int boardNo)
	{
		BoardDto boardDto = boardDao.selectOne(boardNo);
		if (boardDto == null) 
			throw new TargetNotfoundException("존재하지 않는 게시글 번호");		
		
//		if (boardDto.getBoardContent() == null)
//			throw new TargetNotfoundException("게시글에 Content가 없음");		
//		
//		Document document = Jsoup.parse(boardDto.getBoardContent());
//		if (document == null)
//			throw new TargetNotfoundException("게시글 내에 이미지가 없음");
//		Elements elements = document.select(".custom-image");
//			
//		for(Element element : elements) {
//			int mediaNo = Integer.parseInt(element.attr("data-pk"));
//			mediaService.delete(mediaNo);		
//		}
		boardDao.delete(3, boardNo);
		return "redirect:list";
	}
	
	@GetMapping("/image")
	public String image(@RequestParam int boardNo) 
	{
		try 
		{
			int mediaNo = boardDao.findMedia(boardNo);
			return "redirect:/media/download?mediaNo=" + mediaNo;			
		}
		catch(Exception e) 
		{
			return "redirect:/images/error/no-image.png";
		}
	}
}
