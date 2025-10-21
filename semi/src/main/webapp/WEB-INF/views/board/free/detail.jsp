<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>



<h1>
	${boardDto.boardTitle} 
	<c:if test="${boardDto.boardEtime != null}">
	(수정됨)
	</c:if>
</h1>
<div>
<%-- 	${boardDto.boardWriter == null ? '탈퇴한사용자' : boardDto.boardWriter} --%>

	<c:choose>
		<c:when test="${memberDto == null}">탈퇴한사용자</c:when>
		<c:otherwise>
			<a href="/member/detail?memberId=${memberDto.memberId}">
				${memberDto.memberNickname}
			</a>  
<%-- 			(${memberDto.memberLevel}) --%>
		</c:otherwise>
	</c:choose>
</div>
<div>
	<fmt:formatDate value="${boardDto.boardWtime}" pattern="yyyy-MM-dd HH:mm"/> 
	조회수 ${boardDto.boardView}
</div>
<hr>
<div style="min-height: 200px">
	<pre>${boardDto.boardContent}</pre>
</div>
<hr>
<div>
	좋아요 <i id="board-like" class="fa-regular fa-heart red"></i> 
	<span id="board-like-count">?</span>  
<%-- 	댓글 ${boardDto.boardReply} --%>
</div>

<!-- 댓글 영역 -->
<div class = "reply-list-wrapper">목록 영역</div>
<div class = "reply-write-wrapper">
	<textarea class="field w-100 mt-50 reply-input" rows=4 style="resize:none" placeholder="댓글"></textarea>
	<div class="cell right">
		<button type="button" class="btn btn-positive reply-btn-write">
			<span>댓글 작성</span>
		</button>
	</div>
</div>

<hr>
<div>
	<c:if test="${sessionScope.loginId != null}">
		<c:choose>
			<c:when test="${sessionScope.loginId == boardDto.boardWriter}">
				<a href="update?boardNo=${boardDto.boardNo}">수정</a> 
				<a href="delete?boardNo=${boardDto.boardNo}">삭제</a>
			</c:when>
			<c:when test="${sessionScope.loginLevel == 2}">
				<a href="delete?boardNo=${boardDto.boardNo}">삭제</a>
			</c:when>
		</c:choose>
	</c:if>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>
