<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>회원 등급 수정</title>
    <style>
        form { width: 400px; margin: 30px auto; display: flex; flex-direction: column; gap: 10px; }
        label { font-weight: bold; }
        input, textarea { padding: 8px; }
        button { padding: 8px 12px; }
    </style>
</head>
<body>

<h2 style="text-align:center;">회원 등급 수정</h2>

<form action="${pageContext.request.contextPath}/admin/level/edit" method="post">
    <input type="hidden" name="levelNo" value="${level.levelNo}">

    <label>등급 이름</label>
    <input type="text" name="levelName" value="${level.levelName}" required>

    <label>최소 포인트</label>
    <input type="number" name="minPoint" value="${level.minPoint}" required>

    <label>최대 포인트</label>
    <input type="number" name="maxPoint" value="${level.maxPoint}" required>

    <label>설명</label>
    <textarea name="description" rows="3">${level.description}</textarea>

    <div style="text-align:center;">
        <button type="submit">수정 완료</button>
        <a href="${pageContext.request.contextPath}/admin/level/detail?levelNo=${level.levelNo}">취소</a>
    </div>
</form>

</body>
</html>
