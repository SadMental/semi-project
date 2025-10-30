package com.spring.semi.vo;



import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @Builder @NoArgsConstructor @AllArgsConstructor
public class LevelUpdateVO {
	private String memberId;
	private int memberUsedPoint;
	private int maxPoint;
	private int minPoint;
	private int memberLevel;
	private int levelNo;

}
