package com.spring.semi.vo;

import java.sql.Date;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class AdoptDetailVO {
    // BOARD 필드
	private int boardCategoryNo;
	private int boardNo;
	private String boardTitle;
	private String boardContent;
	private String boardWriter;
	private Timestamp boardWtime;
	private Timestamp boardEtime;
	private int boardLike;
	private int boardView;
	private int boardReply;
	
	// 251028 board 테이블에 컬럼 추가
	private int boardAnimalHeader;
	private int boardTypeHeader;
	private int boardScore;
	
	// 251030 deleted 추가
	private int deleted;
	   private String badgeImage;
   private String levelName;



    private int animalNo;
    private String animalName;
    private String animalPermission; // '분양 가능', '분양 완료'
    private String animalContent; // 동물 소개 내용

    private String animalHeaderName; // 동물 분류명
    private String typeHeaderName;   // 게시판 유형명

    // MEMBER 필드 (작성자의 닉네임 등)
    private String memberNickname;
    // ... getter, setter, toString ...
    private Integer mediaNo;
}
