<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<link rel="stylesheet" type="text/css" href="/css/commons.css">
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<style>
/* 기존 HTML 기본 스타일 */
body {
    background-color: #f4ede6;
    color: #5b3a29;
    margin: 0;
    padding: 0;
}

.container.w-800 {
    max-width: 800px;
    margin: 40px auto;
    padding: 30px 35px;
    border-radius: 15px;
    background-color: #ffffffdd;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

h1 {
    font-size: 2.8rem;
    font-weight: 700;
    margin-bottom: 25px;
    text-align: center;
}

table {
    width: 100%;
    border-collapse: collapse;
    font-size: 1.05rem;
}

table thead {
    background-color: #e9d8c6;
}

table th, table td {
    padding: 14px 12px;
    border-bottom: 1px solid #d3bfa6;
    text-align: center;
}

table tr:hover {
    background-color: #f3eae1;
}

a {
    color: #5b3a29;
    text-decoration: none;
}

a:hover {
    text-decoration: underline;
}

.btn.btn-positive {
    background-color: #7e5a3c;
    color: #f9f6f1;
    border: none;
    padding: 10px 20px;
    font-size: 1rem;
    font-weight: 700;
    border-radius: 10px;
    cursor: pointer;
    text-decoration: none;
    display: inline-block;
    margin-top: 20px;
}

.btn.btn-positive:hover {
    background-color: #a67849;
}

.cell.right {
    text-align: right;
}

.no-posts {
    text-align: center;
    padding: 40px 0;
    color: #8c6d5b;
}

.mb-20 {
    margin-bottom: 20px;
}

/* --- ⭐ 새로운 레이아웃 및 카테고리 스타일 ⭐ --- */

/* 페이지 헤더 영역 (제목 + 검색 폼) */
.page-header-area {
    margin-bottom: 25px; /* 필터 섹션과의 간격 */
}
.page-header-area h1 {
    margin-bottom: 15px; /* 제목과 검색 폼 사이 간격 */
}

/* 상단 검색 폼 스타일 */
.search-form-top .search-bar {
    display: flex;
    justify-content: center;
    align-items: center;
    gap: 10px; /* 아이템 사이 간격 */
    margin-bottom: 20px;
}
.search-form-top .search-bar select,
.search-form-top .search-bar input[type="text"] {
    padding: 8px 12px;
    border: 1px solid #d3bfa6;
    border-radius: 8px;
    font-size: 1rem;
    color: #5b3a29;
}
.search-form-top .search-bar input[type="text"] {
    flex-grow: 1; 
    max-width: 250px;
}
.search-form-top .search-bar button {
    padding: 8px 15px;
    font-size: 1rem;
    border-radius: 8px;
    margin-top: 0; /* btn-positive의 margin-top 초기화 */
}


/* 글쓰기 버튼 영역 */
.write-button-area {
    margin-top: 20px;
    margin-bottom: 15px; /* 게시글 목록과의 간격 */
    text-align: right; /* 버튼을 오른쪽으로 정렬 */
}
.write-button-area p {
    font-size: 0.9em;
    color: #8c6d5b;
    margin: 0;
}


/* 카테고리 섹션 컨테이너 */
.category-section {
    margin-top: 10px;
    border: 1px solid #d3bfa6;
    border-radius: 10px;
    padding: 10px;
    background-color: #fff;
    overflow: hidden;
}

.category-row {
    display: flex;
    align-items: center;
    margin-bottom: 8px;
    padding: 5px 0;
    border-bottom: 1px dashed #e0d0c0; 
}
.category-row:last-child {
    border-bottom: none;
    margin-bottom: 0;
}

/* 전체보기 버튼 행 스타일 */
.category-row.main-category {
    justify-content: center;
    border-bottom: 2px solid #d3bfa6;
    margin-bottom: 15px;
    padding-bottom: 15px;
}


/* 그룹 제목 스타일 */
.group-title {
    font-weight: 700;
    color: #5b3a29;
    font-size: 15px;
    margin-right: 15px;
    padding: 0 10px;
    flex-shrink: 0;
    min-width: 80px;
    text-align: right;
}

/* 헤더 그룹 (animal, type) 공통 스타일 */
.header-group {
    display: flex;
    flex-wrap: nowrap;
    overflow-x: auto;
    -webkit-overflow-scrolling: touch;
    padding: 0 5px;
    flex-grow: 1;
}
/* 헤더 그룹 스크롤바 스타일 */
.header-group::-webkit-scrollbar {
    height: 4px;
}
.header-group::-webkit-scrollbar-thumb {
    background-color: #d3bfa6;
    border-radius: 2px;
}
.header-group::-webkit-scrollbar-track {
    background-color: #f4ede6;
}


/* ANIMAL HEADER (category-btn) 스타일 */
.category-btn {
    background-color: #8b5e3c;
    color: #fff;
    font-weight: 700;
    font-size: 14px;
    padding: 6px 14px;
    border-radius: 12px;
    margin: 4px;
    text-decoration: none;
    display: inline-block;
    transition: all 0.2s ease;
    white-space: nowrap;
}
.category-btn:hover {
    background-color: #a4724d;
    transform: translateY(-2px);
}

/* 전체보기 버튼 스타일 오버라이드 */
.category-row.main-category .category-btn {
    background-color: #a4724d;
    padding: 8px 20px;
    border-radius: 15px;
}
.category-row.main-category .category-btn.active {
    background-color: #7e5a3c;
}

/* ANIMAL/CATEGORY 활성화 상태 */
.category-btn.active {
    background-color: #5d3d26;
    border: 2px solid #c7a17a;
    transform: scale(1.05);
}


/* TYPE HEADER (type-btn) 스타일 */
.type-btn {
    background-color: #f7f3ed;
    color: #8b5e3c;
    font-weight: 500;
    font-size: 13px;
    padding: 4px 10px;
    border: 1px solid #c7a17a;
    border-radius: 10px;
    margin: 4px;
    text-decoration: none;
    display: inline-block;
    white-space: nowrap;
    transition: all 0.2s ease;
}
.type-btn:hover {
    background-color: #e0d0c0;
    transform: translateY(-1px);
}
.type-btn.type-active {
    background-color: #c7a17a;
    color: #fff;
    font-weight: 700;
    border: 1px solid #8b5e3c;
    transform: scale(1.05);
}
</style>

	<div class="container w-800">

	    <div class="cell center page-header-area">
	        <h1>${category.categoryName}</h1>
	        <form action="list" class="search-form-top">
	            <div class="search-bar">
	                <select name="column">
	                    <option value="board_title" ${pageVO.column == 'board_title' ? 'selected' : ''}>제목</option>
	                    <option value="board_writer" ${pageVO.column == 'board_writer' ? 'selected' : ''}>아이디</option>
	                    <option value="member_nickname" ${pageVO.column == 'member_nickname' ? 'selected' : ''}>닉네임</option>
	                    <option value="header_name" ${pageVO.column == 'header_name' ? 'selected' : ''}>분류</option>
	                </select>
	                <input type="text" name="keyword" value="${pageVO.keyword}" required placeholder="검색어 입력">
	                <button type="submit" class="btn btn-positive">검색</button>
	            </div>
	        </form>
	    </div>

	    <div class="category-section">
	        <div class="category-row main-category">
	            <a href="list?animalHeaderNo=0&typeHeaderNo=0"
	               class="category-btn ${selectedAnimalHeader == 0 && selectedTypeHeader == 0 ? 'active' : ''}">
	                전체보기
	            </a>
	        </div>

	        <div class="category-row">
	            <span class="group-title">동물 분류</span>
	            <span class="header-group animal-group">
	                <c:forEach var="animal" items="${animalList}" varStatus="st" begin="1">
	                    <a href="list?animalHeaderNo=${animal.animalHeaderNo}&typeHeaderNo=${selectedTypeHeader}"
	                        class="category-btn ${selectedAnimalHeader == animal.animalHeaderNo ? 'active' : ''}">
	                        ${st.count}. ${animal.animalHeaderName}
	                    </a>
	                </c:forEach>
	            </span>
	        </div>
	        
	        <div class="category-row">
	            <span class="group-title">게시판 타입</span>
	            <span class="header-group type-group">
	                <c:forEach var="type" items="${typeList}" varStatus="typeSt" begin="1">
	                    <a href="list?animalHeaderNo=${selectedAnimalHeader}&typeHeaderNo=${type.typeHeaderNo}"
	                        class="type-btn ${selectedTypeHeader == type.typeHeaderNo ? 'type-active' : ''}">
	                        ${typeSt.count}. ${type.typeHeaderName}
	                    </a>
	                </c:forEach>
	            </span>
	        </div>
	    </div>


		<div class="cell right write-button-area">
		        <c:choose>
		            <c:when test="${sessionScope.loginId != null}">
		                <a href="write" class="btn btn-positive">글쓰기</a>
		            </c:when>
		            <c:otherwise>
		                <p><a href="/member/login">로그인</a>을 해야 글을 작성할 수 있습니다</p>
		            </c:otherwise>
		        </c:choose>
		    </div>


		    <c:choose>
		        <c:when test="${empty boardList}">
		            <div class="no-posts">등록된 글이 없습니다.</div>
		        </c:when>
		        <c:otherwise>
		            <div class="cell">
		                <table>
		                    <thead>
		                        <tr>
		                            <th>No</th>
		                            <th>분류</th>
		                            <th>동물종류</th>
		                            <th>제목</th>
		                            <th>작성자</th>
		                            <th>조회수</th>
		                            <th>추천수</th>
		                        </tr>
		                    </thead>
		                    <tbody>
		                        <c:forEach var="boardDto" items="${boardList}">
		                            <tr>
		                                <td>${boardDto.boardNo}</td>
		                                <td>${headerMap[boardDto.boardNo].typeHeaderName}</td>
		                                <td>${animalMap[boardDto.boardNo].animalHeaderName}</td>
		                                <td><a href="detail?boardNo=${boardDto.boardNo}">${boardDto.boardTitle}</a></td>
		                                <td>${boardDto.boardWriter}</td>
		                                <td>${boardDto.boardView}</td>
		                                <td>${boardDto.boardLike}</td>
		                            </tr>
		                        </c:forEach>
		                    </tbody>
		                    <tfoot>
		                        <tr>
		                            <td colspan="7">검색결과 : ${pageVO.begin} - ${pageVO.end} /
		                                ${pageVO.dataCount}개</td>
		                        </tr>
		                        <tr>
		                            <td colspan="7" style="text-align: center;"><jsp:include
		                                    page="/WEB-INF/views/template/pagination.jsp"></jsp:include></td>
		                        </tr>
		                    </tfoot>
		                </table>
		            </div>
		        </c:otherwise>
		    </c:choose>
	

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>