<%@ page contentType="text/html; charset=UTF-8" %>
<jsp:include page="/WEB-INF/views/template/header.jsp" />
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style>
  body {
    background-color: #f4ede6;
    color: #5b3a29;
    margin: 0;
    padding: 0;
  }

  .container.w-400 {
    max-width: 400px;
    margin: 60px auto;
    padding: 30px 35px;
    border-radius: 15px;
    background-color: #ffffffdd;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
    font-family: 'Noto Sans KR', sans-serif;
  }

  h1 {
    font-size: 2rem;
    font-weight: 700;
    margin-bottom: 30px;
    text-align: center;
  }

  label {
    display: block;
    font-weight: 600;
    margin-bottom: 8px;
  }

  input[type="text"] {
    width: 100%;
    padding: 10px 12px;
    border: 1px solid #d6c2a6;
    border-radius: 10px;
    font-size: 1rem;
    color: #5b3a29;
    box-sizing: border-box;
    margin-bottom: 25px;
  }

  .button-group {
  text-align: center;
  display: flex;
  justify-content: center;
  gap: 20px; /* 버튼 사이 간격 */
  margin-top: 20px;
}

button[type="submit"], a.cancel-link {
  flex: 1;           /* 버튼과 링크가 같은 너비를 가지도록 */
  padding: 12px 0;
  border-radius: 12px;
  font-weight: 700;
  font-size: 1.1rem;
  text-align: center;
  cursor: pointer;
  box-sizing: border-box;
  display: inline-block;
  text-decoration: none;
  line-height: 1.2rem;
}

button[type="submit"] {
  background-color: #a67c52;
  color: #fff5e9;
  border: none;
  transition: background-color 0.3s ease;
}

button[type="submit"]:hover {
  background-color: #ba8f65;
}

a.cancel-link {
  background-color: #d9c7b3;
  color: #5b3a29;
  border: none;
  line-height: normal;
  display: flex;
  align-items: center;
  justify-content: center;
  user-select: none;
  transition: background-color 0.3s ease;
}

a.cancel-link:hover {
  background-color: #cbb7a3;
}

  }
</style>

<div class="container w-400">
  <h1>카테고리 수정</h1>

  <form action="edit" method="post">
    <input type="hidden" name="categoryNo" value="${categoryDto.categoryNo}" />

    <label for="categoryName">카테고리 이름:</label>
    <input type="text" id="categoryName" name="categoryName" value="${categoryDto.categoryName}" required autocomplete="off" />

    <div class="button-group">
      <button type="submit">수정 완료</button>
      <a href="list" class="cancel-link">취소</a>
    </div>
  </form>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp" /><%@ page contentType="text/html; charset=UTF-8" %>
<jsp:include page="/WEB-INF/views/template/header.jsp" />
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
</style>
<div class="container w-800">
 <h1>헤더 수정</h1>
 <form action="${pageContext.request.contextPath}/admin/header/edit" method="post">
     <input type="hidden" name="headerNo" value="${headerDto.headerNo}">
     <label for="headerName">헤더 이름</label>
     <input type="text" id="headerName" name="headerName" value="${headerDto.headerName}" required>
     <div class="cell right">
         <button type="submit" class="btn btn-positive">수정 완료</button>
         <a href="${pageContext.request.contextPath}/admin/header/list" class="btn btn-positive">목록으로</a>
     </div>
 </form>
</div>
<jsp:include page="/WEB-INF/views/template/footer.jsp" />

