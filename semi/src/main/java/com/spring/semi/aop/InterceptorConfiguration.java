package com.spring.semi.aop;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class InterceptorConfiguration implements WebMvcConfigurer
{
	@Autowired
	private AdminInterceptor adminInterceptor;
	@Autowired
	private BoardViewIntercepter boardViewIntercepter;
	
	
	@Override
	public void addInterceptors(InterceptorRegistry registry) // 인터셉터 등록메소드
	{
		registry.addInterceptor(boardViewIntercepter)
		.addPathPatterns("/board/free/detail")
		.order(10);
	}
}
