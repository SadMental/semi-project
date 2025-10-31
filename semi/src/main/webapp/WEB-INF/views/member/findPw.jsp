<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<script type="text/javascript" src="/js/find.js"></script>

<div class="container w-600">
	<form action="findPw" method="post" id="send-email">
		<div class="cell">
			<label>이메일 입력</label>
			<input class="field w-100p" type="text" name="memberEmail" >
		</div>
		<div class="cell center">
			<button type="submit" class="btn btn-positive w-50p btn-find-send">
				<i class="fa-solid fa-paper-plane"></i>
				<span>이메일 전송</span>
			</button>
		</div>
		<div class="cell center">
			<h2 class="red">비밀번호는 랜덤으로 재설정되서 보내집니다!</h2>
		</div>
	</form>
</div>


<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>