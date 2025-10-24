package com.spring.semi.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.spring.semi.dto.ReplyDto;
import com.spring.semi.mapper.ReplyMapper;

@Repository
public class ReplyDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private ReplyMapper replyMapper;

    // 1. 특정 작성자 댓글 목록 조회
    public List<ReplyDto> selectList(String replyWriter) {
        String sql = "SELECT * FROM reply WHERE reply_writer = ? ORDER BY reply_no DESC";
        Object[] params = { replyWriter };

        return jdbcTemplate.query(sql, replyMapper, params);
    }

    // 2. 특정 글(reply_target) 기준 댓글 목록 조회
    public List<ReplyDto> selectList(int replyTarget) {
        String sql = "SELECT * FROM reply WHERE reply_target = ? ORDER BY reply_no DESC";
        Object[] params = { replyTarget };

        return jdbcTemplate.query(sql, replyMapper, params);
    }

    // 3. 댓글 삭제
    public boolean delete(int replyNo) {
        String sql = "DELETE FROM reply WHERE reply_no = ?";
        Object[] params = { replyNo };

        return jdbcTemplate.update(sql, params) > 0;
    }

    // 4. 시퀀스에서 새로운 번호 가져오기
    public int sequence() {
        String sql = "SELECT reply_seq.NEXTVAL FROM dual";
        return jdbcTemplate.queryForObject(sql, int.class);
    }

    // 5. 댓글 삽입
    public void insert(ReplyDto replyDto) {
  
        String sql = "INSERT INTO reply (reply_no, reply_writer, reply_target, reply_content, reply_category_no) "
                   + "VALUES (?, ?, ?, ?, ?)";

        Object[] params = {
            replyDto.getReplyNo(),
            replyDto.getReplyWriter(),
            replyDto.getReplyTarget(),
            replyDto.getReplyContent(),
            replyDto.getReplyCategoryNo()
        };

        jdbcTemplate.update(sql, params);
    }

    // 6. 댓글 수정
    public boolean update(ReplyDto replyDto) {
        String sql = "UPDATE reply "
                   + "SET reply_content = ?, reply_etime = SYSTIMESTAMP "
                   + "WHERE reply_no = ?";

        Object[] params = {
            replyDto.getReplyContent(),
            replyDto.getReplyNo()
        };

        return jdbcTemplate.update(sql, params) > 0;
    }

    // 7. 댓글 단건 조회
    public ReplyDto selectOne(int replyNo) {
        String sql = "SELECT * FROM reply WHERE reply_no = ?";
        Object[] params = { replyNo };

        List<ReplyDto> list = jdbcTemplate.query(sql, replyMapper, params);
        return list.isEmpty() ? null : list.get(0);
    }  
}
