package com.spring.semi.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

import com.spring.semi.dao.AnimalDao;
import com.spring.semi.dto.AnimalDto;
import com.spring.semi.vo.PageVO;

@Controller
@RequestMapping("/admin/animal")
public class AdminAnimalController {

	@Autowired
	private AnimalDao animalDao;
	
	@GetMapping("/list")
	public String list(
			Model model,
			@ModelAttribute PageVO pageVO
			) {
		pageVO.setDataCount(animalDao.count(pageVO));
		List<AnimalDto> animalList = animalDao.selectListForPaging(pageVO);
		
		model.addAttribute("animalList", animalList);
		model.addAttribute("pageVO", pageVO);
		
		return "/WEB-INF/views/admin/animal/list.jsp";
	}
	
}
