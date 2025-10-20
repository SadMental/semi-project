package com.spring.semi.aop;

import org.springframework.stereotype.Service;
import org.springframework.web.servlet.HandlerInterceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Service
public class AdminInterceptor implements HandlerInterceptor{
   public boolean preHandle(HttpServletRequest request,HttpServletRequest response,
		   Object Handler) throws Exception{
	   HttpSession session =request.getSession();
	   String loginLevel=(String)session.getAttribute("loginLevel");
	   if(loginLevel.equals("관리자")==false)
		   throw new NeedPermissionException("권한 부족");
	   return true;
   }
}
