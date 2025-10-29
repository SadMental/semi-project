package com.spring.semi.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.spring.semi.dto.AnimalDto;
import com.spring.semi.dto.MemberDto;
import com.spring.semi.mapper.AnimalMapper;
import com.spring.semi.vo.PageVO;

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
		String sql = "insert into animal(animal_no, animal_name, animal_content ,animal_permission, animal_master) "
													+ "values(?, ?, ?, ?, ?)";
		Object[] params = {
				animalDto.getAnimalNo(), 
				animalDto.getAnimalName(), 
				animalDto.getAnimalContent(),
				animalDto.getAnimalPermission(),
				animalDto.getAnimalMaster()
		};
		
		jdbcTemplate.update(sql, params);
	}
	
	public List<AnimalDto> selectList(String animal_master) {
		String sql = "select * from animal where animal_master = ?";
		Object[] params = {animal_master};
		
		return jdbcTemplate.query(sql, animalMapper, params);
	}
	
	public List<AnimalDto> selectList() {
		String sql = "select * from animal";

		return jdbcTemplate.query(sql, animalMapper);
	}
	
	public boolean delete(int animal_no) {
		String sql = "update animal set deleted = 1 where animal_no = ?";
		Object[] params = {animal_no};
		
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	public boolean update(AnimalDto animalDto) {
		String sql = "update animal "
								+ "set animal_name = ?, animal_content = ?, "
										+ "animal_permission = ? where animal_no = ?";
		Object[] params = {
				animalDto.getAnimalName(),
				animalDto.getAnimalContent(),
				animalDto.getAnimalPermission(),
				animalDto.getAnimalNo()
		};
		
		return jdbcTemplate.update(sql, params) > 0;
		
	}
	public AnimalDto selectOne(int animal_no) {
		String sql = "select * from animal where animal_no = ?";
		Object[] params = {animal_no};
		List<AnimalDto> list = jdbcTemplate.query(sql, animalMapper, params);
		
		return list.isEmpty()? null : list.get(0);
	}
	
	public int findMediaNo(String animal_no) {
		String sql = "select media_no from animal_profile where animal_no = ?";
		Object[] params = { animal_no };
		return jdbcTemplate.queryForObject(sql, int.class, params);
	}
	
	//페이징용
		public int count(PageVO pageVO) {
			if(pageVO.isList()) {
				String sql = "select count(*) from animal";
				return jdbcTemplate.queryForObject(sql, int.class);
			} else {
				String sql = "select count(*) from animal where instr(#1, ?) > 0";
				sql = sql.replace("#1", pageVO.getColumn());
				Object[] params = {pageVO.getKeyword()};
				return jdbcTemplate.queryForObject(sql, int.class, params);
			}
		}
		//페이징용
		public List<AnimalDto> selectListForPaging(PageVO pageVO){
			if(pageVO.isList()) {
				String sql = "select * from ("
									+ "select rownum rn, TMP.* from ("
										+ "select * from animal "
										+ "order by animal_no asc"
									+ ") TMP"
								+ ") where rn between ? and ?";
				Object[] params = {pageVO.getBegin(), pageVO.getEnd()};
				return jdbcTemplate.query(sql, animalMapper, params);
			} else {
				String sql = "select * from ("
										+ "select rownum rn, TMP.* from ("
											+ "select * from animal "
											+ "where instr(#1, ?) > 0  "
											+ "order by #1 asc, animal_no asc"
										+ ") TMP"
									+ ") where rn between ? and ?";
				sql = sql.replace("#1", pageVO.getColumn());
				Object[] params = {pageVO.getKeyword(), pageVO.getBegin(), pageVO.getEnd()};
				return jdbcTemplate.query(sql, animalMapper, params);
			}
		}
		public void connect(int animalNo, int mediaNo) {
			String sql = "insert into animal_profile values(?, ?)";
			
			Object[] params = {animalNo, mediaNo};
			
			jdbcTemplate.update(sql, params);
			
		}
}
