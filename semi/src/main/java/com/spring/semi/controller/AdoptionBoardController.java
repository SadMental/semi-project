//package com.spring.semi.controller;
//
//import java.util.HashSet;
//import java.util.Set;
//
//import org.jsoup.Jsoup;
//import org.jsoup.nodes.Document;
//import org.jsoup.nodes.Element;
//import org.jsoup.select.Elements;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Controller;
//import org.springframework.web.bind.annotation.GetMapping;
//import org.springframework.web.bind.annotation.ModelAttribute;
//import org.springframework.web.bind.annotation.PostMapping;
//import org.springframework.web.bind.annotation.RequestMapping;
//import org.springframework.web.bind.annotation.RequestParam;
//
//import com.spring.semi.dto.BoardDto;
//import com.spring.semi.dto.HeaderDto;
//import com.spring.semi.error.NeedPermissionException;
//
//import jakarta.servlet.http.HttpSession;
//
//@Controller
//@RequestMapping("/adoption/board")
//public class AdoptionBoardController {
//   @Autowired
//   private BoardDto boardDto;
//   @Autowired
//   private HeaderDto headerDto;
//	  //등록 매핑
//	 @GetMapping("/write")
//	 public String write()
//	 {
//		 return "/WEB-INF/views/adoption/board/add.jsp";
//	 }
//	 @PostMapping("/write")
//	 public String write(@ModelAttribute BoardDto boardDto,
//			 HttpSession session) throws NeedPermissionException
//	 {
//		 String loginId =(String) session.getAttribute("loginLevel");
//		 boardDto.setBoardWriter(loginId);
//		 String loginLevel = (String)session.getAttribute("loginLevel");
//		 if(loginLevel.equals("관리자")==false && headerDto.getHeaderName().equals("공지"))
//			 throw new NeedPermissionException("공지글을 작성할 권한이 없습니다");
//		 int boardNo = boardDao.sequence(); // 번호를 생성해서
//		 boardDto.setBoardNo(boardNo); //게시글 정보에 합친다.
//		 boardDao.insert(boardDto); //등록
//		 
//		 return "redirect:detail? boardNo=" +boardNo;
//	 }
//	 @RequestMapping("/delete")
//	 public String delete(@RequestParam int boardNo)
//	   BoardDto boardDto =boardDao.selectOne(boardNo);
//	  if(boardDto==null) throw new TargetNotfoundException("존재하지 않는글");
//	  Document document = Jsoup.parse(boardDto.getBoardContent());
//	  Elements elements = document.select(".custom-image"); // <img>를 찾고
//	  for(Element element : elements) {
//		int attachmentNo =Integer.parseInt(element.attr("data-pk"));
//		attachmentServcie.delete(attachmentNo);
//	  }
//	  boardDao.delete(boardNo);
//	  return "redirect:list";
//	  }
//	@GetMapping("/edit")
//	public String edit(Model model, @RequestParam int boardNo) {
//		BoardDto boardDto = boardDao.selectOne(boardNo);
//		if(boardDto ==null) throw new TargetNotfoundException("존재하지 않는글");
//		model.addAttribute("boardDto", boardDto);
//		return "/WEB-INF/views/board/edit.jsp";
//		
//		@PostMapping("/edit")
//		public String edit(@ModelAttribute BoardDto boardDto) {
//			BoardDto beforeDto = boardDao.selectOne(boardDto.getBoardNo());
//			if(beforeDto==null) throw new TargetNotfoundException("존재하지 않는 글");
//			Set<Integer> before = new HashSet<>();
//			Document beforeDocument = Jsoup.parse(beforeDto.getBoardContent());
//			Elements beforeElements = afterDocument.select(".custom-image");
//			for(Element element : afterElements) {
//				int attachmentNo= Integer.parseInt(element.attr("data-pk"));
//				Set<Integer>minus=new HashSet<>(before);
//				minus.removeAll(after);
//				for(int attachmentNo: minus) {
//					attachmentService.delete(attachmentNo);
//				}
//				boardDao.update(boardDto);
//				return "redirect:detail?boardNo"=boardDto.getBoardNo();
//			}
//		}
//				}
//			}
//	 }
//}
