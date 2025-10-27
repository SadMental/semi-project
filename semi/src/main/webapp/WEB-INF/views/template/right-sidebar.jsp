<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<script type="text/template" id="ranking-template">
	<div class="cell w-100p flex-box ranking-wrapper">
        <span class="number me-10">1</span>
        <img src="#" style="width:32px" class="ranking-profile ms-10">

        <div class="ranking-wrapper flex-box flex-vertical" style="width:60%">
            <span class="ranking-nickname left">닉네임</span>
            <span class="ranking-description text-ellipsis left" style="color:gray; font-size: 0.8em;">설명</span>
        </div>
        
        <div class="ranking-heart flex-box" style="width:30%">
            <i class="fa-solid fa-heart red"></i>
            <span class="ranking-member-point">100</span>
        </div>
    </div>
</script>
<script type="text/template" id="new-board-template">
    <div class="cell w-100p new-board-wrapper">
        <span class="new-board-title w-50p">제목</span>
        <span class="new-board-time w-50p" style="color:#e67e22;">시간</span>
    </div>
</script>

<script type="text/javascript">
	moment.locale('ko');
	
	$(function () {
	    /* newboard_list();
	    ranking_list();
	
	    free_board_list(); */
	    
	    Promise.all([
	    	newboard_list(),
	    	ranking_list()
	    ]).then(() => {
	    	free_board_list()
	    })
	
	    function newboard_list() {
	        return $.ajax({
	            url: "/rest/main/newboard",
	            method: "post",
	            data: {},
	            success: function (response) {
	                var wrapper = $(".new-board-list-wrapper")
	                wrapper.empty()
					var htmlBuffer = [];
					
	                for (var i = 0; i < response.length; i++) {
	                    var newboard = response[i];
	
	                    var html = $($.parseHTML($("#new-board-template").text()))
	                    
	
	                    html.find(".new-board-title").text(newboard.boardTitle);
	                    html.find(".new-board-time").text(newboard.formattedWtime);
	                    
	                    htmlBuffer.push(html);
	
	                    /* $(".new-board-list-wrapper").append(html); */
	                }
	                wrapper.append(htmlBuffer)
	            }
	        });
	    }
	
	    function ranking_list() {
	        return $.ajax({
	            url: "/rest/main/ranking",
	            method: "post",
	            data: {},
	            success: function (response) {
	                var wrapper = $(".ranking-list-wrapper")
	                wrapper.empty()
	                
	                var htmlBuffer = [];
	
	                var number = 1;
	                for (var i = 0; i < response.length; i++) {
	                    var ranking = response[i];
	
	                    /* var origin = $("#ranking-template").text(); */
	                    var html = $($.parseHTML($("#ranking-template").text()));
	
	                    html.find(".ranking-profile").attr("src", "/member/profile?member_id=" + ranking.memberId);
	                    html.find(".number").text(number);
	                    number++;
	
	                    html.find(".ranking-nickname").text(ranking.memberNickname);
	                    html.find(".ranking-description").text(ranking.memberDescription);
	
	                    html.find(".ranking-member-point").text(ranking.memberPoint);
	
	                    /* $(".ranking-list-wrapper").append(html); */
	                    htmlBuffer.push(html)
	                }
	                wrapper.append(htmlBuffer);
	            }
	        });
	    }
	
        function free_board_list() {
        	/* $(".free-board-time").each(function() {
    			var free_board_time_text = $(this).text().trim();
    			var free_board_time_time = moment(free_board_time_text);
				$(this).text(free_board_time_time.fromNow());
    		});  */
    		var times = $(".free-board-time")
    		if(times.length == 0) return
    		
    		var now = moment()
    		
    		times.each(function (){
    			var text = $(this).text().trim()
    			var time = moment(text)
    			$(this).text(time.from(now))
    		})
        }
	});
</script>

	<c:if test="${pageContext.request.requestURI != '/WEB-INF/views/member/join.jsp'}">
		 <div class="cell flex-box flex-vertical w-25p">
            <div class="cell ms-10 me-10 center">
            	<c:choose>
	            	<c:when test="${sessionScope.loginId != null && sessionScope.loginLevel == '1' }">
		                <a href="/member/logout" class="btn btn-neutral">로그아웃</a>
					</c:when>
					<c:when test="${sessionScope.loginId != null && sessionScope.loginLevel >= '2' }">
						<a href="/member/logout" class="btn btn-neutral">로그아웃</a>
					</c:when>
					<c:otherwise>
						<form action="/member/login" method="post">
							<div class="cell">
								<label>아이디</label>
								<input class="field w-100p" type="text" name="memberId">
							</div>
							<div class="cell">
								<label>비밀번호</label>
								<input class="field w-100p" type="password" name="memberPw">
							</div>
							<div class="cell center">
								<button class="btn btn-positive w-100p" type="submit">로그인</button>
							</div>
							<hr>
							<div class="cell center">
								<a href="/member/findId" class="link gray">아이디 찾기</a>
								<span class="gray">|</span>
								<a href="/member/findPw" class="link gray">비밀번호 찾기</a>
								<span class="gray">|</span>
								<a class="link gray" href="/member/join">회원가입</a>
							</div>
						</form>
					</c:otherwise>
            	</c:choose>
            </div>

            <div class="cell ms-10 me-10">
                <label class="left" style="font-size: 1.4em; font-weight:bold;">새글</label>
                <div class="new-board-list-wrapper center">새글 영역</div>
            </div>

            <div class="cell ms-10 me-10">
                <label class="left" style="font-size: 1.4em; font-weight:bold;">랭킹</label>
                <div class="ranking-list-wrapper center">랭킹 영역</div>
            </div>
        </div>
	</c:if>
