package com.spring.semi.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.spring.semi.vo.BoardForReviewVO;

@Component
public class BoardForReviewVOMapper  implements RowMapper<BoardForReviewVO> {

	@Override
	public BoardForReviewVO mapRow(ResultSet rs, int rowNum) throws SQLException {
		return BoardForReviewVO.builder()
				.boardCategoryNo(rs.getInt("board_category_no"))
				.boardNo(rs.getInt("board_no"))
				.boardTitle(rs.getString("board_title"))
				.boardContent(rs.getString("board_content"))
				.boardWriter(rs.getString("board_writer"))
				.boardWtime(rs.getTimestamp("board_wtime"))
				.boardEtime(rs.getTimestamp("board_etime"))
				.boardLike(rs.getInt("board_like"))
				.boardView(rs.getInt("board_view"))
				.boardHeader(rs.getInt("board_header"))
				.boardAnimalHeader(rs.getInt("board_animal_header"))
				.boardTypeHeader(rs.getInt("board_type_header"))
				.boardScore(rs.getInt("board_score"))
				.headerName(rs.getString("header_name"))
				.animalHeaderName(rs.getString("animal_header_name"))
				.typeHeaderName(rs.getString("type_header_name"))
				.build();
	}
}
