package com.spring.semi.aop;

import org.springframework.stereotype.Service;
import org.springframework.web.servlet.HandlerInterceptor;

import com.spring.semi.error.NeedPermissionException;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Service
public class AdvancedMemberInterCeptor implements HandlerInterceptor{
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response,
				Object handler) throws Exception{
	HttpSession session= request.getSession();//세션객체를 추출
	 Integer loginLevel = (Integer) session.getAttribute("loginLevel");
	 if(loginLevel==1)   //   일반회원1 
	{
		throw new NeedPermissionException("권한이 부족합니다");
	 }
	 return true; 
	}
}
