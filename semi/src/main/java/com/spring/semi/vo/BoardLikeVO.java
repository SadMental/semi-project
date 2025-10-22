package com.spring.semi.vo;

import lombok.Data;

//화면에 추천, 좋아요 개수를 알려주는 클래스
@Data
public class BoardLikeVO {

	private boolean like;
	private int count;
}
