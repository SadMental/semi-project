package com.spring.semi.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.spring.semi.dto.ReplyDto;

@Component
public class ReplyMapper implements RowMapper<ReplyDto> {

	@Override
	public ReplyDto mapRow(ResultSet rs, int rowNum) throws SQLException {
		return ReplyDto.builder()				
				.replyCategoryNo(rs.getInt("reply_category_no"))
				.replyTarget(rs.getInt("reply_target"))
				.replyNo(rs.getInt("reply_no"))
				.replyContent(rs.getString("reply_content"))
				.replyWriter(rs.getString("reply_writer"))
				.replyWtime(rs.getTimestamp("reply_wtime"))
				.replyEtime(rs.getTimestamp("reply_etime"))
				.build();
	}
}