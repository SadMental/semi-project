package com.spring.semi.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class MailDto {
	private int mailNo;
	private String mailSender;
	private String mailTarget;
	private String mailContent;
	private Timestamp mailWtime;
}