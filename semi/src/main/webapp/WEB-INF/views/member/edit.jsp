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
           $(".btn-add-animal").on("click", function(){
               var origin = $("#animal-template").text(); // 글자를 불러오고
               var html = $.parseHTML(origin); // HTML 구조로 재해석
               $(".target").append(html);
           });
           $(document).on("click", ".btn-animal", function(){
               var animalButton = $(this).closest(".animal-wrapper").find(".btn-animal")
               var permission = animalButton.attr('data-permission')
               console.log(permission)
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
               $.ajax({
                   url : "/rest/animal/add",
                   method : "post",
                   data : {animalName : animalName, 
                	   			animalPermission : animalPermission,
                				animalContent : animalContent	
                   },
                   success : function(response){
                	   wrapper.attr("data-animal-no", response)
                   }
               })
           });
       })
   </script>
<script type="text/template" id="animal-template">
        <div class="cell animal-wrapper">
            <div class="cell">
                <label>
                    <span>동물이름</span>
                    <input class="field w-100p animal-name" type="text" name="animalName">
                </label>
            </div>
            <div class="cell">
                <button class="btn btn-neutral btn-animal" data-permission="f">
                    <i class="fa-solid fa-home"></i>
                    <span>분양불가</span>
                </button>
            </div>
            <button class="btn btn-neutral animal-cancel" type="button">취소하기</button>
            <button class="btn btn-positive animal-access" type="button">추가하기</button>
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


<form action="edit" method="post">
	<div class="cell">
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
		<textarea class="summernote-editor" name="memberDescription">${memberDto.memberDescription }</textarea>
	</div>
	<div class="cell target">
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
		      	<span>동물 이름 : ${animalDto.animalName }</span>
		    </div>
		    <div class="cell">
		      	<span>동물 소개 : ${animalDto.animalContent }</span>
		    </div>
		    <div class="cell">
		        <button class="btn btn-neutral btn-animal" data-permission="f">
		            <i class="fa-solid fa-home"></i>
		            <span>
		            	${(animalDto.animalPermission == 'f')? "분양불가" : "분양가능"}
		            </span>
		        </button>
		    </div>
		    <button class="btn btn-neutral animal-cancel" type="button">삭제하기</button>
		</div>
	</c:forEach>

	<button type="submit" class="btn btn-positive">수정하기</button>
</form>


<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>