package com.spring.semi.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
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
            @ModelAttribute(value = "pageVO") PageVO pageVO,
            Model model) {

        // 카테고리 이름으로 카테고리 정보 조회
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

        return "redirect:/board/" + categoryName + "/detail?boardNo=" + boardNo;
    }

    // 상세 보기
    @GetMapping("/{categoryName}/detail")
    public String detail(
            @PathVariable String categoryName,
            @RequestParam int boardNo,
            Model model) {

        CategoryDto category = categoryDao.selectOneByName(categoryName);
        if (category == null)
            throw new TargetNotfoundException("존재하지 않는 게시판입니다.");
        
        int categoryNo = category.getCategoryNo();

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
}
