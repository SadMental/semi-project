<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp" />

<style>
  /* 배경과 기본 폰트 */
  body {
    background-color: #f9f7f1; /* 부드러운 아이보리 */
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    color: #4e3dea; /* 메인 보라색 */
    margin: 0;
    padding: 0;
  }

  .container {
    max-width: 900px;
    margin: 40px auto;
    background-color: #fff8e7; /* 따뜻한 베이지톤 */
    padding: 30px 40px;
    border-radius: 15px;
    box-shadow: 0 4px 12px rgba(78, 61, 234, 0.15);
  }

  h1 {
    font-size: 2.8rem;
    font-weight: 700;
    margin-bottom: 30px;
    text-align: center;
  }

  .btn {
    display: inline-block;
    background-color: #4e3dea;
    color: #f9f7f1;
    padding: 10px 22px;
    border-radius: 8px;
    font-weight: 600;
    text-decoration: none;
    transition: background-color 0.3s ease;
    margin-bottom: 20px;
  }

  .btn:hover {
    background-color: #3b30b8;
  }

  .btn-container {
    text-align: right;
    margin-bottom: 20px;
  }

  table {
    width: 100%;
    border-collapse: separate;
    border-spacing: 0 12px;
  }

  thead th {
    background-color: #4e3dea;
    color: #fff8e7;
    padding: 15px 10px;
    font-weight: 700;
    border-radius: 10px 10px 0 0;
  }

  tbody tr {
    background-color: #fff8e7;
    box-shadow: 0 2px 8px rgba(78, 61, 234, 0.1);
    transition: transform 0.2s ease;
  }

  tbody tr:hover {
    transform: translateY(-4px);
    box-shadow: 0 8px 20px rgba(78, 61, 234, 0.2);
  }

  tbody td {
    padding: 14px 10px;
    text-align: center;
    color: #3b30b8;
    font-weight: 600;
  }

  tbody td a {
    color: #4e3dea;
    text-decoration: none;
  }

  tbody td a:hover {
    text-decoration: underline;
  }

  .fa-heart.red {
    color: #e74c3c;
  }
</style>

<div class="container">
  <h1>정보게시판</h1>

  <div class="btn-container">
    <a href="write" class="btn">새글 작성</a>
  </div>

  <c:if test="${not empty boardList}">
    <table>
      <thead>
        <tr>
          <th>No</th>
          <th>제목</th>
          <th>작성자</th>
          <th>조회수</th>
          <th><i class="fa-solid fa-heart red"></i></th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="boardDto" items="${boardList}">
          <tr>
            <td>${boardDto.boardNo}</td>
            <td><a href="#">${boardDto.boardTitle}</a></td>
            <td>${boardDto.boardWriter}</td>
            <td>${boardDto.boardView}</td>
            <td>${boardDto.boardLike}</td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </c:if>

  <div class="btn-container">
    <a href="write" class="btn">새글 작성</a>
  </div>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp" />
