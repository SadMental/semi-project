package com.spring.semi.restcontroller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.spring.semi.dao.BoardDao;
import com.spring.semi.error.TargetNotfoundException;
import com.spring.semi.service.AttachmentService;

import jakarta.servlet.http.HttpSession;

@CrossOrigin
@RestController
@RequestMapping("/rest/board")
public class BoardRestController 
{
	//@Autowired
	//private BoardLikeDao boardLikeDao;
	@Autowired
	private BoardDao boardDao;		
	@Autowired
	private AttachmentService attachmentService;
	
//	@GetMapping("/check")
//	public BoardLikeVO check(HttpSession session, @RequestParam int boardNo) 
//	{
//		String loginId = (String)session.getAttribute("loginId");
//		boolean result = boardLikeDao.check(loginId, boardNo);		
//		int count = boardLikeDao.countByBoardNo(boardNo);
//		
//		BoardLikeVO boardLikeVO = new BoardLikeVO();
//		boardLikeVO.setLike(result);
//		boardLikeVO.setCount(count);
//		return boardLikeVO;
//	}
//	
//	@GetMapping("/action")
//	public BoardLikeVO action(HttpSession session, @RequestParam int boardNo) 
//	{
//		String loginId = (String)session.getAttribute("loginId");
//		
//		BoardLikeVO boardLikeVO = new BoardLikeVO();
//		if(boardLikeDao.check(loginId, boardNo)) {//좋아요를 누른 이력이 있으면
//			boardLikeDao.delete(loginId, boardNo);
//			boardLikeVO.setLike(false);
//		}
//		else {//좋아요를 누른 이력이 없으면
//			boardLikeDao.insert(loginId, boardNo);
//			boardLikeVO.setLike(true);
//		}
//		int count = boardLikeDao.countByBoardNo(boardNo);
//		boardDao.updateBoardLike(boardNo, count);
//		boardLikeVO.setCount(count);
//		return boardLikeVO;
//	}
	
	@PostMapping("/temp")
	public int temp(@RequestParam MultipartFile attach) throws IllegalStateException, IOException {
		if(attach.isEmpty()) {
			throw new TargetNotfoundException("파일이 없습니다");
		}
		return attachmentService.save(attach);
	}
	
	@PostMapping("/temps")
	public List<Integer> temps(
			@RequestParam(value = "attach") List<MultipartFile> attachList) throws IllegalStateException, IOException {
		List<Integer> numbers = new ArrayList<>();
		for(MultipartFile attach : attachList) {
			if(attach.isEmpty() == false) {
				int attachmentNo = attachmentService.save(attach);
				numbers.add(attachmentNo);
			}
		}
		return numbers;
	}
}