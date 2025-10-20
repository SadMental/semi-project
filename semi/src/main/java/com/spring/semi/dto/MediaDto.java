package com.spring.semi.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class MediaDto {
	private int MediaNo;
	private String MediaType;
	private String MediaName;
	private Timestamp MedieWtime;
	private String MediaLink;
}
