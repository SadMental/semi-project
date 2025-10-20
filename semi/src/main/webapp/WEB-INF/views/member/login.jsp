<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<form action="login" method="post">
	<input type="text" name="memberId">아이디 <br><br>
	<input type="password" name="memberPw">비밀번호
	<button type="submit">로그인</button>
</form>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>