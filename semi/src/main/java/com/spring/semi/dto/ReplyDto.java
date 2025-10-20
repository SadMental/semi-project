package com.spring.semi.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class ReplyDto {
	private int ReplyCategoryNo;
	private int ReplyTarget;
	private String ReplyContent;
	private String ReplyWriter;
	private Timestamp ReplyWtime;
	private Timestamp ReplyEtime;
}