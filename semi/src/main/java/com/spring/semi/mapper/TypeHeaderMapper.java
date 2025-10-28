package com.spring.semi.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.spring.semi.dto.TypeHeaderDto;

@Component
public class TypeHeaderMapper implements RowMapper<TypeHeaderDto> {

	@Override
	public TypeHeaderDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		return TypeHeaderDto.builder()
				.typeHeaderNo(rs.getInt("type_header_no"))
				.typeHeaderName(rs.getString("type_header_name"))
				.build();
	}
}