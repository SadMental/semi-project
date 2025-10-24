package com.spring.semi.vo;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class MailDetailVO {
	private int mailNo;
	private String mailOwner;
	private String mailSender;
	private String mailTarget;
	private String mailTitle;
	private String mailContent;
	private Timestamp mailWtime;
	private String senderNickname;
}
