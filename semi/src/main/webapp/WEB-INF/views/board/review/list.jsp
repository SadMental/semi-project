<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>


<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<link rel="stylesheet" type="text/css" href="/css/board_list.css">

<style>
	
	.score-badge {
/*          position: absolute; */
		right: 8px;
/*         background-color: #fdcb6e; */
/*         color: white; */
/*         font-size: 14px; */
/*         border: 1px solid #2d3436; */
/*         border-radius: 10px; */
/*         padding: 4px 8px; */
/*         display: flex; */
/*         align-items: center; */
/*         gap: 4px; */
		background-color: #fdcb6e;
		border: 1px solid #2d3436;
		border-radius: 11px;
		padding: 0 0.25em;
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
						    <c:forEach var="boardDto" items="${boardList}" varStatus="st">
						        <tr>
							        <td>
							        	<a href="detail?boardNo=${boardDto.boardNo}">
							        		<div class="cell flex-box w-100p">
							        			<img src="/board/review/image?boardNo=${boardDto.boardNo}" style="width:100px;">
							        			<div class="review-container">
							        				<div class="top-container flex-box w-600">
							        					<div class="flex-box">
														   <div class="badge me-10">${boardDto.animalHeaderName}</div>
														   <div class="badge me-10">${boardDto.typeHeaderName}</div>
														</div>
							        					<label>${boardDto.boardTitle}</label>
							        					<label class="red">[${boardDto.boardReply}]</label>
							        				</div>
							        				<div class="bottom-container flex-box w-400">
							        					<img src="/member/profile?member_id=" + boadrDto.boardWriter" style="width:33px;">
							        					<label style="font-size:0.8em;" class="ms-10 me-10">${boardDto.boardWriter}</label> 
							        					<fmt:formatDate value="${boardDto.boardWtime}" pattern="MM-dd"/> 
							        					<i class="fa fa-eye ms-10"></i> ${boardDto.boardView} 
							        					<i class="fa fa-heart red ms-10"></i> ${boardDto.boardLike}
							        					<div class="score-badge">						        					
								        					<i class="fa-solid fa-star"></i> ${boardDto.boardScore}
							        					</div>
							        				</div>
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
