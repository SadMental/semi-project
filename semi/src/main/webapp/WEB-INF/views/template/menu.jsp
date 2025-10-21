<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:choose>
	<%-- 회원일 시 보이는 카테고리 --%>
	<c:when test="${sessionScope.loginId != null && sessionScope.loginLevel == '1' }">
		<a href="/">홈</a>
		<a href="/board/list">게시판</a>
		<a href="#">메일</a>
		<a href="/member/logout">로그아웃</a>
	</c:when>
	
	<%-- 관리자일 시 보이는 카테고리 --%>
	<c:when test="${sessionScope.loginId != null && sessionScope.loginLevel >= '2' }">
		<a href="/">홈</a>
		<a href="/board/list">게시판</a>
		<a href="#">메일</a>
		<a href="/member/logout">로그아웃</a>
	</c:when>
	
	<%-- 비회원일 시 보이는 카테고리 --%>
	<c:otherwise>
		<a href="/">홈</a>
		<a href="/board/list">게시판</a>
		<a href="/member/login">로그인</a>
		<a href="/member/join">회원가입</a>
	</c:otherwise>
</c:choose>
