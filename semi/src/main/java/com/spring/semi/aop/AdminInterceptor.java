package com.spring.semi.aop;

import org.springframework.stereotype.Service;
import org.springframework.web.servlet.HandlerInterceptor;

import com.spring.semi.error.NeedPermissionException;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Service
public class AdminInterceptor implements HandlerInterceptor{
   public boolean preHandle(HttpServletRequest request,HttpServletRequest response,
		   Object Handler) throws Exception{
	   HttpSession session =request.getSession();
	   Integer loginLevel = (Integer) session.getAttribute("loginLevel");
	   int limit = 2; //   
	   if(loginLevel<limit) //  레벨  2이상 관리자권한 
		   throw new NeedPermissionException("권한 부족");
	   return true;
   }
}
