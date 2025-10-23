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
	    String sql = "insert into board (" +
	                 "board_category_no, board_no, board_writer, board_title, board_content, board_header" +
	                 ") values (?, ?, ?, ?, ?, ?)";
	    
	    Object[] params = {
	        boardType,
	        boardDto.getBoardNo(),
	        boardDto.getBoardWriter(),
	        boardDto.getBoardTitle(),
	        boardDto.getBoardContent(),
	        boardDto.getBoardHeader() // 
	    };
	    
	    jdbcTemplate.update(sql, params);
	}

	public List<BoardDto> selectList(int boardType) {
	    String sql = "SELECT b.*, h.header_name " +
	                 "FROM board b " +
	                 "LEFT JOIN header h ON b.board_header = h.header_no " +
	                 "WHERE b.board_category_no = ? " +
	                 "ORDER BY CASE h.header_name " +
	                 "           WHEN '공지사항(필독)' THEN 1 " +
	                 "           WHEN 'FAQ(자주 묻는 질문)' THEN 2 " +
	                 "           WHEN '이벤트' THEN 3 " +
	                 "           ELSE 4 " +
	                 "         END, " +
	                 "         b.board_no DESC";
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

	// BoardDao.java 내 selectOne 메서드 수정
	public BoardDto selectOne(int boardNo) {
	    
	    // 1. board 테이블과 header 테이블을 LEFT JOIN하여 header_name을 함께 가져옵니다.
	    String sql = "SELECT b.*, h.header_name "
	               + "FROM board b "
	               + "LEFT JOIN header h ON b.board_header = h.header_no "
	               + "WHERE b.board_no=?";
	               
	    Object[] params = { boardNo };
	    
	    // 2. 이 쿼리는 'board' 테이블의 모든 컬럼(b.*)과 'header_name'을 반환합니다.
	    //    따라서 이 모든 컬럼을 처리할 수 있는 매퍼(아마도 boardListMapper)를 사용해야 합니다.
	    //    *주의*: boardMapper가 header_name을 처리하지 못할 수 있습니다.
	    
	    // 이전 대화 내용을 볼 때, 헤더 이름을 가져오는 쿼리에는 'boardListMapper'를 사용하는 것이 안전합니다.
	    List<BoardDto> list = jdbcTemplate.query(sql, boardListMapper, params); 
	    
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
//페이징수정
	public List<BoardDto> selectListWithPaging(PageVO pageVO, int pageType) {
	    if (pageVO.isList()) {
	        String sql = 
	            "select * from (" +
	            "  select rownum rn, TMP.* from (" +
	            "    select b.*, h.header_name " +
	            "    from board b " +
	            "    left join header h on b.board_header = h.header_no " +
	            "    where b.board_category_no=? " +
	            "    order by b.board_no desc" +
	            "  ) TMP" +
	            ") where rn between ? and ?";

	        Object[] params = { pageType, pageVO.getBegin(), pageVO.getEnd() };
	        return jdbcTemplate.query(sql, boardListMapper, params);
	    } else {
	        String sql = 
	            "select * from (" +
	            "  select rownum rn, TMP.* from (" +
	            "    select b.*, h.header_name " +
	            "    from board b " +
	            "    left join header h on b.board_header = h.header_no " +
	            "    where instr(#1, ?) > 0 " +
	            "    and b.board_category_no=? " +
	            "    order by #1 asc, b.board_no desc" +
	            "  ) TMP" +
	            ") where rn between ? and ?";

	        sql = sql.replace("#1", pageVO.getColumn());
	        Object[] params = { pageVO.getKeyword(), pageType, pageVO.getBegin(), pageVO.getEnd() };
	        return jdbcTemplate.query(sql, boardListMapper, params);
	    }
	}
  
	//좋아요 관련
	public boolean updateBoardLike(int boardNo, int boardLike) {
		String sql = "update board set board_like = ? where board_no=?";
		Object[] params = { boardLike, boardNo };
		return jdbcTemplate.update(sql, params) > 0;
	}
  
	public boolean updateBoardView(int boardNo) {
		String sql = "update board set board_view=board_view+1 where board_no=?";
		Object[] params = {boardNo};
		return jdbcTemplate.update(sql, params) > 0;
	}

	public List<BoardDto> selectListByWriteTime(int min, int max)
	{
		String sql = "select * from ("
				+ "select rownum rn, TMP.* from ("
				+ "select * from board order by board_wtime desc"
				+ ")TMP) where rn between ? and ?";
		Object[] params = {min, max};
		return jdbcTemplate.query(sql, boardMapper, params);
	}
}
