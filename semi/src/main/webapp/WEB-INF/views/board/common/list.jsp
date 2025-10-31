<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<link rel="stylesheet" type="text/css" href="/css/commons.css">
<link rel="stylesheet" type="text/css" href="/css/board_list.css">
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>


<div class="container w-800">

	<div class="cell center">
		<h1>${category.categoryName}</h1>
	</div>
	<div class="cell center mt-30 mb-50">
		<form action="list">
			<div class="search-bar">
				<select name="column">
					<option value="board_title">${pageVO.column == 'board_title' ? 'selected' : ''}제목</option>
					<option value="board_writer">${pageVO.column == 'board_writer' ? 'selected' : ''}아이디</option>
					<option value="member_nickname">${pageVO.column == 'member_nickname' ? 'selected' : ''}닉네임</option>
					<option value="header_name">${pageVO.column == 'header_name' ? 'selected' : ''}분류</option>

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
						<a href="write" class="btn btn-positive">글쓰기</a>
					</h3>
				</c:when>
				<c:otherwise>
					<h3>
						<a href="/member/login">로그인</a>을 해야 글을 작성할 수 있습니다
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
							<th><i id="board-like" class="fa-solid	 fa-thumbs-up"
								style="font-size: 1.8rem; color: #a67c52;"></i></th>
							<th>작성일</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="boardDto" items="${boardList}">
							<tr>
								<td>${boardDto.boardNo}</td>
								<td>${boardDto.typeHeaderName}</td>
								<td style="text-align: center;"><a
									href="detail?boardNo=${boardDto.boardNo}">${boardDto.boardTitle}</a>
								</td>
								<td>${boardDto.memberNickname}
								<c:if test="${not empty boardDto.badgeImage}">${boardDto.badgeImage}</c:if> 
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