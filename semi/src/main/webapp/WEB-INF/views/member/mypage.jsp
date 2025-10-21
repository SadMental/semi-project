<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<div class="cell">
	<table class="table">
		<tr>
			<th>아이디</th>
			<td>${memberDto.memberId }</td>
		</tr>
		<tr>
			<th>닉네임</th>
			<td>${memberDto.memberNickname }</td>
		</tr>
		<tr>
			<th>이메일</th>
			<td>${memberDto.memberEmail }</td>
		</tr>
		<tr>
			<th>인증여부</th>
			<td>${memberDto.memberAuth }</td>
		</tr>
		<tr>
			<th>소개글</th>
			<td>${memberDto.memberDescription }</td>
		</tr>
		<tr>
			<th>포인트</th>
			<td>${memberDto.memberPoint }</td>
		</tr>
		<tr>
			<th>동물정보</th>
			<td>${memberDto.memberAnimal }</td>
		</tr>
	</table>
	<div class="cell">
		<a type="button" class="btn btn-neutral" href="edit">정보 수정하기</a>
		<a type="button" class="btn btn-neutral" href="password">비밀번호 변경</a>
		<a type="button" class="btn btn-negative" href="drop">회원 탈퇴하기</a>
	</div>
</div>


<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>