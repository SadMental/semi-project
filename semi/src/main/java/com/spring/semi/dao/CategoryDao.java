package com.spring.semi.dao;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.spring.semi.dto.CategoryDto;
import com.spring.semi.mapper.CategoryDetailMapper;
import com.spring.semi.mapper.CategoryMapper;
import com.spring.semi.vo.CategoryDetailVO;

@Repository
public class CategoryDao {

	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private CategoryMapper categoryMapper;
	@Autowired
	private CategoryDetailMapper categoryDetailMapper;

	public int sequence() {
		String sql = "select category_seq.nextval from dual";
		return jdbcTemplate.queryForObject(sql, int.class);
	}
	// 등록

	public void insert(CategoryDto categoryDto) {
		String sql = "insert into category (category_no, category_name) VALUES (?, ?)";
		Object[] params = { categoryDto.getCategoryNo(), categoryDto.getCategoryName() };
		jdbcTemplate.update(sql, params);
	}

	// 목록
	public List<CategoryDto> selectList() {
		String sql = "select * from category order by category_no ASC";
		return jdbcTemplate.query(sql, categoryMapper);
	}

	// 검색
	public List<CategoryDto> searchList(String column, String keyword) {
		Set<String> allowList = Set.of("category_name");
		if (!allowList.contains(column))
			return List.of();

		String sql = "select * from category where instr(#1, ?) > 0 " + "order by #1 asc, category_no asc";
		sql = sql.replace("#1", column);
		Object[] params = { keyword };
		return jdbcTemplate.query(sql, categoryMapper, params);
	}

	// 삭제
	public boolean delete(int categoryNo) {
	    String sql = "delete from category where category_no = ?";
	    Object[] params = { categoryNo };
	    return jdbcTemplate.update(sql, params) > 0;
	}


	// 수정
	public boolean update(CategoryDto categoryDto) {
		String sql = "update category set category_name = ? where category_no = ?";
		Object[] params = { categoryDto.getCategoryName(), categoryDto.getCategoryNo() };
		return jdbcTemplate.update(sql, params) > 0;
	}

	public CategoryDto selectOne(int categoryNo) {
		String sql = "select * from category where category_no = ?";
		Object[] params = { categoryNo };
		List<CategoryDto> list = jdbcTemplate.query(sql, categoryMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}

	// 상세
	public CategoryDetailVO selectBasicCategoryStatsByName(String categoryName) {
	    String sql = 
	        "select category_no, category_name, " +
	        "  (select count(*) from board where board_category_no = category.category_no) as board_count " +
	        "from category " +
	        "where category_name = ?";
	    Object[] params = { categoryName };
	    List<CategoryDetailVO> list = jdbcTemplate.query(sql, categoryDetailMapper, params);
	    return list.isEmpty() ? null : list.get(0);
	}

	// 마지막 사용 시간 조회
	public java.sql.Timestamp selectLastUseTime(int categoryNo) {
	    String sql = 
	        "select max(greatest(nvl(board_etime, board_wtime), board_wtime)) " +
	        "from board " +
	        "where board_category_no = ?";
	    return jdbcTemplate.queryForObject(sql, java.sql.Timestamp.class, categoryNo);
	}

	// 마지막 사용자 조회
	public String selectLastUser(int categoryNo) {
	    String sql = 
	        "select board_writer from ( " +
	        "  select board_writer, greatest(nvl(board_etime, board_wtime), board_wtime) as last_time " +
	        "  from board " +
	        "  where board_category_no = ? " +
	        "  order by last_time desc " +
	        ") where rownum = 1";
	    return jdbcTemplate.queryForObject(sql, String.class, categoryNo);
	}








}
