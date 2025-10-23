<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header.jsp" />

<style>
    body {
        background-color: #f4ede6;
        color: #5b3a29;
        margin: 0;
        padding: 0;
    }

    .container.w-600 {
        max-width: 600px;
        margin: 40px auto;
        padding: 30px 35px;
        border-radius: 15px;
        background-color: #ffffffdd;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
    }

    h1 {
        font-size: 2rem;
        font-weight: 700;
        margin-bottom: 15px;
    }

    label {
        font-weight: 600;
        display: block;
        margin-bottom: 8px;
        margin-top: 20px;
    }

    input[type="text"], textarea {
        width: 100%;
        padding: 10px;
        border: 1px solid #d6c2a6;
        border-radius: 8px;
        font-size: 1rem;
        color: #5b3a29;
        box-sizing: border-box;
        background-color: #fefcf8;
        resize: vertical;
    }

    textarea {
        min-height: 150px;
    }

    .button-group {
        margin-top: 25px;
        text-align: right;
    }

    button {
        background-color: #a67c52;
        border: none;
        color: #fff5e9;
        font-weight: 700;
        padding: 10px 20px;
        font-size: 1rem;
        border-radius: 10px;
        cursor: pointer;
        margin-left: 10px;
        transition: background-color 0.3s ease;
    }

    button:hover {
        background-color: #ba8f65;
    }

    button.cancel-btn {
        background-color: #d9c7b3;
        color: #5b3a29;
    }

    button.cancel-btn:hover {
        background-color: #cbb7a3;
    }
</style>

<div class="container w-600">
    <h1>${category.categoryName} 글쓰기</h1>

    <form action="${pageContext.request.contextPath}/board/${category.categoryName}/write" method="post">
        <input type="hidden" name="categoryNo" value="${category.categoryNo}" />

        <label for="boardTitle">제목</label>
        <input type="text" id="boardTitle" name="boardTitle" required>

        <label for="boardContent">내용</label>
        <textarea id="boardContent" name="boardContent" required></textarea>

        <div class="button-group">
            <button type="submit">등록</button>
            <button type="button" class="cancel-btn" onclick="history.back()">취소</button>
        </div>
    </form>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp" />
