<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<form action="join" method="post">
	<input type="text" name="memberId">아이디 <br><br>
	<input type="password" name="memberPw">비밀번호 <br><br>
	<input type="text" name="memberNickname">닉네임 <br><br>
	<input type="text" name="memberEmail">이메일 <br><br>
	<div class="cell">
	<input type="hidden" name="memberAuth" value="f">
		<button class="btn btn-positive" type="button">
			<i class="fa-solid fa-lock"></i>
			<span>인증여부</span>
		</button>
	</div>
	<textarea name="memberDescription"></textarea>설명란 <br><br>
	<input type="text" name="memberAnumal">반려동물 

<button type="submit">가입하기</button>
</form>


<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>