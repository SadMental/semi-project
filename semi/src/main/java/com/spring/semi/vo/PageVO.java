package com.spring.semi.vo;

import java.sql.Timestamp;

import com.spring.semi.dto.BoardDto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class PageVO 
{
	// 필드에 페이징에 필요한 데이터들을 배치
	private int page = 1; // 현재 페이지 번호
	private int size = 10; // 한 페이지에 표시할 데이터 수
	private String column, keyword; // 검색 항목
	private int dataCount; // 총 데이터 수
	private int blockSize = 10; // 표시할 블록 개수
	
	// 계산할 수 있는 Getter 메소드 추가 생성
	public boolean isSearch() 
	{
		return column != null && keyword != null;
	}
	
	public boolean isList() 
	{
		return column == null || keyword == null;	
	}
	
	public String getSearchParams() 
	{
		if (isSearch())
			return "size=" + size + "&column=" + column + "&keyword=" + keyword;
		else
			return "size=" + size;
	}
	
	public int getBlockStart() 
	{
		return (page - 1) / blockSize * blockSize + 1;	
	}
	
	public int getBlockFinish() 
	{
		int number = (page - 1) / blockSize * blockSize + blockSize;		
		return Math.min(getTotalPage(), number);
	}
	
	public int getTotalPage() 
	{
		return (dataCount - 1) / size + 1;
	}
	
	public int getBegin() 
	{
		return page * size - (size - 1);
	}
	
	public int getEnd() 
	{
		return page * size;
	}
	
	public boolean isFirstBlock() 
	{
		return getBlockStart() == 1;
	}
	
	public boolean isLastBlock() 
	{
		return getBlockFinish() == getTotalPage();
	}
	
	public int getPrevPage() 
	{
		return getBlockStart() - 1;
	}
	
	public int getNextPage() 
	{
		return getBlockFinish() + 1;
	}
}