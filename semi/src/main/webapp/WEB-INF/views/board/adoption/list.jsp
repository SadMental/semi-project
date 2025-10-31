<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<link rel="stylesheet" type="text/css" href="/css/commons.css">
<link rel="stylesheet" type="text/css" href="/css/board_list.css">
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>


<div class="container w-800">

	<div class="cell center page-header-area">
		<h1>${category.categoryName}</h1>
		<form action="list" class="search-form-top">
			<div class="search-bar">
				<select name="column">
					<option value="board_title"
						${pageVO.column == 'board_title' ? 'selected' : ''}>제목</option>
					<option value="board_writer"
						${pageVO.column == 'board_writer' ? 'selected' : ''}>아이디</option>
					<option value="member_nickname"
						${pageVO.column == 'member_nickname' ? 'selected' : ''}>닉네임</option>
					<option value="header_name"
						${pageVO.column == 'header_name' ? 'selected' : ''}>분류</option>
				</select> <input type="text" name="keyword" value="${pageVO.keyword}"
					required placeholder="검색어 입력">
				<button type="submit" class="btn btn-positive">검색</button>
			</div>
		</form>
	</div>

	<div class="category-section">
		<div class="category-row main-category">
			<a href="list?animalHeaderNo=0&typeHeaderNo=0"
				class="category-btn ${selectedAnimalHeader == 0 && selectedTypeHeader == 0 ? 'active' : ''}">
				전체보기 </a>
		</div>

		<div class="category-row">
			<span class="group-title">동물 분류</span> <span
				class="header-group animal-group"> <c:forEach var="animal"
					items="${animalList}" varStatus="st" begin="1">
					<a
						href="list?animalHeaderNo=${animal.headerNo}&typeHeaderNo=${selectedTypeHeader}"
						class="category-btn ${selectedAnimalHeader == animal.headerNo ? 'active' : ''}">
						${st.count}. ${animal.headerName} </a>
				</c:forEach>
			</span>
		</div>

		<div class="category-row">
			<span class="group-title">게시판 타입</span> <span
				class="header-group type-group"> <c:forEach var="type"
					items="${typeList}" varStatus="typeSt" begin="1">
					<a
						href="list?animalHeaderNo=${selectedAnimalHeader}&typeHeaderNo=${type.headerNo}"
						class="type-btn ${selectedTypeHeader == type.headerNo ? 'type-active' : ''}">
						${typeSt.count}. ${type.headerName} </a>
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
				<p>
					<a href="/member/login">로그인</a>을 해야 글을 작성할 수 있습니다
				</p>
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
								<td>${boardDto.typeHeaderName}</td>
								<td>${boardDto.animalHeaderName}</td>
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
</div>

	<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>