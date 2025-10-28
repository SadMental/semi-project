package com.spring.semi.vo;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class BoardForReviewVO {
	private int boardCategoryNo;
	private int boardNo;
	private String boardTitle;
	private String boardContent;
	private String boardWriter;
	private Timestamp boardWtime;
	private Timestamp boardEtime;
	private int boardLike;
	private int boardView;
	private Integer boardHeader;
	private int boardReply;
	
	// 251028 board 테이블에 컬럼 추가
	private int boardAnimalHeader;
	private int boardTypeHeader;
	private int boardScore;
	
	private String headerName;
	private String animalHeaderName;
	private String typeHeaderName;
	
}
