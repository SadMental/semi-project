<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/WEB-INF/views/template/header.jsp" />

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">

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

.badge {
	display: inline-block;
	padding: 2px 6px;
	font-size: 0.75rem;
	font-weight: 600;
	color: #fff;
	background-color: #a67c52;
	border-radius: 4px;
	margin-left: 10px;
	vertical-align: middle;
}

.reply-editor {
	width: 100%;
	resize: none;
}
</style>

<script>
$(function() {
    var params = new URLSearchParams(location.search);
    var boardNo = params.get("boardNo");

    // 좋아요 상태 확인
    $.get("/rest/board/check?boardNo=" + boardNo, function(response) {
        $("#board-like").toggleClass("fa-solid", response.like).toggleClass("fa-regular", !response.like);
        $("#board-like-count").text(response.count);
    });

    var isLoggedIn = <%=(session.getAttribute("loginId") != null ? "true" : "false")%>;
    if (isLoggedIn) {
        $("#board-like").css("cursor","pointer").on("click", function() {
            $.get("/rest/board/action?boardNo=" + boardNo, function(response){
                $("#board-like").toggleClass("fa-solid", response.like).toggleClass("fa-regular", !response.like);
                $("#board-like-count").text(response.count);
            }).fail(function(){ alert("좋아요 처리 중 오류가 발생했습니다."); });
        });
    } else {
        $("#board-like").css("cursor","default").on("click", function(){ alert("좋아요를 누르려면 로그인하세요."); });
    }

    // 댓글 목록 불러오기
    function loadList() {
        $.post("/rest/reply/list", { replyTarget: boardNo }, function(response){
            $(".reply-list-wrapper").empty();
            response.forEach(function(reply){
                var html = $($.parseHTML($("#reply-view-template").text()));
                $(html).find(".reply-writer").text(reply.replyWriter);
                if(reply.writer) $(html).find(".reply-writer").append("<span class='badge ms-10'>작성자</span>");
                $(html).find(".reply-content").text(reply.replyContent);
                $(html).find(".reply-time").text(moment(reply.replyWtime).fromNow());
                $(html).find(".fa-edit").attr("data-pk", reply.replyNo);
                $(html).find(".fa-trash").attr("data-pk", reply.replyNo);
                if(!reply.owner) $(html).find(".button-wrapper").remove();
                $(".reply-list-wrapper").append(html);
            });
        });
    }
    loadList();

    // 댓글 삭제
    $(".reply-list-wrapper").on("click", ".fa-trash", function(){
        if(!confirm("정말 삭제하시겠습니까?")) return;
        var replyNo = $(this).data("pk");
        $.post("/rest/reply/delete", { replyNo: replyNo }, loadList);
    });

    // 댓글 수정
    $(".reply-list-wrapper").on("click", ".fa-edit", function(){
        var replyNo = $(this).data("pk");
        var content = $(this).closest(".reply-wrapper").find(".reply-content").text();
        var html = $($.parseHTML($("#reply-edit-template").text()));
        $(html).find(".fa-check").attr("data-pk", replyNo);
        $(html).find(".reply-editor").val(content);
        $(this).closest(".reply-wrapper").hide().after(html);
    });

    // 댓글 수정 취소
    $(".reply-list-wrapper").on("click", ".fa-xmark", function(){
        $(this).closest(".reply-edit-wrapper").prev(".reply-wrapper").show();
        $(this).closest(".reply-edit-wrapper").remove();
    });

    // 댓글 수정 완료
    $(".reply-list-wrapper").on("click", ".fa-check", function(){
        var replyNo = $(this).data("pk");
        var replyContent = $(this).closest(".reply-edit-wrapper").find(".reply-editor").val();
        $.post("/rest/reply/edit", { replyNo: replyNo, replyContent: replyContent }, loadList);
    });

    // 댓글 작성
    $(".reply-btn-write").on("click", function(){
        var content = $(".reply-input").val();
        if(!content) return;
        $.post("/rest/reply/write", {
            replyTarget: boardNo,
            replyCategoryNo: ${boardDto.boardCategoryNo},
            replyContent: content
        }, function(){
            loadList();
            $(".reply-input").val("");
        });
    });
});
</script>

<div class="container w-800">
<c:if test="${not empty headerDto}">
    <tr>
       <h1> [${headerDto.headerName}]   ${boardDto.boardTitle}</h1>      
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
		</table>
	</div>

	<div class="content">
		<c:out value="${boardDto.boardContent}" escapeXml="false" />
	</div>

	<div class="cell right" style="margin-top: 10px;">
		<i id="board-like" class="fa-regular fa-thumbs-up"
			style="font-size: 1.8rem; color: #a67c52;"></i> <span
			id="board-like-count"
			style="font-size: 1.2rem; margin-left: 8px; color: #5b3a29;">0</span>
	</div>

	<div class="cell right">
		<a href="list" class="btn btn-neutral">목록으로</a>
		<c:if test="${sessionScope.loginId == boardDto.boardWriter}">
			<a href="edit?boardNo=${boardDto.boardNo}" class="btn btn-edit">수정하기</a>
			<form method="post" action="delete"
				onsubmit="return confirm('정말 삭제하시겠습니까?');" style="display: inline;">
				<input type="hidden" name="boardNo" value="${boardDto.boardNo}">
				<button type="submit" class="btn btn-delete">삭제하기</button>
			</form>
		</c:if>
	</div>

	<div class="reply-list-wrapper">댓글 목록 영역</div>

	<c:if test="${sessionScope.loginId != null}">
		<div class="reply-write-wrapper mt-30">
			<div class="cell">
				<textarea class="reply-input" rows="4"
					style="width: 100%; resize: none;" placeholder="댓글 내용 입력"></textarea>
			</div>
			<div class="cell right">
				<button type="button" class="btn btn-positive reply-btn-write">
					<i class="fa-solid fa-pen"></i> 댓글 작성하기
				</button>
			</div>
		</div>
	</c:if>
</div>

<script type="text/template" id="reply-view-template">
  <div class="reply-wrapper">
    <span class="reply-writer"></span>
    <span class="reply-time"></span>
    <p class="reply-content"></p>
    <div class="button-wrapper">
      <i class="fa fa-edit"></i>
      <i class="fa fa-trash"></i>
    </div>
  </div>
</script>

<script type="text/template" id="reply-edit-template">
  <div class="reply-edit-wrapper">
    <textarea class="reply-editor" rows="3" placeholder="댓글 수정"></textarea>
    <div class="button-wrapper">
      <i class="fa fa-check"></i>
      <i class="fa fa-xmark"></i>
    </div>
  </div>
</script>
<jsp:include page="/WEB-INF/views/template/footer.jsp" />