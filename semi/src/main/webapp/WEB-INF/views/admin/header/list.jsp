<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="/WEB-INF/views/template/header.jsp" />
<link rel="stylesheet" type="text/css" href="/css/board_list.css">

<div class="container w-800">
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
                                  href="edit?headerNo=${header1.headerNo}">
                                   수정
                               </a>
                               <form action="delete" method="post" style="display:inline;">
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
       <a href="add" class="btn btn-positive">＋ 새 헤더 추가</a>
   </div>
</div>
<jsp:include page="/WEB-INF/views/template/footer.jsp" />


