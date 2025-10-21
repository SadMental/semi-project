package com.spring.semi.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.spring.semi.dto.AttachmentDto;
import com.spring.semi.mapper.AttachmentMapper;

@Repository
public class AttachmentDao 
{
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private AttachmentMapper attachmentMapper;
	
	public int sequence() 
	{
		String sql = "select attachment_seq.nextval from dual";
		return jdbcTemplate.queryForObject(sql, int.class);
	}
	
	public void insert(AttachmentDto attachmentDto) 
	{
		String sql = "insert into attachment (attachment_no, attachment_name, "
				+ "attachment_type, attachment_size) "
				+ "values (?, ?, ?, ?)";
		Object[] params = {attachmentDto.getAttachmentNo(), attachmentDto.getAttachmentName(),
				attachmentDto.getAttachmentType(), attachmentDto.getAttachmentSize()};
		jdbcTemplate.update(sql, params);
	}
	
	public AttachmentDto selectOne(int attachmentNo) 
	{
		String sql = "select * from attachment where attachment_no = ?";
		Object[] params = {attachmentNo};
		List<AttachmentDto> list = jdbcTemplate.query(sql, attachmentMapper, params);
		return list.isEmpty()? null : list.get(0);
	}
	
	public boolean delete(int attachmentNo) 
	{
		String sql = "delete attachment where attachment_no = ?";
		Object[] params = {attachmentNo};
		return jdbcTemplate.update(sql, params) > 0;
	}
}
