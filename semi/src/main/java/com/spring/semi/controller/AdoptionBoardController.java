package com.spring.semi.controller;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

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
import com.spring.semi.dao.ReplyDao;
import com.spring.semi.dto.BoardDto;
import com.spring.semi.dto.CategoryDto;
import com.spring.semi.dto.HeaderDto;
import com.spring.semi.dto.MemberDto;
import com.spring.semi.error.TargetNotfoundException;
import com.spring.semi.service.MediaService;
import com.spring.semi.vo.BoardVO;
import com.spring.semi.vo.PageFilterVO;
import com.spring.semi.vo.PageVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/board/adoption")
public class AdoptionBoardController {

    private final MediaService mediaService;

    @Autowired
    private BoardDao boardDao;
    @Autowired
    private MemberDao memberDao;
    @Autowired
    private ReplyDao replyDao;
    @Autowired
    private HeaderDao headerDao;
    @Autowired
    private CategoryDao categoryDao;

    @Autowired
    public AdoptionBoardController(MediaService mediaService) {
        this.mediaService = mediaService;
    }

    // 글 등록 페이지
    @GetMapping("/write")
    public String writeForm(Model model) {
        List<HeaderDto> headerList = headerDao.selectAll("animal");
        model.addAttribute("headerList", headerList);
        return "/WEB-INF/views/board/adoption/write.jsp";
    }

    // 글 등록 처리
    @PostMapping("/write")
    public String write(@ModelAttribute BoardDto boardDto, HttpSession session, Model model) {
        String loginId = (String) session.getAttribute("loginId");
        if (loginId == null) throw new IllegalStateException("로그인 정보가 없습니다.");

        boardDto.setBoardWriter(loginId);
        if (boardDto.getBoardContent() == null || boardDto.getBoardContent().trim().isEmpty()) {
            boardDto.setBoardContent("(내용 없음)");
        }

        boardDto.setBoardNo(boardDao.sequence());
        int boardType = 4; // 입양 게시판 카테고리
        boardDao.insert(boardDto, boardType);

        // 포인트 지급
        memberDao.addPoint(loginId, 60);
        MemberDto member = memberDao.selectOne(loginId);
        model.addAttribute("memberPoint", member.getMemberPoint());

        return "redirect:detail?boardNo=" + boardDto.getBoardNo();
    }



    @GetMapping("/list")
    public String list(
            @ModelAttribute PageFilterVO pageFilterVO,
            Model model) {

        int boardType = 4; // 입양 게시판 고정 타입
        
        // 이전에 남아있을 수 있는 일반 검색 필드를 초기화 (헤더 필터링에 우선순위 부여)
        // PageFilterVO는 @ModelAttribute로 바인딩될 때 URL의 animalHeaderName/typeHeaderName 값이 그대로 들어옵니다.
        pageFilterVO.setColumn(null); 
        pageFilterVO.setKeyword(null);
        
        // ⭐ 1. PageFilterVO에 바인딩된 헤더 필터링 정보 분석 및 설정
        String keyword = null;
        String column = null;
        
        String animalHeaderName = pageFilterVO.getAnimalHeaderName();
        String typeHeaderName = pageFilterVO.getTypeHeaderName();
        
        boolean hasAnimalHeader = animalHeaderName != null && !animalHeaderName.isEmpty();
        boolean hasTypeHeader = typeHeaderName != null && !typeHeaderName.isEmpty();

        // animalHeaderName 필터가 유효한 경우
        if (hasAnimalHeader) {
            column = "animal_header_name";
            keyword = animalHeaderName;
        } 
        // typeHeaderName 필터가 유효한 경우
        else if (hasTypeHeader) {
            column = "type_header_name";
            keyword = typeHeaderName;
        }
        
        // keyword가 설정되었다면, PageFilterVO의 column/keyword 필드를 덮어씁니다.
        if (keyword != null) {
            // 이 두 필드만 설정하면, PageFilterVO.isSearch()가 자동으로 true가 됩니다.
            pageFilterVO.setColumn(column);
            pageFilterVO.setKeyword(keyword);
            
            // pageFilterVO.setList(false); // <--- ❌ 이 호출은 제거되었습니다.
        } 
        // keyword가 설정되지 않았고, VO에 일반 검색(column, keyword) 값도 없다면 isList()가 true 상태가 유지됩니다.
        
        // selectedName을 Model에 추가 (JSP에서 활성화된 헤더 표시용)
        String selectedAnimalName = hasAnimalHeader ? animalHeaderName : null;
        String selectedTypeName = hasTypeHeader ? typeHeaderName : null;
        
        // 페이징 처리
        pageFilterVO.setSize(10);
        // DAO 호출: PageFilterVO.isList()는 column/keyword 설정에 따라 자동으로 결정됨
        pageFilterVO.setDataCount(boardDao.countFilter(pageFilterVO, boardType));

        
        // ⭐ 2. 목록 조회 (DAO 호출)
        List<BoardVO> boardList = boardDao.selectFilterListWithPaging(pageFilterVO, boardType);

        // ⭐ 3. JSP에 전달할 데이터 준비 및 '전체' 항목 제거 (기존 로직 유지)
        List<HeaderDto> animalList = headerDao.selectAll("animal").stream()
            .filter(header -> header.getHeaderNo() != 0).collect(Collectors.toList());
            
        List<HeaderDto> typeList = headerDao.selectAll("type").stream()
            .filter(header -> header.getHeaderNo() != 0).collect(Collectors.toList());

        CategoryDto categoryDto = categoryDao.selectOne(boardType); 
        
        // ... (Model에 값 추가)
        model.addAttribute("animalList", animalList);
        model.addAttribute("typeList", typeList);
        model.addAttribute("boardList", boardList);
        model.addAttribute("pageVO", pageFilterVO); // PageFilterVO를 pageVO 이름으로 JSP에 전달
        model.addAttribute("selectedAnimalHeaderName", selectedAnimalName);
        model.addAttribute("selectedTypeHeaderName", selectedTypeName);
        model.addAttribute("category", categoryDto);
        model.addAttribute("boardType", boardType);


        return "/WEB-INF/views/board/adoption/list.jsp";
    }
    // 글 수정 페이지
    @GetMapping("/edit")
    public String editForm(Model model, @RequestParam int boardNo) {
        BoardDto boardDto = boardDao.selectOne(boardNo);
        if (boardDto == null) throw new TargetNotfoundException("존재하지 않는 글입니다.");

        List<HeaderDto> animalList = headerDao.selectAll("animal");
        List<HeaderDto> typeList = headerDao.selectAll("type");

        model.addAttribute("animalList", animalList);
        model.addAttribute("typeList", typeList);
        model.addAttribute("boardDto", boardDto);

        return "/WEB-INF/views/board/adoption/edit.jsp";
    }

    // 글 수정 처리
    @PostMapping("/edit")
    public String edit(@ModelAttribute BoardDto boardDto) {
        BoardDto beforeDto = boardDao.selectOne(boardDto.getBoardNo());
        if (beforeDto == null) throw new TargetNotfoundException("존재하지 않는 글입니다.");

        // 기존/수정 후 이미지 비교
        Set<Integer> before = extractAttachmentNos(beforeDto.getBoardContent());
        Set<Integer> after = extractAttachmentNos(boardDto.getBoardContent());

        before.removeAll(after);
        for (int attachmentNo : before) {
            mediaService.delete(attachmentNo);
        }

        boardDao.update(boardDto);
        return "redirect:detail?boardNo=" + boardDto.getBoardNo();
    }

    // 글 삭제
    @RequestMapping("/delete")
    public String delete(@RequestParam int boardNo) {
        BoardDto boardDto = boardDao.selectOne(boardNo);
        if (boardDto == null) throw new TargetNotfoundException("존재하지 않는 글입니다.");

        // 이미지 삭제
        Set<Integer> attachments = extractAttachmentNos(boardDto.getBoardContent());
        for (int attachmentNo : attachments) {
            mediaService.delete(attachmentNo);
        }

        boardDao.delete(boardNo);
        return "redirect:list";
    }

    // 상세보기
    @RequestMapping("/detail")
    public String detail(HttpSession session, Model model, @RequestParam int boardNo) {
        BoardDto boardDto = boardDao.selectOne(boardNo);
        if (boardDto == null) throw new TargetNotfoundException("존재하지 않는 글 번호");

        model.addAttribute("boardDto", boardDto);

        HeaderDto animalHeaderDto = headerDao.selectOne(boardDto.getBoardAnimalHeader(), "animal");
        HeaderDto typeHeaderDto = headerDao.selectOne(boardDto.getBoardTypeHeader(), "type");
        model.addAttribute("animalHeaderDto", animalHeaderDto);
        model.addAttribute("typeHeaderDto", typeHeaderDto);

        if (boardDto.getBoardWriter() != null) {
            MemberDto memberDto = memberDao.selectOne(boardDto.getBoardWriter());
            model.addAttribute("memberDto", memberDto);
        }

        return "/WEB-INF/views/board/adoption/detail.jsp";
    }

    // 🔹 내부 헬퍼 메서드
    private Set<Integer> extractAttachmentNos(String html) {
        Set<Integer> set = new HashSet<>();
        Document doc = Jsoup.parse(html);
        Elements elements = doc.select(".custom-image");
        for (Element e : elements) {
            try {
                set.add(Integer.parseInt(e.attr("data-pk")));
            } catch (NumberFormatException ignore) {}
        }
        return set;
    }
}

