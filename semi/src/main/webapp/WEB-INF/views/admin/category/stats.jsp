<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<h2>게시판 상세 정보</h2>

<table>
    <tr>
        <th>게시판 번호</th>
        <td>${categoryDetail.categoryNo}</td>
    </tr>
    <tr>
        <th>게시판 이름</th>
        <td>${categoryDetail.categoryName}</td>
    </tr>
    <tr>
        <th>게시글 수</th>
        <td>${categoryDetail.boardCount}</td>
    </tr>
   <tr>
    <th>마지막 활동 시간</th>
    <td>
        <c:choose>
            <c:when test="${not empty categoryDetail.lastUseTime}">
                ${categoryDetail.boardWriteTime}
            </c:when>
            <c:otherwise>활동 내역 없음</c:otherwise>
        </c:choose>
    </td>
</tr>

    <tr>
        <th>마지막 활동 사용자</th>
        <td><c:out value="${categoryDetail.lastUser}" default="작성자 없음" /></td>
    </tr>
</table>

<br/>
<a href="list">목록으로</a>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>
