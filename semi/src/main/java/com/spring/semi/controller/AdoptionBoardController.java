package com.spring.semi.controller;

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
import com.spring.semi.dao.HeaderDao;
import com.spring.semi.dao.MemberDao;
import com.spring.semi.dao.ReplyDao;
import com.spring.semi.dto.BoardDto;
import com.spring.semi.dto.HeaderDto;
import com.spring.semi.dto.MemberDto;

import com.spring.semi.error.NeedPermissionException;
import com.spring.semi.error.TargetNotfoundException;
import com.spring.semi.service.MediaService;
import com.spring.semi.vo.PageVO;

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
    public String writeForm(Model model) {
        List<HeaderDto> headerList = headerDao.selectAll(); // DB에서 모든 header 조회
        model.addAttribute("headerList", headerList);
        
        return "/WEB-INF/views/adoptionBoard/write.jsp";
        
    }
    
    @PostMapping("/write")
    public String write(@ModelAttribute BoardDto boardDto,
                        @RequestParam(required = false) String headerName, // optional로 받고 null 체크
                        HttpSession session) {

        // 1️ headerName 체크 (빈값이나 null이면 처리 중단)
        if (headerName == null || headerName.trim().isEmpty()) {
            // 오류 메시지 세션이나 model에 담아서 write.jsp로 다시
            // session.setAttribute("error", "머리글을 선택해야 합니다.");
            return "redirect:write";
        }

        // 2️ 로그인 사용자
        String loginId = (String) session.getAttribute("loginId");
        boardDto.setBoardWriter(loginId);

        // 3️headerNo 조회
        HeaderDto existingHeader = headerDao.selectByName(headerName);
        if (existingHeader == null) {
            // DB에 존재하지 않는 headerName → 허용하지 않음
            return "redirect:write";
        }
        int headerNo = existingHeader.getHeaderNo();

        // 4️ boardNo 시퀀스 호출 → 이제야 시퀀스 증가
        int boardNo = boardDao.sequence();
        boardDto.setBoardNo(boardNo);
        boardDto.setBoardHeader(headerNo);

        // 5️ 글 삽입
        boardDao.insert(boardDto, 3);

        return "redirect:detail?boardNo=" + boardNo;
    }
    // 글목록
    @RequestMapping("/list")
    public String list(@ModelAttribute PageVO pageVO, Model model) {
        int boardType = 3; 
        pageVO.setSize(10); 

        int dataCount = boardDao.count(pageVO, boardType);
        pageVO.setDataCount(dataCount); 

        List<BoardDto> boardList = boardDao.selectListWithPaging(pageVO, boardType);

        // BoardDto마다 HeaderDto를 만들어 Map으로 매핑
        Map<Integer, HeaderDto> headerMap = new HashMap<>();
        for (BoardDto b : boardList) {
            HeaderDto headerDto = headerDao.selectOne(b.getBoardHeader());
            if (headerDto != null) {
                headerMap.put(b.getBoardNo(), headerDto);
            }
        }

        model.addAttribute("boardList", boardList);
        model.addAttribute("headerMap", headerMap); // JSP에서 사용
        model.addAttribute("pageVO", pageVO);

        return "/WEB-INF/views/adoptionBoard/list.jsp";
    }
    // 글 수정
    @GetMapping("/edit")
    public String edit(Model model, @RequestParam int boardNo) {
        BoardDto boardDto = boardDao.selectOne(boardNo);
        List<HeaderDto> headerList = headerDao.selectAll(); // DB에서 모든 header 조회
        if (boardDto == null) throw new TargetNotfoundException("존재하지 않는 글");
        model.addAttribute("headerList", headerList);
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
        boardDao.delete(boardNo);

        return "redirect:list";
    }

    //글상세보기
    @RequestMapping("/detail")
    public String detail(Model model, @RequestParam int boardNo) {
        // 게시글 조회
        BoardDto boardDto = boardDao.selectOne(boardNo);
        if (boardDto == null) throw new TargetNotfoundException("존재하지 않는 글 번호");
        model.addAttribute("boardDto", boardDto);

     // 헤더 조회
        HeaderDto headerDto = headerDao.selectOne(boardDto.getBoardHeader());
        Map<Integer, HeaderDto> headerMap = new HashMap<>();
        if(headerDto != null) {
            headerMap.put(boardDto.getBoardNo(), headerDto);
        }
        model.addAttribute("headerMap", headerMap);

        // 작성자 정보
        if (boardDto.getBoardWriter() != null) {
            MemberDto memberDto = memberDao.selectOne(boardDto.getBoardWriter());
            model.addAttribute("memberDto", memberDto);
        }

        return "/WEB-INF/views/adoptionBoard/detail.jsp";
    }
}


