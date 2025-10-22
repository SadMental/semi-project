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

    // 시퀀스 번호 조회
    public int sequence() {
        String sql = "select header_seq.nextval from dual";
        return jdbcTemplate.queryForObject(sql, int.class);
    }

    // 등록
    public void insert(HeaderDto headerDto) {
        // 이미 존재하는 머리글이 있으면 추가하지 않음
        String checkSql = "SELECT COUNT(*) FROM header";
        int count = jdbcTemplate.queryForObject(checkSql, Integer.class);
        
        if (count > 0) {
            throw new IllegalStateException("이미 머리글이 존재합니다.");
        }
        
        String sql = "insert into header(header_no, header_name) values (?, ?)";
        Object[] params = {headerDto.getHeaderNo(), headerDto.getHeaderName()};
        jdbcTemplate.update(sql, params);
    }

    // 수정
    public boolean update(HeaderDto headerDto) {
        String sql = "UPDATE Header SET header_name = ? WHERE header_no = ?";
        Object[] params = {
            headerDto.getHeaderName(),
            headerDto.getHeaderNo()
        };
        return jdbcTemplate.update(sql, params) > 0;
    }
    //헤더번호 기준수정
    public boolean updateByHeaderNo(int headerNo, String newHeaderName) {
        String sql = "UPDATE header SET header_name = ? WHERE header_no = ?";
        Object[] params = {newHeaderName, headerNo};
        return jdbcTemplate.update(sql, params) > 0;  // 하나의 행만 수정되므로 header_no에 의존
    }
    // 삭제
    public boolean delete(int headerNo) {
        String sql = "DELETE FROM header WHERE header_no = ?";
        Object[] params = {headerNo};
        return jdbcTemplate.update(sql, params) > 0;
    }

    // 같은 Header이름 조회
    public List<HeaderDto> selectByHeaderName(String headerName) {
        String sql = "SELECT * FROM header WHERE header_name = ?";
        Object[] params = {headerName};
        return jdbcTemplate.query(sql, headerMapper, params);  // 조건에 맞는 모든 레코드 조회
    }
    
    // 전체 조회
    public List<HeaderDto> selectAll() {
        String sql = "SELECT * FROM header";  // 전체 조회 쿼리
        return jdbcTemplate.query(sql, headerMapper);  // mapper를 통해 결과 매핑
    }
    // 단건 조회
    public HeaderDto selectOne(int headerNo) {
        String sql = "SELECT * FROM header WHERE header_no = ?";
        Object[] params = {headerNo};
        List<HeaderDto> list = jdbcTemplate.query(sql, headerMapper, params);
        return list.isEmpty() ? null : list.get(0);
    }
    
   
}

