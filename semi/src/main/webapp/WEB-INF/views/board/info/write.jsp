<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<!-- summernote -->
<link href="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.js"></script>
<link rel="stylesheet" type="text/css" href="/summernote/custom-summernote.css">
<script src="/summernote/custom-summernote.js"></script>
<link rel="stylesheet" type="text/css" href="/css/board_edit.css">


<form autocomplete="off" action="write" method="post">
  <div class="container w-800">
      <div class="cell center">
          <h1>정보 공유하기</h1>
      </div>
      <div class="cell center">
          이 글은 정보게시판에 업로드 됩니다.<br>
          <em>다른 사람에게 도움이 되는 유익한 글을 작성해주세요!</em>
      </div>
	  <div class="cell flex-box">
	      <div class="flex-box flex-vertical w-25p">
	      <label>동물</label>
			  <select name="boardAnimalHeader" class="field w-100p mt-2">
			  	         <c:forEach var="animalHeader" items="${animalList}">
			  	             <option value="${animalHeader.headerNo}">${animalHeader.headerName}</option>
			  	         </c:forEach>
			  </select>
	      </div>
	      <div class="flex-box flex-vertical w-25p ms-10">
		  <label>type</label>
			  <select name="boardTypeHeader" class="field w-100p mt-2">
			  	         <c:forEach var="typeHeader" items="${typeList}">
			  	             <option value="${typeHeader.headerNo}">${typeHeader.headerName}</option>
			  	         </c:forEach>
			  </select>
	      </div>
      </div>
      <div class="cell mt-20">
          <input type="text" name="boardTitle" class="field w-100p" placeholder="제목을 입력하세요.">
      </div>
      
      <div class="cell mt-20">
          <textarea name="boardContent" class="summernote-editor"></textarea>
      </div>
      
      <div class="cell right mt-20">
          <button class="btn btn-positive">등록하기</button>
      </div>
  </div>
</form>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>