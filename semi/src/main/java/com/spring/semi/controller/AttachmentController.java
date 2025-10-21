package com.spring.semi.controller;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.ContentDisposition;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.semi.dao.AttachmentDao;
import com.spring.semi.dto.AttachmentDto;
import com.spring.semi.error.TargetNotfoundException;
import com.spring.semi.service.AttachmentService;

@Controller
@RequestMapping("/attachment")
public class AttachmentController 
{
	@Autowired
	private AttachmentService attachmentService;
	@Autowired
	private AttachmentDao attachmentDao;
	
	@GetMapping("/download")
	public ResponseEntity<ByteArrayResource> download(@RequestParam int attachmentNo) throws IOException 
	{
		AttachmentDto attachmentDto = attachmentDao.selectOne(attachmentNo);
		if (attachmentDao == null)
			throw new TargetNotfoundException("존재하지 않는 파일");
		
		ByteArrayResource resource = attachmentService.load(attachmentNo);
		
		return ResponseEntity.ok()
				.header(HttpHeaders.CONTENT_ENCODING, StandardCharsets.UTF_8.name())
				.header(HttpHeaders.CONTENT_TYPE, attachmentDto.getAttachmentType())
				.contentLength(attachmentDto.getAttachmentSize())
				.header(HttpHeaders.CONTENT_DISPOSITION, 
						ContentDisposition.attachment().filename(attachmentDto.getAttachmentName(), StandardCharsets.UTF_8).build().toString())
				.body(resource);
	}
}