<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<script src="/js/email-cert.js"></script>
<script src="/js/member-join.js"></script>

<form action="join" method="post">
	<input type="text" name="memberId">아이디 <br>
	<br> <input type="password" name="memberPw">비밀번호 <br>
	<br> <input type="text" name="memberNickname">닉네임 <br>
	<br> <input type="text" inputmode="email" name="memberEmail">이메일
	<button type="button" class="btn-cert-send">인증메일 보내기</button>
	<br>
	<br> <input type="text" inputmode="numeric"
		class="field cert-input" placeholder="인증번호 입력">
	<button type="button" class="btn-cert-check">인증번호 확인</button>
	<span class="success-feedback">이메일 인증이 완료되었습니다</span> <span
		class="fail-feedback">올바른 이메일 형식이 아닙니다</span> <span
		class="fail2-feedback">이메일 인증이 완료되지 않았습니다</span>

	<!-- 	<div class="cell"> -->
	<!-- 	<input type="hidden" name="memberAuth" value="f"> -->
	<!-- 		<button class="btn btn-positive" type="button"> -->
	<!-- 			<i class="fa-solid fa-lock"></i> -->
	<!-- 			<span>인증여부</span> -->
	<!-- 		</button> -->
	<!-- 	</div>  -->
	<br>
	<br>
	<textarea name="memberDescription"></textarea>설명란 <br><br>
	<input type="text" name="memberAnumal">반려동물
	<button type="submit">가입하기</button>
</form>


<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>