package com.spring.semi.restcontroller;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.spring.semi.dao.BoardDao;
import com.spring.semi.dao.BoardLikeDao;
import com.spring.semi.vo.BoardLikeVO;

import jakarta.servlet.http.HttpSession;

@CrossOrigin
@RestController
@RequestMapping("rest/board")
public class BoardRestController {
	@Autowired
	private BoardLikeDao boardLikeDao;
	@Autowired
	private BoardDao boardDao;
	//좋아요 확인
	@GetMapping("/check")
	public BoardLikeVO check(HttpSession session, @RequestParam int boardNo) {
		String loginId = (String)session.getAttribute("loginId");
		boolean result = boardLikeDao.check(loginId, boardNo);	
		int count = boardLikeDao.countByBoardNo(boardNo);
		BoardLikeVO boardLikeVO = new BoardLikeVO();
		boardLikeVO.setLike(result);
		boardLikeVO.setCount(count);
		return boardLikeVO;
	}
	//좋아요 설정
	@GetMapping("/action")
	public BoardLikeVO action(HttpSession session, @RequestParam int boardNo) {
		String loginId = (String)session.getAttribute("loginId");
		BoardLikeVO boardLikeVO = new BoardLikeVO();
		if(boardLikeDao.check(loginId, boardNo)) {
			boardLikeDao.delete(loginId, boardNo);
			boardLikeVO.setLike(false);
			
		}
		else {
			boardLikeDao.insert(loginId, boardNo);
			boardLikeVO.setLike(true);
		}	
		int count =boardLikeDao.countByBoardNo(boardNo);
		boardDao.updateBoardLike(boardNo, count);
		boardLikeVO.setCount(count);
		return boardLikeVO;
	}

}