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
.btn-edit {
  background-color: #a67c52;
  color: #fff5e9;
  border: none;
}

.btn-edit:hover {
  background-color: #ba8f65;
}

.btn-delete {
  background-color: #a94442;
  color: #fff2f0;
  border: none;
}

.btn-delete:hover {
  background-color: #922d2b;
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
	<h1>${mailDto.mailTitle}</h1>

	<div class="meta">
		<table>
			<%-- <tr>
				<th>[번호] : </th>
				<td>${mailDto.mailNo}</td>
			</tr> --%>
			<tr>
				<th>[작성자] :</th>
				<td>${mailDto.senderNickname}</td>
			</tr>
		</table>
	</div>

	<div class="content">
		<c:out value="${mailDto.mailContent}" escapeXml="false" />
	</div>

	<div class="cell right">
		<a href="list/receive" class="btn btn-neutral">목록으로</a>

		<form method="post" action="delete"
      onsubmit="return confirm('정말 삭제하시겠습니까?');"
      style="display:inline;">

			<input type="hidden" name="mailNo" value="${mailDto.mailNo}">
			<button type="submit" class="btn btn-delete">삭제하기</button>
		</form>
	</div>
</div>


<jsp:include page="/WEB-INF/views/template/footer.jsp" />