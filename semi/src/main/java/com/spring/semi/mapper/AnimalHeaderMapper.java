package com.spring.semi.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import com.spring.semi.dto.AnimalHeaderDto;

public class AnimalHeaderMapper implements RowMapper<AnimalHeaderDto> {

	@Override
	public AnimalHeaderDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		return AnimalHeaderDto.builder()
				.animalHeaderNo(rs.getInt("animal_header_no"))
				.animalHeaderName(rs.getString("animal_header_name"))
				.build();
	}
}