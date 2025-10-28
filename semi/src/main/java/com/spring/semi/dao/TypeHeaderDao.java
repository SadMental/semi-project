package com.spring.semi.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.spring.semi.dto.AnimalHeaderDto;
import com.spring.semi.dto.TypeHeaderDto;
import com.spring.semi.mapper.TypeHeaderMapper;

@Repository
public class TypeHeaderDao {
    @Autowired
    private JdbcTemplate jdbcTemplate;
    @Autowired
    private TypeHeaderMapper typeHeaderMapper;
    
    public List<TypeHeaderDto> selectAll() {
        String sql = "select * from type_header order by type_header_no asc";
        return jdbcTemplate.query(sql, typeHeaderMapper);
    }
    
    /** 단일 조회 */
    public TypeHeaderDto selectOne(int typeHeaderNo) {
        String sql = "select * from type_header where type_header_no = ?";
        Object[] params = { typeHeaderNo };
        List<TypeHeaderDto> list = jdbcTemplate.query(sql, typeHeaderMapper, params);
        return list.isEmpty() ? null : list.get(0);
    }
}
