package com.spring.semi.dao;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.spring.semi.dto.BoardDto;
import com.spring.semi.mapper.BoardListMapper;
import com.spring.semi.mapper.BoardMapper;
import com.spring.semi.vo.PageVO;

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

	// 등록
	public void insert(BoardDto boardDto, int boardType) {
		String sql = "insert into board (board_category_no, board_no, " + "board_writer, board_title, board_content) "
				+ "values (?, ?, ?, ?, ?)";
		Object[] params = { boardType, boardDto.getBoardNo(), boardDto.getBoardWriter(), boardDto.getBoardTitle(),
				boardDto.getBoardContent() };
		jdbcTemplate.update(sql, params);
	}

	// 목록
	public List<BoardDto> selectList(int boardType) {
		String sql = "select * from board where board_category_no=? " + "order by board_no desc";
		Object[] params = { boardType };
		return jdbcTemplate.query(sql, boardListMapper, params);
	}

	// 검색
	public List<BoardDto> searchList(String column, String keyword) {
		Set<String> allowList = Set.of("board_title", "board_writer", "board_content");
		if (!allowList.contains(column))
			return List.of();

		String sql = "select * from board where instr(#1, ?) > 0 " + "order by #1 asc, board_no asc";
		sql = sql.replace("#1", column);
		Object[] params = { keyword };
		return jdbcTemplate.query(sql, boardMapper, params);

	}

	// 상세
	public BoardDto selectOne(int boardNo) {
		String sql = "select * from board where board_no=?";
		Object[] params = { boardNo };
		List<BoardDto> list = jdbcTemplate.query(sql, boardMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}

	// 삭제
	public boolean delete(int boardNo) {
		String sql = "delete board where board_no = ?";
		Object[] params = { boardNo };
		return jdbcTemplate.update(sql, params) > 0;
	}

	// 수정
	public boolean update(BoardDto boardDto) {
		String sql = "update board " + "set board_title=?, board_content=? " + ", board_etime=systimestamp "
				+ "where board_no=?";
		Object[] params = { boardDto.getBoardTitle(), boardDto.getBoardContent(), boardDto.getBoardNo() };
		return jdbcTemplate.update(sql, params) > 0;
	}

	public int count(PageVO pageVO, int pageType) {
		if (pageVO.isList()) {
			String sql = "select count(*) from board " + "where board_category_no=? " + "order by board_no asc";
			Object[] params = { pageType };
			return jdbcTemplate.queryForObject(sql, int.class, params);
		} else {
			String sql = "select count(*) from board " + "where instr(#1, ?) > 0 " + "and board_category_no=?";
			sql = sql.replace("#1", pageVO.getColumn());
			Object[] params = { pageVO.getKeyword(), pageType };
			return jdbcTemplate.queryForObject(sql, int.class, params);
		}
	}

	public List<BoardDto> selectListWithPaging(PageVO pageVO, int pageType) {
		if (pageVO.isList()) {
			String sql = "select * from (" + "select rownum rn, TMP.* from (" + "select * from board "
					+ "where board_category_no=?" + "order by board_no desc" + ")TMP" + ") where rn between ? and ?";

			Object[] params = { pageType, pageVO.getBegin(), pageVO.getEnd() };
			return jdbcTemplate.query(sql, boardListMapper, params);
		} else {
			String sql = "select * from (" + "select rownum rn, TMP.* from (" + "select * from board "
					+ "where instr(#1, ?) > 0 and " + "board_category_no=?" + "order by #1 asc, board_no desc" + ")TMP"
					+ ") where rn between ? and ?";
			sql = sql.replace("#1", pageVO.getColumn());
			Object[] params = { pageVO.getKeyword(), pageType, pageVO.getBegin(), pageVO.getEnd() };// 동적할당
			return jdbcTemplate.query(sql, boardListMapper, params);
		}
	}

	//좋아요 관련
	public boolean updateBoardLike(int boardNo, int boardLike) {
		String sql = "update board set board_like = ? where board_no=?";
		Object[] params = { boardLike, boardNo };
		return jdbcTemplate.update(sql, params) > 0;
	public boolean updateBoardView(int boardNo) {
		String sql = "update board set board_view=board_view+1 where board_no=?";
		Object[] params = {boardNo};
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	

	}

	public boolean updateBoardLike(int boardNo) {
		String sql = "update board " + "set board_like = (select count(*) from board_like where board_no = ?) "
				+ "where board_no = ?";
		Object[] params = { boardNo, boardNo };
		return jdbcTemplate.update(sql, params) > 0;
	}

}
