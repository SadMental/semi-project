package com.spring.semi.dao;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.spring.semi.controller.MainController;
import com.spring.semi.dto.BoardDto;
import com.spring.semi.mapper.AdoptDetailMapper;
import com.spring.semi.mapper.BoardDetailVOMapper;
import com.spring.semi.mapper.BoardListVOMapper;
import com.spring.semi.mapper.BoardMapper;
import com.spring.semi.mapper.BoardVOMapper;
import com.spring.semi.vo.AdoptDetailVO;
import com.spring.semi.vo.BoardDetailVO;
import com.spring.semi.vo.BoardListVO;
import com.spring.semi.vo.BoardVO;
import com.spring.semi.vo.PageFilterVO;
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
	@Autowired
	private AdoptDetailMapper adoptDetailMapper;
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
	
	public List<BoardVO> selectFilterList(int min, int max, String orderBy, int categoryNo, String keyword) {
	    // ✅ 1. 허용된 정렬 기준만 사용
	    List<String> allows = List.of("view", "like", "wtime");
	    if (!allows.contains(orderBy)) return List.of();

	    // ✅ 2. 정렬 컬럼 설정
	    String orderColumn;
	    switch (orderBy) {
	        case "view": orderColumn = "board_view"; break;
	        case "like": orderColumn = "board_like"; break;
	        case "wtime":
	        default: orderColumn = "board_wtime"; break;
	    }

	    // ✅ 3. 기본 SQL
	    String sql = "SELECT * FROM ( "
	        + " SELECT rownum rn, TMP.* FROM ( "
	        + "   SELECT * FROM board_header_view "
	        + "   WHERE board_category_no = ? AND deleted = 0 ";

	    // ✅ 4. 검색어 조건 (board_content 제외)
	    if (keyword != null && !keyword.isEmpty()) {
	        sql += " AND (INSTR(type_header_name, ?) > 0 "
	             + " OR INSTR(animal_header_name, ?) > 0 "
	             + " OR INSTR(board_title, ?) > 0) ";
	    }

	    // ✅ 5. 정렬 및 페이징
	    sql += "   ORDER BY " + orderColumn + " DESC "
	         + " ) TMP "
	         + ") WHERE rn BETWEEN ? AND ?";

	    // ✅ 6. 파라미터 구성 및 실행
	    if (keyword != null && !keyword.isEmpty()) {
	        Object[] params = { categoryNo, keyword, keyword, keyword, min, max };
	        return jdbcTemplate.query(sql, boardVOMapper, params);
	    } else {
	        Object[] params = { categoryNo, min, max };
	        return jdbcTemplate.query(sql, boardVOMapper, params);
	    }
	    }
	public List<BoardVO> selectFilterListWithPaging(PageFilterVO pageFilterVO, int pageType) {
	    String column = pageFilterVO.getColumn();

	    if (pageFilterVO.isList()) {
	        // 목록 (검색 X)
	        String sql = "select * from (" + 
	                     "  select rownum rn, TMP.* from (" +
	                     "    select * from board_header_view " +
	                     "    where board_category_no=? and deleted = 0 order by board_no desc" +
	                     "  ) TMP" +
	                     ") where rn between ? and ?";
	        Object[] params = { pageType, pageFilterVO.getBegin(), pageFilterVO.getEnd() };
	        return jdbcTemplate.query(sql, boardVOMapper, params);
	    } else {
	        // 검색 (Search O)
	        
	        // ⭐ 통합 헤더 검색 (header_name, animal_header_name, type_header_name 요청 시)
	        if ("header_name".equalsIgnoreCase(column) || "animal_header_name".equalsIgnoreCase(column) || "type_header_name".equalsIgnoreCase(column)) {
	            
	            String sql = "select * from (" + "  select rownum rn, TMP.* from (" + "    select * "
	                    + "    from board_header_view "
	                    // 두 헤더 컬럼 모두에서 검색
	                    + "    where (instr(type_header_name, ?) > 0 or instr(animal_header_name, ?) > 0) "
	                    + "    and board_category_no=? and deleted = 0 "
	                    + "    order by board_no desc" 
	                    + "  ) TMP" + ") where rn between ? and ?";

	            // 검색어 2개, pageType 1개, 페이징 2개
	            Object[] params = { 
	                pageFilterVO.getKeyword(), 
	                pageFilterVO.getKeyword(), 
	                pageType, 
	                pageFilterVO.getBegin(), 
	                pageFilterVO.getEnd() 
	            };
	            return jdbcTemplate.query(sql, boardVOMapper, params);

	        } else {
	            // 기타 컬럼 검색 (#1 치환 사용)
	            String sql = "select * from (" + "  select rownum rn, TMP.* from (" + "    select * "
	                    + "    from board_header_view "
	                    + "    where instr(#1, ?) > 0 and board_category_no=? and deleted = 0 "
	                    + "    order by #1 asc, board_no desc" + "  ) TMP" + ") where rn between ? and ?";

	            sql = sql.replace("#1", column);
	            Object[] params = { pageFilterVO.getKeyword(), pageType, pageFilterVO.getBegin(), pageFilterVO.getEnd() };
	            return jdbcTemplate.query(sql, boardVOMapper, params);
	        }
	    }
	}
	//상세조회

	public AdoptDetailVO selectAdoptDetail(int boardNo) {
	    String sql = 
	        "SELECT " +
	        "B.board_category_no, B.board_no, B.board_title, B.board_content, B.board_writer, B.board_wtime, B.board_etime, " +
	        "B.board_like, B.board_view, B.board_reply, B.board_animal_header, B.board_type_header, B.board_score, B.deleted, " +
	        "A.animal_name, A.animal_permission, A.animal_content, A.animal_master, BA.animal_no AS animal_no, " +
	        "AH.header_name AS animal_header_name, TH.header_name AS type_header_name, " +
	        "NVL(AP.media_no, -1) AS media_no, " + 
	        "M.member_nickname, ML.level_name, ML.badge_image " +
	        "FROM board B " +
	        "LEFT JOIN board_animal BA ON B.board_no = BA.board_no " +
	        "LEFT JOIN animal A ON BA.animal_no = A.animal_no " +
	        "LEFT JOIN animal_header AH ON B.board_animal_header = AH.header_no " +
	        "LEFT JOIN type_header TH ON B.board_type_header = TH.header_no " +
	        "LEFT JOIN animal_profile AP ON A.animal_no = AP.animal_no " + 
	     
	        "LEFT JOIN member M ON B.board_writer = M.member_id " +
	        "LEFT JOIN member_level_table ML ON M.member_level = ML.level_no " +
	        "WHERE B.board_no = ? AND B.deleted = 0";

	    List<AdoptDetailVO> list = jdbcTemplate.query(sql, adoptDetailMapper, boardNo);
	    return list.isEmpty() ? null : list.get(0);
	}
	public int countFilter(PageFilterVO pageFilterVO, int pageType) {
	    String column = pageFilterVO.getColumn();

	    if (pageFilterVO.isList()) {
	        // 목록 조회 (검색 X)
	        String sql = "select count(*) from board where board_category_no=? and deleted = 0";
	        Object[] params = { pageType };
	        return jdbcTemplate.queryForObject(sql, int.class, params);
	    } else {
	        // 검색 시:
	        
	        // ⭐ 통합 헤더 검색 (header_name, animal_header_name, type_header_name 요청 시)
	        if ("header_name".equalsIgnoreCase(column) || "animal_header_name".equalsIgnoreCase(column) || "type_header_name".equalsIgnoreCase(column)) {
	            
	            String sql = "select count(*) from board_header_view "
	                       + "where (instr(type_header_name, ?) > 0 or instr(animal_header_name, ?) > 0) " 
	                       + "and board_category_no=? and deleted = 0";
	            
	            Object[] params = { pageFilterVO.getKeyword(), pageFilterVO.getKeyword(), pageType }; 
	            return jdbcTemplate.queryForObject(sql, int.class, params);
	            
	        } else {
	            // 기존검색 (작성자, 제목, 내용 등) - #1 치환 사용
	            String sql = "select count(*) from board " 
	                       + "where instr(#1, ?) > 0 " 
	                       + "and board_category_no=? and deleted = 0";
	            
	            sql = sql.replace("#1", column); // column 변수 사용
	            Object[] params = { pageFilterVO.getKeyword(), pageType };
	            return jdbcTemplate.queryForObject(sql, int.class, params);
	        }
	    }
	}


	public void insertFilter(AdoptDetailVO vo, int boardType) {
	    // 1️⃣ board_no 생성 후 게시글 저장
	    String boardSeqSql = "SELECT board_seq.nextval FROM dual";
	    int boardNo = jdbcTemplate.queryForObject(boardSeqSql, int.class);
	    vo.setBoardNo(boardNo);

	    // SQL 타입 오류는 위에서 CLOB으로 변경하여 해결해야 함
	    String boardInsertSql =
	        "INSERT INTO board (board_no, board_category_no, board_title, board_content, " +
	        "board_writer, board_animal_header, board_type_header, board_wtime, board_view, " +
	        "board_like, board_reply, board_score, deleted) " +
	        "VALUES (?, ?, ?, ?, ?, ?, ?, SYSDATE, 0, 0, 0, 0, 0)";

	    jdbcTemplate.update(boardInsertSql, vo.getBoardNo(), boardType, vo.getBoardTitle(),
	        vo.getBoardContent(), vo.getBoardWriter(), vo.getBoardAnimalHeader(), vo.getBoardTypeHeader());

	    String connectSql = "INSERT INTO board_animal (board_no, animal_no) VALUES (?, ?)";
	    // 폼에서 전달받은 vo.getAnimalNo()를 사용합니다.
	    jdbcTemplate.update(connectSql, boardNo, vo.getAnimalNo());
	}
	public void updateFilter(AdoptDetailVO vo) {
	 
	    String boardUpdateSql =
	        "UPDATE board SET board_title=?, board_content=?, board_animal_header=?, board_type_header=?, board_wtime=SYSDATE " +
	        "WHERE board_no=?";

	    jdbcTemplate.update(boardUpdateSql,
	        vo.getBoardTitle(),
	        vo.getBoardContent(),
	        vo.getBoardAnimalHeader(),
	        vo.getBoardTypeHeader(),
	        vo.getBoardNo() // WHERE 조건
	    );

	    String connectUpdateSql = "UPDATE board_animal SET animal_no=? WHERE board_no=?";
	    
	    // vo.getAnimalNo()는 수정 폼에서 사용자가 새로 선택한 animalNo 값입니다. (int 형태)
	    jdbcTemplate.update(connectUpdateSql,
	        vo.getAnimalNo(),
	        vo.getBoardNo() // WHERE 조건
	    );
	}
	public void insertAnimalConnect(int boardNo, int animalNo) {
        String sql = "INSERT INTO board_animal (board_no, animal_no) VALUES (?, ?)";
        jdbcTemplate.update(sql, boardNo, animalNo); 
    }
	public boolean updateAnimalConnect(int boardNo, int newAnimalNo) {
	    String sql = "UPDATE board_animal SET animal_no = ? WHERE board_no = ?";
	    Object[] params = {newAnimalNo, boardNo};
	     return jdbcTemplate.update(sql, params) > 0;
	}
	public int selectAnimalNoByBoardNo(int boardNo) {
	    String sql = "SELECT animal_no FROM board_animal WHERE board_no = ?";
	    return jdbcTemplate.queryForObject(sql, int.class, boardNo);
	}
	public int updatePermissionToF(int boardNo) {
	
	    String sql = 
	        "UPDATE animal a SET a.animal_permission = 'f' " +
	        "WHERE a.animal_no = (SELECT ba.animal_no FROM board_animal ba WHERE ba.board_no = ?)";
	    return jdbcTemplate.update(sql, boardNo);
	}
}