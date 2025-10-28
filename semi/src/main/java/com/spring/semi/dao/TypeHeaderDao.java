package com.spring.semi.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;

import com.spring.semi.dto.TypeHeaderDto;
import com.spring.semi.mapper.TypeHeaderMapper;

public class TypeHeaderDao {
    @Autowired
    private JdbcTemplate jdbcTemplate;
    @Autowired
    private TypeHeaderMapper typeHeaderMapper;
    
    public List<TypeHeaderDto> selectAll() {
        String sql = "select * from type_header order by type_header_no asc";
        return jdbcTemplate.query(sql, typeHeaderMapper);
    }
}
