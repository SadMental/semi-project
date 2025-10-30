<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>회원 등급 상세보기</title>
    <style>
        table { border-collapse: collapse; width: 400px; margin: 30px auto; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
        th { background: #f9f9f9; width: 150px; }
        .buttons { text-align: center; margin-top: 20px; }
        .button { padding: 6px 12px; border: 1px solid #888; background: #eee; text-decoration: none; border-radius: 3px; }
        .button:hover { background: #ddd; }
    </style>
</head>
<body>

<h2 style="text-align:center;">회원 등급 상세 정보</h2>

<table>
    <tr>
        <th>등급 번호</th>
        <td>${level.levelNo}</td>
    </tr>
    <tr>
        <th>등급 이름</th>
        <td>${level.levelName}</td>
    </tr>
    <tr>
        <th>최소 포인트</th>
        <td>${level.minPoint}</td>
    </tr>
    <tr>
        <th>최대 포인트</th>
        <td>${level.maxPoint}</td>
    </tr>
    <tr>
        <th>설명</th>
        <td>${level.description}</td>
    </tr>
</table>

<div class="buttons">
    <a href="${pageContext.request.contextPath}/admin/level/edit?levelNo=${level.levelNo}" class="button">수정</a>

    <form action="${pageContext.request.contextPath}/admin/level/delete" method="post" style="display:inline;">
        <input type="hidden" name="levelNo" value="${level.levelNo}">
        <button type="submit" onclick="return confirm('정말 삭제하시겠습니까?');" class="button">삭제</button>
    </form>

    <a href="${pageContext.request.contextPath}/admin/level/list" class="button">목록으로</a>
</div>

</body>
</html>
