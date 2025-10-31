package com.spring.semi.dto;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class MemberLevelDto {
private int levelNo;
private String levelName;
private int minPoint;
private int maxPoint;
private String description;
private String badgeImage;
private int memberCount;
	
}
