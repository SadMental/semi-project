package com.spring.semi.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.spring.semi.dto.MemberDto;
import com.spring.semi.mapper.MemberMapper;

@Repository
public class MemberDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private MemberMapper memberMapper;
	
	public void insert(MemberDto memberDto) {
		String sql = "insert into "
				+ "member(member_id, member_pw, member_nickname, member_email, "
								+ "member_description, member_auth, member_animal) "
				+ "values(?, ?, ?, ?, ?, ?, ?)";
		
		Object[] params = {
				memberDto.getMemberId(), memberDto.getMemberPw(),
				memberDto.getMemberNickname(), memberDto.getMemberEmail(),
				memberDto.getMemberDescription(),
				memberDto.getMemberAuth(), memberDto.getMemberAnimal()};
		
		jdbcTemplate.update(sql, params);
	}
	
	public boolean delete(String member_id) {
		String sql = "delete from member where member_id = ?";
		Object[] params = {member_id};
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	public boolean updateForUser(MemberDto memberDto) {
		String sql = "update member set member_nickname = ?, member_email = ?, "
												+ "member_description = ?, member_auth = ?, member_animal = ? "
												+ "where member_id = ?";
		Object[] params = {
				memberDto.getMemberNickname(), memberDto.getMemberEmail(),
				memberDto.getMemberDescription(),
				memberDto.getMemberAuth(), memberDto.getMemberAnimal(),
				memberDto.getMemberId()};
		
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	public boolean updateForUserPassword(String member_pw, String member_id) {
		String sql = "update member set member_pw = ? where member_id = ?";
		Object[] params = {
				member_pw, member_id
		};
		
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	public MemberDto selectOne(String member_id) {
		String sql = "select * from member where member_id = ?";
		Object[] params = {member_id};
		List<MemberDto> list = jdbcTemplate.query(sql, memberMapper, params);
		return list.isEmpty()? null : list.get(0);
	}
	
	
}
