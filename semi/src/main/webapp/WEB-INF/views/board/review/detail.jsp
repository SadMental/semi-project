<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script src="https://cdn.jsdelivr.net/npm/twemoji@14.0.2/dist/twemoji.min.js" defer></script>
<jsp:include page="/WEB-INF/views/template/header.jsp" />
<link rel="stylesheet" type="text/css" href="/css/board_detail.css">

<div class="container w-800">
       <h1> [${boardDto.animalHeaderName}]   ${boardDto.boardTitle}</h1>      


	<div class="meta">
		<table>
			<tr>
				<th>[번호] :</th>
				<td>${boardDto.boardNo}</td>
			</tr>
			<tr>
				<th>[작성자]</th>
				<td>${boardDto.memberNickname}<c:if
						test="${not empty boardDto.badgeImage}">${boardDto.badgeImage}</c:if>
					<c:if test="${not empty boardDto.levelName}">
						<span class="level-badge">${boardDto.levelName}</span>
					</c:if>
				</td>
			</tr>
			<tr>
				<th>[작성일]</th>
				<td><fmt:formatDate value="${boardDto.boardWtime}"
						pattern="yyyy-MM-dd HH:mm" /></td>
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
		</table>
	</div>
	<div class="content">
		<img src = "/board/review/image?boardNo=${boardDto.boardNo}">
		<c:out value="${boardDto.boardContent}" escapeXml="false" />
	</div>
	
	<div class="cell right" style="margin-top: 10px;">
  		<i id="board-like" class="fa-regular fa-thumbs-up" style="font-size: 1.8rem; cursor: pointer; color: #a67c52;"></i>
    	<span id="board-like-count" style="font-size: 1.2rem; margin-left: 8px; color: #5b3a29;">0</span>
	</div>

	<div class="cell right">
		<a href="list" class="btn btn-neutral">목록으로</a>
		<c:if test="${boardDto.boardWriter == sessionScope.loginId || loginLevel == 0 }">
			<a href="edit?boardNo=${boardDto.boardNo}" class="btn btn-edit">수정하기</a>
	
			<form method="post" action="delete"
	      onsubmit="return confirm('정말 삭제하시겠습니까?');"
	      style="display:inline;">
	
				<input type="hidden" name="boardNo" value="${boardDto.boardNo}">
				<button type="submit" class="btn btn-delete">삭제하기</button>
			</form>
		</c:if>
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