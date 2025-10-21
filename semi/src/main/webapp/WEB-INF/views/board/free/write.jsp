<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<!-- summernote -->
<link href="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.js"></script>
<link rel="stylesheet" type="text/css" href="/summernote/custom-summernote.css">
<script src="/summernote/custom-summernote.js"></script>

<form autocomplete="off" action="write" method="post">
	<div class="container w-800">
	    <div class="cell">
	        <h1>자유게시판 작성</h1>
	    </div>
	    
	    <div class="cell">
	        <input type="text" name="boardTitle" class="field w-100p" placeholder="제목을 입력하세요.">
	    </div>
	    
	    <div class="cell">
	        <textarea name="boardContent" class="summernote-editor"></textarea>
	    </div>
	    
	    <div class="cell right">
	        <button class="btn btn-positive">등록</button>
	    </div>
	</div>
</form>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>