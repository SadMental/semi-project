package com.spring.semi.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class ReplyLikeDao {
    @Autowired
    private JdbcTemplate jdbcTemplate;

    // ✅ 좋아요 등록
    public void insert(String memberId, int replyNo) {
        String sql = "INSERT INTO reply_like(member_id, reply_no) VALUES(?, ?)";
        jdbcTemplate.update(sql, memberId, replyNo);
    }

    // ✅ 좋아요 여부 확인
    public boolean check(String memberId, int replyNo) {
        String sql = "SELECT COUNT(*) FROM reply_like WHERE member_id=? AND reply_no=?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, memberId, replyNo);
        return count != null && count > 0;
    }

    // ✅ 좋아요 취소
    public boolean delete(String memberId, int replyNo) {
        String sql = "DELETE FROM reply_like WHERE member_id=? AND reply_no=?";
        return jdbcTemplate.update(sql, memberId, replyNo) > 0;
    }

    // ✅ 댓글이 받은 좋아요 개수
    public int countByReplyNo(int replyNo) {
        String sql = "SELECT COUNT(*) FROM reply_like WHERE reply_no=?";
        return jdbcTemplate.queryForObject(sql, Integer.class, replyNo);
    }
}




