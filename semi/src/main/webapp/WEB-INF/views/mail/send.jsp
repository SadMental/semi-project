<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>    

<link href="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.js"></script>
<link rel="stylesheet" type="text/css" href="/summernote/custom-summernote.css">
<script src="/summernote/custom-summernote.js"></script>

<div class="container w-600">
	<form action="send" method="post">
		<div class="cell">
			<label>
				<span>제목</span>
				<i class="fa-solid fa-asterisk red"></i>
			</label>
			<input type="text" class="field w-100p" name="mailTitle">
		</div>
		<div class="cell">
			<label>
				<span>받는 이</span>
				<i class="fa-solid fa-asterisk red"></i>
			</label>
			<div class="cell flex-box">
				<input type="text" class="field flex-fill" name="memberNickname">
				<button type="button" class="btn btn-neutral">
					<i class="fa-solid fa-magnifying-glass"></i>
					<span>확인</span>
				</button>
			</div>
		</div>
		<div class="cell">
			<label>
				<span>내용</span>
				<i class="fa-solid fa-asterisk red"></i>
			</label>
			<textarea name="mailContent" class="summernote-editor"></textarea>
		</div>
		<div class="cell center">
			<button type="submit" class="btn btn-positive w-50p">
				<i class="fa-solid fa-paper-plane"></i>
				<span>우편 보내기</span>
			</button>
		</div>
	</form>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>    