<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

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
			<c:forEach var="animalDto" items="${animalList }">
				<th>동물정보</th>
				<td>
					<div class="cell" data-animal-no="${animalDto.animalNo }">
					    <div class="cell">
					      	<span>동물 이름 : ${animalDto.animalName }</span>
					    </div>
					    <div class="cell">
					      	<span>동물 소개 : ${animalDto.animalContent }</span>
					    </div>
					    <div class="cell">
					            <span>
					            	${(animalDto.animalPermission == 'f')? "분양불가" : "분양가능"}
					            </span>
					    </div>
					</div>
				<td>
			</c:forEach>
		</tr>
	</table>
	<div class="cell">
		<a type="button" class="btn btn-neutral" href="edit">정보 수정하기</a>
		<a type="button" class="btn btn-neutral" href="password">비밀번호 변경</a>
		<a type="button" class="btn btn-negative" href="drop">회원 탈퇴하기</a>
	</div>
</div>


<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>