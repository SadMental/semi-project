package com.spring.semi.vo;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data 
public class BoardListVO {
	private int boardNo;
	private String categoryName;
	private String boardTitle;
	private Timestamp boardWtime;
	private int boardView;
	
	public String getFormattedWtime() {
	    if (boardWtime == null) return "";	
	    LocalDateTime wtime = boardWtime.toLocalDateTime();
	    LocalDateTime now = LocalDateTime.now();

	    DateTimeFormatter timeFmt = DateTimeFormatter.ofPattern("HH:mm");
	    DateTimeFormatter dateFmt = DateTimeFormatter.ofPattern("yyyy-MM-dd");

	    if (wtime.toLocalDate().isEqual(now.toLocalDate())) {
	        return wtime.format(timeFmt);
	    } else {
	        return wtime.format(dateFmt);
	    }
	}
}
	
	// 이 VO는 마이페이지 조회 전용입니다.
	// 공지사항 조회나 목록/페이징 통합에 사용하려면 필드 추가가 필요합니다.

	