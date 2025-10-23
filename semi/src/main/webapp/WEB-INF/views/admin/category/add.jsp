<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>카테고리 등록</title>
</head>
<body>
    <h1>카테고리 등록</h1>

    <form action="add" method="post">
        <label>카테고리 이름:</label>
        <input type="text" name="categoryName" required>
        <br><br>
        <button type="submit">등록</button>
    </form>

    <br>
    <a href="list">목록으로</a>
</body>
</html>
