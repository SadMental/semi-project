package com.spring.semi.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import com.spring.semi.dto.BoardDto;
import com.spring.semi.mapper.BoardListMapper;
import com.spring.semi.mapper.BoardMapper;

@Repository
public class BoardDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private BoardMapper boardMapper;
	@Autowired
	private BoardListMapper boardListMapper;
	
	public int sequence() {
		String sql = "select board_seq.nextval from dual";
		return jdbcTemplate.queryForObject(sql, int.class);
	}
	
 1020infoboard
	public void insert(BoardDto boardDto) {
		String sql = "insert into ";
		Object[] params = {};
=======
	public void insert(BoardDto boardDto, int boardType) {
		String sql = "insert into board (board_category_no, board_no, "
				+ "board_writer, board_title, board_content) "
				+ "values (?, ?, ?, ?, ?)";
		Object[] params = {boardType, 
				boardDto.getBoardNo(),
				boardDto.getBoardWriter(),
				boardDto.getBoardTitle(),
				boardDto.getBoardContent()};

		jdbcTemplate.update(sql, params);
	}
	
	public List<BoardDto> selectList(int boardType)
	{
		String sql = "select * from board where board_category_no=? "
				+ "order by board_no desc";
		Object[] params = {boardType};
		return jdbcTemplate.query(sql, boardListMapper, params);
	}
}
