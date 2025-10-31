package com.spring.semi.restcontroller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.spring.semi.dao.BoardDao;
import com.spring.semi.dao.MemberDao;
import com.spring.semi.dao.ReplyDao;
import com.spring.semi.dao.ReplyLikeDao;
import com.spring.semi.dto.BoardDto;
import com.spring.semi.dto.MemberDto;
import com.spring.semi.dto.ReplyDto;
import com.spring.semi.error.NeedPermissionException;
import com.spring.semi.error.TargetNotfoundException;
import com.spring.semi.vo.ReplyLikeVO;
import com.spring.semi.vo.ReplyListResponseVO;
import com.spring.semi.vo.ReplyListVO;

import jakarta.servlet.http.HttpSession;

@CrossOrigin
@RestController
@RequestMapping("/rest/reply")
public class ReplyRestController {

	@Autowired
	private ReplyDao replyDao;
	@Autowired
	private BoardDao boardDao;
	@Autowired
	private MemberDao memberDao;
	@Autowired
	private ReplyLikeDao replyLikeDao;

	/**
	 * 💬 댓글 목록 조회
	 * → GET /rest/reply/list?replyTarget=123
	 */
	@GetMapping("/list")
	public ReplyListResponseVO list(
            @RequestParam int replyTarget, 
            @RequestParam(defaultValue = "time") String sort, // ⭐ sort 파라미터 추가
            HttpSession session) {
        
		String loginId = (String) session.getAttribute("loginId");

		BoardDto boardDto = boardDao.selectOne(replyTarget);
		if (boardDto == null)
			throw new TargetNotfoundException("존재하지 않는 게시글");

        // ⭐ 1. 정렬 기준에 따라 댓글 목록 조회 메서드 선택
		List<ReplyDto> list;
        if ("like".equalsIgnoreCase(sort)) {
            // 좋아요순 정렬 메서드 호출
            list = replyDao.selectListByLike(replyTarget); 
        } else {
            // 기본(time) 정렬 메서드 호출
            list = replyDao.selectListByTime(replyTarget);
        }
        // *참고: DAO에 selectList(int replyTarget)만 있다면, selectListByTime으로 이름을 바꾸는 게 명확합니다.

		List<ReplyListVO> result = new ArrayList<>();

		for (ReplyDto replyDto : list) {
			boolean owner = loginId != null && replyDto.getReplyWriter() != null
					&& loginId.equals(replyDto.getReplyWriter());
			boolean writer = boardDto.getBoardWriter() != null && replyDto.getReplyWriter() != null
					&& boardDto.getBoardWriter().equals(replyDto.getReplyWriter());

			// 로그인한 사용자의 좋아요 여부
			boolean isLiked = loginId != null ? replyLikeDao.check(loginId, replyDto.getReplyNo()) : false;

			result.add(ReplyListVO.builder()
					.replyNo(replyDto.getReplyNo())
					.replyWriter(replyDto.getReplyWriter())
					.replyContent(replyDto.getReplyContent())
					.replyWtime(replyDto.getReplyWtime())
					.owner(owner)
					.writer(writer)
					.replyLike(replyDto.getReplyLike())
					.isLiked(isLiked)
					.build());
		}

        // ⭐ 2. 댓글 총 개수를 DB에서 COUNT하여 가져옴 (가장 정확한 방법)
        int totalReplyCount = replyDao.countByBoardNo(replyTarget);
        
		return ReplyListResponseVO.builder()
				.boardReply(totalReplyCount) // ⭐ boardDto.getBoardReply() 대신 COUNT 값 사용
				.list(result)
				.build();
	}

	/**
	 * ✏️ 댓글 작성
	 * → POST /rest/reply/write
	 */
	@PostMapping("/write")
	public MemberDto write(@ModelAttribute ReplyDto replyDto, HttpSession session) {
		if (replyDto.getReplyCategoryNo() == 0) {
			throw new IllegalArgumentException("댓글 카테고리 번호가 필요합니다.");
		}

		int sequence = replyDao.sequence();
		replyDto.setReplyNo(sequence);

		String loginId = (String) session.getAttribute("loginId");
		replyDto.setReplyWriter(loginId);

		replyDao.insert(replyDto);

		// 포인트 +20
		memberDao.addPoint(loginId, 20);

		return memberDao.selectOne(loginId);
	}

	/**
	 * 🗑 댓글 삭제
	 * → POST /rest/reply/delete
	 */
	@PostMapping("/delete")
	public void delete(HttpSession session, @RequestParam int replyNo) {
		String loginId = (String) session.getAttribute("loginId");

		ReplyDto replyDto = replyDao.selectOne(replyNo);
		if (replyDto == null)
			throw new TargetNotfoundException("존재하지 않는 댓글");

		if (!loginId.equals(replyDto.getReplyWriter()))
			throw new NeedPermissionException("권한 부족");

		int boardNo = replyDto.getReplyTarget();
		replyDao.delete(replyNo, boardNo);

		// 포인트 -20
		memberDao.addPoint(loginId, -20);
	}

	/**
	 * 🪶 댓글 수정
	 * → POST /rest/reply/edit
	 */
	@PostMapping("/edit")
	public void edit(HttpSession session, @ModelAttribute ReplyDto replyDto) {
		String loginId = (String) session.getAttribute("loginId");

		ReplyDto findDto = replyDao.selectOne(replyDto.getReplyNo());
		if (findDto == null)
			throw new TargetNotfoundException("존재하지 않는 댓글");

		if (!loginId.equals(findDto.getReplyWriter()))
			throw new NeedPermissionException("권한 부족");

		replyDao.update(replyDto);
	}

	/**
	 * 💗 좋아요 토글
	 * → POST /rest/reply/like/action
	 */
	@PostMapping("/like/action")
	public ReplyLikeVO likeAction(HttpSession session, @RequestParam int replyNo) {
	    String memberId = (String) session.getAttribute("loginId");
	    if (memberId == null)
	        throw new NeedPermissionException("로그인 필요");

	    boolean alreadyLiked = replyLikeDao.check(memberId, replyNo);

	    if (alreadyLiked) {
	        replyLikeDao.delete(memberId, replyNo);
	        replyDao.decreaseReplyLike(replyNo); // ✅ 감소는 여기서만
	    } else {
	        replyLikeDao.insert(memberId, replyNo);
	        replyDao.increaseReplyLike(replyNo); // ✅ 증가는 여기서만
	    }

	    int count = replyLikeDao.countByReplyNo(replyNo);
	    return new ReplyLikeVO(!alreadyLiked, count);
	}

	/**
	 * ❤️ 좋아요 상태 확인
	 * → GET /rest/reply/like/check?replyNo=123
	 */
	@GetMapping("/like/check")
	public ReplyLikeVO likeCheck(HttpSession session, @RequestParam int replyNo) {
		String memberId = (String) session.getAttribute("loginId");
		int count = replyLikeDao.countByReplyNo(replyNo);

		if (memberId == null)
			return new ReplyLikeVO(false, count);

		boolean alreadyLiked = replyLikeDao.check(memberId, replyNo);
		return new ReplyLikeVO(alreadyLiked, count);
	}
}


