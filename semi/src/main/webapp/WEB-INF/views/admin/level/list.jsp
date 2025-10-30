<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp" />

<style>

</style>

<div class="container w-800">
  <h1>회원 등급 목록</h1>
  	<div class="cell right">
		<a class="btn btn-neutral" href="/admin/home">목록으로</a>
	</div>

  <div style="text-align: right; margin-bottom: 20px;">
    <a href="${pageContext.request.contextPath}/admin/level/add" class="btn btn-positive	">등급 추가</a>

    <form action="${pageContext.request.contextPath}/admin/level/updateAll" method="post" style="display:inline;">
      <button type="submit" class="btn btn-neutral">전체 등급 갱신</button>
    </form>
  </div>

  <table>
    <thead>
      <tr>
        <th>번호</th>
        <th>등급명</th>
        <th>최소 포인트</th>
        <th>최대 포인트</th>
        <th>설명</th>
        <th>관리</th>
      </tr>
    </thead>
    <tbody>
      <c:forEach var="level" items="${levels}">
        <tr>
          <td>${level.levelNo}</td>
          <td><a href="${pageContext.request.contextPath}/admin/level/detail?levelNo=${level.levelNo}">${level.levelName}</a></td>
          <td>${level.minPoint}</td>
          <td>${level.maxPoint}</td>
          <td>${level.description}</td>
          <td class="actions">
            <a class="btn-link" href="${pageContext.request.contextPath}/admin/level/edit?levelNo=${level.levelNo}">수정</a>

            <form method="post" action="${pageContext.request.contextPath}/admin/level/delete" style="display:inline;" onsubmit="return confirm('정말 삭제하시겠습니까?');">
              <input type="hidden" name="levelNo" value="${level.levelNo}">
              <button type="submit" class="btn-delete">삭제</button>
            </form>
          </td>
        </tr>
      </c:forEach>
    </tbody>
  </table>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp" />
