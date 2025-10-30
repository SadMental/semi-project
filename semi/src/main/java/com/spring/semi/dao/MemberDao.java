	package com.spring.semi.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.spring.semi.dto.MemberDto;
import com.spring.semi.mapper.MemberMapper;
import com.spring.semi.vo.PageVO;

@Repository
public class MemberDao {
	@Autowired
	private JdbcTemplate jdbcTemplate;
	@Autowired
	private MemberMapper memberMapper;

	public void insert(MemberDto memberDto) {
		String sql = "insert into " + "member(member_id, member_pw, member_nickname, member_email, "
				+ "member_description, member_auth) " + "values(?, ?, ?, ?, ?, ?)";

		Object[] params = { memberDto.getMemberId(), memberDto.getMemberPw(), memberDto.getMemberNickname(),
				memberDto.getMemberEmail(), memberDto.getMemberDescription(), memberDto.getMemberAuth() };

		jdbcTemplate.update(sql, params);
	}

	public boolean delete(String member_id) {
		String sql = "delete from member where member_id = ?";
		Object[] params = { member_id };
		return jdbcTemplate.update(sql, params) > 0;
	}

	public boolean updateForUser(MemberDto memberDto) {
		String sql = "update member set member_nickname = ?, member_email = ?, "
				+ "member_description = ?, member_auth = ?" + "where member_id = ?";
		Object[] params = { memberDto.getMemberNickname(), memberDto.getMemberEmail(), memberDto.getMemberDescription(),
				memberDto.getMemberAuth(), memberDto.getMemberId() };

		return jdbcTemplate.update(sql, params) > 0;
	}

	public boolean updateForUserPassword(String member_pw, String member_id) {
		String sql = "update member set member_pw = ?, member_change = systimestamp where member_id = ?";
		Object[] params = { member_pw, member_id };

		return jdbcTemplate.update(sql, params) > 0;
	}
	
	public void updateForLogin(String member_id) {
		String sql = "update member set member_login = systimestamp where member_id = ?";
		Object[] params = {member_id};
		jdbcTemplate.update(sql, params);
	}
	
	public void updateForAdmin(MemberDto findDto) {
		String sql = "update member set member_nickname = ?, member_description = ?, member_point = ? "
																+ "where member_id = ?";
		
		Object[] params = {
				findDto.getMemberNickname(),
				findDto.getMemberDescription(),
				findDto.getMemberPoint(),
				findDto.getMemberId()
				};
		
		jdbcTemplate.update(sql, params);
		
	}
	
	public MemberDto selectOne(String member_id) {
		String sql = "select * from member where member_id = ?";
		Object[] params = { member_id };
		List<MemberDto> list = jdbcTemplate.query(sql, memberMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
	public MemberDto selectForEmail(String memberEmail) {
		String sql = "select * from member where member_email = ?";
		Object[] params = {memberEmail};
		List<MemberDto> list = jdbcTemplate.query(sql, memberMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
	public MemberDto selectForNickname(String memberNickname) {
		String sql = "select * from member where member_nickname = ?";
		Object[] params = {memberNickname};
		List<MemberDto> list = jdbcTemplate.query(sql, memberMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
	public List<MemberDto> selectList(){
		String sql = "select * from member";
		
		return jdbcTemplate.query(sql, memberMapper);
	}

	public void connect(String member_id, int media_no) {
		String sql = "insert into member_profile values(?, ?)";
		Object[] params = { member_id, media_no };
		jdbcTemplate.update(sql, params);
	}

	public int findMediaNo(String member_id) {
		String sql = "select media_no from member_profile where member_id = ?";
		Object[] params = { member_id };
		return jdbcTemplate.queryForObject(sql, int.class, params);
	}
	
	// member_point가 가장 높은 10명의 회원들
	public List<MemberDto> selectListByMemberPoint(int min, int max)
	{
		String sql = "select * from ("
				+ "select rownum rn, TMP.* from ("
				+ "select * from member order by member_point desc"
				+ ")TMP) where rn between ? and ?";
		Object[] params = {min, max};
		return jdbcTemplate.query(sql, memberMapper, params);
	}
	
	//포인트 쌓기
		public void addPoint(String memberId, int point) {
			String sql = "update member set member_point = member_point + ? "
					+ "where member_id = ?";
			Object[] params = {point, memberId};
			int result = jdbcTemplate.update(sql, params);

		}
		
		
		

	//포인트 차감
		//public void minusPoint(String memberId, int point) {
			//String sql = "update member set member_point = member_point - ? "
			//		+ "where member_id	= ?";
			//Object[] params = {point, memberId};
			//int result = jdbcTemplate.update(sql, params);
		//}

	//페이징용
	public int count(PageVO pageVO) {
		if(pageVO.isList()) {
			String sql = "select count(*) from member where member_level != 2";
			return jdbcTemplate.queryForObject(sql, int.class);
		} else {
			String sql = "select count(*) from member where instr(#1, ?) > 0 and member_level != 2";
			sql = sql.replace("#1", pageVO.getColumn());
			Object[] params = {pageVO.getKeyword()};
			return jdbcTemplate.queryForObject(sql, int.class, params);
		}
	}
	//페이징용
	public List<MemberDto> selectListForPaging(PageVO pageVO){
		if(pageVO.isList()) {
			String sql = "select * from ("
								+ "select rownum rn, TMP.* from ("
									+ "select * from member "
									+ "where member_level != 2 "
									+ "order by member_id asc"
								+ ") TMP"
							+ ") where rn between ? and ?";
			Object[] params = {pageVO.getBegin(), pageVO.getEnd()};
			return jdbcTemplate.query(sql, memberMapper, params);
		} else {
			String sql = "select * from ("
									+ "select rownum rn, TMP.* from ("
										+ "select * from member "
										+ "where instr(#1, ?) > 0 and member_level != 2 "
										+ "order by #1 asc, member_id asc"
									+ ") TMP"
								+ ") where rn between ? and ?";
			sql = sql.replace("#1", pageVO.getColumn());
			Object[] params = {pageVO.getKeyword(), pageVO.getBegin(), pageVO.getEnd()};
			return jdbcTemplate.query(sql, memberMapper, params);
		}
	}



}
