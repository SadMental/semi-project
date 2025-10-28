package com.spring.semi.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class MemberVO {
    private String memberId;
    private String memberNickname;
    private int memberPoint;
    private int memberLevel;
    private String grade;
    private String badgeName;
    private String emoji;  
}
