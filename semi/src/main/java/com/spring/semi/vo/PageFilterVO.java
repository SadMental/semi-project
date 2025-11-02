package com.spring.semi.vo;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data 
@NoArgsConstructor 
@AllArgsConstructor 
@Builder
public class PageFilterVO {
    
    // 🔹 페이징 관련
    private int page = 1;          // 현재 페이지
    private int size = 10;         // 한 페이지당 표시할 개수
    private int dataCount;         // 전체 데이터 개수
    private int blockSize = 10;    // 페이지 블록 크기

    // 🔹 검색 및 필터 관련
    private String column;         // 검색 컬럼 (board_title, board_content 등)
    private String keyword;        // 검색어
    private String animalHeaderName; // 동물 헤더명 (예: 강아지, 고양이)
    private String typeHeaderName;   
    
    // 🔹 정렬 관련
    private String orderBy = "wtime"; // 정렬 기준 (view, like, wtime)
    
    // =============================
    // 🔸 상태 판단 메서드
    // =============================
    public boolean isSearch() {
        return keyword != null && !keyword.isEmpty();
    }

    public boolean isList() {
        return !isSearch();
    }

    // =============================
    // 🔸 페이징 계산 메서드
    // =============================
    public int getBegin() {
        return (page - 1) * size + 1;
    }

    public int getEnd() {
        return page * size;
    }

    public int getTotalPage() {
        return (dataCount - 1) / size + 1;
    }

    public int getBlockStart() {
        return (page - 1) / blockSize * blockSize + 1;
    }

    public int getBlockFinish() {
        int number = (page - 1) / blockSize * blockSize + blockSize;
        return Math.min(getTotalPage(), number);
    }

    public boolean isFirstBlock() {
        return getBlockStart() == 1;
    }

    public boolean isLastBlock() {
        return getBlockFinish() == getTotalPage();
    }

    public int getPrevPage() {
        return getBlockStart() - 1;
    }

    public int getNextPage() {
        return getBlockFinish() + 1;
    }

    public void fixPageRange() {
        int total = getTotalPage();
        if (page < 1) page = 1;
        if (page > total) page = total;
    }

    // =============================
    // 🔸 쿼리 파라미터 문자열 생성
    // =============================
    public String getSearchParams() {
        StringBuilder sb = new StringBuilder();
        sb.append("size=").append(size);

        if (orderBy != null) sb.append("&orderBy=").append(orderBy);
        if (animalHeaderName != null && !animalHeaderName.isEmpty())
            sb.append("&animalHeaderName=").append(animalHeaderName);
        if (typeHeaderName != null && !typeHeaderName.isEmpty())
            sb.append("&typeHeaderName=").append(typeHeaderName);
        if (keyword != null && !keyword.isEmpty())
            sb.append("&keyword=").append(keyword);

        return sb.toString();
    }
}
