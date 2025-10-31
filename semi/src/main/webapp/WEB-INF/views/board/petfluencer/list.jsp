<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<link rel="stylesheet" type="text/css" href="/css/commons.css">
<link rel="stylesheet" type="text/css" href="/css/board_list.css">

<div class="container w-800">

	<div class="cell center">
		<h1>펫플루언서</h1>	
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
						        <c:if test="${st.index % 3 == 0}">
						            <tr>
						        </c:if>
						
						        <td>
						        	<a href="detail?boardNo=${boardDto.boardNo}">
						        		<div class="cell card">
									        <img src="/board/petfluencer/image?boardNo=${boardDto.boardNo}">
									        <button class="overlay-btn"><i class="fa fa-camera"></i></button>
									        <div class="like-badge"><i class="fa fa-heart"></i> ${boardDto.boardLike}</div>
									        <div class="card-container">
									            <div class="card-title">${boardDto.boardTitle}</div>
									            <div class="card-info">
									                <i class="fa fa-eye"></i> ${boardDto.boardView}
									                <i class="fa fa-comment"></i> ${boardDto.boardReply}
									            </div>
									        </div>
									    </div>
						        	</a>
						        </td>
						
						        <c:if test="${st.index % 3 == 2}">
						            </tr>
						        </c:if>
						    </c:forEach>
						
						    <c:if test="${numbers.size() % 3 != 0}">
						        </tr>
						    </c:if>
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
