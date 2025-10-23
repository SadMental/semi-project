<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<div class="container w-600">
	<form action="login" method="post">
		<div class="cell">
			<label>아이디</label>
			<input class="field w-100p" type="text" name="memberId">
		</div>
		<div class="cell">
			<label>비밀번호</label>
			<input class="field w-100p" type="password" name="memberPw">
		</div>
		<div class="cell center">
			<button class="btn btn-positive" type="submit">로그인</button>
			<a class="btn btn-neutral" href="join">회원가입</a>
		</div>
	</form>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>