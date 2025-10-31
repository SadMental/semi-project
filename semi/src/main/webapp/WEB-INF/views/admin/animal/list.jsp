<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<div class="container w-600">
	<div class="cell right">
		<a class="btn btn-neutral" href="/admin/home">목록으로</a>
	</div>
	<table class="table table-border w-100p">
		<tr>
			<th>No.</th>
			<th>분양여부</th>
			<th>이름</th>
			<th>주인</th>
			<th>소개</th>
		</tr>
		<c:forEach var="animalDto" items="${animalList }">
			<tr>
				<td>
					<span>${animalDto.animalNo }</span>
				</td>
				<td>
					<span>${animalDto.animalPermission }</span>
				</td>
				<td>
					<a class="link" href="detail?animalNo=${animalDto.animalNo }">${animalDto.animalName }</a>
				</td>
				<td>
					<span>${animalDto.animalMaster }</span>
				</td>
				<td>
					<span>${animalDto.animalContent }</span>
				</td>
			</tr>
		</c:forEach>
		<tfoot>
			<tr>
				<td colspan="9">
					검색결과 : 
					${pageVO.begin} - ${pageVO.end}
					/
					${pageVO.dataCount}개
				</td>
			</tr>
			
			<tr>
		        <td colspan="9" style="text-align: center;">
		            <jsp:include page="/WEB-INF/views/template/pagination.jsp"></jsp:include>
		        </td>
		    </tr>
		</tfoot>
	</table>
</div>



<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>