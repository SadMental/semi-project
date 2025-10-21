package com.spring.semi.aop;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.resource.NoResourceFoundException;
import com.spring.semi.error.TargetNotfoundException;
import com.spring.semi.error.NeedPermissionException;
import com.spring.semi.error.UnauthorizationException;

@ControllerAdvice
public class ExceptionControllerAdvice {

	@ExceptionHandler(value = {TargetNotfoundException.class, NoResourceFoundException.class})
	public String notFound(Exception e, Model model) {
		model.addAttribute("title", e.getMessage());
		return "/WEB-INF/views/error/notFound.jsp";
	}
	
	@ExceptionHandler(UnauthorizationException.class)
	public String unauthorize(UnauthorizationException e, Model model) {
		model.addAttribute("title", e.getMessage());
		return "/WEB-INF/views/error/unauthorize.jsp";
	}
	
	@ExceptionHandler(NeedPermissionException.class)
	public String needPermission(NeedPermissionException e, Model model) {
		model.addAttribute("title", e.getMessage());
		return "/WEB-INF/views/error/needPermission.jsp";
	}
	@ExceptionHandler(Exception.class)
	public String all(Exception e) {
		e.printStackTrace();
		return "/WEB-INF/views/error/all.jsp";
	}	
}

