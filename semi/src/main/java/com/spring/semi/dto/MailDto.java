package com.spring.semi.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class MailDto {
	private String MailSender;
	private String MailTarget;
	private String MailContent;
	private Timestamp MailWtime;
}