package com.spring.semi.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

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

        CategoryDto category = categoryDao.selectOneByName(categoryName);
        if (category == null)
            throw new TargetNotfoundException("존재하지 않는 게시판입니다.");

        int categoryNo = category.getCategoryNo();
        pageVO.setSize(10);
        int dataCount = boardDao.count(pageVO, categoryNo);
        pageVO.setDataCount(dataCount);

        List<BoardDto> boardList = boardDao.selectListWithPaging(pageVO, categoryNo);

        // BoardDto마다 HeaderDto를 만들어 Map으로 매핑 (리스트 전용)
        Map<Integer, HeaderDto> headerMap = new HashMap<>();
        for (BoardDto b : boardList) {
            HeaderDto headerDto = headerDao.selectOne(b.getBoardHeader());
            if (headerDto != null) {
                headerMap.put(b.getBoardNo(), headerDto);
            }
        }

        model.addAttribute("category", category);
        model.addAttribute("boardList", boardList);
        model.addAttribute("headerMap", headerMap);
        model.addAttribute("pageVO", pageVO);

        return "/WEB-INF/views/board/common/list.jsp";
    }

    // 작성 폼
    @GetMapping("/{categoryName}/write")
    public String writeForm(@PathVariable String categoryName, Model model) {
        CategoryDto category = categoryDao.selectOneByName(categoryName);
        if (category == null)
            throw new TargetNotfoundException("존재하지 않는 게시판입니다.");

        // 헤더 목록 조회
        List<HeaderDto> headerList = headerDao.selectAll();
        model.addAttribute("category", category);
        model.addAttribute("headerList", headerList);

        return "/WEB-INF/views/board/common/write.jsp";
    }

    // 작성 처리
    @PostMapping("/{categoryName}/write")
    public String write(
            @PathVariable String categoryName,
            @ModelAttribute BoardDto boardDto,
            HttpSession session) {

        CategoryDto category = categoryDao.selectOneByName(categoryName);
        if (category == null)
            throw new TargetNotfoundException("존재하지 않는 게시판입니다.");

        int categoryNo = category.getCategoryNo();
        boardDto.setBoardCategoryNo(categoryNo);

        String loginId = (String) session.getAttribute("loginId");
        if (loginId == null)
            throw new IllegalStateException("로그인 정보가 없습니다.");
        boardDto.setBoardWriter(loginId);

        if (boardDto.getBoardContent() == null || boardDto.getBoardContent().trim().isEmpty()) {
            boardDto.setBoardContent("(내용 없음)");
        }

        // header 번호 기본값 처리
        if (boardDto.getBoardHeader() == 0) {
            boardDto.setBoardHeader(1); // 기본 header_no
        }

        boardDto.setBoardNo(boardDao.sequence());
        boardDao.insert(boardDto, categoryNo);

        return "redirect:/board/" + categoryName + "/detail?boardNo=" + boardDto.getBoardNo();
    }

    // 상세
    @GetMapping("/{categoryName}/detail")
    public String detail(
            @PathVariable String categoryName,
            @RequestParam int boardNo,
            Model model) {

        CategoryDto category = categoryDao.selectOneByName(categoryName);
        if (category == null)
            throw new TargetNotfoundException("존재하지 않는 게시판입니다.");

        BoardDto boardDto = boardDao.selectOne(boardNo);
        if (boardDto == null)
            throw new TargetNotfoundException("존재하지 않는 게시글입니다.");

        // 헤더 조회
        HeaderDto headerDto = headerDao.selectOne(boardDto.getBoardHeader());
        if (headerDto != null) {
            model.addAttribute("headerDto", headerDto);
        }

        // 작성자 조회
        MemberDto memberDto = null;
        if (boardDto.getBoardWriter() != null) {
            memberDto = memberDao.selectOne(boardDto.getBoardWriter());
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
        if (category == null)
            throw new TargetNotfoundException("존재하지 않는 게시판입니다.");

        BoardDto boardDto = boardDao.selectOne(boardNo);
        if (boardDto == null)
            throw new TargetNotfoundException("존재하지 않는 게시글입니다.");

        String loginId = (String) session.getAttribute("loginId");
        if (!boardDto.getBoardWriter().equals(loginId)) {
            throw new TargetNotfoundException("삭제 권한이 없습니다.");
        }

        boardDao.delete(boardNo);
        return "redirect:/board/" + categoryName + "/list";
    }

    // 수정 폼
    @GetMapping("/{categoryName}/edit")
    public String editForm(
            @PathVariable String categoryName,
            @RequestParam int boardNo,
            HttpSession session,
            Model model) {

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

        // 헤더 목록 조회
        List<HeaderDto> headerList = headerDao.selectAll();
        model.addAttribute("category", category);
        model.addAttribute("boardDto", boardDto);
        model.addAttribute("headerList", headerList);

        return "/WEB-INF/views/board/common/edit.jsp";
    }

    // 수정 처리
    @PostMapping("/{categoryName}/edit")
    public String edit(
            @PathVariable String categoryName,
            @ModelAttribute BoardDto boardDto,
            HttpSession session) {

        BoardDto existing = boardDao.selectOne(boardDto.getBoardNo());
        if (existing == null)
            throw new TargetNotfoundException("존재하지 않는 게시글입니다.");

        String loginId = (String) session.getAttribute("loginId");
        if (!existing.getBoardWriter().equals(loginId)) {
            throw new TargetNotfoundException("수정 권한이 없습니다.");
        }

        // boardHeader 필드 포함 수정 가능
        boardDao.update(boardDto);
        return "redirect:/board/" + categoryName + "/detail?boardNo=" + boardDto.getBoardNo();
    }
}

