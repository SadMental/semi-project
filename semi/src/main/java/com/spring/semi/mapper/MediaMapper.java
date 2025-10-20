package com.spring.semi.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.spring.semi.dto.MediaDto;

@Component
public class MediaMapper implements RowMapper<MediaDto> {

	@Override
	public MediaDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		return MediaDto.builder()
				.mediaNo(rs.getInt("media.no"))
				.mediaType(rs.getString("media_type"))
				.mediaName(rs.getString("media_name"))
				.mediaWtime(rs.getTimestamp("media_wtime"))
				.mediaLink(rs.getString("media_link"))
				.build();
	}
}