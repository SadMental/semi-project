<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

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
	font-size: 2.8rem;
	font-weight: 700;
	margin-bottom: 25px;
	text-align: center;
}

table {
	width: 100%;
	border-collapse: collapse;
	font-size: 1.05rem;
}

table thead {
	background-color: #e9d8c6;
}

table th, table td {
	padding: 14px 12px;
	border-bottom: 1px solid #d3bfa6;
	text-align: center;
}

table tr:hover {
	background-color: #f3eae1;
}

a {
	color: #5b3a29;
	text-decoration: none;
}

a:hover {
	text-decoration: underline;
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
}

.btn.btn-positive:hover {
	background-color: #a67849;
}

.cell.right {
	text-align: right;
}

.no-posts {
	text-align: center;
	padding: 40px 0;
	color: #8c6d5b;
}

.mb-20 {
	margin-bottom: 20px;
}
</style>

<div class="container w-800">
	<div class="cell center">
		<h2>우편함</h2>
	</div>
	<div class="cell right">
		<a class="btn btn-positive" href="/mail/send">우편 보내기</a>
	</div>
	<div class="cell flex-box">
		<a class="btn btn-neutral w-50p" href="send">보낸 우편함</a> <a
			class="btn btn-neutral w-50p" href="receive">받은 우편함</a>
	</div>

	<div class="cell">
		<c:choose>
			<c:when test="${empty mailList}">
				<div class="no-posts">
					<c:choose>
						<c:when test="${type == 'send'}">보낸 우편이 없습니다.</c:when>
						<c:otherwise>받은 우편이 없습니다.</c:otherwise>
					</c:choose>
				</div>
			</c:when>

			<c:otherwise>
				<div class="cell">
					<table>
						<thead>
							<tr>
								<th>제목</th>
								<c:choose>
									<c:when test="${type == 'send'}">
										<th>받은이</th>
										<th>보낸 일자</th>
									</c:when>
									<c:otherwise>
										<th>보낸이</th>
										<th>받은 일자</th>
									</c:otherwise>
								</c:choose>
							</tr>
						</thead>

						<tbody>
							<c:forEach var="mailDto" items="${mailList}">
								<tr>
									<td style="text-align: center;"><a
										href="/mail/detail?mailNo=${mailDto.mailNo}">
											${mailDto.mailTitle} </a></td>

									<c:choose>
										<c:when test="${type == 'send'}">
											<td>${mailDto.targetNickname}</td>
										</c:when>
										<c:otherwise>
											<td>${mailDto.senderNickname}</td>
										</c:otherwise>
									</c:choose>

									<td>${mailDto.mailWtime}</td>
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
										page="/WEB-INF/views/template/pagination.jsp" /></td>
							</tr>
						</tfoot>
					</table>
				</div>
			</c:otherwise>
		</c:choose>
	</div>
</div>


<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>