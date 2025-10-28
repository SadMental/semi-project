package com.spring.semi.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class AnimalHeaderDto {
	private int animalHeaderNo;
	private String animalHeaderName;
}