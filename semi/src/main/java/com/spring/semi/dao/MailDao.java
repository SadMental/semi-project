package com.spring.semi.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.spring.semi.dto.BoardDto;
import com.spring.semi.dto.MailDto;
import com.spring.semi.mapper.MailListMapper;
import com.spring.semi.mapper.MailMapper;
import com.spring.semi.vo.PageVO;

@Repository
public class MailDao {
	@Autowired 
	JdbcTemplate jdbcTemplate;
	@Autowired
	private MailMapper mailMapper;
	@Autowired
	private MailListMapper mailListMapper;

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
	public MailDto selectOne(String mailNo) {
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
	public List<MailDto> selectListWithPaging(PageVO pageVO, String mailOwner) {
	    if (pageVO.isList()) {
	        String sql = 
	        		"select * from (" 
	            		+"select rownum rn, TMP.* from (" 
	            			+"select mail_no, mail_owner, mail_sender, mail_target, mail_title, mail_wtime " 
	            			+"from mail " 
	            				+"where mail_owner = ? " 
	            					+"order by mail_no desc" 
            					+") TMP" 
        					+") where rn between ? and ?";

	        Object[] params = { mailOwner, pageVO.getBegin(), pageVO.getEnd() };
	        return jdbcTemplate.query(sql, mailListMapper, params);
	    } else {
	        String sql = 
		            "select * from (" 
				        + "select rownum rn, TMP.* from (" 
					        + "select mail_no, mail_owner, mail_sender, mail_target, mail_title, mail_wtime "
								+ "from mauk " 
									+ "where instr(#1, ?) > 0 " 
									+ "and mail_owner=? " 
									+ "order by #1 asc, mail_no desc" 
								+ ") TMP" 
				            + ") where rn between ? and ?";

	        sql = sql.replace("#1", pageVO.getColumn());
	        Object[] params = { pageVO.getKeyword(), mailOwner, pageVO.getBegin(), pageVO.getEnd() };
	        return jdbcTemplate.query(sql, mailListMapper, params);
	    }
	}
	
}
