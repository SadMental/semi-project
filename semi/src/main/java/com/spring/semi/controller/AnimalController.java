package com.spring.semi.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.semi.dao.AnimalDao;
import com.spring.semi.dao.MediaDao;
import com.spring.semi.dto.AnimalDto;
import com.spring.semi.error.TargetNotfoundException;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/animal")
public class AnimalController {

	@Autowired
	private AnimalDao animalDao;
	@Autowired
	private MediaDao mediaDao;
	
	@GetMapping("/list")
	public String list(
			Model model,
			HttpSession session
			) {
		String loginId = (String) session.getAttribute("loginId");
		if(loginId == null) throw new TargetNotfoundException("존재하지 않는 회원");

		List<AnimalDto> animalList = animalDao.selectList(loginId);
		
		model.addAttribute("animalList", animalList);
		
		return "/WEB-INF/views/animal/list.jsp";
	}
	
	@GetMapping("/profile")
	public String profile(
			@RequestParam int animalNo
			) {
		try {
			int mediaNo = animalDao.findMediaNo(animalNo);
			return "redirect:/media/download?mediaNo=" + mediaNo;
		} catch(Exception e) {
			return "redirect:/image/error/no-image.png";
		}
	}
	
}
