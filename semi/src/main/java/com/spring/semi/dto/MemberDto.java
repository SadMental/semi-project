package com.spring.semi.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class MemberDto {
	private String memberId;
	private String memberPw;
	private String memberNickname;
	private String memberEmail;
	private String memberDescription;
	private int memberPoint;
	private int memberLevel;
	private String memberAuth;
	private Integer memberAnimal;
	private Timestamp memberJoin;
	private Timestamp memberLogin;
	private Timestamp memberChange;
}