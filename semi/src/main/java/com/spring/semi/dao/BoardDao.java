package com.spring.semi.dao;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.spring.semi.controller.MainController;
import com.spring.semi.dto.BoardDto;
import com.spring.semi.mapper.BoardDetailVOMapper;
import com.spring.semi.mapper.BoardListVOMapper;
import com.spring.semi.mapper.BoardMapper;
import com.spring.semi.mapper.BoardVOMapper;
import com.spring.semi.vo.BoardDetailVO;
import com.spring.semi.vo.BoardListVO;
import com.spring.semi.vo.BoardVO;
import com.spring.semi.vo.PageVO;

@Repository
public class BoardDao {

	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private BoardMapper boardMapper;
	@Autowired
	private BoardListVOMapper boardListVOMapper;
	@Autowired
	private BoardVOMapper boardVOMapper;
	@Autowired
	private BoardDetailVOMapper boardDetailVOMapper;

	public int sequence() {
		String sql = "select board_seq.nextval from dual";
		return jdbcTemplate.queryForObject(sql, int.class);
	}

	// 등록
	public void insert(BoardDto boardDto, int boardType) {
		String sql = "insert into board ("
				+ "board_category_no, board_no, board_writer, board_title, board_content, board_type_header, board_animal_header"
				+ ") values (?, ?, ?, ?, ?, ?, ?)";

		Object[] params = { boardType, boardDto.getBoardNo(), boardDto.getBoardWriter(), boardDto.getBoardTitle(),
				boardDto.getBoardContent(), boardDto.getBoardTypeHeader(), boardDto.getBoardAnimalHeader() };

		jdbcTemplate.update(sql, params);
	}

	public void insertForReview(BoardDto boardDto, int boardType) {
		String sql = "insert into board (" + "board_category_no, board_no, board_writer, board_title, board_content, "
				+ "board_animal_header, board_type_header, board_score" + ") values (?, ?, ?, ?, ?, ?, ?, ?)";

		Object[] params = { boardType, boardDto.getBoardNo(), boardDto.getBoardWriter(), boardDto.getBoardTitle(),
				boardDto.getBoardContent(), boardDto.getBoardAnimalHeader(), boardDto.getBoardTypeHeader(),
				boardDto.getBoardScore() };

		jdbcTemplate.update(sql, params);
	}

	// 검색
	public List<BoardDto> searchList(String column, String keyword) {
		Set<String> allowList = Set.of("board_title", "board_writer", "board_content", "header_name");
		if (!allowList.contains(column))
			return List.of();

		String sql = "select b.* from board b left join header h on b.header_no = h.header_no "
				+ "where instr(#1, ?) > 0 and b.deleted = 0 order by #1 asc, b.board_no asc";
		sql = sql.replace("#1", column);
		Object[] params = { keyword };
		return jdbcTemplate.query(sql, boardMapper, params);
	}

	// 글 하나 조회
	public BoardDto selectOne(int boardNo) {
		String sql = "SELECT * FROM board WHERE board_no=? AND deleted = 0";
		Object[] params = { boardNo };
		List<BoardDto> list = jdbcTemplate.query(sql, boardMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}

	// 삭제
	public boolean delete(int boardNo) {
		String sql = "update board set deleted = 1 where board_no = ?";
		Object[] params = { boardNo };
		return jdbcTemplate.update(sql, params) > 0;
	}

	// 마이페이지에서 글 삭제
	public boolean mypageDelete(int boardNo) {
		return delete(boardNo);
	}

	// 삭제된 글 조회
	public List<BoardListVO> selectDeletedByMemberId(String login_id) {
		String sql = "select board_no, board_title, board_wtime, board_view, category_name from board "
				+ "join category on category_no = board_category_no " + "where board_writer = ? and deleted = 1 "
				+ "order by board_wtime desc";
		Object[] params = { login_id };
		return jdbcTemplate.query(sql, boardListVOMapper, params);
	}

	// 수정
	public boolean update(BoardDto boardDto) {
		String sql = "update board set board_title=?, board_content=?, board_type_header=?, board_animal_header=?, board_etime=systimestamp "
				+ "where board_no=?";
		Object[] params = { boardDto.getBoardTitle(), boardDto.getBoardContent(), boardDto.getBoardTypeHeader(),
				boardDto.getBoardAnimalHeader(), boardDto.getBoardNo() };
		return jdbcTemplate.update(sql, params) > 0;
	}

	public boolean updateForReview(BoardDto boardDto) {
		String sql = "update board set board_title=?, board_content=?, board_etime=systimestamp, "
				+ "board_animal_header=?, board_type_header=?, board_score=? " + "where board_no=?";
		Object[] params = { boardDto.getBoardTitle(), boardDto.getBoardContent(), boardDto.getBoardAnimalHeader(),
				boardDto.getBoardTypeHeader(), boardDto.getBoardScore(), boardDto.getBoardNo() };
		return jdbcTemplate.update(sql, params) > 0;
	}

	// 전체 글 수 조회
	public int count(PageVO pageVO, int pageType) {
		if (pageVO.isList()) {
			String sql = "select count(*) from board where board_category_no=? and deleted = 0";
			Object[] params = { pageType };
			return jdbcTemplate.queryForObject(sql, int.class, params);
		} else {
			if ("header_name".equalsIgnoreCase(pageVO.getColumn())) {
				String sql = "select count(*) from board b " + "left join header h on b.board_header = h.header_no "
						+ "where instr(h.header_name, ?) > 0 and b.board_category_no=? and b.deleted = 0";
				Object[] params = { pageVO.getKeyword(), pageType };
				return jdbcTemplate.queryForObject(sql, int.class, params);
			} else {
				String sql = "select count(*) from board where instr(#1, ?) > 0 and board_category_no=? and deleted = 0";
				sql = sql.replace("#1", pageVO.getColumn());
				Object[] params = { pageVO.getKeyword(), pageType };
				return jdbcTemplate.queryForObject(sql, int.class, params);
			}
		}
	}

	// 페이징 처리된 글 목록 조회
	public List<BoardVO> selectListWithPaging(PageVO pageVO, int pageType) {
		if (pageVO.isList()) {
			String sql = "select * from (" + "  select rownum rn, TMP.* from (" + "    select * from board_header_view "
					+ "    where board_category_no=? and deleted = 0 order by board_no desc" + "  ) TMP"
					+ ") where rn between ? and ?";
			Object[] params = { pageType, pageVO.getBegin(), pageVO.getEnd() };
			return jdbcTemplate.query(sql, boardVOMapper, params);
		} else {
			String sql = "select * from (" + "  select rownum rn, TMP.* from (" + "    select * from board_header_view "
					+ "    where instr(#1, ?) > 0 and board_category_no=? and deleted = 0 "
					+ "    order by #1 asc, board_no desc" + "  ) TMP" + ") where rn between ? and ?";
			sql = sql.replace("#1", pageVO.getColumn());
			Object[] params = { pageVO.getKeyword(), pageType, pageVO.getBegin(), pageVO.getEnd() };
			return jdbcTemplate.query(sql, boardVOMapper, params);
		}
	}



	// 좋아요 관련
	public boolean updateBoardLike(int boardNo, int boardLike) {
		String sql = "update board set board_like = ? where board_no=?";
		Object[] params = { boardLike, boardNo };
		return jdbcTemplate.update(sql, params) > 0;
	}

    
    public boolean updateBoardLike(int board_no) {
		String sql = "update board "
							+ "set board_like = (select count(*) from board_like where board_no = ?) "
							+ "where board_no = ?";
		Object[] params = {board_no, board_no};
		return jdbcTemplate.update(sql, params) > 0;
	}
    

    public boolean updateBoardView(int boardNo) {
        String sql = "update board set board_view=board_view+1 where board_no=?";
        Object[] params = { boardNo };
        return jdbcTemplate.update(sql, params) > 0;
    }

    // 최신순 목록
    public List<BoardListVO> selectListByWriteTime(int min, int max) {
        String sql = "select * from (" +
                     "select rownum rn, TMP.* from (" +
                     "select board_no, board_title, board_wtime, board_view, category_name " +
                     "from board join category on category_no = board_category_no " +
                     "where deleted = 0 " +
                     "order by board_wtime desc" +
                     ") TMP) where rn between ? and ?";
        Object[] params = { min, max };
        return jdbcTemplate.query(sql, boardListVOMapper, params);
    }

    // 조회순, 추천순, 시간순 목록 조회 (카테고리별)
    public List<BoardDto> selectList(int min, int max, String orderBy, int categoryNo) {
        String orderColumn;
        switch (orderBy) {
        case "view":
            orderColumn = "board_view";
            break;
        case "like":
            orderColumn = "board_like";
            break;
        case "wtime":
        default:
            orderColumn = "board_wtime";
            break;
        }

        String sql = "SELECT * FROM ( " +
                     "  SELECT rownum rn, TMP.* FROM ( " +
                     "    SELECT * FROM board " +
                     "    WHERE board_category_no = ? AND deleted = 0 " +
                     "    ORDER BY " + orderColumn + " DESC " +
                     "  ) TMP " +
                     ") WHERE rn BETWEEN ? AND ?";

        Object[] params = { categoryNo, min, max };
        return jdbcTemplate.query(sql, boardMapper, params);
    }

    public List<BoardVO> selectList2(int min, int max, String orderBy, int categoryNo) {
        List<String> allows = List.of("view", "like", "wtime");
        if (!allows.contains(orderBy)) return List.of();

        String orderColumn;
        switch (orderBy) {
        case "view":
            orderColumn = "board_view";
            break;
        case "like":
            orderColumn = "board_like";
            break;
        case "wtime":
        default:
            orderColumn = "board_wtime";
            break;
        }

        String sql = "SELECT * FROM ( " +
                     "    SELECT rownum rn, TMP.* FROM ( " +
                     "        select * from board_header_view " +
                     "        WHERE board_category_no = ? AND deleted = 0 " +
                     "        ORDER BY " + orderColumn + " DESC " +
                     "    ) TMP " +
                     ") WHERE rn BETWEEN ? AND ?";

        Object[] params = { categoryNo, min, max };
        return jdbcTemplate.query(sql, boardVOMapper, params);
    }

    // 이미지/비디오 연결
    public void connect(int boardNo, int mediaNo) {
        String sql = "insert into board_image (board_no, media_no) values (?, ?)";
        Object[] params = { boardNo, mediaNo };
        jdbcTemplate.update(sql, params);
    }

    public void connect_video(int boardNo, int videoNo) {
        String sql = "insert into board_video (board_no, video_no) values (?, ?)";
        Object[] params = { boardNo, videoNo };
        jdbcTemplate.update(sql, params);
    }

    public int findMedia(int boardNo) {
        String sql = "select media_no from board_image where board_no = ?";
        Object[] params = { boardNo };
        return jdbcTemplate.queryForObject(sql, int.class, params);
    }

    public int findVideo(int boardNo) {
        String sql = "select video_no from board_video where board_no = ?";
        Object[] params = { boardNo };
        return jdbcTemplate.queryForObject(sql, int.class, params);
    }

    // 메인페이지 목록
    public List<BoardVO> selectListWithPagingForMainPage(int pageType, int min, int max) {
        String sql = "select * from (" +
                     "  select rownum rn, TMP.* from (" +
                     "   select * from board_header_view " +
                     "    where board_category_no=? AND deleted = 0 " +
                     "    order by board_no desc" +
                     "  ) TMP" +
                     ") where rn between ? and ?";
        Object[] params = { pageType, min, max };
        return jdbcTemplate.query(sql, boardVOMapper, params);
    }

    // 마이페이지 내 글 조회
    public List<BoardListVO> selectByMemberId(String login_id) {
        String sql = "select board_no, board_title, board_wtime, board_view, category_name from board " +
                     "join category on category_no = board_category_no " +
                     "where board_writer = ? and deleted = 0 " +
                     "order by board_wtime desc";
        Object[] params = { login_id };
        return jdbcTemplate.query(sql, boardListVOMapper, params);
    }
  
    
  public BoardDetailVO selectOneDetail(int boardNo) {
	    String sql = "SELECT b.board_category_no, b.board_no, b.board_title, b.board_content, b.board_writer, "
	            + "b.board_wtime, b.board_etime, b.board_like, b.board_view, b.board_reply, "
	            + "ah.header_name AS animal_header_name, "
	            + "th.header_name AS type_header_name, "
	            + "b.board_score, b.deleted, "
	            + "m.member_nickname, ml.level_name, ml.badge_image "
	            + "FROM board b "
	            + "LEFT JOIN member m ON b.board_writer = m.member_id "
	            + "LEFT JOIN member_level_table ml ON m.member_level = ml.level_no "
	            + "LEFT JOIN animal_header ah ON b.board_animal_header = ah.header_no "
	            + "LEFT JOIN type_header th ON b.board_type_header = th.header_no "
	            + "WHERE b.board_no = ? AND b.deleted = 0";

	    Object[] params = { boardNo };
	    List<BoardDetailVO> list = jdbcTemplate.query(sql, boardDetailVOMapper, params);
	    return list.isEmpty() ? null : list.get(0);
	}



	// 목록 조회 (정보게시판 전용, 페이징)

	public List<BoardDetailVO> selectListDetail(int min, int max, int categoryNo, String orderBy) {
		String orderColumn;
		switch (orderBy) {
		case "view":
			orderColumn = "b.board_view";
			break;
		case "like":
			orderColumn = "b.board_like";
			break;
		case "wtime":
		default:
			orderColumn = "b.board_wtime";
			break;
		}

		String sql = "SELECT * FROM ("
		        + "  SELECT rownum rn, TMP.* FROM ("
		        + "    SELECT b.board_category_no, b.board_no, b.board_title, b.board_content, b.board_writer, "
		        + "           b.board_wtime, b.board_etime, b.board_like, b.board_view, b.board_reply, "
		        + "           ah.header_name AS animal_header_name, "
		        + "           th.header_name AS type_header_name, "
		        + "           b.board_score, b.deleted, "
		        + "           m.member_nickname, ml.level_name, ml.badge_image "
		        + "    FROM board b "
		        + "    LEFT JOIN member m ON b.board_writer = m.member_id "
		       + "    LEFT JOIN member_level_table ml ON m.member_level = ml.level_no "
		        + "    LEFT JOIN animal_header ah ON b.board_animal_header = ah.header_no "
		        + "    LEFT JOIN type_header th ON b.board_type_header = th.header_no "
		        + "    WHERE b.board_category_no = ? AND b.deleted = 0 "
		        + "    ORDER BY " + orderColumn + " DESC"
		        + "  ) TMP"
		        + ") WHERE rn BETWEEN ? AND ?";


		Object[] params = { categoryNo, min, max };
		return jdbcTemplate.query(sql, boardDetailVOMapper, params);
	}
}