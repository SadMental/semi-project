<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<jsp:include page="/WEB-INF/views/template/header.jsp" />

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
	margin-bottom: 15px;
}
.meta {
	font-size: 0.95rem;
	color: #7a5a44;
	margin-bottom: 20px;
}
.content {
	font-size: 1.1rem;
	line-height: 1.6;
	min-height: 200px;
	border-top: 1px solid #d6c2a6;
	padding-top: 20px;
}
.cell.right {
	text-align: right;
	margin-top: 30px;
}
.btn {
	padding: 10px 20px;
	font-size: 1rem;
	border-radius: 10px;
	font-weight: 600;
	text-decoration: none;
	display: inline-block;
	margin-right: 10px;
}
.btn-edit {
  background-color: #a67c52;
  color: #fff5e9;
  border: none;
}
.btn-edit:hover {
  background-color: #ba8f65;
}
.btn-delete {
  background-color: #a94442;
  color: #fff2f0;
  border: none;
}
.btn-delete:hover {
  background-color: #922d2b;
}
.btn-neutral {
	background-color: #d9c7b3;
	color: #5b3a29;
	border: none;
}
.btn-neutral:hover {
	background-color: #cbb7a3;
}
</style>

<div class="container w-800">
	<c:if test="${not empty typeHeaderDto}">
	    <tr>
	       <h1> [${typeHeaderDto.headerName}]   ${boardDto.boardTitle}</h1>      
	    </tr>
	</c:if>


	<div class="meta">
		<table>
			<tr>
				<th>[번호] :</th>
				<td>${boardDto.boardNo}</td>
			</tr>
			<tr>
				<th>[작성자] :</th>
				<td>${boardDto.boardWriter}</td>
			</tr>
			<tr>
				<th>[작성일] :</th>
				<td>${boardDto.boardWtime}</td>
			</tr>
			<tr>
			    <th>[수정일] :</th>
			    <td>
			        <c:choose>
			            <c:when test="${not empty boardDto.boardEtime}">
			                <fmt:formatDate value="${boardDto.boardEtime}" pattern="yyyy-MM-dd HH:mm"/>
			            </c:when>
			            <c:otherwise>

			            </c:otherwise>
			        </c:choose>
			    </td>
		  	</tr>
			<tr>
			    <th>[동물 분류] :</th>
			    <td>
			        ${animalHeaderDto.headerName}
			    </td>
		  	</tr>
		</table>
	</div>

	<div class="content">
		<img src = "/board/fun/image?boardNo=${boardDto.boardNo}">
		<video src="/board/fun/video?boardNo=${boardDto.boardNo}" controls autoplay="autoplay"></video>
		<c:out value="${boardDto.boardContent}" escapeXml="false" />
	</div>

	<div class="cell right" style="margin-top: 10px;">
  		<i id="board-like" class="fa-regular fa-thumbs-up" style="font-size: 1.8rem; cursor: pointer; color: #a67c52;"></i>
    	<span id="board-like-count" style="font-size: 1.2rem; margin-left: 8px; color: #5b3a29;">0</span>
	</div>

	<div class="cell right">
		<a href="list" class="btn btn-neutral">목록으로</a>
		<a href="edit?boardNo=${boardDto.boardNo}" class="btn btn-edit">수정하기</a>

		<form method="post" action="delete"
      onsubmit="return confirm('정말 삭제하시겠습니까?');"
      style="display:inline;">

			<input type="hidden" name="boardNo" value="${boardDto.boardNo}">
			<button type="submit" class="btn btn-delete">삭제하기</button>
		</form>
	</div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
	$(function(){
	    var params = new URLSearchParams(location.search);
	    var boardNo = params.get("boardNo");
	
	    // 좋아요 상태 확인
	    $.ajax({
	        url:"/rest/board/check?boardNo=" + boardNo,
	        method:"get",
	        success:function(response){
	            if(response.like) {
	                $("#board-like").removeClass("fa-regular").addClass("fa-solid");
	            } else {
	                $("#board-like").removeClass("fa-solid").addClass("fa-regular");
	            }
	            $("#board-like-count").text(response.count);
	        }
	    });
	
	    // 로그인한 사용자만 좋아요 클릭 가능하도록 조건 추가 (jsp EL이용)
	    <%-- 로그인 아이디가 없으면 좋아요 클릭 막기 위해 flag 생성 --%>
	    var isLoggedIn = <%= (session.getAttribute("loginId") != null ? "true" : "false") %>;
	
	    if(isLoggedIn) {
	        $("#board-like").css("cursor", "pointer");
	
	        $("#board-like").on("click", function(){
	            $.ajax({
	                url:"/rest/board/action?boardNo=" + boardNo,
	                method:"get",
	                success:function(response){
	                    if(response.like) {
	                        $("#board-like").removeClass("fa-regular").addClass("fa-solid");
	                    } else {
	                        $("#board-like").removeClass("fa-solid").addClass("fa-regular");
	                    }
	                    $("#board-like-count").text(response.count);
	                },
	                error: function(){
	                    alert("좋아요 처리 중 오류가 발생했습니다.");
	                }
	            });
	        });
	    } else {
	        // 로그인 안 된 사용자에겐 클릭 시 경고 메시지 띄우기
	        $("#board-like").css("cursor", "default").on("click", function(){
	            alert("좋아요를 누르려면 로그인하세요.");
	        });
	    }
	});
</script>


<jsp:include page="/WEB-INF/views/template/footer.jsp" />