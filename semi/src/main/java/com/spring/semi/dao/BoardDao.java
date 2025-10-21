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
	//등록
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
	//목록
	public List<BoardDto> selectList(int boardType)
	{
		String sql = "select * from board where board_category_no=? "
				+ "order by board_no desc";
		Object[] params = {boardType};
		return jdbcTemplate.query(sql, boardListMapper, params);
	}
	//상세
	public BoardDto selectOne(int boardNo) {
		String sql = "select * from board where board_no=?";
		Object[] params = {boardNo};
		List<BoardDto> list = jdbcTemplate.query(sql, boardMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	//삭제
	public boolean delete(int boardNo) {
		String sql = "delete board where board_no = ?";
		Object[] params = {boardNo};
		return jdbcTemplate.update(sql, params) > 0;
	}
	//수정
	public boolean update(BoardDto boardDto) {
		String sql = "update board "
						+ "set board_title=?, board_content=? "
						+ ", board_etime=systimestamp "
						+ "where board_no=?";
		Object[] params = {
			boardDto.getBoardTitle(), boardDto.getBoardContent(),
		    boardDto.getBoardNo()
		};
		return jdbcTemplate.update(sql, params) > 0;
	}

	//attachment
	
}