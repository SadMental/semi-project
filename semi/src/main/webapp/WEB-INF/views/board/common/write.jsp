<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<!-- summernote -->
<link
	href="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.js"></script>
<link rel="stylesheet" type="text/css"
	href="/summernote/custom-summernote.css">
<link rel="stylesheet" type="text/css"
	href="/css/board_edit.css">
<script src="/summernote/custom-summernote.js"></script>

<style>
</style>

<form autocomplete="off" action="write" method="post">
	<div class="container w-800">
		<div class="cell center">
			<h1>글 작성</h1>
		</div>
		<div class="cell center">
			<em>작은 정보라도 공유하면 큰 가치를 만듭니다.</em>
		</div>
		<div class="cell">

			<div class="cell mt-20">
				<input type="text" name="boardTitle" class="field w-100p"
					placeholder="제목을 입력하세요.">
			</div>
			<div class="cell flex-box">
		      <div class="flex-box flex-vertical w-25p ms-10">
				  <label>type</label>
					  <select name="boardTypeHeader" class="field w-100p mt-2">
					  	         <c:forEach var="headerDto" items="${headerList}">
					  	             <option value="${headerDto.headerNo}">${headerDto.headerName}</option>
					  	         </c:forEach>
					  </select>
			      </div>
		      </div>
			<div class="cell mt-20">
				<textarea name="boardContent" id="content" class="summernote-editor"></textarea>
			</div>
			<div class="cell right mt-20">
				<button class="btn btn-positive">등록하기</button>
			</div>
		</div>
		</div>
		
</form>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>