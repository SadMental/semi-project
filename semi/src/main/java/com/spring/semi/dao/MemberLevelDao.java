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
        String sql = "INSERT INTO member_level_table "
                   + "(level_no, level_name, min_point, max_point, description, badge_image) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";
        jdbcTemplate.update(sql,
                level.getLevelNo(),
                level.getLevelName(),
                level.getMinPoint(),
                level.getMaxPoint(),
                level.getDescription(),
                level.getBadgeImage());
    }

    // 전체 조회 (회원 수 포함)
    public List<MemberLevelDto> selectAll() {
        String sql = "SELECT l.level_no, l.level_name, l.min_point, l.max_point, "
                   + "l.description, l.badge_image, "
                   + "(SELECT COUNT(*) FROM member m WHERE m.member_level = l.level_no) AS member_count "
                   + "FROM member_level_table l "
                   + "ORDER BY l.level_no";
        return jdbcTemplate.query(sql, memberLevelMapper);
    }

    // 상세 조회 (회원 수 포함)
    public MemberLevelDto selectOne(int levelNo) {
        String sql = "SELECT l.level_no, l.level_name, l.min_point, l.max_point, "
                   + "l.description, l.badge_image, "
                   + "(SELECT COUNT(*) FROM member m WHERE m.member_level = l.level_no) AS member_count "
                   + "FROM member_level_table l "
                   + "WHERE l.level_no = ?";
        return jdbcTemplate.queryForObject(sql, memberLevelMapper, levelNo);
    }

    // 수정
    public void update(MemberLevelDto level) {
        String sql = "UPDATE member_level_table SET "
                   + "level_name = ?, min_point = ?, max_point = ?, description = ?, badge_image = ? "
                   + "WHERE level_no = ?";
        jdbcTemplate.update(sql,
                level.getLevelName(),
                level.getMinPoint(),
                level.getMaxPoint(),
                level.getDescription(),
                level.getBadgeImage(),
                level.getLevelNo());
    }

    // 삭제
    public void delete(int levelNo) {
        String sql = "DELETE FROM member_level_table WHERE level_no = ?";
        jdbcTemplate.update(sql, levelNo);
    }

    // 해당 등급을 가진 회원 수 조회
    public int countMembersByLevel(int levelNo) {
        String sql = "SELECT COUNT(*) FROM member WHERE member_level = ?";
        return jdbcTemplate.queryForObject(sql, Integer.class, levelNo);
    }
}
