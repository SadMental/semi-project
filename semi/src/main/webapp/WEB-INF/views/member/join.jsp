<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<link href="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.js"></script>
<link rel="stylesheet" type="text/css" href="/summernote/custom-summernote.css">
<script src="/summernote/custom-summernote.js"></script>

<form action="join" method="post">
	<div class="cell">
		<label>
			<span>아이디</span>
			<i class="fa-solid fa-asterisk red"></i>
		</label>
		<input class="field w-100p" type="text" name="memberId">
	</div>
	<div class="cell">
		<label>
			<span>비밀번호</span>
			<i class="fa-solid fa-asterisk red"></i>
		</label>
		<input class="field w-100p" type="password" name="memberPw">
	</div>
	<div class="cell">
		<label>
			<span>닉네임</span>
			<i class="fa-solid fa-asterisk red"></i>
		</label>
		<input class="field w-100p" type="text" name="memberNickname" value="${memberDto.memberNickname}">
	</div>
	<div class="cell">
		<label>
			<span>이메일</span>
			<!-- <i class="fa-solid fa-asterisk red"></i> -->
		</label>
		<input class="field w-100p" type="text" name="memberEmail" value="${memberDto.memberEmail }">
	</div>
	<div class="cell">
		<input type="hidden" name="memberAuth" value="${memberDto.memberAuth }">
		<button class="btn btn-positive" type="button">
			<i class="fa-solid fa-lock"></i>
			<span>인증여부</span>
		</button>
	</div>
	<div class="cell">
		<label>
			<span>소개글</span>
			<!-- <i class="fa-solid fa-asterisk red"></i> -->
		</label>
		<textarea class="summernote-editor" name="memberDescription">${memberDto.memberDescription }</textarea>
	</div>


<button type="submit">가입하기</button>
</form>


<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>