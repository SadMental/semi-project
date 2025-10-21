<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<form action="password" method="post" autocomplete="off">
	<div class="cell">
		<label>
			<span>현재 비밀번호</span>
			<i class="fa-solid fa-asterisk red"></i>
		</label>
		<input class="field w-100p" name="current_pw">
	</div>
	<div class="cell">
	<label>
			<span>수정할 비밀번호</span>
			<i class="fa-solid fa-asterisk red"></i>
		</label>
		<input class="field w-100p" name="change_pw">
	</div>
	<button type="submit" class="btn btn-positive">
		<i class="fa-solid fa-floppy-disk"></i>
		<span>저장하기</span>
	</button>
</form>


<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>