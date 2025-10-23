<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
    font-family: 'Noto Sans KR', sans-serif;
  }

  h2 {
    font-size: 2rem;
    font-weight: 700;
    margin-bottom: 25px;
    text-align: center;
  }

  table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 30px;
  }

  th, td {
    padding: 12px 15px;
    border-bottom: 1px solid #d6c2a6;
    text-align: left;
    vertical-align: middle;
  }

  th {
    background-color: #a67c52;
    color: #fff5e9;
    width: 40%;
    border-radius: 8px 0 0 8px;
  }

  td {
    background-color: #f9f4ec;
    border-radius: 0 8px 8px 0;
  }

  a.btn-neutral {
    display: inline-block;
    background-color: #d9c7b3;
    color: #5b3a29;
    padding: 10px 20px;
    border-radius: 12px;
    font-weight: 600;
    text-decoration: none;
    transition: background-color 0.3s ease;
  }

  a.btn-neutral:hover {
    background-color: #cbb7a3;
  }

  /* 마지막 행 예외처리 (rounded corners) */
  table tr:last-child th {
    border-radius: 8px 0 0 8px;
  }

  table tr:last-child td {
    border-radius: 0 8px 8px 0;
  }
</style>

<div class="container w-600">
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
            <fmt:formatDate value="${categoryDetail.lastUseTime}" pattern="yyyy-MM-dd HH:mm:ss" />
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

  <div style="text-align:center;">
    <a href="list" class="btn-neutral">목록으로</a>
  </div>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp" />
