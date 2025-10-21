<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<!-- 댓글 처리 -->
<script type="text/javascript">
	$(function(){
		//로딩이 완료되면 현재 글에 대한 댓글을 조회
		var params = new URLSearchParams(location.search);
		var boardNo = params.get("boardNo");
		
		//**** 어쩔 수 없이 백엔드의 정보를 받아야 하는 상황 ****
		//- 세션은 백엔드의 고유 저장소이기 때문에 로그인한 사용자의 아이디는 JS에서 알 수 없음
		//- 백엔드에서 정보를 다 만들어서 제공하면 작성할 필요가 없는 구문
		//var loginId = "${sessionScope.loginId}";
		//var boardWriter = "${boardDto.boardWriter}";
		
		loadList();//최초 목록 호출
		
		function loadList() {//목록을 불러오는 함수
			$.ajax({
				url:"/rest/reply/list",
				method:"post",
				data:{ replyTarget : boardNo },
				success:function(response){//response는 List<ReplyDto>이다
					//댓글 목록 영역 청소
					//$(".reply-list-wrapper").html("");//text도 가능
					$(".reply-list-wrapper").empty();
					
					//댓글 화면 생성
					for(var i=0; i < response.length; i++) {
						var reply = response[i];
						//reply의 정보를 템플릿에 옮겨담아서 화면에 추가
						
						var origin = $("#reply-view-template").text();//표시용 템플릿 불러와서
						var html = $.parseHTML(origin);//HTML로 재해석하고
						$(html).find(".reply-writer-profile").attr("src", "/member/profile?memberId="+reply.replyWriter);
						$(html).find(".reply-writer").text(reply.replyWriter);//작성자 교체
						
						//if(작성자가 게시글 작성자 본인이라면) {
						//if(boardWriter.length > 0 && boardWriter == reply.replyWriter) {
						if(reply.writer == true) {
							$(html).find(".reply-writer").append("<span class='badge ms-10'>작성자</span>");
						}
						
						$(html).find(".reply-content").text(reply.replyContent);//댓글내용 교체
						//$(html).find(".reply-time").text(reply.replyWtime);//작성시각 교체
						//var wtime = moment(reply.replyWtime).format("YYYY-MM-DD HH:mm:ss");
						var wtime = moment(reply.replyWtime).fromNow();
						$(html).find(".reply-time").text(wtime);//작성시각 교체
						
						$(html).find(".fa-edit").attr("data-pk", reply.replyNo);//PK 설정
						$(html).find(".fa-trash").attr("data-pk", reply.replyNo);//PK 설정
						
						//if(비회원이거나 본인글이 아니면) {
						//if(loginId.length == 0 || loginId != reply.replyWriter) {
						if(reply.owner == false) {
							$(html).find(".button-wrapper").remove();
						}
						
						$(".reply-list-wrapper").append(html);//댓글 목록 영역에 추가
					}
				}
			});
		}
		
		//삭제 버튼 이벤트
		$(".reply-list-wrapper").on("click", ".fa-trash", function(){
			//if(loginId.length == 0) return;			
			
			var choice = window.confirm("정말 삭제하시겠습니까?");
			if(choice == false) return;
			
			var replyNo = $(this).data("pk");//this는 삭제아이콘 (data-pk)
			
			$.ajax({
				url:"/rest/reply/delete",
				method:"post",
				data:{ replyNo : replyNo },
				success:function(response){
					//해당 화면만 지우기 or 목록 전체를 갱신하기
					loadList();
				}
			});
		});
		
		//수정 버튼 이벤트
		// - 수정을 위하여 만들어둔 템플릿(아직없음)을 불러온다
		// - 현재 버튼이 속해있는 영역의 정보를 불러와서 작성한뒤 추가한다
		// - 현재 버튼이 속해있는 영역을 숨김 처리한다
		$(".reply-list-wrapper").on("click",  ".fa-edit", function(){
			//this == 클릭한 수정버튼
			var origin = $("#reply-edit-template").text();//편집용 화면을 불러와서
			var html = $.parseHTML(origin);//HTML로 재해석하고
			
			//var replyNo = $(this).attr("data-pk");
			var replyNo = $(this).data("pk");//읽기 명령만 존재
			var replyContent = $(this).closest(".reply-wrapper").find(".reply-content").text();
			$(html).find(".fa-check").attr("data-pk", replyNo);
			//$(html).find(".fa-check").data("pk", "?");//이런 명령은 없음
			$(html).find(".reply-editor").val(replyContent);//텍스트 편집기에 글자 설정
			
			$(".reply-wrapper").show();//표시용 화면을 모두 표시해주고
			$(".reply-edit-wrapper").remove();//기존에 만들어진 편집용 화면을 모두 지우고
			$(this).closest(".reply-wrapper").hide().after(html);//버튼이 속한 영역 뒤에 추가
		});
		
		//취소 버튼 이벤트
		$(".reply-list-wrapper").on("click", ".fa-xmark", function(){
			$(this).closest(".reply-edit-wrapper").prev(".reply-wrapper").show();//보기영역 표시
			$(this).closest(".reply-edit-wrapper").remove();//수정영역 제거
		});
		
		//완료 버튼 이벤트
		$(".reply-list-wrapper").on("click", ".fa-check", function(){
			//this == 완료버튼(수정영역)
			var replyNo = $(this).data("pk");
			var replyContent = $(this).closest(".reply-edit-wrapper")
														.find(".reply-editor").val();
			
			$.ajax({
				url:"/rest/reply/edit",
				method:"post",
				data: { replyNo : replyNo , replyContent : replyContent },
				success:function(response){
					loadList();
				}
			});
		});
		
		//댓글 등록 이벤트
		//$(document).on("click", ".reply-btn-write", function(){});//되긴 하지만 성능 소모가 심함
		$(".reply-btn-write").on("click", function(){
			var content = $(".reply-input").val();
			//if(content.trim().length == 0) return;
			if(content.length == 0) return;
			
			$.ajax({
				url:"/rest/reply/write",
				method:"post",
				data: { replyTarget : boardNo , replyContent : content },
				success:function(response){
					loadList();//목록 갱신
					$(".reply-input").val("");//입력내용 삭제
				}
			});
		});
	});
</script>


<!-- 댓글 표시용 템플릿 -->
<style>
	.reply-wrapper {
		display: flex;
	}
	.reply-profile-wrapper {
		width:100px;
		padding: 10px;
	}
	.reply-writer-profile {
		width:100%;
		border-radius: 50%;
		box-shadow: 0 0 1px 1px gray;
		overflow: hidden;
	}
	.reply-body-wrapper {
		flex-grow: 1;
		padding:10px;
	}
	.reply-writer {
		margin-top: 0;
		margin-bottom: 0;
	}
	.button-wrapper {
		text-align: right;
	}
	.reply-time {
		margin-top: 10px;
		color: gray;
	}
	.reply-edit-wrapper {
		padding:10px;
	}
</style>

<script type="text/template" id="reply-view-template">
	<div class="reply-wrapper">
		<div class="reply-profile-wrapper">
			<img class="reply-writer-profile">
		</div>
		<div class="reply-body-wrapper">
			<h3 class="reply-writer">작성자</h3>
			<pre class="reply-content">내용</pre>
			<div class="reply-time">yyyy-MM-dd HH:mm:ss</div>
			<div class="button-wrapper">
				<i class="fa-solid fa-2x fa-edit orange"></i>
				<i class="fa-solid fa-2x fa-trash red"></i>
			</div>
		</div>
	</div>
</script>
<script type="text/template" id="reply-edit-template">
	<div class="reply-edit-wrapper">
		<h3 class="reply-writer"></h3>
		<textarea class="reply-editor field w-100" rows="4" style="resize:none;"></textarea>
		<div class="button-wrapper">
			<i class="fa-solid fa-2x fa-xmark red"></i>
			<i class="fa-solid fa-2x fa-check blue"></i>
		</div>
	</div>
</script>

<!-- 좋아요 확인 -->
<script type="text/javascript">
	$(function(){
		var params = new URLSearchParams(location.search);
		var boardNo = params.get("boardNo");
		
		$.ajax({
			url:"/rest/board/check?boardNo=" + boardNo,
			method:"get",
			success:function(response){
				if (response.like)
				{
					$("#board-like").removeClass("fa-regular").addClass("fa-solid");
					$("#board-like-count").text(response.count);
				}
				else 
				{
					$("#board-like").removeClass("fa-solid").addClass("fa-regular");	
					$("#board-like-count").text(response.count);
				}
			}
		});
	});
</script>

<!-- 좋아요 -->
<script type="text/javascript">
	$(function(){
		$("#board-like").on("click", function(){
			$.ajax({
				url:"/rest/board/action?boardNo=${boardDto.boardNo}",
				method:"get",
				success:function(response){
					if (response.like)
					{
						$("#board-like").removeClass("fa-regular").addClass("fa-solid");
						$("#board-like-count").text(response.count);
					}
					else 
					{
						$("#board-like").removeClass("fa-solid").addClass("fa-regular");	
						$("#board-like-count").text(response.count);
					}
				}
			});
		});
	});
</script>


<h1>
	${boardDto.boardTitle} 
	<c:if test="${boardDto.boardEtime != null}">
	(수정됨)
	</c:if>
</h1>
<div>
<%-- 	${boardDto.boardWriter == null ? '탈퇴한사용자' : boardDto.boardWriter} --%>

	<c:choose>
		<c:when test="${memberDto == null}">탈퇴한사용자</c:when>
		<c:otherwise>
			<a href="/member/detail?memberId=${memberDto.memberId}">
				${memberDto.memberNickname}
			</a>  
<%-- 			(${memberDto.memberLevel}) --%>
		</c:otherwise>
	</c:choose>
</div>
<div>
	<fmt:formatDate value="${boardDto.boardWtime}" pattern="yyyy-MM-dd HH:mm"/> 
	조회수 ${boardDto.boardView}
</div>
<hr>
<div style="min-height: 200px">
	<pre>${boardDto.boardContent}</pre>
</div>
<hr>
<div>
	좋아요 <i id="board-like" class="fa-regular fa-heart red"></i> 
	<span id="board-like-count">?</span>  
<%-- 	댓글 ${boardDto.boardReply} --%>
</div>

<!-- 댓글 영역 -->
<div class = "reply-list-wrapper">목록 영역</div>
<div class = "reply-write-wrapper">
	<textarea class="field w-100 mt-50 reply-input" rows=4 style="resize:none" placeholder="댓글"></textarea>
	<div class="cell right">
		<button type="button" class="btn btn-positive reply-btn-write">
			<span>댓글 작성</span>
		</button>
	</div>
</div>

<hr>
<div>
	<a href="write">글쓰기</a> 
	<a href="write?boardOrigin=${boardDto.boardNo}">답글쓰기</a> 
	<%-- 내 글일 경우 수정 삭제를 모두 표시 --%>
	<c:if test="${sessionScope.loginId != null}">
		<c:choose>
			<c:when test="${sessionScope.loginId == boardDto.boardWriter}">
				<a href="update?boardNo=${boardDto.boardNo}">수정</a> 
				<a href="delete?boardNo=${boardDto.boardNo}">삭제</a>
			</c:when>
			<c:when test="${sessionScope.loginLevel == 2}">
				<a href="delete?boardNo=${boardDto.boardNo}">삭제</a>
			</c:when>
		</c:choose>
	</c:if>
	<a href="list">목록</a>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>
