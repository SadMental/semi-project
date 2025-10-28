<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

	<div class="container w-600">
		<div class="cell flex-box flex-vertical flex-center">
			<a class="btn btn-neutral mt-10 w-50p" href="category/list">게시판 관리 페이지</a>
			<a class="btn btn-neutral mt-10 w-50p" href="header/animal/list">동물 머리글 관리 페이지</a>
			<a class="btn btn-neutral mt-10 w-50p" href="header/type/list">기타 머리글 관리 페이지</a>
			<a class="btn btn-neutral mt-10 w-50p" href="member/list">회원 관리 페이지</a>
			<a class="btn btn-neutral mt-10 w-50p" href="animal/list">동물 관리 페이지</a>
		</div>
	
	</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>