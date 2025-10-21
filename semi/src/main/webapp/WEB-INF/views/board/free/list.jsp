<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>
=======
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<div class = "container w-900">
    <div class = "cell mb-30 center">
        <h1>자유게시판</h1>
    </div>
	
	<div class = "cell right">
	    <a href = "write" class = "btn me-10  btn-neutral">새글 작성</a>
	</div>

<c:if test="${not empty boardList}">
    <div class = "cell">
        <table class = "table w-100p center">
            <thead>
                <tr>
                    <th>No</th>
                    <th>제목</th>
                    <th>작성자</th>
                    <th>조회수</th>
                    <th><i class="fa-solid fa-heart red"></i></th>
                </tr>
            </thead>

            <tbody>
				<c:forEach var="boardDto" items="${boardList}">
					<tr>
						<td>${boardDto.boardNo}</td>
						<td><a href="detail?boardNo=${boardDto.boardNo}">${boardDto.boardTitle}</a></td>
						<td>${boardDto.boardWriter}</td>
						<td>${boardDto.boardView}</td>
						<td>${boardDto.boardLike}</td>
					</tr>
				</c:forEach>
            </tbody>
        </table>
    </div>
</c:if>
        <div class = "cell right">
	    	<a href = "write" class = "btn me-10  btn-neutral">새글 작성</a>
		</div>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>
