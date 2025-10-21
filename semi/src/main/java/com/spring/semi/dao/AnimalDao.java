package com.spring.semi.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.spring.semi.dto.AnimalDto;
import com.spring.semi.mapper.AnimalMapper;

@Repository
public class AnimalDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private AnimalMapper animalMapper;
	
	public int sequence() {
		String sql = "select animal_seq.nextval from dual";
		
		return jdbcTemplate.queryForObject(sql, int.class);
	}
	public void insert(AnimalDto animalDto) {
		String sql = "insert into animal(animal_no, animal_name, animal_permission, animal_content, animal_master) "
													+ "values(?, ?, ?, ?, ?)";
		Object[] params = {
				animalDto.getAnimalNo(), 
				animalDto.getAnimalName(), 
				animalDto.getAnimalPermission(),
				animalDto.getAnimalContent(),
				animalDto.getAnimalMaster()};
		
		jdbcTemplate.update(sql, params);
	}
	
	public List<AnimalDto> selectList(String animal_master) {
		String sql = "select * from animal where animal_master = ?";
		Object[] params = {animal_master};
		System.out.println("SQL : " + sql + params);
		return jdbcTemplate.query(sql, animalMapper, params);
	}
	
	public boolean delete(int animal_no) {
		String sql = "delete from animal where animal_no = ?";
		Object[] params = {animal_no};
		
		return jdbcTemplate.update(sql, params) > 0;
	}
}
