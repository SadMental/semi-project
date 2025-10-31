package com.spring.semi.vo;


import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data @NoArgsConstructor @AllArgsConstructor @Builder
public class PageFilterVO 
{
	// 필드에 페이징에 필요한 데이터들을 배치
	private int page = 1; // 현재 페이지 번호
	private int size = 10; // 한 페이지에 표시할 데이터 수
	private String column, keyword; // 일반 검색 항목
    
    // ⭐ ⭐ ⭐ 추가 필드: 헤더 필터링 정보 ⭐ ⭐ ⭐
    private String animalHeaderName; // 동물 헤더 이름 (URL 파라미터와 일치)
    private String typeHeaderName;   // 타입 헤더 이름 (URL 파라미터와 일치)
    // ⭐ ⭐ ⭐ ⭐ ⭐ ⭐ ⭐ ⭐ ⭐ ⭐ ⭐ ⭐ ⭐ ⭐ ⭐ ⭐ ⭐
    
	private int dataCount; // 총 데이터 수
	private int blockSize = 10; // 표시할 블록 개수
	
	// 계산할 수 있는 Getter 메소드 추가 생성
    
    // ⭐ ⭐ ⭐ 수정된 메서드: 검색/필터링 여부 판단 ⭐ ⭐ ⭐
	public boolean isSearch() 
	{
        // 일반 검색 (column/keyword)이 있거나, 헤더 필터링(animalHeaderName/typeHeaderName)이 하나라도 있으면 true
        // 문자열이 비어있는 경우를 방지하기 위해 isBlank()를 사용합니다.
        // isBlank()를 사용할 수 없다면, !keyword.isEmpty()로 대체합니다.
        
        // 1. 일반 검색 체크
        if (column != null && keyword != null && !keyword.isEmpty()) {
            return true;
        }

        // 2. 헤더 필터링 체크
        if ((animalHeaderName != null && !animalHeaderName.isEmpty()) || 
            (typeHeaderName != null && !typeHeaderName.isEmpty())) {
            return true;
        }

        return false;
	}
	
	public boolean isList() 
	{
		return !isSearch();	// isSearch()의 반대
	}
    
    // ⭐ ⭐ ⭐ 수정된 메서드: 검색/필터링 URL 파라미터 생성 ⭐ ⭐ ⭐
    // 페이지 이동 시 기존 검색/필터링 조건 유지
	public String getSearchParams() 
	{
		if (isSearch()) {
            StringBuilder sb = new StringBuilder();
            sb.append("size=").append(size);

            // 1. 일반 검색 조건 추가
            if (column != null && keyword != null && !keyword.isEmpty()) {
                sb.append("&column=").append(column)
                  .append("&keyword=").append(keyword);
            }
            // 2. 헤더 필터링 조건 추가
            else if (animalHeaderName != null && !animalHeaderName.isEmpty()) {
                 sb.append("&animalHeaderName=").append(animalHeaderName);
            } else if (typeHeaderName != null && !typeHeaderName.isEmpty()) {
                 sb.append("&typeHeaderName=").append(typeHeaderName);
            }
            
            return sb.toString();
        } else {
			return "size=" + size;
        }
	}
    // ⭐ ⭐ ⭐ ⭐ ⭐ ⭐ ⭐ ⭐ ⭐ ⭐ ⭐ ⭐ ⭐ ⭐ ⭐ ⭐ ⭐
    
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
	
	public void fixPageRange() {
	    int total = getTotalPage();
	    if (page < 1) page = 1;
	    if (page > total) page = total;
	}
}