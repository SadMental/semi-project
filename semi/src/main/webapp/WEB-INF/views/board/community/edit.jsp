<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<link rel="stylesheet" href="/css/board_edit.css" >
<!-- Summernote -->
<link href="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.js"></script>
<link rel="stylesheet" type="text/css" href="/summernote/custom-summernote.css">
<script src="/summernote/custom-summernote.js"></script>

<form action="edit" method="post">
  <input type="hidden" name="boardNo" value="${boardDto.boardNo}">
  
  <div class="container w-800">
    <div class="cell">
      <h1>[${boardDto.boardNo}번] 게시글 수정</h1>
	  <select name="boardAnimalHeader" required>
	          <option value="">-- 선택 --</option>
	          <c:forEach var="animalDto" items="${animalList}">
	              <option value="${animalDto.headerNo}">
	                  ${animalDto.headerName}
	              </option>
	          </c:forEach>
	  </select>
	  <select name="boardTypeHeader" required>
	          <option value="">-- 선택 --</option>
	          <c:forEach var="typeDto" items="${typeList}">
	              <option value="${typeDto.headerNo}">
	                  ${typeDto.headerName}
	              </option>
	          </c:forEach>
	  </select>
    </div>
    
    <div class="cell">
      <label for="title">제목 <i class="fa-solid fa-asterisk red"></i></label>
      <input type="text" name="boardTitle" id="title" value="${boardDto.boardTitle}" class="field w-100">
    </div>
    
    <div class="cell">
      <label for="content">내용 <i class="fa-solid fa-asterisk red"></i></label>
      <textarea name="boardContent" id="content" class="summernote-editor">${boardDto.boardContent}</textarea>
    </div>
    
    <div class="cell mt-40">
      <button type="submit" class="btn btn-positive w-100">
        <i class="fa-solid fa-edit"></i>
        <span>수정하기</span>
      </button>
    </div>
  </div>
</form>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>