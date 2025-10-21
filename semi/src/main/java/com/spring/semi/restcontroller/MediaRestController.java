package com.spring.semi.restcontroller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.spring.semi.error.TargetNotfoundException;
import com.spring.semi.service.MediaService;

@CrossOrigin
@RestController
@RequestMapping("/rest/media")
public class MediaRestController 
{
	@Autowired
	private MediaService mediaService;
	
	@PostMapping("/temp")
	public int temp(@RequestParam MultipartFile media) throws IllegalStateException, IOException {
		if(media.isEmpty()) {
			throw new TargetNotfoundException("파일이 없습니다");
		}
		return mediaService.save(media);
	}
	
	@PostMapping("/temps")
	public List<Integer> temps(
			@RequestParam(value = "media") List<MultipartFile> mediaList) throws IllegalStateException, IOException {
		List<Integer> numbers = new ArrayList<>();
		for(MultipartFile media : mediaList) {
			if(media.isEmpty() == false) {
				int mediaNo = mediaService.save(media);
				numbers.add(mediaNo);
			}
		}
		return numbers;
	}
}//