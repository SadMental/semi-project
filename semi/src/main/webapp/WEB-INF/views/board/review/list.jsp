<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<link rel="stylesheet" type="text/css" href="/css/board_list.css">

<style>
	.score-badge {		
		display: flex;
		align-items: center;    /* 세로 가운데 */
		height: inherit;          /* 부모 높이가 있어야 중앙 기준이 생김 */	
		background-color: #F35F4C;
		border: 1px solid #2d3436;
		color:white;
		border-radius: 10px;
		padding: 0 0.25em;
		margin-left: auto;
    }
</style>

<div class="container w-800">

	<div class="cell center">
		<h1>사용후기</h1>	
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
							<th></th>
						</tr>
					</thead>
					<tbody>						
						<table border="1">
						    <c:forEach var="boardDetailVO" items="${boardList}" varStatus="st">
						        <tr>
							        <td>
							        	<a href="detail?boardNo=${boardDetailVO.boardNo}">
							        		<div class="cell flex-box">
										        <img src="/board/review/image?boardNo=${boardDetailVO.boardNo}" class="left" style="width:60px; height:60px;">
										        <div class="animal-container">
										        	<div class="top-container flex-box">										        		
														 <div class="badge me-10">${boardDetailVO.animalHeaderName}</div>
														 <div class="badge me-10">${boardDetailVO.typeHeaderName}</div>
										        		 <div class="review-title">${boardDetailVO.boardTitle}</div>
										        		 <div class="review-reply red">[${boardDetailVO.boardReply}]</div>
										        	</div>
										        	<div class="bottom-container flex-box">
										        		<img src="/member/profile?member_id=${boardDetailVO.boardWriter}" width="24px;" height="24px;">
										        		<div class="ms-10 review-writer">[${boardDetailVO.memberNickname}]</div>
										        		<div class="ms-10 review-wtime">${boardDetailVO.formattedWtime}</div>
										        		<i class="ms-10 fa fa-eye"></i> ${boardDetailVO.boardView}
										                <i class="ms-10 fa-regular fa-heart"></i> ${boardDetailVO.boardLike}
										        	</div>
										        </div>
										        <div class="score-badge">						        					
								        			<i class="fa-solid fa-star"></i> ${boardDetailVO.boardScore}
							        			</div>
									    	</div>
							        	</a>
							        </td>
						        </tr>
						    </c:forEach>
						</table>
					</tbody>
					<tfoot>
						<tr>
							<td colspan="7">
								검색결과 : 
								${pageVO.begin} - ${pageVO.end}
								/
								${pageVO.dataCount}개
							</td>
						</tr>
						
						<tr>
					        <td colspan="7" style="text-align: center;">
					            <jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
					        </td>
					    </tr>
					</tfoot>
				</table>
			</div>
		</c:otherwise>
	</c:choose>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>
