package com.spring.semi.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.spring.semi.dto.MemberLevelDto;
import com.spring.semi.mapper.MemberLevelMapper;

@Repository
public class MemberLevelDao {

	@Autowired
	private JdbcTemplate jdbcTemplate;

	@Autowired
	private MemberLevelMapper memberLevelMapper;

	// 등록
	public void insert(MemberLevelDto level) {
		String sql = "INSERT INTO member_level_table (level_no, level_name, min_point, max_point, description) "
				+ "VALUES (?, ?, ?, ?, ?)";
		jdbcTemplate.update(sql, level.getLevelNo(), level.getLevelName(), level.getMinPoint(), level.getMaxPoint(),
				level.getDescription());
	}

	// 조회
	public List<MemberLevelDto> selectAll() {
		String sql = "select * from member_level_table order by level_no";
		return jdbcTemplate.query(sql, memberLevelMapper);
	}

	// 상세 조회
	public MemberLevelDto selectOne(int levelNo) {
		String sql = "SELECT * FROM member_level_table WHERE level_no = ?";
		return jdbcTemplate.queryForObject(sql, memberLevelMapper, levelNo);
	}

	// 수정
	public void update(MemberLevelDto level) {
		String sql = "update member_level_table set " + "level_name = ?, min_point = ?, max_point = ?, description = ? "
				+ "where level_no = ?";
		jdbcTemplate.update(sql, level.getLevelName(), level.getMinPoint(), level.getMaxPoint(), level.getDescription(),
				level.getLevelNo());
	}

	// 삭제
	public void delete(int levelNo) {
		String sql = "delete from member_level_table where level_no = ?";
		jdbcTemplate.update(sql, levelNo);
	}
}
