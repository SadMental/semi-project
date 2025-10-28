package com.spring.semi.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.spring.semi.dto.AnimalHeaderDto;
import com.spring.semi.mapper.AnimalHeaderMapper;

@Repository
public class AnimalHeaderDao {
    @Autowired
    private JdbcTemplate jdbcTemplate;
    @Autowired
    private AnimalHeaderMapper animalHeaderMapper;

    public List<AnimalHeaderDto> selectAll() {
        String sql = "select * from animal_header order by animal_header_no asc";
        return jdbcTemplate.query(sql, animalHeaderMapper);
    }
}
