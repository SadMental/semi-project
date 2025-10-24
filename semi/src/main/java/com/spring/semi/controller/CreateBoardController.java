package com.spring.semi.controller;

import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
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
import com.spring.semi.vo.PageVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/board")
public class CreateBoardController {

    @Autowired private BoardDao boardDao;
    @Autowired private CategoryDao categoryDao;
    @Autowired private MemberDao memberDao;
    @Autowired private HeaderDao headerDao;
    
    // 목록
    @GetMapping("/{categoryName}/list")
    public String list(
            @PathVariable String categoryName,
            @ModelAttribute("pageVO") PageVO pageVO,
            Model model) {

        categoryName = URLDecoder.decode(categoryName, StandardCharsets.UTF_8);

        CategoryDto category = categoryDao.selectOneByName(categoryName);
        if (category == null)
            throw new TargetNotfoundException("존재하지 않는 게시판입니다.");

        int categoryNo = category.getCategoryNo();

        model.addAttribute("category", category);
        model.addAttribute("boardList", boardDao.selectListWithPaging(pageVO, categoryNo));

        pageVO.setDataCount(boardDao.count(pageVO, categoryNo));
        model.addAttribute("pageVO", pageVO);

        return "/WEB-INF/views/board/common/list.jsp";
    }

    // 작성 폼
    @GetMapping("/{categoryName}/write")
    public String writeForm(@PathVariable String categoryName, Model model) {
        categoryName = URLDecoder.decode(categoryName, StandardCharsets.UTF_8);

        CategoryDto category = categoryDao.selectOneByName(categoryName);
        if (category == null)
            throw new TargetNotfoundException("존재하지 않는 게시판입니다.");

        model.addAttribute("category", category);
        return "/WEB-INF/views/board/common/write.jsp";
    }

    // 작성 처리
    @PostMapping("/{categoryName}/write")
    public String write(
            @PathVariable String categoryName,
            @ModelAttribute BoardDto boardDto,
            @ModelAttribute HeaderDto headerDto,
            HttpSession session) {

        CategoryDto category = categoryDao.selectOneByName(categoryName);
        if (category == null)
            throw new TargetNotfoundException("존재하지 않는 게시판입니다.");

        int categoryNo = category.getCategoryNo();

        String loginId = (String) session.getAttribute("loginId");
        boardDto.setBoardWriter(loginId);
        boardDto.setBoardCategoryNo(categoryNo);

        int boardNo = boardDao.sequence();
        boardDto.setBoardNo(boardNo);

        int headerNo = headerDao.sequence();
        headerDto.setHeaderNo(headerNo);
        headerDao.insert(headerDto);

        boardDto.setBoardHeader(headerNo);
        boardDao.insert(boardDto, categoryNo);

        // 한글 URL 인코딩 적용
        String encodedCategory = URLEncoder.encode(categoryName, StandardCharsets.UTF_8);
        return "redirect:/board/" + encodedCategory + "/detail?boardNo=" + boardNo;
    }


    // 상세
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

        if (boardDto.getBoardWriter() != null) {
            MemberDto memberDto = memberDao.selectOne(boardDto.getBoardWriter());
            model.addAttribute("memberDto", memberDto);
        }

        model.addAttribute("category", category);
        model.addAttribute("boardDto", boardDto);

        return "/WEB-INF/views/board/common/detail.jsp";
    }
 // 삭제
    @PostMapping("/{categoryName}/delete")
    public String delete(
            @PathVariable String categoryName,
            @RequestParam int boardNo,
            HttpSession session) {

        CategoryDto category = categoryDao.selectOneByName(categoryName);
        if (category == null) {
            throw new TargetNotfoundException("존재하지 않는 게시판입니다.");
        }

        BoardDto boardDto = boardDao.selectOne(boardNo);
        if (boardDto == null) {
            throw new TargetNotfoundException("존재하지 않는 게시글입니다.");
        }

        String loginId = (String) session.getAttribute("loginId");
        if (loginId == null || !boardDto.getBoardWriter().equals(loginId)) {
            throw new TargetNotfoundException("삭제 권한이 없습니다.");
        }

        boardDao.delete(boardNo);
        // 한글 URL 인코딩 적용
        String encodedCategory = UriUtils.encodePathSegment(categoryName, StandardCharsets.UTF_8);
        return "redirect:/board/" + encodedCategory + "/list";
    }




    // 수정
    @GetMapping("/{categoryName}/edit")
    public String edit(
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

        model.addAttribute("category", category);
        model.addAttribute("boardDto", boardDto);
        

        return "/WEB-INF/views/board/common/edit.jsp";
    }
    // 수정
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
        boardDao.update(boardDto);
        String encodedCategory = UriUtils.encodePathSegment(categoryName, StandardCharsets.UTF_8);
        return "redirect:/board/" + encodedCategory + "/detail?boardNo=" + boardDto.getBoardNo();
    }

}
