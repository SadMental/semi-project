	package com.spring.semi.dao;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.spring.semi.dto.BoardDto;
import com.spring.semi.dto.HeaderDto;
import com.spring.semi.mapper.BoardListMapper;
import com.spring.semi.mapper.BoardListVOMapper;
import com.spring.semi.mapper.BoardMapper;
import com.spring.semi.mapper.HeaderMapper;
import com.spring.semi.vo.BoardListVO;
import com.spring.semi.vo.PageVO;

@Repository
public class BoardDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;
    @Autowired
    private BoardMapper boardMapper;
    @Autowired
    private BoardListMapper boardListMapper;
    @Autowired
    private HeaderMapper headerMapper;
    @Autowired
	private BoardListVOMapper boardListVOMapper;

    /** 게시글 번호 발급 */
    public int sequence() {
        String sql = "select board_seq.nextval from dual";
        return jdbcTemplate.queryForObject(sql, int.class);
    }

    /** 게시글 등록 */
    public void insert(BoardDto boardDto, int boardType) {
        String sql = "insert into board ("
                   + "board_category_no, board_no, board_writer, board_title, board_content, board_header"
                   + ") values (?, ?, ?, ?, ?, ?)";

        Object[] params = {
            boardType,
            boardDto.getBoardNo(),
            boardDto.getBoardWriter(),
            boardDto.getBoardTitle(),
            boardDto.getBoardContent(),
            (boardDto.getBoardHeader() == null || boardDto.getBoardHeader().toString().trim().isEmpty())
                ? null
                : boardDto.getBoardHeader()
        };

        jdbcTemplate.update(sql, params);
    }

    /** 게시글 목록 (header 포함, 페이징 없는 버전) */
    public List<BoardDto> selectList(int boardType) {
        String sql = "SELECT b.*, h.header_name "
                   + "FROM board b "
                   + "LEFT JOIN header h ON b.board_header = h.header_no "
                   + "WHERE b.board_category_no = ? "
                   + "ORDER BY b.board_no DESC";
        Object[] params = { boardType };
        return jdbcTemplate.query(sql, boardListMapper, params);
    }

    /** 게시글 검색 (board + header 모두 지원) */
    public List<BoardDto> searchList(String column, String keyword) {
        Set<String> allowList = Set.of("board_title", "board_writer", "board_content", "header_name");
        if (!allowList.contains(column)) return List.of();

        String sql =
            "SELECT b.*, h.header_name "
          + "FROM board b "
          + "LEFT JOIN header h ON b.board_header = h.header_no "
          + "WHERE INSTR(#1, ?) > 0 "
          + "ORDER BY #1 ASC, b.board_no DESC";

        if ("header_name".equals(column))
            sql = sql.replace("#1", "h.header_name");
        else
            sql = sql.replace("#1", "b." + column);

        Object[] params = { keyword };
        return jdbcTemplate.query(sql, boardMapper, params);
    }

    /** 게시글 상세조회 */
    public BoardDto selectOne(int boardNo) {
        String sql = "SELECT board_no, board_category_no, board_writer, "
                   + "board_title, board_content, board_view, board_like, "
                   + "board_wtime, board_etime, board_header, board_reply "
                   + "FROM board "
                   + "WHERE board_no=?";
        Object[] params = { boardNo };
        List<BoardDto> list = jdbcTemplate.query(sql, boardMapper, params);
        return list.isEmpty() ? null : list.get(0);
    }

    /** 게시글 수정 */
    public boolean update(BoardDto boardDto) {
        String sql = "UPDATE board "
                   + "SET board_title=?, board_content=?, board_etime = systimestamp "
                   + "WHERE board_no=?";
        Object[] params = {
            boardDto.getBoardTitle(),
            boardDto.getBoardContent(),
            boardDto.getBoardNo()
        };
        return jdbcTemplate.update(sql, params) > 0;
    }

    /** 게시글 삭제 */
    public boolean delete(int boardNo) {
        String sql = "DELETE FROM board WHERE board_no = ?";
        Object[] params = { boardNo };
        return jdbcTemplate.update(sql, params) > 0;
    }

    /** 게시글 개수 (검색 + 카테고리) */
    public int count(PageVO pageVO, int pageType) {
        if (pageVO == null) pageVO = new PageVO();
        if (pageVO.getColumn() == null || pageVO.getColumn().isEmpty()) pageVO.setColumn("board_title");
        if (pageVO.getKeyword() == null) pageVO.setKeyword("");

        String sql;
        Object[] params;

        if (pageVO.isList() || pageVO.getKeyword().isEmpty()) {
            // 검색 없음
            sql = "SELECT COUNT(*) FROM board WHERE board_category_no = ?";
            params = new Object[]{ pageType };
        } 
        else if ("header_name".equals(pageVO.getColumn())) {
            // header_name 검색
            sql = "SELECT COUNT(*) "
                + "FROM board b LEFT JOIN header h ON b.board_header = h.header_no "
                + "WHERE INSTR(h.header_name, ?) > 0 AND b.board_category_no = ?";
            params = new Object[]{ pageVO.getKeyword(), pageType };
        } 
        else {
            // 일반 컬럼 검색
            sql = "SELECT COUNT(*) FROM board "
                + "WHERE INSTR(#1, ?) > 0 AND board_category_no = ?";
            sql = sql.replace("#1", "b." + pageVO.getColumn());
            params = new Object[]{ pageVO.getKeyword(), pageType };
        }

        return jdbcTemplate.queryForObject(sql, Integer.class, params);
    }

    /** 게시글 목록 (페이징 + 검색 + header JOIN) */
    public List<BoardDto> selectListWithPaging(PageVO pageVO, int pageType) {
        if (pageVO == null) pageVO = new PageVO();
        if (pageVO.getColumn() == null || pageVO.getColumn().isEmpty()) pageVO.setColumn("board_title");
        if (pageVO.getKeyword() == null) pageVO.setKeyword("");

        String sql;
        Object[] params;

        if (pageVO.isList() || pageVO.getKeyword().isEmpty()) {
            // 검색 없음
            sql =
                "SELECT * FROM (" +
                "  SELECT ROWNUM rn, TMP.* FROM (" +
                "    SELECT b.*, h.header_name " +
                "    FROM board b " +
                "    LEFT JOIN header h ON b.board_header = h.header_no " +
                "    WHERE b.board_category_no = ? " +
                "    ORDER BY b.board_no DESC" +
                "  ) TMP" +
                ") WHERE rn BETWEEN ? AND ?";
            params = new Object[]{ pageType, pageVO.getBegin(), pageVO.getEnd() };
        } 
        else if ("header_name".equals(pageVO.getColumn())) {
            // header_name 검색
            sql =
                "SELECT * FROM (" +
                "  SELECT ROWNUM rn, TMP.* FROM (" +
                "    SELECT b.*, h.header_name " +
                "    FROM board b " +
                "    LEFT JOIN header h ON b.board_header = h.header_no " +
                "    WHERE INSTR(h.header_name, ?) > 0 " +
                "    AND b.board_category_no = ? " +
                "    ORDER BY h.header_name ASC, b.board_no DESC" +
                "  ) TMP" +
                ") WHERE rn BETWEEN ? AND ?";
            params = new Object[]{ pageVO.getKeyword(), pageType, pageVO.getBegin(), pageVO.getEnd() };
        } 
        else {
            // 일반 컬럼 검색
            sql =
                "SELECT * FROM (" +
                "  SELECT ROWNUM rn, TMP.* FROM (" +
                "    SELECT b.*, h.header_name " +
                "    FROM board b " +
                "    LEFT JOIN header h ON b.board_header = h.header_no " +
                "    WHERE INSTR(#1, ?) > 0 " +
                "    AND b.board_category_no = ? " +
                "    ORDER BY #1 ASC, b.board_no DESC" +
                "  ) TMP" +
                ") WHERE rn BETWEEN ? AND ?";
            sql = sql.replace("#1", "b." + pageVO.getColumn());
            params = new Object[]{ pageVO.getKeyword(), pageType, pageVO.getBegin(), pageVO.getEnd() };
        }

        return jdbcTemplate.query(sql, boardListMapper, params);
    }
    /** 좋아요 수 업데이트 */
    public boolean updateBoardLike(int boardNo, int boardLike) {
        String sql = "UPDATE board SET board_like = ? WHERE board_no = ?";
        Object[] params = { boardLike, boardNo };
        return jdbcTemplate.update(sql, params) > 0;
    }

    /** 좋아요 카운트 반영 (board_like 테이블 기준) */
    public boolean syncBoardLikeCount(int boardNo) {
        String sql = "UPDATE board "
                   + "SET board_like = (SELECT COUNT(*) FROM board_like WHERE board_no = ?) "
                   + "WHERE board_no = ?";
        Object[] params = { boardNo, boardNo };
        return jdbcTemplate.update(sql, params) > 0;
    }

    /** 조회수 증가 */
    public boolean updateBoardView(int boardNo) {
        String sql = "UPDATE board SET board_view = board_view + 1 WHERE board_no = ?";
        Object[] params = { boardNo };
        return jdbcTemplate.update(sql, params) > 0;
    }

    /** 최신글 목록 (시간순) */
    public List<BoardDto> selectListByWriteTime(int min, int max) {
        String sql = "SELECT * FROM ("
                   + "  SELECT ROWNUM rn, TMP.* FROM ("
                   + "    SELECT board_no, board_title, board_writer, board_wtime, board_view "
                   + "    FROM board ORDER BY board_wtime DESC"
                   + "  ) TMP"
                   + ") WHERE rn BETWEEN ? AND ?";
        Object[] params = { min, max };
        return jdbcTemplate.query(sql, boardMapper, params);
    }

    /** 헤더 이름으로 조회 (중복 체크용) */
    public HeaderDto selectByName(String headerName) {
        String sql = "SELECT * FROM header WHERE header_name = ?";
        List<HeaderDto> list = jdbcTemplate.query(sql, headerMapper, headerName);
        return list.isEmpty() ? null : list.get(0);
    }
    //마이페이지  내글 보기 관련
    public List<BoardListVO> selectByMemberId(String login_id) {
  	String sql = "select board_no, board_title, board_wtime, board_view from board "
  			+ "where board_writer = ? "
  			+ "order by board_wtime desc";
  	Object[] params = {login_id};
  	return jdbcTemplate.query(sql, boardListVOMapper, params);
    }
}

