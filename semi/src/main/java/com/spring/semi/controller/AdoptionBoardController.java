package com.spring.semi.controller;

import java.util.HashSet;
import java.util.List;
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
import com.spring.semi.dao.ReplyDao;
import com.spring.semi.dto.BoardDto;
import com.spring.semi.dto.HeaderDto;
import com.spring.semi.dto.MemberDto;

import com.spring.semi.error.NeedPermissionException;
import com.spring.semi.error.TargetNotfoundException;
import com.spring.semi.service.MediaService;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/adoptionBoard")
public class AdoptionBoardController {

    private final MediaService attachmentService;
    @Autowired
    private BoardDao boardDao;
    @Autowired
    private MemberDao memberDao;
    @Autowired
    private ReplyDao replyDao;
  @Autowired
  private HeaderDao headerDao;
    AdoptionBoardController(MediaService attachmentService) {
        this.attachmentService = attachmentService;
    }

    // 글 등록
    @GetMapping("/write")
    public String write() {
        return "/WEB-INF/views/adoptionBoard/write.jsp";
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

        boardDao.insert(boardDto, 3);
        return "redirect:detail?boardNo=" + boardNo;
    }

    // 글목록
    @RequestMapping("/list")
    public String list(Model model) {
    	List<BoardDto> boardList= boardDao.selectList(3);
    	model.addAttribute("boardList", boardList);
    	return "/WEB-INF/views/adoptionBoard/list.jsp";
    }
    // 글 수정
    @GetMapping("/edit")
    public String edit(Model model, @RequestParam int boardNo) {
        BoardDto boardDto = boardDao.selectOne(boardNo);
        if (boardDto == null) throw new TargetNotfoundException("존재하지 않는 글");
        model.addAttribute("boardDto", boardDto);
        return "/WEB-INF/views/adoptionBoard/edit.jsp";
    }

    @PostMapping("/edit")
    public String edit(@ModelAttribute BoardDto boardDto) {
        BoardDto beforeDto = boardDao.selectOne(boardDto.getBoardNo());
        if (beforeDto == null) throw new TargetNotfoundException("존재하지 않는 글");

        // 기존글과 변경될 글의 이미지번호를 차이를 구하기 위한 코드
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
            attachmentService.delete(attachmentNo);
        }

        // 글 수정
        boardDao.update(boardDto);

        return "redirect:detail?boardNo=" + boardDto.getBoardNo();
    }

    // 글 삭제
    @RequestMapping("/delete")
    public String delete(@RequestParam int boardNo) {
        BoardDto boardDto = boardDao.selectOne(boardNo);
        if (boardDto == null) throw new TargetNotfoundException("존재하지 않는 글");

        // 글 내용에서 이미지 삭제 처리
        Document document = Jsoup.parse(boardDto.getBoardContent());
        Elements elements = document.select(".custom-image"); // <img>를 찾고
        for (Element element : elements) {
            int attachmentNo = Integer.parseInt(element.attr("data-pk"));
            attachmentService.delete(attachmentNo);
        }

        // 글 삭제
        boardDao.delete(4, boardNo);

        return "redirect:list";
    }

    // 글 상세보기
    @RequestMapping("/detail")
    public String detail(Model model, @RequestParam int boardNo) {
        BoardDto boardDto = boardDao.selectOne(boardNo);
        if (boardDto == null) throw new TargetNotfoundException("존재하지 않는 글 번호");
        model.addAttribute("boardDto", boardDto);
        // 작성자 정보 추가
        if (boardDto.getBoardWriter() != null) {
            MemberDto memberDto = memberDao.selectOne(boardDto.getBoardWriter());
            model.addAttribute("memberDto", memberDto);
        }

        return "/WEB-INF/views/adoptionBoard/detail.jsp";
    }
}
	 

