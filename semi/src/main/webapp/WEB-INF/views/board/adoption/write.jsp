<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<link rel="stylesheet" type="text/css" href="/css/commons.css">
<script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
<style>

 :root {
     --primary-brown: #7e5a3c; 
     --secondary-beige: #a67c52; 
     --light-beige: #f9f6f1;
     --container-bg: #ffffff; 
     --border-color: #e6d4c3; 
     --text-dark: #5b3a29; 
     --placeholder-color: #a69a8b; 
 }
 body {
   background-color: var(--light-beige);
   color: var(--text-dark);
   margin: 0;
   padding: 0;
   font-family: 'Malgun Gothic', 'Dotum', sans-serif;
 }
  .container.w-800 {
   max-width: 800px;
   margin: 40px auto;
   padding: 40px;
   border-radius: 20px; 
   background-color: var(--container-bg);
   box-shadow: 0 8px 20px rgba(0,0,0,0.1); 
 }
  h1 {
   font-size: 2.5rem;
   font-weight: 800;
   margin-bottom: 10px;
   color: var(--primary-brown);
 }
 .cell.center em {
     font-style: normal;
     font-weight: 600;
     color: var(--secondary-beige);
     letter-spacing: -0.5px;
 }

 .form-label {
     display: block;
     font-size: 1.1rem;
     font-weight: 700;
     color: var(--primary-brown);
     margin-bottom: 8px;
     padding-left: 5px;
 }

 input.field.w-100, select.field.w-100, textarea.field.w-100 {
   width: 100%;
   padding: 14px 18px; 
   border: 1px solid var(--border-color);
   border-radius: 12px;
   font-size: 1.05rem;
   color: var(--text-dark);
   background-color: #fff;
   box-sizing: border-box;
   transition: border-color 0.2s, box-shadow 0.2s;
   resize: vertical; 
 }
  input.field.w-100::placeholder, textarea.field.w-100::placeholder {
     color: var(--placeholder-color);
 }
  input.field.w-100:focus, select.field.w-100:focus, textarea.field.w-100:focus {
   outline: none;
   border-color: var(--primary-brown);
   box-shadow: 0 0 0 3px rgba(126, 90, 60, 0.15);
 }

 button.btn.btn-positive {
   background-color: var(--primary-brown);
   color: #fff;
   border: none;
   padding: 14px 35px;
   font-size: 1.15rem;
   font-weight: 700;
   border-radius: 15px;
   cursor: pointer;
   transition: all 0.2s;
   box-shadow: 0 4px 8px rgba(0,0,0,0.15);
 }
  button.btn.btn-positive:hover {
   background-color: #a67849;
   transform: translateY(-2px);
   box-shadow: 0 6px 12px rgba(0,0,0,0.2);
 }

 .btn-link {
   text-decoration: none;
   padding: 14px 35px;
   font-size: 1.15rem;
   font-weight: 700;
   border-radius: 15px;
   cursor: pointer;
   transition: all 0.2s;
   box-shadow: 0 4px 8px rgba(0,0,0,0.15);
   display: inline-block; 
   margin-left: 10px; 
 }

 .btn-animal-regist {
     background-color: var(--secondary-beige); 
     color: #fff;
 }
 .btn-animal-regist:hover {
     background-color: #8c6a47;
     transform: translateY(-2px);
 }
 .btn-animal-regist i {
     margin-right: 5px;
 }
</style>
<form autocomplete="off" action="write" method="post" enctype="multipart/form-data">
 <div class="container w-800">
     <div class="cell center">
         <h1>분양 정보 공유하기</h1>
     </div>
     <div class="cell center" style="margin-bottom: 30px;">
         이 글은 분양 정보게시판에 업로드 됩니다.<br>
         <em>다른 사람에게 도움이 되는 유익한 글을 작성해주세요!</em>
     </div>
    
     <div class="cell">
         <input type="text" name="boardTitle" class="field w-100" placeholder="제목을 입력하세요." required>
   
		  <select name="boardAnimalHeader" class="field w-100 mt-2">
		  	         <option value="">-- 동물 분류 선택 --</option>
		  	         <c:forEach var="animalHeader" items="${animalList}">
		  	             <option value="${animalHeader.headerNo}">${animalHeader.headerName}</option>
		  	         </c:forEach>
		  </select>
		  <select name="boardTypeHeader" class="field w-100 mt-2">
		  	         <option value="">-- 게시글 타입 선택 --</option>
		  	         <c:forEach var="typeHeader" items="${typeList}">
		  	             <option value="${typeHeader.headerNo}">${typeHeader.headerName}</option>
		  	         </c:forEach>
		  </select>
	  </div>
    
     <div class="cell mt-4">
         <select name="animalNo" class="field w-100" required>
             <option value="">-- 분양할 동물 선택 (분양 가능만 표시) --</option>
             <c:forEach var="animal" items="${adoptableAnimalList}">
                 <option value="${animal.animalNo}">${animal.animalName} (No.${animal.animalNo})</option>
             </c:forEach>
         </select>
        
         <div class="cell right mt-2">
           <a href="/animal/list" class="btn-link btn-animal-regist">
               <i class="fa-solid fa-paw"></i> 동물 등록하기
           </a>
         </div>
     </div>
    
     <div class="cell mt-4">
         <label for="board_content" class="form-label">게시글 본문 (분양 조건 및 자세한 소개)</label>
         <textarea id="board_content" name="boardContent" class="field w-100" rows="10"
                   placeholder="분양 조건 및 분양을 원하는 분들에게 전달할 내용을 상세하게 작성해주세요. (필수)"
                   required></textarea>
     </div>
	 
     <div class="cell right mt-4">
         <button class="btn btn-positive">등록</button>
     </div>
    
 </div>
</form>
<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>
