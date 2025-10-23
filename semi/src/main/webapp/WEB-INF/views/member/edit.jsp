<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<link href="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.js"></script>
<link rel="stylesheet" type="text/css" href="/summernote/custom-summernote.css">
<script src="/summernote/custom-summernote.js"></script>
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

<script type="text/javascript">
       $(function(){
           $(".btn-add-animal").on("click", function(){
               var origin = $("#animal-template").text(); // 글자를 불러오고
               var html = $.parseHTML(origin); // HTML 구조로 재해석
               $(".target").append(html);
           });
           $(document).on("click", ".btn-animal", function(){
               var animalButton = $(this).closest(".animal-wrapper").find(".btn-animal")
               var permission = animalButton.attr('data-permission')
               if(permission === 'f') {
                   animalButton.attr("data-permission", 't')
                   animalButton.find("span").text("분양가능")
               } else {
                   animalButton.attr("data-permission", 'f')
                   animalButton.find("span").text("분양불가")
               }
           });
           $(document).on("click", ".animal-cancel", function(){
        	   var wrapper = $(this).closest(".animal-wrapper")
        	   var animalNo = wrapper.attr("data-animal-no")
        	   console.log(animalNo)
        	   if(animalNo == "new"){
        		   wrapper.remove();
        		   return;
        	   }
        	   $.ajax({
        		   url : '/rest/animal/delete',
        		   method : 'post',
        		   data : {animalNo : animalNo},
        		   success : function () {
        			   wrapper.remove();
					}
        	   })		
           });
           $(document).on("click", ".animal-access", function(){
        	   var wrapper = $(this).closest(".animal-wrapper")
               var animalName = wrapper.find(".animal-name").val()
               var animalPermission = wrapper.find(".btn-animal").attr("data-permission")
               var animalContent = wrapper.find(".animal-content").val()
               var animalNo = wrapper.attr("data-animal-no")
               if(animalNo == "new"){
	               $.ajax({
	                   url : "/rest/animal/add",
	                   method : "post",
	                   data : {
                	   		animalName : animalName, 
               	   			animalPermission : animalPermission,
               				animalContent : animalContent	
	                   },
	                   success : function(response){
	                	   wrapper.attr("data-animal-no", response)
	                	   wrapper.find(".animal-access").toggle();
	                	   wrapper.find(".animal-edit").toggle();
	                	   wrapper.find(".animal-name").attr("readonly", "readonly")
	                	   wrapper.find(".animal-content").attr("readonly", "readonly")
	                	   wrapper.find(".btn-animal").attr("disabled", "disabled")
	                	   
	                   }
	               })
               } else {
            	   $.ajax({
	                   url : "/rest/animal/edit",
	                   method : "post",
	                   data : {
	                	   animalNo : animalNo,
							animalName : animalName, 
							animalPermission : animalPermission,
							animalContent : animalContent	
	                   },
	                   success : function(response){
	                	   wrapper.find(".animal-access").toggle();
	                	   wrapper.find(".animal-edit").toggle();
	                	   wrapper.find(".animal-name").attr("readonly", "readonly")
	                	   wrapper.find(".animal-content").attr("readonly", "readonly")
	                	   wrapper.find(".btn-animal").attr("disabled", "disabled")
	                   }
	               })
               }
           });
           $(document).on("click", ".animal-edit", function() {
        	   var wrapper = $(this).closest(".animal-wrapper")
        	   wrapper.find(".animal-access").toggle();
           	   wrapper.find(".animal-edit").toggle();
           	   wrapper.find(".animal-name").removeAttr("readonly")
           	   wrapper.find(".animal-content").removeAttr("readonly")
           	   wrapper.find(".btn-animal").removeAttr("disabled")
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
<style>
       /* 외곽선을 field와 같이 변경 */
       .note-editor {
           border: 1px solid #636e72 !important;
       }
       /* 전체화면일 떄 뒤가 비치지 않도록 변경 */
       .note-editable{
           background-color: white;
       }
</style>


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
			<input class="field w-100p" type="text" name="memberEmail" value="${memberDto.memberEmail }">
		</div>
		<div class="cell">
			<input type="hidden" name="memberAuth" value="${memberDto.memberAuth }">
			<button class="btn btn-positive" type="button">
				<i class="fa-solid fa-lock"></i>
				<span>인증여부</span>
			</button>
		</div>
		<div class="cell">
			<textarea class="" name="memberDescription">${memberDto.memberDescription }</textarea>
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