package com.spring.semi.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.spring.semi.vo.AdoptDetailVO;


@Component
public class AdoptBoardMapper  implements RowMapper<AdoptDetailVO> {

	@Override
	public AdoptDetailVO mapRow(ResultSet rs, int rowNum) throws SQLException {
		return AdoptDetailVO.builder()
				// BOARD_HEADER_VIEW (bhv) 컬럼 매핑
				.boardCategoryNo(rs.getInt("board_category_no"))
				.boardNo(rs.getInt("board_no"))
				.boardTitle(rs.getString("board_title"))
				.boardWriter(rs.getString("board_writer"))
				.boardWtime(rs.getTimestamp("board_wtime"))
				.boardEtime(rs.getTimestamp("board_etime"))
				.boardLike(rs.getInt("board_like"))
				.boardView(rs.getInt("board_view"))
				.boardReply(rs.getInt("board_reply"))
				.deleted(rs.getInt("deleted"))
				.animalHeaderName(rs.getString("animal_header_name"))
				.typeHeaderName(rs.getString("type_header_name"))
				.boardScore(rs.getInt("board_score"))
				
				// MEMBER_LEVEL_TABLE (ml) 컬럼 매핑
				.badgeImage(rs.getString("BADGE_IMAGE")) // 🌟 SQL에서 대문자 BADGE_IMAGE로 가져옴
		        .levelName(rs.getString("level_name")) 
		        
		        // ANIMAL (a) 컬럼 매핑
		        .animalNo(rs.getInt("animalNo"))       // 🌟 SQL에서 별칭 'animalNo'로 가져옴
		        .animalPermission(rs.getString("animal_permission"))
		        
		        // MEMBER (m) 컬럼 매핑
		        .memberNickname(rs.getString("member_nickname")) 
		        
		        // 현재 목록 쿼리에서 SELECT 하지 않는 컬럼은 매핑에서 제외하거나 필요시 주석 처리
				//.animalName(rs.getString("animal_name"))
				//.animalContent(rs.getString("animal_content"))
				.build();
	}
}