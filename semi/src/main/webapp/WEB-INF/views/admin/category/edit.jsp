<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>카테고리 수정</title>
</head>
<body>
    <h1>카테고리 수정</h1>

    <form action="edit" method="post">
        <input type="hidden" name="categoryNo" value="${categoryDto.categoryNo}" />
        
        <label for="categoryName">카테고리 이름:</label><br>
        <input type="text" id="categoryName" name="categoryName" value="${categoryDto.categoryName}" required /><br><br>
        
        <button type="submit">수정 완료</button>
        <a href="list">취소</a>
    </form>
</body>
</html>
