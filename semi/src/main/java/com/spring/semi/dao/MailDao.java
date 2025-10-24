package com.spring.semi.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.spring.semi.dto.BoardDto;
import com.spring.semi.dto.MailDto;
import com.spring.semi.mapper.MailVOMapper;
import com.spring.semi.mapper.MailDetailMapper;
import com.spring.semi.mapper.MailMapper;
import com.spring.semi.vo.MailDetailVO;
import com.spring.semi.vo.MailVO;
import com.spring.semi.vo.PageVO;

@Repository
public class MailDao {
	@Autowired 
	JdbcTemplate jdbcTemplate;
	@Autowired
	private MailMapper mailMapper;
	@Autowired
	private MailVOMapper mailVOMapper;
	@Autowired
	private MailDetailMapper mailDetailMapper;
	public int sequence() {
		String sql = "select mail_seq.nextval from dual";
		return jdbcTemplate.queryForObject(sql, int.class);
	}

	// 우편 보내는 사람의 저장용
	public void insertForSender(MailDto mailDto) {
		mailDto.setMailOwner(mailDto.getMailSender());
		insert(mailDto);
	}
	
	// 우편 받는 사람의 저장용
	public void insertForTarget(MailDto mailDto) {
		mailDto.setMailOwner(mailDto.getMailTarget());
		insert(mailDto);
	}
	
	// 우편 저장 통합기능
	public void insert(MailDto mailDto) {
		String sql = "insert into mail(mail_no, mail_owner ,mail_sender, mail_target, mail_title, mail_content) "
				+ "values(?, ?, ?, ?, ?, ?)";
		
		Object[] params = {
				mailDto.getMailNo(),
				mailDto.getMailOwner(),
				mailDto.getMailSender(),
				mailDto.getMailTarget(),
				mailDto.getMailTitle(),
				mailDto.getMailContent()
		};
		
		jdbcTemplate.update(sql, params);
	}
	// 우편 내용 보기 용도
	public MailDto selectOne(int mailNo) {
		String sql = "select * from mail where mail_no = ?";
		Object[] params = {mailNo};
		
		List<MailDto> list = jdbcTemplate.query(sql, mailMapper, params);
		return list.isEmpty()? null : list.get(0);
	}
	
	// 우편 리스트 나열 용도
	public List<MailDto> selectList(String mailOwner){
		String sql = "select * from mail where mail_owner = ?";
		Object[] params = {mailOwner};
		
		return jdbcTemplate.query(sql, mailMapper, params);
		
	}
	
	// 개인 우편 삭제 용도
	public boolean delete(int mailNo) {
		String sql = "delete from mail where mail_no = ?";
		Object[] params = {mailNo};
		
		return jdbcTemplate.update(sql, params) > 0;
	}

	public int count(PageVO pageVO, String mailOwner) {
		if (pageVO.isList()) {
			String sql = "select count(*) from mail " 
									+ "where mail_owner=? " 
								+ "order by mail_no asc";
			Object[] params = { mailOwner };
			return jdbcTemplate.queryForObject(sql, int.class, params);
		} else {
			String sql = "select count(*) from mail " 
									+ "where instr(#1, ?) > 0 " 
								+ "and mail_owner = ?";
			sql = sql.replace("#1", pageVO.getColumn());
			Object[] params = { pageVO.getKeyword(), mailOwner };
			return jdbcTemplate.queryForObject(sql, int.class, params);
		}
	}
//페이징수정
	public List<MailVO> selectListWithPaging(PageVO pageVO, String mailOwner) {
	    if (pageVO.isList()) {
	        String sql = 
	        		"select * from (" 
	            		+"select rownum rn, TMP.* from (" 
	            			+"select m.mail_no, m.mail_owner, m.mail_sender, m.mail_target, m.mail_title, m.mail_wtime, "
	            			+ "s.member_nickname as sender_nickname,"
	            			+ "t.member_nickname as target_nickname " 
		            			+"from mail m "
		            			+ "join member s on m.mail_sender = s.member_id "
		            			+ "join member t on m.mail_target = t.member_id "  
	            				+"where m.mail_owner = ? " 
	            					+"order by m.mail_no desc" 
            					+") TMP" 
        					+") where rn between ? and ?";

	        Object[] params = { mailOwner, pageVO.getBegin(), pageVO.getEnd() };
	        return jdbcTemplate.query(sql, mailVOMapper, params);
	    } else {
	        String sql = 
		            "select * from (" 
				        + "select rownum rn, TMP.* from (" 
					        +"select m.mail_no, m.mail_owner, m.mail_sender, m.mail_target, m.mail_title, m.mail_wtime, "
	            			+ "s.member_nickname as sender_nickname,"
	            			+ "t.member_nickname as target_nickname " 
		            			+"from mail m "
		            			+ "join member s on m.mail_sender = s.member_id "
		            			+ "join member t on m.mail_target = t.member_id " 
									+ "where instr(#1, ?) > 0 " 
									+ "and m.mail_owner=? " 
									+ "order by #1 asc, m.mail_no desc" 
								+ ") TMP" 
				            + ") where rn between ? and ?";

	        sql = sql.replace("#1", pageVO.getColumn());
	        Object[] params = { pageVO.getKeyword(), mailOwner, pageVO.getBegin(), pageVO.getEnd() };
	        return jdbcTemplate.query(sql, mailVOMapper, params);
	    }
	}
	
	public List<MailVO> selectListForSenderWithPaging(PageVO pageVO, String mailSender) {
	    if (pageVO.isList()) {
	        String sql = 
	        		"select * from (" 
	            		+"select rownum rn, TMP.* from (" 
		            		+"select m.mail_no, m.mail_owner, m.mail_sender, m.mail_target, m.mail_title, m.mail_wtime, "
	            			+ "s.member_nickname as sender_nickname,"
	            			+ "t.member_nickname as target_nickname " 
	            			+"from mail m "
	            			+ "join member s on m.mail_sender = s.member_id "
	            			+ "join member t on m.mail_target = t.member_id " 
	            				+"where mail_sender = ? and mail_sender = mail_owner " 
	            					+"order by mail_no desc" 
            					+") TMP" 
        					+") where rn between ? and ?";

	        Object[] params = { mailSender, pageVO.getBegin(), pageVO.getEnd() };
	        return jdbcTemplate.query(sql, mailVOMapper, params);
	    } else {
	        String sql = 
		            "select * from (" 
				        + "select rownum rn, TMP.* from (" 
					        +"select m.mail_no, m.mail_owner, m.mail_sender, m.mail_target, m.mail_title, m.mail_wtime, "
	            			+ "s.member_nickname as sender_nickname,"
	            			+ "t.member_nickname as target_nickname " 
		            			+"from mail m "
		            			+ "join member s on m.mail_sender = s.member_id "
		            			+ "join member t on m.mail_target = t.member_id " 
									+ "where instr(#1, ?) > 0 " 
									+ "and m.mail_sender=? and m.mail_sender = m.mail_owner " 
									+ "order by #1 asc, m.mail_no desc" 
								+ ") TMP" 
				            + ") where rn between ? and ?";

	        sql = sql.replace("#1", pageVO.getColumn());
	        Object[] params = { pageVO.getKeyword(), mailSender, pageVO.getBegin(), pageVO.getEnd() };
	        return jdbcTemplate.query(sql, mailVOMapper, params);
	    }
	}
	
	public List<MailVO> selectListForTargetWithPaging(PageVO pageVO, String mailTarget) {
	    if (pageVO.isList()) {
	        String sql = 
	        		"select * from (" 
	            		+"select rownum rn, TMP.* from (" 
		            		+"select m.mail_no, m.mail_owner, m.mail_sender, m.mail_target, m.mail_title, m.mail_wtime, "
	            			+ "s.member_nickname as sender_nickname,"
	            			+ "t.member_nickname as target_nickname "  
		            			+"from mail m "
		            			+ "join member s on m.mail_sender = s.member_id "
		            			+ "join member t on m.mail_target = t.member_id " 
		            				+"where m.mail_target = ? and m.mail_sender != m.mail_owner " 
		            					+"order by m.mail_no desc" 
	            					+") TMP" 
	        					+") where rn between ? and ?";

	        Object[] params = { mailTarget, pageVO.getBegin(), pageVO.getEnd() };
	        return jdbcTemplate.query(sql, mailVOMapper, params);
	    } else {
	        String sql = 
		            "select * from (" 
				        + "select rownum rn, TMP.* from (" 
					        +"select m.mail_no, m.mail_owner, m.mail_sender, m.mail_target, m.mail_title, m.mail_wtime, "
	            			+ "s.member_nickname as sender_nickname,"
	            			+ "t.member_nickname as target_nickname " 
		            			+"from mail m "
		            			+ "join member s on m.mail_sender = s.member_id "
		            			+ "join member t on m.mail_target = t.member_id " 
									+ "where instr(#1, ?) > 0 " 
									+ "and m.mail_target=? and m.mail_sender != m.mail_owner " 
									+ "order by #1 asc, m.mail_no desc" 
								+ ") TMP" 
				            + ") where rn between ? and ?";

	        sql = sql.replace("#1", pageVO.getColumn());
	        Object[] params = { pageVO.getKeyword(), mailTarget, pageVO.getBegin(), pageVO.getEnd() };
	        return jdbcTemplate.query(sql, mailVOMapper, params);
	    }
	}
	
	public MailDetailVO selectForDetail(int mailNo) {
		String sql = "select mail.*, s.member_nickname as sender_nickname from mail join member s on mail_sender = s.member_id where mail_no = ?";
		
		Object[] params = {mailNo};
		List<MailDetailVO> list =	jdbcTemplate.query(sql, mailDetailMapper, params);
		
		return list.isEmpty()? null:list.get(0);
	}
	
}
