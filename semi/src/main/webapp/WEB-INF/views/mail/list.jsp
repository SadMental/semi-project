<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<div class="container w-800">
	<div class="cell center">
		<h2>우편함</h2>
	</div>
	<div class="cell">
		<c:choose>
		<c:when test="${empty mailList}">
			<div class="no-posts">받은 우편이 없습니다.</div>
		</c:when>
		<c:otherwise>
			<div class="cell">
				<table>
					<thead>
						<tr>
							<th>제목</th>
							<th>보낸이</th>
							<th>받은 일자</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="mailDto" items="${mailList}">
							<tr>
								<td style="text-align: center;"><a
									href="detail?boardNo=${mailDto.mailNo}">${mailDto.mailTitle}</a>
								</td>
								<td>${mailDto.mailSender}</td>
								<td>${mailDto.mailWtime}</td>								
							</tr>
						</c:forEach>
					</tbody>
					<tfoot>
						<tr>
							<td colspan="7">
								검색결과 : 
								${pageVO.begin} - ${pageVO.end}
								/
								${pageVO.dataCount}개
							</td>
						</tr>
						
						<tr>
					        <td colspan="7" style="text-align: center;">
					            <jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
					        </td>
					    </tr>
					</tfoot>
				</table>
			</div>
		</c:otherwise>
	</c:choose>
	</div>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>