<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<div class="container w-600">
	<form action="findId" method="post">
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
	</form>
</div>


<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>