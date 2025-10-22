<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<script type="text/javascript">
        $(function(){
            $(".btn-add-animal").on("click", function(){
                var origin = $("#animal-template").text(); // 글자를 불러오고
                var html = $.parseHTML(origin); // HTML 구조로 재해석
                $(".target").append(html);
            })
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
                $(this).closest(".animal-wrapper").remove();
            });
            $(document).on("click", ".animal-access", function(){
                var animalName = $(this).closest(".animal-wrapper").find(".animal-name").val()
                var animalPermission = $(this).closest(".animal-wrapper").find(".btn-animal").attr("data-permission")
                console.log(animalName)
                console.log(animalPermission)
                $.ajax({
                    url : "/rest/animal/add",
                    method : "post",
                    data : {animalName : animalName, animalPermission : animalPermission},
                    success : function(response){
                        
                    }
                })
            });
        })
</script>

<div class="cell">
	<table class="table">
		<tr>
			<th>아이디</th>
			<td>${memberDto.memberId }</td>
		</tr>
		<tr>
			<th>닉네임</th>
			<td>${memberDto.memberNickname }</td>
		</tr>
		<tr>
			<th>이메일</th>
			<td>${memberDto.memberEmail }</td>
		</tr>
		<tr>
			<th>인증여부</th>
			<td>${memberDto.memberAuth }</td>
		</tr>
		<tr>
			<th>소개글</th>
			<td>${memberDto.memberDescription }</td>
		</tr>
		<tr>
			<th>포인트</th>
			<td>${memberDto.memberPoint }</td>
		</tr>
		<tr>
			<th>동물정보</th>
			<td></td>
		</tr>
	</table>
	<div class="cell">
		<a type="button" class="btn btn-neutral" href="edit">정보 수정하기</a>
		<a type="button" class="btn btn-neutral" href="password">비밀번호 변경</a>
		<a type="button" class="btn btn-negative" href="drop">회원 탈퇴하기</a>
	</div>
</div>


<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>