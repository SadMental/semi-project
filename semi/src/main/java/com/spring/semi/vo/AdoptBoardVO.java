package com.spring.semi.vo;

import java.sql.Timestamp;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class AdoptBoardVO {
   
    private int boardCategoryNo;
    private int boardNo;
    private String boardTitle;
    private String boardWriter;
    private Timestamp boardWtime;
    private Timestamp boardEtime;
    private int boardLike;
    private int boardView;
    private int boardReply;
    private int boardScore;
    private int deleted; // DELETED
    private String animalHeaderName; 
    private String typeHeaderName;   
    private String boardContent;
    private int boardAnimalHeader;
    private int boardTypeHeader;

    // MEMBER_LEVEL_TABLE (조인 결과)
    private String levelName;
    private String badgeImage; 

    // ANIMAL (조인 결과)
    private int animalNo;
    private String animalPermission; //

   
    // MEMBER (조인 결과)
    private String memberNickname;

    // MEDIA (필요하다면)

}