package com.spring.semi.controller;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.util.UriUtils;

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
import com.spring.semi.vo.PageVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/board")
public class CreateBoardController {
	 private final MediaService mediaService;
    @Autowired private BoardDao boardDao;
    @Autowired private CategoryDao categoryDao;
    @Autowired private MemberDao memberDao;
    @Autowired private HeaderDao headerDao;
    CreateBoardController(MediaService mediaService) {
        this.mediaService = mediaService;
    }
	
 // 목록 + 정렬 기능 (카테고리별)
    @GetMapping("/{categoryName}/list")
    public String list(
            @PathVariable String categoryName,
            @RequestParam(required = false, defaultValue = "wtime") String orderBy,
            @ModelAttribute("pageVO") PageVO pageVO,
            Model model) {

        // URL 디코딩
        categoryName = URLDecoder.decode(categoryName, StandardCharsets.UTF_8);

        // 카테고리 조회
        CategoryDto category = categoryDao.selectOneByName(categoryName);
        if (category == null) {
            throw new TargetNotfoundException("존재하지 않는 게시판입니다.");
        }
        int categoryNo = category.getCategoryNo();

        // 페이징 설정
        pageVO.setSize(10);
        int dataCount = boardDao.count(pageVO, categoryNo);
        pageVO.setDataCount(dataCount);

        List<BoardDto> boardList = boardDao.selectList(
                pageVO.getBegin(), pageVO.getEnd(), orderBy, categoryNo);

        // 헤더 매핑
        Map<Integer, HeaderDto> headerMap = new HashMap<>();
        for (BoardDto board : boardList) {
            if (board.getBoardHeader() >= 1) {
                HeaderDto headerDto = headerDao.selectOne(board.getBoardHeader());
                if (headerDto != null) {
                    headerMap.put(board.getBoardNo(), headerDto);
                }
            }
        }

        model.addAttribute("category", category);
        model.addAttribute("boardList", boardList);
        model.addAttribute("headerMap", headerMap);
        model.addAttribute("pageVO", pageVO);
        model.addAttribute("orderBy", orderBy);

        return "/WEB-INF/views/board/common/list.jsp";
    }



    //작성

    @GetMapping("/{categoryName}/write")
    public String write(@PathVariable String categoryName, Model model) {
        categoryName = URLDecoder.decode(categoryName, StandardCharsets.UTF_8);

        CategoryDto category = categoryDao.selectOneByName(categoryName);
        if (category == null)
            throw new TargetNotfoundException("존재하지 않는 게시판입니다.");

 
        List<HeaderDto> headerList = headerDao.selectAll();
        model.addAttribute("headerList", headerList);
        model.addAttribute("category", category);
        return "/WEB-INF/views/board/common/write.jsp";
    }


    @PostMapping("/{categoryName}/write")
    public String write(
            @PathVariable String categoryName,
            @ModelAttribute BoardDto boardDto,
            HttpSession session) {

        CategoryDto category = categoryDao.selectOneByName(categoryName);
        if (category == null)
            throw new TargetNotfoundException("존재하지 않는 게시판입니다.");

        int categoryNo = category.getCategoryNo();

        String loginId = (String) session.getAttribute("loginId");
        if (loginId == null) throw new IllegalStateException("로그인 정보가 없습니다.");

        boardDto.setBoardWriter(loginId);
        boardDto.setBoardCategoryNo(categoryNo);

     
        Integer headerNo = boardDto.getBoardHeader();
        if (headerNo != null) {
            HeaderDto headerCheck = headerDao.selectOne(headerNo);
            if (headerCheck == null) throw new IllegalArgumentException("존재하지 않는 헤더입니다.");
        }

        int boardNo = boardDao.sequence();
        boardDto.setBoardNo(boardNo);
        boardDao.insert(boardDto, categoryNo);

        // 
        String encodedCategory = URLEncoder.encode(categoryName, StandardCharsets.UTF_8);
        return "redirect:/board/" + encodedCategory + "/detail?boardNo=" + boardNo;
    }

    //상세

    @GetMapping("/{categoryName}/detail")
    public String detail(
            @PathVariable String categoryName,
            @RequestParam int boardNo,
            Model model) {

        categoryName = URLDecoder.decode(categoryName, StandardCharsets.UTF_8);

        CategoryDto category = categoryDao.selectOneByName(categoryName);
        if (category == null)
            throw new TargetNotfoundException("존재하지 않는 게시판입니다.");

        BoardDto boardDto = boardDao.selectOne(boardNo);
        if (boardDto == null)
            throw new TargetNotfoundException("존재하지 않는 게시글입니다.");

 
        HeaderDto header = headerDao.selectOne(boardDto.getBoardHeader());
        if (header != null) {
            model.addAttribute("headerDto", header);
        }

        if (boardDto.getBoardWriter() != null) {
            MemberDto memberDto = memberDao.selectOne(boardDto.getBoardWriter());
            model.addAttribute("memberDto", memberDto);
        }

        model.addAttribute("category", category);
        model.addAttribute("boardDto", boardDto);
        return "/WEB-INF/views/board/common/detail.jsp";
    }

    //삭제
    @PostMapping("/{categoryName}/delete")
    public String delete(
            @PathVariable String categoryName,
            @RequestParam int boardNo,
            HttpSession session) {

        CategoryDto category = categoryDao.selectOneByName(categoryName);
        if (category == null)
            throw new TargetNotfoundException("존재하지 않는 게시판입니다.");

        BoardDto boardDto = boardDao.selectOne(boardNo);
        if (boardDto == null)
            throw new TargetNotfoundException("존재하지 않는 게시글입니다.");

        String loginId = (String) session.getAttribute("loginId");
        if (loginId == null || !boardDto.getBoardWriter().equals(loginId)) {
            throw new TargetNotfoundException("삭제 권한이 없습니다.");
        }

        boardDao.delete(boardNo);

        String encodedCategory = UriUtils.encodePathSegment(categoryName, StandardCharsets.UTF_8);
        return "redirect:/board/" + encodedCategory + "/list";
    }


    //수정
    @GetMapping("/{categoryName}/edit")
    public String editForm(
            @PathVariable String categoryName,
            @RequestParam int boardNo,
            HttpSession session,
            Model model) {

        categoryName = URLDecoder.decode(categoryName, StandardCharsets.UTF_8);

        CategoryDto category = categoryDao.selectOneByName(categoryName);
        if (category == null)
            throw new TargetNotfoundException("존재하지 않는 게시판입니다.");

        BoardDto boardDto = boardDao.selectOne(boardNo);
        if (boardDto == null)
            throw new TargetNotfoundException("존재하지 않는 게시글입니다.");

        String loginId = (String) session.getAttribute("loginId");
        if (!boardDto.getBoardWriter().equals(loginId)) {
            throw new TargetNotfoundException("수정 권한이 없습니다.");
        }

        //
        List<HeaderDto> headerList = headerDao.selectAll();
        model.addAttribute("headerList", headerList);

        model.addAttribute("category", category);
        model.addAttribute("boardDto", boardDto);
        return "/WEB-INF/views/board/common/edit.jsp";
    }


    @PostMapping("/{categoryName}/edit")
    public String edit(
            @PathVariable String categoryName,
            @ModelAttribute BoardDto boardDto,
            HttpSession session) {

        categoryName = URLDecoder.decode(categoryName, StandardCharsets.UTF_8);

        BoardDto existing = boardDao.selectOne(boardDto.getBoardNo());
        if (existing == null)
            throw new TargetNotfoundException("존재하지 않는 게시글입니다.");

        String loginId = (String) session.getAttribute("loginId");
        if (!existing.getBoardWriter().equals(loginId)) {
            throw new TargetNotfoundException("수정 권한이 없습니다.");
        }


        Integer headerNo = boardDto.getBoardHeader();
        if (headerNo != null) {
            HeaderDto headerCheck = headerDao.selectOne(headerNo);
            if (headerCheck == null) throw new IllegalArgumentException("존재하지 않는 헤더입니다.");
        }

        boardDao.update(boardDto);

        String encodedCategory = UriUtils.encodePathSegment(categoryName, StandardCharsets.UTF_8);
        return "redirect:/board/" + encodedCategory + "/detail?boardNo=" + boardDto.getBoardNo();
    }
}

