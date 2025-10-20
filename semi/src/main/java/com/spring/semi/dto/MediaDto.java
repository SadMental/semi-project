package com.spring.semi.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class MediaDto {
	private int mediaNo;
	private String mediaType;
	private String mediaName;
	private Timestamp mediaWtime;
	private String mediaLink;
}
