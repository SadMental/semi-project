package com.spring.semi.mapper;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date; // Date 타입을 사용했다면 import
import java.sql.Timestamp; // Timestamp 타입을 사용했다면 import

import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;

import com.spring.semi.vo.AdoptDetailVO; // AdoptDetailVO의 실제 경로로 수정

@Component
public class AdoptDetailMapper implements RowMapper<AdoptDetailVO> {

	@Override
	public AdoptDetailVO mapRow(ResultSet rs, int rowNum) throws SQLException {
		// AdoptDetailVO 생성 및 BOARD, ANIMAL, HEADER 정보 매핑
		AdoptDetailVO vo = new AdoptDetailVO();
		
		// 1. BOARD 필드 매핑
		vo.setBoardNo(rs.getInt("board_no"));
		vo.setBoardCategoryNo(rs.getInt("board_category_no"));
		vo.setBoardTitle(rs.getString("board_title"));
		vo.setBoardContent(rs.getString("board_content"));
		vo.setBoardWriter(rs.getString("board_writer"));
		vo.setBoardWtime(rs.getTimestamp("board_wtime"));
		vo.setBoardEtime(rs.getTimestamp("board_etime"));
		vo.setBoardLike(rs.getInt("board_like"));
		vo.setBoardView(rs.getInt("board_view"));
		vo.setBadgeImage(rs.getString("badge_image"));
        vo.setLevelName(rs.getString("level_name"));
		
		// 2. ANIMAL 필드 매핑 (DAO 쿼리에서 조인되어 넘어온 컬럼)
        // SQL: A.animal_name, A.animal_permission, A.animal_content
    	
        vo.setAnimalNo(rs.getInt("animal_no"));
        vo.setMemberNickname(rs.getString("member_nickname"));
		vo.setAnimalName(rs.getString("animal_name"));
		vo.setAnimalPermission(rs.getString("animal_permission"));
		vo.setAnimalContent(rs.getString("animal_content"));
		 vo.setMediaNo(rs.getInt("media_no"));
		// 3. HEADER 필드 매핑 (DAO 쿼리에서 조인되어 넘어온 컬럼)
        // SQL: AH.header_name AS animal_header_name, TH.header_name AS type_header_name
        vo.setAnimalHeaderName(rs.getString("animal_header_name"));
        vo.setTypeHeaderName(rs.getString("type_header_name"));
		
		return vo;
	}
}