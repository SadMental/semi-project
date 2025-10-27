<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<link href="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.js"></script>
<link rel="stylesheet" type="text/css" href="/summernote/custom-summernote.css">
<script src="/summernote/custom-summernote.js"></script>
<script src="/js/member-check.js"></script>
<script src="/js/add-animal.js"></script>

<script type="text/javascript">
	$(function(){
		var origin = $(".image-profile").attr("src");
		$("#profile-input").on("input", function(){
			var list = $("#profile-input").prop("files")
			if(list.length == 0) return;
			
			var form = new FormData(); // <form> 역할
			form.append("media", list[0]);
			$.ajax({
				processData : false, // multipart로 보내기 위해 미리 정의된 전처리 제거
				contentType : false, // multipart로 보내기 위해 미리 정의된 MINE 타입을 제거
				url : "/rest/member/profile",
				method : "post",
				data : form,
				success : function(response){
					var new_origin = origin + "&t=" + new Date().getTime();
					$(".image-profile").attr("src", new_origin);
				}
			});			
		});
		$("#profile-delete").on("click", function(){
			$.ajax({
				url : "/rest/member/delete",
				method : "post",
				data : {},
				success : function(response) {
					$(".image-profile").attr("src", "/image/error/no-image.png")
				}
			})
		});
	});
</script>
<script type="text/template" id="animal-template">
        <div class="cell animal-wrapper" data-animal-no="new">
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


<form action="edit" method="post" enctype="multipart/form-data" autocomplete="off">
	<div class="container w-600">
		<div class="cell" >
			<label>
				<span>확인용 비밀번호</span>
				<i class="fa-solid fa-asterisk red"></i>
			</label>
			<input class="field w-100p" type="password" name="memberPw">
		</div>
		<div class="cell">
			<input class="field w-100p" type="text" name="memberNickname" value="${memberDto.memberNickname}">
		</div>
		<div class="cell">
			<div class="flex-box" style="flex-wrap: wrap;">
				<input class="field flex-fill" type="text" name="memberEmail" value="${memberDto.memberEmail }" readonly="readonly">
				<button class="btn btn-neutral auth-edit-btn" type="button" style="display: none;">
					<i class="fa-solid fa-pen"></i>
					<span>수정</span>
				</button>
				<button type="button" class="btn-cert-send btn btn-positive" style="display: none;">
					<i class="fa-solid fa-paper-plane"></i>
					<span>인증메일 전송</span>
				</button> 
				<div class="fail-feedback w-100p">올바른 이메일 형식이 아닙니다</div>
				<div class="fail2-feedback w-100p">이미 등록된 이메일입니다</div>
			</div>
		</div>
		<div class="cell cert-input-area" style="display: none;">
			<div class="flex-box" style="flex-wrap: wrap;">
				<input type="text" inputmode="numeric"
					class="cert-input field flex-fill" placeholder="인증번호 입력"  size="5">
				<button type="button" class="btn-cert-check btn btn-positive w-75p">
					<i class="fa-solid fa-envelope"></i>
					<span>인증번호 확인</span>
				</button> 
				<div class="success-feedback w-100p">이메일 인증이 완료되었습니다</div>
			  	<div class="fail2-feedback w-100p">인증번호가 올바르지 않거나 유효시간이 초과되었습니다</div>
			</div>
		</div>
		<div class="cell">
			<input type="hidden" name="memberAuth" value="${memberDto.memberAuth }">
			<button class="auth-btn btn btn-positive ms-20" type="button" 
					style="border-radius: 50%; color: white; ">
				<i class="fa-solid fa-check"></i>
			</button>
		</div>
		<div class="cell">
			<textarea class="text-summernote-editor" name="memberDescription">${memberDto.memberDescription }</textarea>
		</div>
		<div class="cell center">
	        <img class="image-profile" src="profile?member_id=${memberDto.memberId }" width="100">
	        <label for="profile-input" class="flex-box flex-center">변경</label>
	        <label id="profile-delete" class="flex-box flex-center">제거</label>
	        <input type="file" id="profile-input" name="media" style="display: none;">
	    </div>
		<div class="cell">
			<label>
				<span>동물 등록</span>
				<!-- <i class="fa-solid fa-asterisk red"></i> -->
			</label>
			<button type="button" class="btn btn-neutral btn-add-animal">
	            <span>추가</span>
	        </button>
		</div>
		<c:forEach var="animalDto" items="${animalList }">
			<div class="cell animal-wrapper" data-animal-no="${animalDto.animalNo }">
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
	            <button class="btn btn-positive animal-access" type="button" style="display: none;">추가하기</button>
	            <button class="btn btn-positive animal-edit" type="button" >수정하기</button>
			</div>
		</c:forEach>
		<div class="cell target"></div>
		<div class="cell center">
			<button type="submit" class="btn btn-positive w-50p">수정하기</button>
		</div>
	</div>
</form>


<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>