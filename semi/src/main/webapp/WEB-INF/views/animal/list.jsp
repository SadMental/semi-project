<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<script src="/js/add-animal.js"></script>

<script type="text/template" id="animal-template">
        <div class="cell animal-wrapper mt-20" data-animal-no="new">
			<div class="cell center" >
				<input type="file"  name="media" class="field w-100p" accept="image/*">
				<img class="img-preview" src="/image/error/no-image.png" width="100">
			</div>
            <div class="cell">
                <label>
                    <span>동물이름</span>
                </label>
                <input class="field w-100p animal-name" type="text" name="animalName">
            </div>
			<div class="cell">
				<label>
					<span>동물 소개</span>
				</label>
				<textarea class="animal-content w-100p" name="animalContent"></textarea>
			</div>
            <div class="cell">
                <button class="btn btn-neutral btn-animal" data-permission="f" type="button">
                    <i class="fa-solid fa-home"></i>
                    <span>분양불가</span>
                </button>
            </div>
            <button class="btn btn-neutral animal-cancel" type="button">취소하기</button>
            <button class="btn btn-positive animal-access" type="button">추가하기</button>
            <button class="btn btn-positive animal-edit" type="button" style="display: none;">수정하기</button>
        </div>
</script>

<div class="container w-600">
	<div class="cell flex-box">
		<div class="cell center">
			<p>동물 등록</p>
			<!-- <i class="fa-solid fa-asterisk red"></i> -->
			<button type="button" class="btn btn-neutral btn-add-animal">
		           <span>추가</span>
	       </button>
		</div>
		<div class="flex-box flex-fill"></div>
		<div class="flex-box flex-center">
	   		<a class="btn btn-neutral" href="/member/mypage">돌아가기</a>
		</div>
	</div>
	<c:forEach var="animalDto" items="${animalList }">
		<div class="cell animal-wrapper mt-20" data-animal-no="${animalDto.animalNo }">
			<div class="cell center" >
				<input type="hidden"  name="media" class="field w-100p" accept="image/*">
				<img class="img-preview" src="profile?animalNo=${animalDto.animalNo }" width="100">
			</div>
		    <div class="cell">
	               <label>
	                   <span>동물이름</span>
	               </label>
	               <input class="field w-100p animal-name" type="text" name="animalName" readonly="readonly" value="${animalDto.animalName }">
	           </div>
			<div class="cell">
				<label>
					<span>동물 소개</span>
				</label>
				<textarea class="animal-content w-100p" name="animalContent" readonly="readonly">${animalDto.animalContent }</textarea>
			</div>
	           <div class="cell">
	               <button class="btn btn-neutral btn-animal" data-permission="${animalDto.animalPermission }" type="button" disabled="disabled">
	                   <i class="fa-solid fa-home"></i>
	                   <span>${(animalDto.animalPermission == 'f')? "분양불가" : "분양가능"}</span>
	               </button>
	           </div>
	           <button class="btn btn-neutral animal-cancel" type="button">삭제하기</button>
	           <button class="btn btn-positive animal-access" type="button" style="display: none;">수정완료</button>
	           <button class="btn btn-positive animal-edit" type="button" >수정하기</button>
		</div>
	</c:forEach>
	<div class="cell target"></div>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>