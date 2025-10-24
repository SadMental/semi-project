package com.spring.semi.vo;


import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class ReplyListVO {
	private int replyNo;
	private String replyContent;
	private String replyWriter;
	private int replyTarget;
	private Timestamp replyWtime;
	private Timestamp replyEtime;
	private boolean writer;
	private boolean owner;
}