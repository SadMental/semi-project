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

    public int insertAndReturnNo(String headerName) {
        // 1️⃣ 이미 존재하면 해당 번호 반환
        String findSql = "select header_no from header where header_name = ?";
        List<Integer> list = jdbcTemplate.query(findSql, (rs, rowNum) -> rs.getInt("header_no"), headerName);

        if (!list.isEmpty()) {
            return list.get(0); // 중복 존재 시 기존 번호 반환
        }

        // 2️⃣ 없으면 새로 추가
        String insertSql = "insert into header(header_no, header_name) values(header_seq.nextval, ?)";
        jdbcTemplate.update(insertSql, headerName);

        // 3️⃣ 새로 추가된 header_no 반환
        String getSql = "select header_no from header where header_name = ?";
        return jdbcTemplate.queryForObject(getSql, Integer.class, headerName);
    }
    // 등록
    public void insert(String headerName) {
        String checkSql = "select count(*) from header where header_name = ?";
        int count = jdbcTemplate.queryForObject(checkSql, Integer.class, headerName);

        if (count == 0) {
            String insertSql = "insert into header(header_no, header_name) values(header_seq.nextval, ?)";
            jdbcTemplate.update(insertSql, headerName);
        } else {
            System.out.println("이미 존재하는 header_name: " + headerName);
        }
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
    public HeaderDto selectByName(String headerName) {
        String sql = "select * from header where header_name = ?";
        List<HeaderDto> list = jdbcTemplate.query(sql, headerMapper, headerName);
        return list.isEmpty() ? null : list.get(0);
    }
    // 전체 조회
    public List<HeaderDto> selectAll() {
        String sql = "SELECT header_no, header_name FROM header ORDER BY header_no ASC"; 
        return jdbcTemplate.query(sql, headerMapper);
    }
    // 단건 조회
    public HeaderDto selectOne(int headerNo) {
        String sql = "SELECT * FROM header WHERE header_no = ?";
        Object[] params = {headerNo};
        List<HeaderDto> list = jdbcTemplate.query(sql, headerMapper, params);
        return list.isEmpty() ? null : list.get(0);
    }
   
    
}

