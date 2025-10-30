package com.spring.semi.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.spring.semi.mapper.LevelUpdateMapper;
import com.spring.semi.vo.LevelUpdateVO;

@Repository
public class LevelUpdateDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;
    @Autowired
    private LevelUpdateMapper levelUpdateMapper;


    public List<LevelUpdateVO> selectMembersForLevelUpdate() {
        String sql = "SELECT m.member_id, m.member_point, m.member_level, " +
                     "       l.level_no, l.min_point, l.max_point " +
                     "FROM member m " +
                     "JOIN member_level l ON m.member_point BETWEEN l.min_point AND l.max_point";
        return jdbcTemplate.query(sql, levelUpdateMapper);
    }


    public int updateMemberLevels() {
        String sql = "UPDATE member m " +
                     "SET member_level = (" +
                     "    SELECT l.level_no " +
                     "    FROM member_level_table l " + 
                     "    WHERE m.member_point BETWEEN l.min_point AND l.max_point" +
                     ") " +
                     "WHERE EXISTS (" +
                     "    SELECT 1 " +
                     "    FROM member_level_table l " + 
                     "    WHERE m.member_point BETWEEN l.min_point AND l.max_point" +
                     ")";
        return jdbcTemplate.update(sql);
    }

}

