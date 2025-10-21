package com.spring.semi.restcontroller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.spring.semi.dao.AnimalDao;
import com.spring.semi.dto.AnimalDto;

import jakarta.servlet.http.HttpSession;

@CrossOrigin
@RestController
@RequestMapping("/rest/animal")
public class AnimalRestController {
	@Autowired
	private AnimalDao animalDao;
	
	@PostMapping("/add")
	public void add(
			@ModelAttribute AnimalDto animalDto,
			HttpSession session
			) {
		String login_id = (String) session.getAttribute("loginId");
		int seq = animalDao.sequence();
		
		animalDto.setAnimalNo(seq);
		animalDto.setAnimalMaster(login_id);
		animalDao.insert(animalDto);
	}
	
	@PostMapping("/delete")
	public void delete(
			@RequestParam int animal_no
			) {
		animalDao.delete(animal_no);
	}
}
