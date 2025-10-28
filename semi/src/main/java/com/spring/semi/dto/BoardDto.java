package com.spring.semi.dto;

import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class BoardDto {
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
	

	

    public String getFormattedWtime() {
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