package com.spring.semi.vo;

import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class ReplyListResponseVO {
    private int boardReply;                // 댓글 총 개수
    private List<ReplyListVO> list;        // 댓글 리스트
}