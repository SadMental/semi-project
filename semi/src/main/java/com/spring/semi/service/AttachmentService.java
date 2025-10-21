package com.spring.semi.service;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import com.spring.semi.dao.AttachmentDao;
import com.spring.semi.dto.AttachmentDto;
import com.spring.semi.error.TargetNotfoundException;

@Service
public class AttachmentService 
{
	@Autowired
	private AttachmentDao attachmentDao;
	
	private File home = new File(System.getProperty("user.home"));
	private File upload = new File(home, "upload");
	
	@Transactional
	public int save(MultipartFile attach) throws IllegalStateException, IOException 
	{
		int attachmentNo = attachmentDao.sequence();
		
		if (upload.exists() == false) 
			upload.mkdirs();
		
		File target = new File(upload, String.valueOf(attachmentNo)); // 저장할 파일의 인스턴스
		attach.transferTo(target);
		
		AttachmentDto attachmentDto = new AttachmentDto();
		attachmentDto.setAttachmentNo(attachmentNo);
		attachmentDto.setAttachmentName(attach.getOriginalFilename());
		attachmentDto.setAttachmentType(attach.getContentType());
		attachmentDto.setAttachmentSize(attach.getSize());
		
		attachmentDao.insert(attachmentDto);
		
		return attachmentNo;
	}
	
	public ByteArrayResource load(int attachmentNo) throws IOException 
	{
		File home = new File(System.getProperty("user.home"));
		File upload = new File(home, "upload");
		File target = new File(upload, String.valueOf(attachmentNo));
		
		if (!target.isFile())
			throw new TargetNotfoundException("존재하지 않는 파일");
		
		byte[] data = Files.readAllBytes(target.toPath());
		ByteArrayResource resource = new ByteArrayResource(data);
		return resource;
	}
	
	public void delete(int attachmentNo) 
	{
		AttachmentDto attachmentDto = attachmentDao.selectOne(attachmentNo);
		if (attachmentDto == null)
			throw new TargetNotfoundException("존재하지 않는 파일");
		
		File target = new File(upload, String.valueOf(attachmentNo));
		target.delete();
		
		attachmentDao.delete(attachmentNo);
	}
}