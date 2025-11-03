<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<link rel="stylesheet" type="text/css" href="/summernote/custom-summernote.css">
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
 .field.w-100, select {
   width: 100%;
   padding: 12px 15px;
   border: 2px solid #c9a66b;
   border-radius: 10px;
   font-size: 1.1rem;
   color: #5b3a29;
   box-sizing: border-box;
   margin-bottom: 20px;
 }
 .field.w-100:focus, select:focus {
   outline: none;
   border-color: #7e5a3c;
   box-shadow: 0 0 8px #a57a50;
 }
 textarea {
   width: 100%;
   padding: 12px 15px;
   border: 2px solid #c9a66b;
   border-radius: 10px;
   font-size: 1.1rem;
   color: #5b3a29;
   box-sizing: border-box;
   resize: vertical;
   min-height: 300px;
 }
 .btn {
   display: inline-flex;
   align-items: center;
   justify-content: center;
   gap: 8px;
   border: none;
   border-radius: 12px;
   padding: 14px 25px;
   font-size: 1.1rem;
   font-weight: 700;
   cursor: pointer;
   text-decoration: none;
   transition: background-color 0.2s ease;
 }
 .btn.btn-positive {
   background-color: #7e5a3c;
   color: #f9f6f1;
 }
 .btn.btn-positive:hover {
   background-color: #a67849;
 }

 .btn-animal-regist {
   background-color: #c19a6b;
   color: #fff;
 }
 .btn-animal-regist:hover {
   background-color: #a67849;
 }
 .red { color: red; }
 .btn-complete-adoption {
   background-color: #dc3545;
   color: white;
 }
 .btn-complete-adoption:hover {
   background-color: #c82333;
 }
 .button-area {
   display: flex;
   justify-content: flex-end;
   align-items: center;
   gap: 10px;
   margin-top: 40px;
 }
</style>

<c:if test="${sessionScope.loginId == adoptDetailVO.boardWriter 
              and adoptDetailVO.animalPermission == 't'}">
  <form id="completeForm" action="completeAdoption" method="post" 
        onsubmit="return confirm('정말로 이 동물의 분양을 완료 처리하시겠습니까?')"
        style="display:none;">
    <input type="hidden" name="boardNo" value="${adoptDetailVO.boardNo}">
  </form>
</c:if>

<form id="editForm" action="edit" method="post">
 <input type="hidden" name="boardNo" value="${adoptDetailVO.boardNo}">
 <div class="container w-800">
   <h1>[${adoptDetailVO.boardNo}번] 게시글 수정</h1>
   
   <label for="animalHeader">동물 종류</label>
   <select name="boardAnimalHeader" id="animalHeader" required>
       <option value="">-- 동물 선택 --</option>
       <c:forEach var="animal" items="${animalList}">
           <option value="${animal.headerNo}" ${animal.headerNo != adoptDetailVO.boardAnimalHeader? '':'selected'}>
               ${animal.headerName}
           </option>
       </c:forEach>
   </select>
   
   <label for="typeHeader">게시글 분류</label>
       <select name="boardTypeHeader" id="typeHeader" required>
           <option value="">-- 분류 선택 --</option>
          
           <c:forEach var="type" items="${typeList}">
               <option value="${type.headerNo}" ${type.headerNo == adoptDetailVO.boardTypeHeader ? 'selected' : ''}>
                   ${type.headerName}
               </option>
           </c:forEach>
       </select>
   
   <label for="animalNo">분양할 동물 선택</label>
   <select name="animalNo" id="animalNo" required>
       <option value="">-- 분양할 동물 선택 (재선택 가능) --</option>
       <c:forEach var="animal" items="${adoptableAnimalList}">
           <option value="${animal.animalNo}" ${animal.animalNo == currentAnimalNo ? 'selected' : ''}>
               ${animal.animalName} (No.${animal.animalNo})
           </option>
       </c:forEach>
   </select>

   <div class="cell right mt-2" style="text-align: right;">
       <a href="/animal/list" class="btn btn-animal-regist">
           <i class="fa-solid fa-paw"></i>
           <span>동물 등록하러가기</span>
       </a>
   </div>
   
   <label for="title">제목 <i class="fa-solid fa-asterisk red"></i></label>
   <input type="text" name="boardTitle" id="title"
          value="${adoptDetailVO.boardTitle}" class="field w-100">
          
   <label for="content">내용 <i class="fa-solid fa-asterisk red"></i></label>
   <textarea name="boardContent" id="content" rows="15">${adoptDetailVO.boardContent}</textarea>
   
   <div class="button-area">
     
     <c:if test="${sessionScope.loginId == adoptDetailVO.boardWriter 
                   and adoptDetailVO.animalPermission == 't'}">
       <button type="submit" form="completeForm" class="btn btn-complete-adoption">
         <i class="fa-solid fa-check"></i> 분양 완료 처리
       </button>
     </c:if>
     
     <button type="submit" form="editForm" class="btn btn-positive">
       <i class="fa-solid fa-edit"></i> 수정하기
     </button>
   </div>
 </div>
</form>
<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>