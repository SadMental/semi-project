<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp" />
<link rel="stylesheet" type="text/css" href="/css/commons.css">

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
    text-align: center;
  }

  table {
    width: 100%;
    border-collapse: collapse;
    margin-bottom: 30px;
  }

  thead th {
    background-color: #a67c52;
    color: #fff5e9;
    padding: 12px 15px;
    text-align: left;
    border-radius: 8px 8px 0 0;
  }

  tbody tr:nth-child(even) {
    background-color: #f9f4ec;
  }

  tbody td {
    padding: 12px 15px;
    border-bottom: 1px solid #d6c2a6;
  }

  tbody td a {
    color: #5b3a29;
    text-decoration: none;
    font-weight: 600;
  }

  tbody td a:hover {
    text-decoration: underline;
  }

  .btn-link {
    background-color: #d9c7b3;
    color: #5b3a29;
    padding: 6px 12px;
    border-radius: 8px;
    font-weight: 600;
    text-decoration: none;
    margin-right: 8px;
    display: inline-block;
  }

  .btn-link:hover {
    background-color: #cbb7a3;
  }

  .btn-delete {
    background-color: #a94442;
    color: #fff2f0;
    border: none;
    padding: 6px 12px;
    border-radius: 8px;
    font-weight: 600;
    cursor: pointer;
  }

  .btn-delete:hover {
    background-color: #922d2b;
  }

  .actions {
    white-space: nowrap;
  }

  a.add-category {
    display: inline-block;
    background-color: #a67c52;
    color: #fff5e9;
    padding: 10px 20px;
    border-radius: 12px;
    font-weight: 700;
    text-decoration: none;
  }

  a.add-category:hover {
    background-color: #ba8f65;
  }
</style>

<div class="container w-800">
  <h1>게시판 목록</h1>
	<div class="cell right">
		<a class="btn btn-neutral" href="/admin/home">목록으로</a>
	</div>
  <table>
    <thead>
      <tr>
        <th>번호</th>
        <th>이름</th>
        <th>가능한 작업</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="categoryDto" items="${categoryList}">
        <tr>
          <td>${categoryDto.categoryNo}</td>
          <td><a href="./stats?categoryName=${categoryDto.categoryName}">${categoryDto.categoryName}</a></td>
          <td class="actions">
            <a class="btn-link" href="${pageContext.request.contextPath}/board/${categoryDto.categoryName}/list">이동</a>
            <a class="btn-link" href="edit?categoryNo=${categoryDto.categoryNo}">수정</a>
            <form method="post" action="delete" style="display:inline;" onsubmit="return confirm('정말 삭제하시겠습니까?');">
              <input type="hidden" name="categoryNo" value="${categoryDto.categoryNo}">
              <button type="submit" class="btn-delete">삭제</button>
            </form>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>

  <div style="text-align: center;">
  <a href="add" class="add-category">새로운 카테고리 등록</a>
</div>

</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp" />
