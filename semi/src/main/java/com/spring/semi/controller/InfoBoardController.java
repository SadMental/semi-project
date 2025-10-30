package com.spring.semi.controller;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
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
import com.spring.semi.dao.CategoryDao;
import com.spring.semi.dao.HeaderDao;
import com.spring.semi.dao.MemberDao;
import com.spring.semi.dto.BoardDto;
import com.spring.semi.dto.CategoryDto;
import com.spring.semi.dto.HeaderDto;
import com.spring.semi.dto.MemberDto;
import com.spring.semi.error.TargetNotfoundException;
import com.spring.semi.service.MediaService;
import com.spring.semi.vo.BoardVO;
import com.spring.semi.vo.PageVO;
import com.spring.semi.service.MemberService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/board/info")
public class InfoBoardController {
	 private final MediaService mediaService;
	@Autowired
	private BoardDao boardDao;
	@Autowired
	private MemberDao memberDao;
	@Autowired
	private HeaderDao headerDao;
	@Autowired
	private CategoryDao categoryDao;
	@Autowired
	private MemberService memberService;

	InfoBoardController(MediaService mediaService) {
	        this.mediaService = mediaService;
	    }
		
	// 등록
	// 글 등록
	@GetMapping("/write")
	public String writeForm(Model model) {
		List<HeaderDto> animalList = headerDao.selectAll("animal"); // DB에서 모든 header 조회
		List<HeaderDto> typeList = headerDao.selectAll("type"); // DB에서 모든 header 조회
		model.addAttribute("animalList", animalList);
	    model.addAttribute("typeList", typeList);
		return "/WEB-INF/views/board/info/write.jsp";
	}

	 @PostMapping("/write")
	   public String write(@ModelAttribute BoardDto boardDto, HttpSession session, Model model) {
	    
	       String loginId = (String) session.getAttribute("loginId");
	       if (loginId == null) throw new IllegalStateException("로그인 정보가 없습니다.");
	       boardDto.setBoardWriter(loginId);
	    
	       if (boardDto.getBoardContent() == null || boardDto.getBoardContent().trim().isEmpty()) {
	           boardDto.setBoardContent("(내용 없음)");
	       }
	   
	       boardDto.setBoardNo(boardDao.sequence());
	       int boardType = 2;
	       boardDao.insert(boardDto, boardType);
	       
	       //게시글 포인트
	       memberDao.addPoint(loginId, 70);
	       MemberDto member = memberDao.selectOne(loginId);
	       model.addAttribute("memberPoint", member.getMemberPoint());
	       
		return "redirect:list";

	}

	 @RequestMapping("/list")
	 public String list(
	         Model model,
	         @ModelAttribute("pageVO") PageVO pageVO,
	         @RequestParam(required = false, defaultValue = "wtime") String orderBy
	 ) {
	     int boardType = 2;
	     CategoryDto categoryDto = categoryDao.selectOne(boardType);

	     pageVO.setSize(10);
	     pageVO.setDataCount(boardDao.count(pageVO, boardType));

	     List<BoardVO> boardList = boardDao.selectList2(
	             pageVO.getBegin(), pageVO.getEnd(), orderBy, boardType);

	     model.addAttribute("category", categoryDto);
	     model.addAttribute("boardList", boardList);

	     model.addAttribute("pageVO", pageVO);
	     model.addAttribute("orderBy", orderBy);

	     return "/WEB-INF/views/board/info/list.jsp";
	 }

	 @RequestMapping("/detail")
	 public String detail(Model model, @RequestParam int boardNo) {
		 // 게시글 조회
		 BoardDto boardDto = boardDao.selectOne(boardNo);
		 if (boardDto == null) throw new TargetNotfoundException("존재하지 않는 글 번호");
		 model.addAttribute("boardDto", boardDto);
		 
		 HeaderDto animalHeaderDto = headerDao.selectOne(boardDto.getBoardAnimalHeader(), "animal");
		 HeaderDto typeHeaderDto = headerDao.selectOne(boardDto.getBoardTypeHeader(), "type");
		 // Map 대신 DTO 객체 자체를 "headerDto"라는 이름으로 Model에 담습니다.
		 if(animalHeaderDto != null) {
			 model.addAttribute("animalHeaderDto", animalHeaderDto); // Model에 animalHeaderDto 자체를 추가
		 }
		 if(typeHeaderDto != null) {
			 model.addAttribute("typeHeaderDto", typeHeaderDto); // Model에 typeHeaderDto 자체를 추가
		 }
		 
			// 작성자 정보
			if (boardDto.getBoardWriter() != null) {
				MemberDto memberDto = memberDao.selectOne(boardDto.getBoardWriter());
				model.addAttribute("memberDto", memberDto);
			}
			return "/WEB-INF/views/board/info/detail.jsp";
	 }


	// 삭제
	 @RequestMapping("/delete")
	 public String delete(@RequestParam int boardNo) {
		 BoardDto boardDto = boardDao.selectOne(boardNo);
		 if (boardDto == null)
			 throw new TargetNotfoundException("존재하지 않는 글");
		 boardDao.delete(boardNo);
		 return "redirect:list";
	 }

	// 수정
	 @GetMapping("/edit")
	 public String edit(Model model, @RequestParam int boardNo) {
		 BoardDto boardDto = boardDao.selectOne(boardNo);
		 if (boardDto == null) throw new TargetNotfoundException("존재하지 않는 글");
		 List<HeaderDto> animalList = headerDao.selectAll("animal"); // DB에서 모든 header 조회
		 List<HeaderDto> typeList = headerDao.selectAll("type"); // DB에서 모든 header 조회
		 model.addAttribute("animalList", animalList);
		 model.addAttribute("typeList", typeList);
		 model.addAttribute("boardDto", boardDto);
		 return "/WEB-INF/views/board/info/edit.jsp";
	 }

	 @PostMapping("/edit")
	 public String edit(@ModelAttribute BoardDto boardDto) {
		 BoardDto beforeDto = boardDao.selectOne(boardDto.getBoardNo());
		 if (beforeDto == null) throw new TargetNotfoundException("존재하지 않는 글");
		 
		 Set<Integer> before = new HashSet<>();
		 Document beforeDocument = Jsoup.parse(beforeDto.getBoardContent());
		 Elements beforeElements = beforeDocument.select(".custom-image");
		 for (Element element : beforeElements) {
			 int attachmentNo = Integer.parseInt(element.attr("data-pk"));
			 before.add(attachmentNo);
		 }
		 Set<Integer> after = new HashSet<>();
		 Document afterDocument = Jsoup.parse(boardDto.getBoardContent());
		 Elements afterElements = afterDocument.select(".custom-image");
		 for (Element element : afterElements) {
			 int attachmentNo = Integer.parseInt(element.attr("data-pk"));
			 after.add(attachmentNo);
		 }
		 // 삭제된 이미지 처리
		 Set<Integer> minus = new HashSet<>(before);
		 minus.removeAll(after);
		 for (int attachmentNo : minus) {
			 mediaService.delete(attachmentNo);
		 }
		 boardDao.update(boardDto);
		 return "redirect:detail?boardNo=" + boardDto.getBoardNo();
	 }

}