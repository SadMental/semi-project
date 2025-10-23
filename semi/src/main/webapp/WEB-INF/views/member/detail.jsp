<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"/>	

<div class="container w-600">
	<div class="cell center">
		<h2>${memberDto.memberNickname}님의 프로필</h2>
	</div>
	<div class="cell">
		<table class="table">
			<tr>
				<td>인증</td>
				<th>${(memberDto.memberAuth == 'f')? '미인증' : '인증'}</th>
			</tr>
			<tr>
				<td>소개글</td>
				<th>${memberDto.memberDescription }</th>
			</tr>
			<tr>
				<td>등급</td>
				<th>${memberDto.memberLevel }</th>
			</tr>
			<tr>
				<c:forEach var="animalDto" items="${animalList }">
					<th>키우는 동물</th>
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
	</div>

</div>


<jsp:include page="/WEB-INF/views/template/footer.jsp"/>	