package com.spring.semi.dto;

import java.sql.Timestamp;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class AnimalDto {
	private int AnimalNo;
	private String AnimalName;
	private String AnimalPermission;
}