package com.spring.semi.vo;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data 
public class BoardListVO {
	private int boardNo;
	private String boardTitle;
	private Timestamp boardWtime;
	private int boardView;
}
	
	// 이 VO는 마이페이지 조회 전용입니다.
	// 공지사항 조회나 목록/페이징 통합에 사용하려면 필드 추가가 필요합니다.
