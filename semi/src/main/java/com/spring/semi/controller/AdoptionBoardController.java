package com.spring.semi.controller;

import java.io.IOException;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

import org.apache.coyote.BadRequestException;
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
import org.springframework.web.multipart.MultipartFile;

import com.spring.semi.dao.AnimalDao;
import com.spring.semi.dao.BoardDao;
import com.spring.semi.dao.CategoryDao;
import com.spring.semi.dao.HeaderDao;
import com.spring.semi.dao.MemberDao;
import com.spring.semi.dao.ReplyDao;
import com.spring.semi.dto.AnimalDto;
import com.spring.semi.dto.BoardDto;
import com.spring.semi.dto.CategoryDto;
import com.spring.semi.dto.HeaderDto;
import com.spring.semi.dto.MemberDto;
import com.spring.semi.error.TargetNotfoundException;
import com.spring.semi.service.MediaService;
import com.spring.semi.vo.AdoptDetailVO;
import com.spring.semi.vo.BoardVO;
import com.spring.semi.vo.PageFilterVO;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/board/adoption")
public class AdoptionBoardController {

    @Autowired private MediaService mediaService;
    @Autowired private BoardDao boardDao;
    @Autowired private MemberDao memberDao;
    @Autowired private ReplyDao replyDao;
    @Autowired private HeaderDao headerDao;
    @Autowired private CategoryDao categoryDao;
    @Autowired private AnimalDao animalDao;
    
    @Autowired
    public AdoptionBoardController(BoardDao boardDao) {
        this.boardDao = boardDao;
    }

    // =============================
    // 🔹 글 등록 페이지
    // =============================
    @GetMapping("/write")
    public String writeForm(HttpSession session, Model model) {
        String loginId = (String) session.getAttribute("loginId");
        if (loginId == null) return "redirect:/member/login";

        List<HeaderDto> animalList = headerDao.selectAll("animal");
        List<HeaderDto> typeList = headerDao.selectAll("type");
        List<AnimalDto> adoptableAnimalList = animalDao.selectFilterTMaster(loginId);

        model.addAttribute("animalList", animalList);
        model.addAttribute("typeList", typeList);
        model.addAttribute("adoptableAnimalList", adoptableAnimalList);

        return "/WEB-INF/views/board/adoption/write.jsp";
    }

    // =============================
    // 🔹 글 등록 처리
    // =============================
    @PostMapping("/write")
    public String write(
        @ModelAttribute AdoptDetailVO adoptDetailVO,
        @RequestParam(required = false) MultipartFile media,
        HttpSession session,
        Model model
    ) throws IllegalStateException, IOException {
        String loginId = (String) session.getAttribute("loginId");
        if (loginId == null) throw new IllegalStateException("로그인 정보가 없습니다.");

        int animalNo = adoptDetailVO.getAnimalNo();

        BoardDto boardDto = new BoardDto();
        boardDto.setBoardTitle(adoptDetailVO.getBoardTitle());
        boardDto.setBoardContent(adoptDetailVO.getBoardContent());
        boardDto.setBoardCategoryNo(adoptDetailVO.getBoardCategoryNo());
        boardDto.setBoardAnimalHeader(adoptDetailVO.getBoardAnimalHeader());
        boardDto.setBoardTypeHeader(adoptDetailVO.getBoardTypeHeader());
        boardDto.setBoardWriter(loginId);
        if (boardDto.getBoardContent() == null || boardDto.getBoardContent().trim().isEmpty()) {
            boardDto.setBoardContent("(내용 없음)");
        }

        boardDto.setBoardNo(boardDao.sequence());
        int boardType = 4;
        boardDao.insert(boardDto, boardType);
        boardDao.insertAnimalConnect(boardDto.getBoardNo(), animalNo);

        memberDao.addPoint(loginId, 60);
        MemberDto member = memberDao.selectOne(loginId);
        model.addAttribute("memberPoint", member.getMemberPoint());

        return "redirect:detail?boardNo=" + boardDto.getBoardNo();
    }

    // =============================
    // 🔹 글 목록
    // =============================
    @GetMapping("/list")
    public String list(@ModelAttribute PageFilterVO pageFilterVO, Model model) {
        final int boardType = 4;
        final int pageSize = 10;

        String orderBy = (pageFilterVO.getOrderBy() == null || pageFilterVO.getOrderBy().isBlank())
                ? "wtime" : pageFilterVO.getOrderBy();

        String keyword = null;
        if (pageFilterVO.getAnimalHeaderName() != null && !pageFilterVO.getAnimalHeaderName().isBlank()) {
            keyword = pageFilterVO.getAnimalHeaderName();
        } else if (pageFilterVO.getTypeHeaderName() != null && !pageFilterVO.getTypeHeaderName().isBlank()) {
            keyword = pageFilterVO.getTypeHeaderName();
        } else if (pageFilterVO.getKeyword() != null && !pageFilterVO.getKeyword().isBlank()) {
            keyword = pageFilterVO.getKeyword();
        }

        int page = (pageFilterVO.getPage() > 0) ? pageFilterVO.getPage() : 1;
        int begin = (page - 1) * pageSize + 1;
        int end = page * pageSize;

        List<BoardVO> boardList = boardDao.selectFilterList(begin, end, orderBy, boardType, keyword);
        int totalCount = boardDao.countFilter(pageFilterVO, boardType);

        pageFilterVO.setDataCount(totalCount);

        List<HeaderDto> animalList = headerDao.selectAll("animal").stream()
                .filter(h -> h.getHeaderNo() != 0)
                .collect(Collectors.toList());
        List<HeaderDto> typeList = headerDao.selectAll("type").stream()
                .filter(h -> h.getHeaderNo() != 0)
                .collect(Collectors.toList());
        CategoryDto categoryDto = categoryDao.selectOne(boardType);

        model.addAttribute("boardList", boardList);
        model.addAttribute("animalList", animalList);
        model.addAttribute("typeList", typeList);
        model.addAttribute("category", categoryDto);
        model.addAttribute("boardType", boardType);
        model.addAttribute("pageVO", pageFilterVO);
        model.addAttribute("selectedAnimalHeaderName", pageFilterVO.getAnimalHeaderName());
        model.addAttribute("selectedTypeHeaderName", pageFilterVO.getTypeHeaderName());
        model.addAttribute("selectedOrderBy", orderBy);

        return "/WEB-INF/views/board/adoption/list.jsp";
    }

    // =============================
    // 🔹 글 수정 페이지
    // =============================
    @GetMapping("/edit")
    public String editForm(
        Model model, 
        @RequestParam int boardNo,
        HttpSession session
    ) {
        // 1. 로그인 ID 및 권한 검사
        String loginId = (String) session.getAttribute("loginId");
        if (loginId == null) {
            throw new RuntimeException("로그인이 필요합니다."); 
        }
        
        // 2. 게시글 상세 정보 (AdoptDetailVO) 조회
        // AdoptDetailVO는 boardDto와 animalDto의 핵심 정보를 모두 포함하고 있습니다.
        AdoptDetailVO detailVO = boardDao.selectAdoptDetail(boardNo);
        
        if (detailVO == null) {
            throw new TargetNotfoundException("존재하지 않는 글이거나 동물 정보가 누락되었습니다.");
        }
        
        // 3. 권한 검사: 작성자인지 확인
        if (!loginId.equals(detailVO.getBoardWriter())) {
            throw new RuntimeException("수정 권한이 없습니다."); // 권한이 없으면 수정 페이지 진입 불가
        }

        // 4. 드롭다운 목록에 필요한 데이터 조회 (기존 로직 유지)
        List<HeaderDto> animalList = headerDao.selectAll("animal");
        List<HeaderDto> typeList = headerDao.selectAll("type");
        
        // 5. 현재 로그인된 사용자의 '분양 가능' 동물 목록 조회 (animalNo 드롭다운용)
        List<AnimalDto> adoptableAnimalList = animalDao.selectFilterTMaster(loginId);
        
        // 6. 모델에 데이터 추가 (detailVO를 중심으로 정리)
        model.addAttribute("animalList", animalList);
        model.addAttribute("typeList", typeList);
        model.addAttribute("adoptableAnimalList", adoptableAnimalList);
        
        // ✅ JSP가 참조할 객체를 detailVO 하나로 통일합니다.
        model.addAttribute("adoptDetailVO", detailVO); 
        
        // JSP에서 필요에 따라 사용할 수 있도록 별도 속성 추가 (선택 사항)
        model.addAttribute("currentAnimalNo", detailVO.getAnimalNo()); 

        return "/WEB-INF/views/board/adoption/edit.jsp";
    }
    @PostMapping("/edit")
	public String edit(@ModelAttribute BoardDto boardDto) {

		BoardDto beforeDto = boardDao.selectOne(boardDto.getBoardNo());
		if (beforeDto == null)
			throw new TargetNotfoundException("존재하지 않는 글");

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

    // =============================
    // 🔹 글 삭제 (첨부 안전 처리 추가)
    // =============================
    @RequestMapping("/delete")
    public String delete(@RequestParam int boardNo) {
        BoardDto boardDto = boardDao.selectOne(boardNo);
        if (boardDto == null) throw new TargetNotfoundException("존재하지 않는 글입니다.");

        deleteAttachmentsFromContent(boardDto.getBoardContent());
        boardDao.delete(boardNo);
        return "redirect:list";
    }

    // =============================
    // 🔹 상세보기
    // =============================
    @RequestMapping("/detail")
    public String detail(HttpSession session, Model model, @RequestParam int boardNo)
            throws BadRequestException {

        AdoptDetailVO adoptDetailVO = boardDao.selectAdoptDetail(boardNo);
        if (adoptDetailVO == null) throw new BadRequestException("존재하지 않는 글 번호입니다.");

        int animalNo = adoptDetailVO.getAnimalNo();
        try {
            int mediaNo = animalDao.findMediaNo(animalNo);
            adoptDetailVO.setMediaNo(mediaNo);
        } catch (Exception e) {
            adoptDetailVO.setMediaNo(null);
            System.out.println("DEBUG: Animal No " + animalNo + " 의 미디어 없음.");
        }

        model.addAttribute("adoptDetailVO", adoptDetailVO);
        return "/WEB-INF/views/board/adoption/detail.jsp";
    }

    // =============================
    // 🔹 분양 완료 처리
    // =============================
    @PostMapping("/completeAdoption")
    public String completeAdoption(@RequestParam int boardNo, HttpSession session) {
        System.out.println("분양 완료 요청 BoardNo: " + boardNo);
        
        int updatedCount = boardDao.updatePermissionToF(boardNo);

        if (updatedCount > 0) {
            return "redirect:detail?boardNo=" + boardNo + "&status=completed";
        } else {
            return "redirect:detail?boardNo=" + boardNo + "&status=error";
        }
    }
    
    

    // =============================
    // ✅ 공통 유틸 (첨부파일 안전 처리)
    // =============================
    private Set<Integer> extractAttachmentNos(String content) {
        Set<Integer> result = new HashSet<>();
        if (content == null || content.isBlank()) return result;
        try {
            Document doc = Jsoup.parse(content);
            Elements elements = doc.select(".custom-image[data-pk]");
            for (Element el : elements) {
                String dataPk = el.attr("data-pk");
                if (dataPk != null && dataPk.matches("\\d+")) {
                    result.add(Integer.parseInt(dataPk));
                }
            }
        } catch (Exception e) {
            System.out.println("extractAttachmentNos() 오류: " + e.getMessage());
        }
        return result;
    }

    private void deleteAttachmentsFromContent(String content) {
        if (content == null || content.isBlank()) return;
        try {
            Set<Integer> attachments = extractAttachmentNos(content);
            for (int attachmentNo : attachments) {
                try {
                    mediaService.delete(attachmentNo);
                } catch (Exception e) {
                    System.out.println("첨부 삭제 실패 (무시 가능): " + e.getMessage());
                }
            }
        } catch (Exception e) {
            System.out.println("본문 파싱 실패: " + e.getMessage());
        }
    }
}

