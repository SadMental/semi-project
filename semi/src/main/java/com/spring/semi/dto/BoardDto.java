package com.spring.semi.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class BoardDto {
	private int BoardCategoryNo;
	private int BoardNo;
	private String BoardContent;
	private String BoardWriter;
	private Timestamp BoardWtime;
	private Timestamp BoardEtime;
	private int BoardLike;
	private int BoardView;
	private int BoardHeader;
}