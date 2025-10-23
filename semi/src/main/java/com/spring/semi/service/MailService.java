package com.spring.semi.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.semi.dao.MailDao;
import com.spring.semi.dto.MailDto;

@Service
public class MailService {

	@Autowired
	private MailDao mailDao;
	
	@Transactional
	public void sendMail(MailDto mailDto) {
		
		mailDto.setMailNo(mailDao.sequence());
		mailDao.insertForSender(mailDto);
		
		mailDto.setMailNo(mailDao.sequence());
		mailDao.insertForTarget(mailDto);
	}
}
