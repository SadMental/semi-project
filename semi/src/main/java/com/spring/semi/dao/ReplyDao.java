package com.spring.semi.dao;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import com.spring.semi.dto.ReplyDto;
import com.spring.semi.mapper.ReplyLikeMapper;
import com.spring.semi.mapper.ReplyMapper;
import com.spring.semi.vo.ReplyListVO;
@Repository
public class ReplyDao {
   @Autowired
   private JdbcTemplate jdbcTemplate;
   @Autowired
   private ReplyMapper replyMapper;
   @Autowired
   private ReplyLikeMapper replyLikeMapper;
   // 1. 특정 작성자 댓글 목록 조회
   public List<ReplyDto> selectList(String replyWriter) {
       String sql = "SELECT * FROM reply WHERE reply_writer = ? ORDER BY reply_no DESC";
       Object[] params = { replyWriter };
       return jdbcTemplate.query(sql, replyMapper, params);
   }
   // 2. 특정 글(reply_target) 기준 댓글 목록 조회
   public List<ReplyDto> selectList(int replyTarget) {
       String sql = "SELECT * FROM reply WHERE reply_target = ? ORDER BY reply_no DESC";
       Object[] params = { replyTarget };
       return jdbcTemplate.query(sql, replyMapper, params);
   }
// 3. 댓글 삭제
   public boolean delete(int replyNo, int boardNo) {
       String sql = "DELETE FROM reply WHERE reply_no = ?";
       Object[] params = { replyNo };
       int result = jdbcTemplate.update(sql, params);
       if (result > 0) {
           // 댓글 수 -1
           String updateSql = "UPDATE board SET board_reply = board_reply - 1 WHERE board_no = ?";
           jdbcTemplate.update(updateSql, boardNo);
       }
       return result > 0;
   }
   // 4. 시퀀스에서 새로운 번호 가져오기
   public int sequence() {
       String sql = "SELECT reply_seq.NEXTVAL FROM dual";
       return jdbcTemplate.queryForObject(sql, Integer.class);
   }
   // 5. 댓글 삽입
   public void insert(ReplyDto replyDto) {
       String sql = "INSERT INTO reply (reply_no, reply_writer, reply_target, reply_content, reply_category_no) "
                  + "VALUES (?, ?, ?, ?, ?)";
       Object[] params = {
           replyDto.getReplyNo(),
           replyDto.getReplyWriter(),
           replyDto.getReplyTarget(),  // 게시글 번호
           replyDto.getReplyContent(),
           replyDto.getReplyCategoryNo()
       };
       int result = jdbcTemplate.update(sql, params);
       // 댓글이 정상 등록되면 게시글 댓글 수 +1
       if (result > 0) {
           String updateSql = "UPDATE board SET board_reply = board_reply + 1 WHERE board_no = ?";
           jdbcTemplate.update(updateSql, replyDto.getReplyTarget());
       }
   }
   // 6. 댓글 수정
   public boolean update(ReplyDto replyDto) {
       String sql = "UPDATE reply "
                  + "SET reply_content = ?, reply_etime = SYSTIMESTAMP "
                  + "WHERE reply_no = ?";
       Object[] params = {
           replyDto.getReplyContent(),
           replyDto.getReplyNo()
       };
       return jdbcTemplate.update(sql, params) > 0;
   }	
   // 7. 댓글 단건 조회
   public ReplyDto selectOne(int replyNo) {
       String sql = "SELECT * FROM reply WHERE reply_no = ?";
       Object[] params = { replyNo };
       List<ReplyDto> list = jdbcTemplate.query(sql, replyMapper, params);
       return list.isEmpty() ? null : list.get(0);
   } 
  
// ✅ 댓글의 좋아요 개수 갱신
   public void updateReplyLikeCount(int replyNo) {
       String sql = "UPDATE reply "
                  + "SET reply_like = (SELECT COUNT(*) FROM reply_like WHERE reply_no = ?) "
                  + "WHERE reply_no = ?";
       jdbcTemplate.update(sql, replyNo, replyNo);
   }
// ✅ 좋아요 시 reply.reply_like + 1
   public void increaseReplyLike(int replyNo) {
       String sql = "UPDATE reply SET reply_like = reply_like + 1 WHERE reply_no = ?";
       jdbcTemplate.update(sql, replyNo);
   }
   // ✅ 좋아요 취소 시 reply.reply_like - 1 (단, 0 밑으로는 내려가지 않게)
   public void decreaseReplyLike(int replyNo) {
       String sql = "UPDATE reply SET reply_like = CASE WHEN reply_like > 0 THEN reply_like - 1 ELSE 0 END WHERE reply_no = ?";
       jdbcTemplate.update(sql, replyNo);
   }
// ✅ 최신순 정렬 (기본) - [이것을 대신 사용]
   public List<ReplyDto> selectListByTime(int replyTarget) {
       String sql = "SELECT * FROM reply WHERE reply_target = ? ORDER BY reply_no DESC";
       return jdbcTemplate.query(sql, replyMapper, replyTarget);
   }
   // ✅ 좋아요순 정렬
   public List<ReplyDto> selectListByLike(int replyTarget) {
       String sql = "SELECT * FROM reply WHERE reply_target = ? ORDER BY reply_like DESC, reply_no DESC";
       return jdbcTemplate.query(sql, replyMapper, replyTarget);
   }
   // ✅ 댓글 총 개수 조회
   public int countByBoardNo(int boardNo) {
       String sql = "SELECT COUNT(*) FROM reply WHERE reply_target = ?";
       Integer count = jdbcTemplate.queryForObject(sql, Integer.class, boardNo);
       return count != null ? count.intValue() : 0;
   }
public List<ReplyListVO> selectListWithLike(int replyTarget, String sort, String loginId) {
		
		String sql =
		    "SELECT "
		    + "    R.*, "
		
		    + "    CASE WHEN RL.REPLY_NO IS NOT NULL THEN 1 ELSE 0 END AS IS_LIKED "
		    + "FROM "
		    + "    REPLY R "
		    		    + "LEFT JOIN "
		    + "    REPLY_LIKE RL ON R.REPLY_NO = RL.REPLY_NO AND RL.MEMBER_ID = ? " // 1번째 파라미터: loginId
		    + "WHERE "
		    + "    R.REPLY_TARGET = ? ";
		   
		
		// 2. 정렬 조건 추가
		if ("like".equalsIgnoreCase(sort)) {
			sql += "ORDER BY R.REPLY_LIKE DESC, R.REPLY_WTIME DESC";
		} else {
			
			sql += "ORDER BY R.REPLY_WTIME DESC";
		}
		
	
		Object[] params = {loginId, replyTarget};
		
		
		return jdbcTemplate.query(sql, replyLikeMapper, params);
	}
}
