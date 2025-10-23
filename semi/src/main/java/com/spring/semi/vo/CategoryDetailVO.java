package com.spring.semi.vo;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class CategoryDetailVO {
    private int categoryNo;//카테고리 번호
    private String categoryName;//카테고리 이름
    private int boardCount; // 해당 카테고리에 속한 게시글 수
    private Timestamp lastUseTime; // 마지막으로 게시판을 사용한 시간
    private String lastUser;// 가장 최근에 게시판을 사용한 사람

	public String getBoardWriteTime() {
		LocalDateTime wtime = lastUseTime.toLocalDateTime();//작성시점을 LocalDateTime으로 변환
		LocalDate today = LocalDate.now();//오늘날짜를 구하고
		LocalDate wday = wtime.toLocalDate();//작성일자를 구해서
		
		if(wday.isBefore(today)) {//이전에 작성한 글이라면
			return wtime.toLocalDate().toString();//날짜 반환
		}
		else {
			DateTimeFormatter fmt = DateTimeFormatter.ofPattern("HH:mm");
			return wtime.toLocalTime().format(fmt);//시간 반환
		}
	}
}
