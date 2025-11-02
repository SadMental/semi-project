

package com.spring.semi.dto;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class ReplyLikeDto {
	// 좋아요를 누른 댓글 번호
	private int replyNo;
	
	// 좋아요를 누른 회원 ID
	private String memberId;
}
