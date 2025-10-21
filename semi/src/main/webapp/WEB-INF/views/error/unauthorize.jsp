<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<h1>${title}</h1>
<h2><a href="/member/login">로그인하기</a></h2>

<img src="/image/error/401.png" width="300">

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>