package com.spring.semi.restcontroller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.spring.semi.dao.BoardDao;
import com.spring.semi.dao.ReplyDao;
import com.spring.semi.dto.BoardDto;
import com.spring.semi.dto.ReplyDto;
import com.spring.semi.error.NeedPermissionException;
import com.spring.semi.error.TargetNotfoundException;
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

  //댓글목록
   @PostMapping("/list")
	public List<ReplyListVO> list(@RequestParam int replyTarget, HttpSession session) {
		String loginId = (String)session.getAttribute("loginId");
		
		BoardDto boardDto = boardDao.selectOne(replyTarget);
		if(boardDto == null) throw new TargetNotfoundException("존재하지 않는 게시글");
		
		List<ReplyDto> list = replyDao.selectList(replyTarget);
		List<ReplyListVO> result = new ArrayList<>();
		for(ReplyDto replyDto : list) {
			boolean owner = loginId != null && replyDto.getReplyWriter() != null
											&& loginId.equals(replyDto.getReplyWriter());
			boolean writer = boardDto.getBoardWriter() != null
								&& replyDto.getReplyWriter() != null
								&& boardDto.getBoardWriter().equals(replyDto.getReplyWriter());
			
			result.add(ReplyListVO.builder()
						.replyNo(replyDto.getReplyNo())
						.replyWriter(replyDto.getReplyWriter())
						.replyTarget(replyDto.getReplyTarget())
						.replyContent(replyDto.getReplyContent())
						.replyWtime(replyDto.getReplyWtime())
						.replyEtime(replyDto.getReplyEtime())
						.owner(owner)
						.writer(writer)
					.build());
		}
		return result;
	}
   @PostMapping("/write")
   public void write(@ModelAttribute ReplyDto replyDto, HttpSession session) {
       if (replyDto.getReplyCategoryNo() == 0) {
           throw new IllegalArgumentException("댓글 카테고리 번호가 필요합니다.");
       }

       int sequence = replyDao.sequence();
       replyDto.setReplyNo(sequence);

       String loginId = (String) session.getAttribute("loginId");
       replyDto.setReplyWriter(loginId);

       replyDao.insert(replyDto);
   }

	
	@PostMapping("/delete")
	public void delete(HttpSession session, @RequestParam int replyNo) {
		String loginId = (String)session.getAttribute("loginId");
		
		ReplyDto replyDto = replyDao.selectOne(replyNo);
		if(replyDto == null) throw new TargetNotfoundException("존재하지 않는 댓글");
		
		boolean owner = loginId.equals(replyDto.getReplyWriter());
		if(owner == false) throw new NeedPermissionException("권한 부족");
		
		replyDao.delete(replyNo);
	}
	@PostMapping("/edit")
	public void edit(HttpSession session, @ModelAttribute ReplyDto replyDto) {
		String loginId = (String)session.getAttribute("loginId");
		
		ReplyDto findDto = replyDao.selectOne(replyDto.getReplyNo());
		if(findDto == null) throw new TargetNotfoundException("존재하지 않는 댓글");
		
		boolean owner = loginId.equals(findDto.getReplyWriter());//본인이야?
		if(owner == false) throw new NeedPermissionException("권한 부족");
		
		replyDao.update(replyDto);
	}
}
