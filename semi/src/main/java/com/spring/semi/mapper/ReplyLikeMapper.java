package com.spring.semi.mapper;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Component;
import com.spring.semi.vo.ReplyListVO;
@Component

public class ReplyLikeMapper implements RowMapper<ReplyListVO> {
	@Override
	
	public ReplyListVO mapRow(ResultSet rs, int rowNum) throws SQLException {
		int isLikedValue = 0;
		try {
			// IS_LIKED 컬럼을 쿼리에서 추가했으므로, 이 값을 읽어옵니다.
			isLikedValue = rs.getInt("IS_LIKED");
		} catch (SQLException e) {
			// IS_LIKED가 없는 쿼리일 경우를 대비한 예외 처리 (선택 사항)
		}
		boolean isLikedBoolean = isLikedValue == 1;
		
		return ReplyListVO.builder()				
				// ReplyListVO 필드에 맞게 매핑
				.replyNo(rs.getInt("reply_no"))
				.replyContent(rs.getString("reply_content"))
				.replyWriter(rs.getString("reply_writer"))
				.replyTarget(rs.getInt("reply_target")) // reply_target
				.replyWtime(rs.getTimestamp("reply_wtime"))
				.replyEtime(rs.getTimestamp("reply_etime"))
				.replyLike(rs.getInt("reply_like"))
				
				// boolean 필드 매핑 (writer, owner는 쿼리에서 가져오지 않는다고 가정하고 false로 초기화)
				// 이 두 필드는 Service 단에서 로그인 ID와 비교하여 true/false를 설정하는 것이 좋습니다.
				.writer(false)
				.owner(false)
				
				.isLiked(isLikedBoolean) // ⭐ 쿼리 결과의 IS_LIKED 값을 ReplyListVO에 매핑
				.build();
	}
}
