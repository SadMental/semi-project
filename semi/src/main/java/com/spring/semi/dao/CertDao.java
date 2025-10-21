package com.spring.semi.dao;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.spring.semi.dto.CertDto;
import com.spring.semi.mapper.CertMapper;

@Repository
public class CertDao {
	@Autowired
	private CertMapper certMapper;
	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	//인증번호 생성해서 DB 저장
	public void insert(CertDto certDto) {
		String sql = "insert into cert(cert_email, cert_number) values(?, ?)";
		Object[] params = {certDto.getCertEmail(), certDto.getCertNumber()};
		jdbcTemplate.update(sql, params);
	}
	
	//재인증 요청시 인증번호 새로 갱신
	public boolean update(CertDto certDto) {
		String sql = "update cert set cert_number=?, cert_time=systimestamp where cert_email=?";
		Object[] params = {certDto.getCertNumber(), certDto.getCertEmail()};
		return jdbcTemplate.update(sql, params) > 0;
	}
	
	//입력한 이메일로 DB조회하여 번호, 시간등 가져옴
	//결과 없으면 0, 있으면 첫번째 데이터 0 반환
	public CertDto selectOne(String certEmail) {
		String sql = "select * from cert where cert_email = ?";
		Object[] params = {certEmail};
		List<CertDto> list = jdbcTemplate.query(sql, certMapper, params);
		return list.isEmpty() ? null : list.get(0);
	}
	
	//인증 완료후,  필요없는 이메일 DB서 삭제
	public boolean delete(String certEmail) {
		String sql = "delete cert where cert_email = ?";
		Object[] params = {certEmail};
		return jdbcTemplate.update(sql, params) > 0;
	}
	
}
