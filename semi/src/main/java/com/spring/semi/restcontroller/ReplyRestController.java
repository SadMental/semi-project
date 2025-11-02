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
	           // 💡 요청하신 대로 클라이언트가 보낸 loginId를 받는 파라미터를 추가했습니다.
	           // 이 값은 세션 ID와 동일해야 하지만, 세션 ID를 우선하여 사용합니다.
	           @RequestParam(required = false) String clientLoginId, 
	           HttpSession session) {
	      
	     
			String loginId = (String) session.getAttribute("loginId");
	        if (loginId == null) {
	            // null 대신 빈 문자열을 사용하여 DAO의 SQL 쿼리에서 NULL 비교 오류를 방지합니다.
	            loginId = "";
	        }
	        
			BoardDto boardDto = boardDao.selectOne(replyTarget);
			if (boardDto == null)
				throw new TargetNotfoundException("존재하지 않는 게시글");
	       
	       // ⭐ DAO 메소드 호출 시, null 대신 빈 문자열이 전달될 수 있으므로 안전합니다.
			List<ReplyListVO> result = replyDao.selectListWithLike(replyTarget, sort, loginId);
	       
	       // 2. ReplyListVO의 writer/owner 필드 채우기 (Mapper가 못 하므로 여기서 처리)
	       for (ReplyListVO reply : result) {
	           // writer: 게시글 작성자와 댓글 작성자가 같은지
	           boolean isBoardWriter = boardDto.getBoardWriter() != null &&
	                                   reply.getReplyWriter() != null &&
	                                   boardDto.getBoardWriter().equals(reply.getReplyWriter());
	           reply.setWriter(isBoardWriter);
	          
	           // owner: 댓글 작성자와 현재 로그인 사용자가 같은지
	           // loginId가 빈 문자열이므로, .isEmpty()를 사용하여 로그인 상태를 판단합니다.
	           boolean isOwner = !loginId.isEmpty() && // loginId가 빈 문자열이 아닌 경우 (로그인 상태)
	                             reply.getReplyWriter() != null &&
	                             loginId.equals(reply.getReplyWriter());
	           reply.setOwner(isOwner);
	           // isLiked 필드는 이미 DAO/Mapper에서 채워져 있습니다.
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

