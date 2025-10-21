package com.spring.semi.restcontroller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.spring.semi.dao.AnimalDao;
import com.spring.semi.dto.AnimalDto;

import jakarta.servlet.http.HttpSession;

@RestController
@RequestMapping("/rest/animal")
public class AnimalRestController {
	@Autowired
	private AnimalDao animalDao;
	
	@PostMapping("/add")
	public int add(
			@ModelAttribute AnimalDto animalDto,
			HttpSession session
			) {
		String login_id = (String) session.getAttribute("loginId");
		int seq = animalDao.sequence();
		
		animalDto.setAnimalNo(seq);
		animalDto.setAnimalMaster(login_id);
		System.out.println("동물 정보: " + animalDto.toString());
		animalDao.insert(animalDto);
		return seq;
	}
	
	@PostMapping("/delete")
	public void delete(
			@RequestParam int animalNo
			) {
		animalDao.delete(animalNo);
	}
}
