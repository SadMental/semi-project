package com.spring.semi.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.spring.semi.dto.AttachmentDto;

@Component
public class AttachmentMapper implements RowMapper<AttachmentDto> {

	@Override
	public AttachmentDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		return AttachmentDto
				.builder()
				.attachmentNo(rs.getInt("attachment_no"))
				.attachmentName(rs.getString("attachment_name"))
				.attachmentType(rs.getString("attachment_type"))
				.attachmentSize(rs.getLong("attachment_size"))
				.attachmentTime(rs.getTimestamp("attachment_time"))
				.build();
	}
}
