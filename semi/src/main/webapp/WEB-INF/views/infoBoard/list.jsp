<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

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
    font-size: 2.8rem;
    font-weight: 700;
    margin-bottom: 25px;
    text-align: center;
  }

  table {
    width: 100%;
    border-collapse: collapse;
    font-size: 1.05rem;
  }

  table thead {
    background-color: #e9d8c6;
  }

  table th, table td {
    padding: 14px 12px;
    border-bottom: 1px solid #d3bfa6;
    text-align: center;
  }

  table tr:hover {
    background-color: #f3eae1;
  }

  a {
    color: #5b3a29;
    text-decoration: none;
  }

  a:hover {
    text-decoration: underline;
  }

  .btn.btn-positive {
    background-color: #7e5a3c;
    color: #f9f6f1;
    border: none;
    padding: 10px 20px;
    font-size: 1rem;
    font-weight: 700;
    border-radius: 10px;
    cursor: pointer;
    text-decoration: none;
    display: inline-block;
    margin-top: 20px;
  }

  .btn.btn-positive:hover {
    background-color: #a67849;
  }

  .cell.right {
    text-align: right;
  }

  .no-posts {
    text-align: center;
    padding: 40px 0;
    color: #8c6d5b;
  }
  .mb-20 {
  margin-bottom: 20px;
}
  
</style>

<div class="container w-800">
    <div class="cell center">
        <h1>정보 게시판</h1>
    </div>

    <div class="cell right mb-20">
        <a href="write" class="btn btn-positive">새로운 글 작성</a>
    </div>

    <c:choose>
        <c:when test="${empty boardList}">
            <div class="no-posts">등록된 글이 없습니다.</div>
        </c:when>
        <c:otherwise>
            <div class="cell">
                <table>
                    <thead>
                        <tr>
                            <th>No</th>
                            <th>제목</th>
                            <th>작성자</th>
                            <th>조회수</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="boardDto" items="${boardList}">
                            <tr>
                                <td>${boardDto.boardNo}</td>
                                <td style="text-align: center;">
                                    <a href="detail?boardNo=${boardDto.boardNo}">${boardDto.boardTitle}</a>
                                </td>
                                <td>${boardDto.boardWriter}</td>
                                <td>${boardDto.boardView}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>
