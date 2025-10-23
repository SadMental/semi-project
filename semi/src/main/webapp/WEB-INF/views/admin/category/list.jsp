<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>카테고리 목록</title>
</head>
<body>
    <h1>카테고리 목록</h1>

    <table border="1" cellpadding="10">
        <thead>
            <tr>
                <th>번호</th>
                <th>이름</th>
                <th>작업</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="categoryDto" items="${categoryList}">
                <tr>
                    <td>${categoryDto.categoryNo}</td>
                    <td><a href="detail?categoryName=${categoryDto.categoryName}">${categoryDto.categoryName}</a></td>
                    <td>
                        <a href="edit?categoryNo=${categoryDto.categoryNo}">수정</a> |
                        <a href="delete?categoryNo=${categoryDto.categoryNo}" onclick="return confirm('삭제하시겠습니까?');">삭제</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <br>
    <a href="add">카테고리 등록</a>
</body>
</html>
