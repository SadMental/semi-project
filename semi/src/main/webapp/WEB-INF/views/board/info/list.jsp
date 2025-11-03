<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<link rel="stylesheet" type="text/css" href="/css/commons.css">

<style>

/* 검색 바 */
.search-bar {
	display: flex;
	justify-content: center;
	align-items: center;
	gap: 10px;
	background-color: #f7f9fa;
	border: 1px solid #d3e3e7;
	border-radius: 12px;
	padding: 12px 20px;
	box-shadow: 0 3px 10px rgba(0, 0, 0, 0.04);
}

.search-bar select, .search-bar input {
	padding: 8px 10px;
	border: 1px solid #b7d0d6;
	border-radius: 8px;
	font-size: 0.95rem;
}

.search-bar input {
	width: 220px;
}

.cell.right {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-top: 25px;
	flex-wrap: wrap;
}

.cell.right a {
	color: #598d96;
	font-weight: 600;
	margin: 0 6px;
	transition: color 0.2s ease, background-color 0.2s ease;
	border-radius: 6px;
	padding: 4px 8px;
}

.cell.right a:hover {
	background-color: #e9f0f2;
	color: #36616a;
}

.cell.right a.active {
	background-color: #6ca3ae;
	color: #fffbf5;
}


.cell.right h3 {
	font-size: 0.95rem;
	color: #5b3a29;
	margin-top: 10px;
}

table {
	width: 100%;
	border-collapse: collapse;
	font-size: 1rem;
	margin-top: 25px;
	border-radius: 12px;
	overflow: hidden;
	box-shadow: 0 3px 10px rgba(0, 0, 0, 0.05);
}

table thead {
	background-color: #e9d8c6;
	color: #5b3a29;
	font-weight: 600;
}

table th, table td {
	padding: 14px 12px;
	border-bottom: 1px solid #d3bfa6;
	text-align: center;
}

table tbody tr:hover {
	background-color: #f3eae1;
	transition: background-color 0.2s ease;
}

table a {
	color: #5b3a29;
	font-weight: 600;
	text-decoration: none;
}

table a:hover {
	color: #598d96;
	text-decoration: underline;
}

.no-posts {
	text-align: center;
	padding: 45px 0;
	color: #7b5a3a;
	background-color: #faf8f5;
	border-radius: 12px;
	border: 1px solid #e0d1bc;
	margin-top: 30px;
}

tfoot td {
	font-size: 0.95rem;
	color: #5b3a29;
	background-color: #f7f9fa;
	padding: 12px 8px;
	border-top: 2px solid #6ca3ae;
}

tfoot td a {
	color: #598d96;
	font-weight: 600;
	text-decoration: none;
}

tfoot td a:hover {
	color: #fffbf5;
	background-color: #598d96;
	padding: 2px 6px;
	border-radius: 6px;
	transition: all 0.2s ease;
}
</style>

<div class="container w-800">

	<div class="cell center">
		<h1>${category.categoryName}</h1>
	</div>

	<div class="cell center mt-30 mb-50">
		<form action="list">
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

		<div class="cell right">
			<div class="cell">
				<a href="list?orderBy=wtime"
					class="${orderBy eq 'wtime' ? 'active' : ''}">최신순</a> | <a
					href="list?orderBy=view"
					class="${orderBy eq 'view' ? 'active' : ''}">조회순</a> | <a
					href="list?orderBy=like"
					class="${orderBy eq 'like' ? 'active' : ''}">추천순</a>
			</div>

			<c:choose>
				<c:when test="${sessionScope.loginId != null}">
					<h3>
						<a href="write" class="btn btn-neutral"> <i
							class="fa-solid fa-pen-to-square"></i> 글쓰기
						</a>
					</h3>

				</c:when>
				<c:otherwise>
					<h3>
						<a href="/member/login" style="color: #598d96;">로그인</a>을 해야 글을 작성할
						수 있습니다
					</h3>
				</c:otherwise>
			</c:choose>
		</div>
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
							<th>제목</th>
							<th>작성자</th>
							<th>조회수</th>
							<th><i id="board-like" class="fa-solid fa-thumbs-up"
								style="font-size: 1.3rem; color: #a67c52;"></i></th>
							<th>작성일</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="boardDto" items="${boardList}">
							<tr>
								<td>${boardDto.boardNo}</td>
								<td>${boardDto.typeHeaderName}</td>
								<td><a href="detail?boardNo=${boardDto.boardNo}">${boardDto.boardTitle}</a></td>
								<td>${boardDto.memberNickname} <c:if
										test="${not empty boardDto.badgeImage}">${boardDto.badgeImage}</c:if>
									<c:if test="${not empty boardDto.levelName}">
										<span class="level-badge">${boardDto.levelName}</span>
									</c:if>
								</td>
								<td>${boardDto.boardView}</td>
								<td>${boardDto.boardLike}</td>
								<td>${boardDto.formattedWtime}</td>
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
