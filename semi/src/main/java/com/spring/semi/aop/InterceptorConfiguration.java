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
	@Autowired
	private MemberLoginInterceptor memberLoginInterceptor;
	
	
	@Override
	public void addInterceptors(InterceptorRegistry registry) // 인터셉터 등록메소드
	{
		registry.addInterceptor(boardViewIntercepter)
		.addPathPatterns("/board/community/detail", "/infoBoard/detail", "/board/petfluence/detail",
				"/board/fun/detail", "/board/**/detail")
		.order(10);
		
		registry.addInterceptor(memberLoginInterceptor)
		.addPathPatterns("/board/**", "/member/**", "/rest/**")
		.excludePathPatterns(
				"/board/**/detail", "/board/**/list",
				"/member/detail", "/**/login",
				"/member/join**", "/member/find**",
				"/**/profile", "/rest/main/**",
				"/**/image"
				)
		.order(2);
		
		registry.addInterceptor(adminInterceptor)
		.addPathPatterns("/admin/**")
		.order(1);
	} 
}
