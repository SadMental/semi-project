package com.spring.semi.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.spring.semi.dto.HeaderDto;
import com.spring.semi.mapper.HeaderMapper;

@Repository
public class HeaderDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private HeaderMapper headerMapper;

    /** 시퀀스 조회 */
    public int sequence() {
        String sql = "SELECT header_seq.NEXTVAL FROM dual";
        return jdbcTemplate.queryForObject(sql, int.class);
    }

    /** 등록 (INSERT) */
    public boolean insert(HeaderDto headerDto) {
        String sql = "INSERT INTO header (header_no, header_name) VALUES (?, ?)";
        Object[] params = { headerDto.getHeaderNo(), headerDto.getHeaderName() };
        return jdbcTemplate.update(sql, params) > 0;
    }

    /** 수정 (UPDATE) */
    public boolean update(HeaderDto headerDto) {
        String sql = "UPDATE header SET header_name = ? WHERE header_no = ?";
        Object[] params = { headerDto.getHeaderName(), headerDto.getHeaderNo() };
        return jdbcTemplate.update(sql, params) > 0;
    }

    /** 번호로 수정 */
    public boolean updateByHeaderNo(int headerNo, String newHeaderName) {
        String sql = "UPDATE header SET header_name = ? WHERE header_no = ?";
        Object[] params = { newHeaderName, headerNo };
        return jdbcTemplate.update(sql, params) > 0;
    }

    /** 삭제 */
    public boolean delete(int headerNo) {
        String sql = "DELETE FROM header WHERE header_no = ?";
        Object[] params = { headerNo };
        return jdbcTemplate.update(sql, params) > 0;
    }

    /** 이름으로 조회 */
    public List<HeaderDto> selectByHeaderName(String headerName) {
        String sql = "SELECT * FROM header WHERE header_name = ?";
        Object[] params = { headerName };
        return jdbcTemplate.query(sql, headerMapper, params);
    }

    /** 전체 조회 */
    public List<HeaderDto> selectAll() {
        String sql = "SELECT * FROM header ORDER BY header_no ASC";
        return jdbcTemplate.query(sql, headerMapper);
    }

    /** 단일 조회 */
    public HeaderDto selectOne(int headerNo) {
        String sql = "SELECT * FROM header WHERE header_no = ?";
        Object[] params = { headerNo };
        List<HeaderDto> list = jdbcTemplate.query(sql, headerMapper, params);
        return list.isEmpty() ? null : list.get(0);
    }
}

