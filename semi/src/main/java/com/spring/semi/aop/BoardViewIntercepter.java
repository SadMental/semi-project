package com.spring.semi.aop;

import java.util.HashSet;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.HandlerInterceptor;

import com.spring.semi.dao.BoardDao;
import com.spring.semi.dto.BoardDto;
import com.spring.semi.error.TargetNotfoundException;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Service
public class BoardViewIntercepter implements HandlerInterceptor
{
	@Autowired
	private BoardDao boardDao;
	
	@Override
	public boolean preHandle(HttpServletRequest request,
			HttpServletResponse response,
			Object handler)
			throws Exception {
		
		HttpSession session = request.getSession();
		String loginId = (String) session.getAttribute("loginId");
		if (loginId == null)
			return true; // 로그인 안 했으면 오르지 않음
		
		int boardNo = Integer.parseInt(request.getParameter("boardNo"));
		
		BoardDto boardDto = boardDao.selectOne(boardNo);
		if (boardDto == null)
				throw new TargetNotfoundException("존재하지 않는 게시글");
		if (loginId != null && boardDto.getBoardWriter() != null) 
		{
			if (loginId.equals(boardDto.getBoardWriter())) 
			{
				return true; // 내 글일 때는 그냥 통과
			}
		}
		
		Integer loginLevel = (Integer)session.getAttribute("loginLevel");
		if (loginLevel != null && loginLevel == 2) 
		{
			return true; // 관리자는 조회수가 오르지 않는다
		}
		
		Set<Integer> history = (Set<Integer>)session.getAttribute("history");
		if (history == null)
			history = new HashSet<>();
		if (history.contains(boardNo))
			return true; // 해당 아이디로 해당 글을 본 적이 있으면 오르지 않는다
		else
			history.add(boardNo);
		session.setAttribute("history", history);
		
		boardDao.updateBoardView(boardDto.getBoardNo());
		return true;		
	}
}