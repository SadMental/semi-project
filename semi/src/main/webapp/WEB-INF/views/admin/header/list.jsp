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
div class="container w-800">
   <h1>헤더 목록</h1>
   <c:choose>
       <c:when test="${empty headerList}">
           <div class="no-posts">등록된 헤더가 없습니다.</div>
       </c:when>
       <c:otherwise>
           <table>
               <thead>
                   <tr>
                       <th>번호</th>
                       <th>헤더 이름</th>
                       <th>관리</th>
                   </tr>
               </thead>
               <tbody>
                   <c:forEach var="header1" items="${headerList}">
                       <tr>
                           <td>${header1.headerNo}</td>
                           <td>${header1.headerName}</td>
                           <td>
                               <a class="btn btn-positive"
                                  href="${pageContext.request.contextPath}/admin/header/edit?headerNo=${header1.headerNo}">
                                   수정
                               </a>
                               <form action="${pageContext.request.contextPath}/admin/header/delete" method="post" style="display:inline;">
                                   <input type="hidden" name="headerNo" value="${header1.headerNo}">
                                   <button type="submit" class="btn btn-positive" style="background:#a94442;">삭제</button>
                               </form>
                           </td>
                       </tr>
                   </c:forEach>
               </tbody>
           </table>
       </c:otherwise>
   </c:choose>
   <div class="cell right">
       <a href="${pageContext.request.contextPath}/admin/header/add" class="btn btn-positive">＋ 새 헤더 추가</a>
   </div>
</div>
<jsp:include page="/WEB-INF/views/template/footer.jsp" />
