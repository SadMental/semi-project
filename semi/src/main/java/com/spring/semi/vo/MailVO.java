package com.spring.semi.vo;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class MailVO {
	
	private int mailNo;
	private String mailOwner;
	private String mailTitle;
	private Timestamp mailWtime;
	private String senderNickname;
	private String targetNickname;

}
