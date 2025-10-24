package com.spring.semi.dao;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;
import com.spring.semi.dto.HeaderDto;
import com.spring.semi.mapper.HeaderMapper;
@Repository
public class HeaderDao {
   @Autowired
   private JdbcTemplate jdbcTemplate;
   @Autowired
   private HeaderMapper headerMapper;
   // 시퀀스 번호 조회
   public int sequence() {
       String sql = "select header_seq.nextval from dual";
       return jdbcTemplate.queryForObject(sql, int.class);
   }
   public void insert(String headerName) {
	    String sql = "insert into header(header_no, header_name) values(header_seq.nextval, ?)";
	    jdbcTemplate.update(sql, headerName);
	}
   // 수정
   public boolean update(HeaderDto headerDto) {
       String sql = "UPDATE Header SET header_name = ? WHERE header_no = ?";
       Object[] params = {
           headerDto.getHeaderName(),
           headerDto.getHeaderNo()
       };
       return jdbcTemplate.update(sql, params) > 0;
   }
   //헤더번호 기준수정
   public boolean updateByHeaderNo(int headerNo, String newHeaderName) {
       String sql = "UPDATE header SET header_name = ? WHERE header_no = ?";
       Object[] params = {newHeaderName, headerNo};
       return jdbcTemplate.update(sql, params) > 0;  // 하나의 행만 수정되므로 header_no에 의존
   }
   // 삭제
   public boolean delete(int headerNo) {
       String sql = "DELETE FROM header WHERE header_no = ?";
       Object[] params = {headerNo};
       return jdbcTemplate.update(sql, params) > 0;
   }
   // 같은 Header이름 조회
   public HeaderDto selectByName(String headerName) {
       String sql = "select * from header where header_name = ?";
       List<HeaderDto> list = jdbcTemplate.query(sql, headerMapper, headerName);
       return list.isEmpty() ? null : list.get(0);
   }
   // 전체 조회
   public List<HeaderDto> selectAll() {
       String sql = "SELECT * FROM header ORDER BY header_no ASC";

       return jdbcTemplate.query(sql, headerMapper);
   }
   // 단건 조회
   public HeaderDto selectOne(int headerNo) {
       String sql = "SELECT * FROM header WHERE header_no = ?";
       Object[] params = {headerNo};
       List<HeaderDto> list = jdbcTemplate.query(sql, headerMapper, params);
       return list.isEmpty() ? null : list.get(0);
   }
 
  
}

