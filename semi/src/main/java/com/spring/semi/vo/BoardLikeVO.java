package com.spring.semi.vo;

import com.spring.semi.dto.AnimalDto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

//화면에 추천, 좋아요 개수를 알려주는 클래스
@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class BoardLikeVO {

	private boolean like;
	private int count;
}
