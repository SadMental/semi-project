package com.spring.semi.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class MemberDto {
	private String MemberId;
	private String MemberPw;
	private String MemberNickname;
	private String MemberEmail;
	private String MemberDesciption;
	private int MemberPoint;
	private int MemberLevel;
	private String MemberAuto;
	private int MemberAnimal;
	private Timestamp MemberJoin;
	private Timestamp MemberLogin;
	private Timestamp MemberChange;
}