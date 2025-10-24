<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<!-- Summernote -->
<link href="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.js"></script>
<link rel="stylesheet" type="text/css" href="/summernote/custom-summernote.css">
<script src="/summernote/custom-summernote.js"></script>

<style>
  body {
    background-color: #f4ede6;
    color: #5b3a29;
    margin: 0;
    padding: 0;
  }

  .container.w-800 {
    max-width: 800px;
    margin: 40px auto;
    padding: 30px 35px;
    border-radius: 15px;
    background-color: #ffffffdd;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  }

  h1 {
    font-size: 2.4rem;
    font-weight: 700;
    margin-bottom: 25px;
  }

  label {
    display: block;
    font-size: 1.05rem;
    font-weight: 600;
    margin-bottom: 10px;
    color: #5b3a29;
  }

  .field.w-100 {
    width: 100%;
    padding: 12px 15px;
    border: 2px solid #c9a66b;
    border-radius: 10px;
    font-size: 1.1rem;
    color: #5b3a29;
    box-sizing: border-box;
  }

  .field.w-100:focus {
    outline: none;
    border-color: #7e5a3c;
    box-shadow: 0 0 8px #a57a50;
  }

  .summernote-editor {
    margin-top: 10px;
  }

  .btn.btn-positive.w-100 {
    background-color: #7e5a3c;
    color: #f9f6f1;
    border: none;
    padding: 14px;
    font-size: 1.1rem;
    font-weight: 700;
    border-radius: 12px;
    cursor: pointer;
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
  }

  .btn.btn-positive.w-100:hover {
    background-color: #a67849;
  }

  .mt-40 {
    margin-top: 40px;
  }

  .red {
    color: red;
  }
</style>

<form action="edit" method="post" enctype="multipart/form-data">
  <input type="hidden" name="boardNo" value="${boardDto.boardNo}">
  
  <div class="container w-800">
    <div class="cell">
      <h1>[${boardDto.boardNo}번] 게시글 수정</h1>
      <input type="hidden" name="boardNo" value="${boardDto.boardNo}">
    </div>
    
    <div class="cell">
      <label for="title">제목 <i class="fa-solid fa-asterisk red"></i></label>
      <input type="text" name="boardTitle" id="title" value="${boardDto.boardTitle}" class="field w-100">
    </div>
    
    <div class="cell">
      <label for="content">내용 <i class="fa-solid fa-asterisk red"></i></label>
      <textarea name="boardContent" id="content" class="summernote-editor">${boardDto.boardContent}</textarea>
    </div>
    
    <div class = "cell">
   		<label>썸네일</label>
        <input type = "file"
        name = "media" accept = ".png,.jpg" class = "field w-100" required>
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