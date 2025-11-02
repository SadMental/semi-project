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

	@GetMapping("/list")
	public ReplyListResponseVO list(
	           @RequestParam int replyTarget,
	           @RequestParam(defaultValue = "time") String sort,
	           // 💡 클라이언트에서 보낸 파라미터(clientLoginId)는 제거하고 세션에만 의존하여 보안과 일관성을 유지합니다.
	           HttpSession session) {
	      
	        // 💡 수정된 부분: 세션에서 loginId를 가져오되, null이면 빈 문자열로 초기화합니다.
	        // 이 loginId가 DAO로 전달되어 해당 사용자의 좋아요 상태를 조회합니다.
			String loginId = (String) session.getAttribute("loginId");
	        if (loginId == null) {
	            // DAO 쿼리가 SQL NULL 비교를 하지 않도록 빈 문자열로 대체하여 비로그인 상태를 명확히 합니다.
	            loginId = "";
	        }
	        
			BoardDto boardDto = boardDao.selectOne(replyTarget);
			if (boardDto == null)
				throw new TargetNotfoundException("존재하지 않는 게시글");
	       
	       // ⭐ DAO 호출 시, loginId가 null 대신 ""로 전달되어 안전합니다.
			List<ReplyListVO> result = replyDao.selectListWithLike(replyTarget, sort, loginId);
	       
	       // 2. ReplyListVO의 writer/owner 필드 채우기 (Mapper가 못 하므로 여기서 처리)
	       for (ReplyListVO reply : result) {
	           // writer: 게시글 작성자와 댓글 작성자가 같은지
	           boolean isBoardWriter = boardDto.getBoardWriter() != null &&
	                                   reply.getReplyWriter() != null &&
	                                   boardDto.getBoardWriter().equals(reply.getReplyWriter());
	           reply.setWriter(isBoardWriter);
	          
	        
	           boolean isOwner = !loginId.isEmpty() && // loginId가 빈 문자열이 아닌 경우 (로그인 상태)
	                             reply.getReplyWriter() != null &&
	                             loginId.equals(reply.getReplyWriter());
	           reply.setOwner(isOwner);
	    
	       }
	       // ⭐ 3. 댓글 총 개수를 DB에서 COUNT하여 가져옴
	       int totalReplyCount = replyDao.countByBoardNo(replyTarget);
	      
			return ReplyListResponseVO.builder()
					.boardReply(totalReplyCount)
					.list(result)
					.build();
		}

  
   // ... (write, delete, edit, likeAction, likeCheck 메소드는 변경 없음)
	/**
	 * ✏️ 댓글 작성
	 * → POST /rest/reply/write
	 */
	@PostMapping("/write")
	public MemberDto write(@ModelAttribute ReplyDto replyDto, HttpSession session) {
       // ... 기존 로직 유지
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
       // ... 기존 로직 유지
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
       // ... 기존 로직 유지
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
replyDao.decreaseReplyLike(replyNo); } else {
	replyLikeDao.insert(memberId, replyNo);
	 replyDao.increaseReplyLike(replyNo);
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

