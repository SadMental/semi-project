<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<jsp:include page="/WEB-INF/views/template/header.jsp" />

<style>
    body {
        background-color: #f4ede6;
        color: #5b3a29;
        margin: 0;
        padding: 0;
    }

    .container.w-800 {
        max-width: 800px;
        margin: 40px auto;
        padding: 30px 35px;
        border-radius: 15px;
        background-color: #ffffffdd;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
    }

    h1 {
        font-size: 2rem;
        font-weight: 700;
        margin-bottom: 25px;
    }

    a.write-btn {
        display: inline-block;
        background-color: #a67c52;
        color: #fff5e9;
        padding: 10px 20px;
        border-radius: 10px;
        text-decoration: none;
        font-weight: 600;
        margin-bottom: 20px;
        transition: background-color 0.3s ease;
    }

    a.write-btn:hover {
        background-color: #ba8f65;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 20px;
    }

    th, td {
        border: 1px solid #d6c2a6;
        padding: 10px 15px;
        text-align: center;
        color: #5b3a29;
    }

    th {
        background-color: #e9d9c5;
        font-weight: 700;
    }

    td a {
        color: #a67c52;
        text-decoration: none;
        font-weight: 600;
    }

    td a:hover {
        text-decoration: underline;
    }

    .no-posts {
        text-align: center;
        font-style: italic;
        color: #7a5a44;
    }

    .pagination-info {
        font-size: 1rem;
        color: #5b3a29;
        font-weight: 600;
    }
</style>

<div class="container w-800">
    <h1>${category.categoryName}</h1>

    <a href="${pageContext.request.contextPath}/board/${category.categoryName}/write" class="write-btn">글쓰기</a>

    <table>
        <thead>
            <tr>
                <th>번호</th>
                <th>제목</th>
                <th>작성자</th>
                <th>작성일</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="board" items="${boardList}">
                <tr>
                    <td>${board.boardNo}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/board/${category.categoryName}/detail?boardNo=${board.boardNo}">
                            ${board.boardTitle}
                        </a>
                    </td>
                    <td>${board.boardWriter}</td>
                    <td><fmt:formatDate value="${board.boardWtime}" pattern="yyyy-MM-dd"/></td>
                </tr>
            </c:forEach>
            <c:if test="${empty boardList}">
                <tr><td colspan="4" class="no-posts">게시글이 없습니다.</td></tr>
            </c:if>
        </tbody>
    </table>

    <div class="pagination-info">
        전체 게시물: ${pageVO.dataCount}건
    </div>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp" />
