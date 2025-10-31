<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- <link rel="stylesheet" type="text/css" href="/css/commons.css"> --%> <%-- 이 부분은 header.jsp에서 이미 로드하고 있으므로 제거했습니다. --%>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<style>
/* -------------------- 수정된 스타일: .container.w-800 대신 .list-page-wrapper 사용 -------------------- */
body { background-color: #f4ede6; color: #5b3a29; margin: 0; padding: 0; }
.list-page-wrapper {
	max-width: 800px; 
	margin: 40px auto; 
	padding: 30px 35px;
	border-radius: 15px; 
	background-color: #ffffffdd;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
	/* header.jsp의 flex-box 안에 들어가 중앙 정렬되도록 margin: 0 auto를 유지합니다. */
}
h1 { font-size: 2.4rem; font-weight: 700; margin-bottom: 25px; text-align: center; }
table { width: 100%; border-collapse: collapse; font-size: 1.05rem; }
table thead { background-color: #e9d8c6; }
table th, table td { padding: 14px 12px; border-bottom: 1px solid #d3bfa6; text-align: center; }
table tr:hover { background-color: #f3eae1; }
a { color: #5b3a29; text-decoration: none; }
a:hover { text-decoration: underline; }
.btn.btn-positive {
	background-color: #7e5a3c; color: #f9f6f1; border: none; padding: 10px 20px;
	font-size: 1rem; font-weight: 700; border-radius: 10px; cursor: pointer;
	text-decoration: none; display: inline-block;
}
.btn.btn-positive:hover { background-color: #a67849; }
.cell.right { text-align: right; }
.no-posts { text-align: center; padding: 40px 0; color: #8c6d5b; }

/* 카테고리 섹션 */
.category-section { border: 1px solid #d3bfa6; border-radius: 10px; padding: 10px; background-color: #fff; }
.category-row { display: flex; align-items: center; margin-bottom: 8px; border-bottom: 1px dashed #e0d0c0; }
.category-row:last-child { border-bottom: none; }
.group-title { font-weight: 700; color: #5b3a29; margin-right: 15px; min-width: 80px; text-align: right; }
.header-group { display: flex; flex-wrap: nowrap; overflow-x: auto; padding: 0 5px; }
.category-btn, .type-btn { text-decoration: none; white-space: nowrap; margin: 4px; transition: 0.2s; }

/* 버튼 색상 */
.category-btn { background-color: #8b5e3c; color: #fff; font-weight: 700; font-size: 14px; padding: 6px 14px; border-radius: 12px; }
.category-btn:hover { background-color: #a4724d; }
.category-btn.active { background-color: #5d3d26; border: 2px solid #c7a17a; }
.type-btn { background-color: #f7f3ed; color: #8b5e3c; border: 1px solid #c7a17a; border-radius: 10px; padding: 4px 10px; }
.type-btn:hover { background-color: #e0d0c0; }
.type-btn.type-active { background-color: #c7a17a; color: #fff; border: 1px solid #8b5e3c; }
</style>


<div class="list-page-wrapper"> <%-- 클래스명 변경: w-1200 컨테이너와의 충돌을 피합니다. --%>
	<div class="page-header-area">
		    <h1>${category.categoryName}</h1>

		    <form action="list" method="get" class="search-form-top">
		        <div class="search-bar">
		            <select name="column">
		                <option value="board_title" <c:if test="${pageVO.column eq 'board_title'}">selected</c:if>>제목</option>
		                <option value="board_writer" <c:if test="${pageVO.column eq 'board_writer'}">selected</c:if>>아이디</option>
		                <option value="member_nickname" <c:if test="${pageVO.column eq 'member_nickname'}">selected</c:if>>닉네임</option>
		                <option value="header_name" <c:if test="${pageVO.column eq 'header_name'}">selected</c:if>>분류</option>
		                
		                <option value="animal_header_name" <c:if test="${pageVO.column eq 'animal_header_name'}">selected</c:if>>동물 분류명</option>
		                <option value="type_header_name" <c:if test="${pageVO.column eq 'type_header_name'}">selected</c:if>>게시판 타입명</option>
		            </select>
		            <input type="text" name="keyword" value="${pageVO.keyword != null ? pageVO.keyword : ''}" placeholder="검색어 입력">
		            <button type="submit" class="btn btn-positive">검색</button>
		        </div>
		        <%-- 검색 폼 제출 시 기존 필터링 값도 유지하기 위해 hidden 필드 추가 --%>
		        <c:if test="${selectedAnimalHeaderName != null}">
		            <input type="hidden" name="animalHeaderName" value="${selectedAnimalHeaderName}">
		        </c:if>
		        <c:if test="${selectedTypeHeaderName != null}">
		            <input type="hidden" name="typeHeaderName" value="${selectedTypeHeaderName}">
		        </c:if>
		    </form>
		</div>

	<div class="category-section">

	    <div class="category-row" style="justify-content:center; border-bottom:2px solid #d3bfa6; padding-bottom:10px;">
	        <a href="list?animalHeaderName=&typeHeaderName=&begin=1"
	           class="category-btn <c:if test='${empty selectedAnimalHeaderName and empty selectedTypeHeaderName}'>active</c:if>'">
	            전체보기
	        </a>
	    </div>

		<div class="category-row">
			        <span class="group-title">동물 분류</span>
			        <span class="header-group">
			        	<%-- '동물 분류 전체' 버튼 --%>
			            <a href="list?animalHeaderName=&typeHeaderName=${selectedTypeHeaderName != null ? selectedTypeHeaderName : ''}"
		                   class="category-btn <c:if test='${empty selectedAnimalHeaderName}'>active</c:if>">
		                    전체
		                </a>
			            <c:forEach var="animal" items="${animalList}">
			                <a href="list?animalHeaderName=${animal.headerName}&typeHeaderName=${selectedTypeHeaderName != null ? selectedTypeHeaderName : ''}"
			                   class="category-btn <c:if test='${selectedAnimalHeaderName eq animal.headerName}'>active</c:if>">
			                    ${animal.headerName}
			                </a>
			            </c:forEach>
			        </span>
			    </div>

			    <div class="category-row">
			        <span class="group-title">게시판 타입</span>
			        <span class="header-group">
			        	<%-- '게시판 타입 전체' 버튼 --%>
			            <a href="list?animalHeaderName=${selectedAnimalHeaderName != null ? selectedAnimalHeaderName : ''}&typeHeaderName="
		                   class="type-btn <c:if test='${empty selectedTypeHeaderName}'>type-active</c:if>">
		                    전체
		                </a>
			            <c:forEach var="type" items="${typeList}">
			                <a href="list?animalHeaderName=${selectedAnimalHeaderName != null ? selectedAnimalHeaderName : ''}&typeHeaderName=${type.headerName}"
			                   class="type-btn <c:if test='${selectedTypeHeaderName eq type.headerName}'>type-active</c:if>">
			                    ${type.headerName}
			                </a>
			            </c:forEach>
			        </span>
			    </div>
	</div> <%-- .category-section 닫힘 --%>
	
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
	                        <td>${boardDto.typeHeaderName}</td>
	                        <td>${boardDto.animalHeaderName}</td>
	                        <td>
	                            <a href="detail?boardNo=${boardDto.boardNo}">
	                                ${boardDto.boardTitle}
	                            </a>
	                        </td>
	                        <td>${boardDto.boardWriter}</td>
	                        <td>${boardDto.boardView}</td>
	                        <td>${boardDto.boardLike}</td>
	                    </tr>
	                </c:forEach>
	            </tbody>
	            <tfoot>
	                <tr>
	                    <td colspan="7">검색결과 : ${pageVO.begin} - ${pageVO.end} / ${pageVO.dataCount}개</td>
	                </tr>
	                <tr>
	                    <td colspan="7" style="text-align:center;">
	                        <jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
	                    </td>
	                </tr>
	            </tfoot>
	        </table>
	    </c:otherwise>
	</c:choose>

</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>