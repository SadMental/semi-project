<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header.jsp" />

<style>
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
	font-size: 2rem;
	font-weight: 700;
	margin-bottom: 15px;
}

.meta {
	font-size: 0.95rem;
	color: #7a5a44;
	margin-bottom: 20px;
}

.content {
	font-size: 1.1rem;
	line-height: 1.6;
	min-height: 200px;
	border-top: 1px solid #d6c2a6;
	padding-top: 20px;
}

.cell.right {
	text-align: right;
	margin-top: 30px;
}

.btn {
	padding: 10px 20px;
	font-size: 1rem;
	border-radius: 10px;
	font-weight: 600;
	text-decoration: none;
	display: inline-block;
	margin-right: 10px;
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

.btn-positive:hover {
	background-color: #a67849;
}

.btn-neutral {
	background-color: #d9c7b3;
	color: #5b3a29;
	border: none;
}

.btn-neutral:hover {
	background-color: #cbb7a3;
}
</style>

<div class="container w-800">
	<h1>${boardDto.boardTitle}</h1>

	<div class="meta">
	<table>
		<tr>
			<th>번호</th>
			<td>${boardDto.boardNo}</td>
		</tr>
		<tr>
			<th>제목</th>
			<td>${boardDto.boardTitle}</td>
		</tr>
		<tr>
			<th>작성자</th>
			<td>${boardDto.boardWriter}</td>
		</tr>
	</table>
	</div>

	<div class="content">
		<c:out value="${boardDto.boardContent}" escapeXml="false" />
	</div>

	<div class="cell right">
		<a href="list" class="btn btn-neutral">목록으로</a> <a
			href="edit?boardNo=${boardDto.boardNo}" class="btn btn-positive">수정하기</a>
		<a href="delete?boardNo=${boardDto.boardNo}" class="btn btn-neutral"
			onclick="return confirm('정말 삭제하시겠습니까?');">삭제하기</a>
	</div>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp" />
