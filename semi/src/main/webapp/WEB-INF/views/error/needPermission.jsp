<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>페이지를 찾을 수 없습니다</title>
<style>
body {
	background-color: #f4ede6;
	color: #5b3a29;
	font-family: '나눔고딕', 'Malgun Gothic', sans-serif;
	display: flex;
	justify-content: center;
	align-items: center;
	height: 100vh;
	margin: 0;
}

.container {
	background-color: #ffffffdd;
	padding: 50px 60px;
	border-radius: 15px;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
	max-width: 700px;
	width: 90%;
	text-align: center; /* 중앙 정렬 핵심 */
}

h2 {
	font-size: 2.2rem;
	margin-bottom: 15px;
	color: #a67c42;
}

p {
	font-size: 1.2rem;
	margin-bottom: 30px;
	color: #7a5a44;
}

img {
	width: 400px;
	margin: 20px auto 40px auto;
	display: block; /* 중앙 정렬 */
}

a.btn-home {
	text-decoration: none;
	background-color: #a67c42;
	color: #fff5e9;
	padding: 12px 30px;
	border-radius: 10px;
	font-weight: 600;
	font-size: 1rem;
	transition: background-color 0.3s ease;
	display: inline-block;
	margin: 0 auto;
}

a.btn-home:hover {
	background-color: #ba8f65;
}
</style>
</head>
<body>
	<div class="container">
		<p>
			요청하신 페이지가 존재하지 않거나<br>삭제되었을 수 있습니다.
		</p>

		<img src="/image/error/notfound.png"> <a
			href="<c:url value='/' />" class="btn-home">홈으로 돌아가기</a>
	</div>
</body>
</html>
