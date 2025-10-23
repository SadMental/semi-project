<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<style>
	.text-ellipsis {
	  display: inline-block;     /* 또는 block */
	  width: 150px;              /* 최대 너비 설정 */
	  white-space: nowrap;       /* 한 줄로 유지 */
	  overflow: hidden;          /* 넘친 텍스트 숨기기 */
	  text-overflow: ellipsis;   /* ... 표시 */
	}
	
	.new-board-title {
        float: left;
    }

    .new-board-time {
        float: right;
    }
</style>

<script type="text/template" id="ranking-template">
	<div class="cell w-100p flex-box">
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
    <div class="cell w-100">
        <span class="new-board-title">제목</span>
        <span class="new-board-time" style="color:#e67e22;">시간</span>
    </div>
</script>

<script type="text/javascript">
	$(function(){
		//newboard_list();
		ranking_list();
		
		function newboard_list() {
			$.ajax({
				url:"/rest/main/newboard",
				method:"post",
				data:{},
				success:function(response){
					$(".new-board-list-wrapper").empty();
					
//					for(var i=0; i < response.length; i++) {
//						console.log(response);
// 						var newboard = response[i];
						
// 						return;
						
// 						var origin = $("#new-board-template").text();
// 						var html = $.parseHTML(origin);
						
// 						$(html).find(".new-board-title").text(newboard.boardTitle);
// 						$(html).find(".new-board-time").text(newboard.boardTime);
						
// 						$(".new-board-list-wrapper").append(html);
//					}
				}
			});
		}
		
		function ranking_list() {
			$.ajax({
				url:"/rest/main/ranking",
				method:"post",
				data:{},
				success:function(response){
					$(".ranking-list-wrapper").empty();
					
					var number = 1;
					for(var i=0; i < response.length; i++) {
						var ranking = response[i];
						
						var origin = $("#ranking-template").text();
						var html = $.parseHTML(origin);
						
						$(html).find(".ranking-profile").attr("src", "/member/profile?member_id="+ranking.memberId);
						$(html).find(".number").text(number);
						number++;
						
						$(html).find(".ranking-nickname").text(ranking.memberNickname);
						$(html).find(".ranking-description").text(ranking.memberDescription);
						
						$(html).find(".ranking-member-point").text(ranking.memberPoint);
						
						$(".ranking-list-wrapper").append(html);
					}
				}
			});
		}
	});
</script>

<div class = "container w-1200">
	그냥 쓰담쓰담 따라서 메인 페이지 분할해봄
	<div class = "cell flex-box">
		<div class = "cell flex-vertical w-75p">
			<div class = "cell flex-box">
				<div class="cell ms-10 pe-10 center w-50p">
					<p>1</p>
					<p>2</p>
					메인				
					<p>3</p>
					<p>4</p>
				</div>
				
				<div class="cell ms-10 me-10 center w-50p">
					<p>1</p>
					<p>2</p>
					메인				
					<p>3</p>
					<p>4</p>
				</div>
			</div>
			
			<div class = "cell ms-10 me-10 center" style="background-color:green">
				<p>1</p>
				<p>2</p>
				<p>3</p>
				광고판인가?		
				<p>4</p>
				<p>5</p>
				<p>6</p>
			</div>
			
			<div class="cell ms-10 me-10">
				<label>커뮤니티</label>
			</div>
			<div class = "cell flex-box">			
				<div class="cell ms-10 me-10 center w-50p">
					<p>커뮤니티 1</p>
					<p>커뮤니티 3</p>
					<p>커뮤니티 5</p>
					<p>커뮤니티 7</p>
				</div>
				
				<div class="cell ms-10 me-10 center w-50p">
					<p>커뮤니티 2</p>
					<p>커뮤니티 4</p>	
					<p>커뮤니티 6</p>
					<p>커뮤니티 8</p>
				</div>
			</div>
			<div class="cell ms-10 me-10 center">
				<a href="/board/free/list" class="link">커뮤니티 더보기 ></a>
			</div>
			
			<div class="cell ms-10 me-10">
				<label>펫플루언서</label>
			</div>
			<div class = "cell ms-10 me-10 center" style="background-color:green">
					<p>1</p>
					<p>2</p>
					<p>3</p>
					펫플루언서 가로형 스크롤
					<p>4</p>
					<p>5</p>
					<p>6</p>
			</div>
			<div class="cell ms-10 me-10 center">
				<a href="#" class="link">펫 플루언서 더보기 ></a>
			</div>
			
			<div class="cell ms-10 me-10">
				<label>FUN</label>
			</div>
			<div class = "cell flex-box">			
				<div class="cell ms-10 me-10 center w-50p">
					<p>FUN 1</p>
					<p>FUN 3</p>
					<p>FUN 5</p>
					<p>FUN 7</p>
				</div>
				
				<div class="cell ms-10 me-10 center w-50p">
					<p>FUN 2</p>
					<p>FUN 4</p>
					<p>FUN 6</p>
					<p>FUN 8</p>
				</div>
			</div>
			<div class="cell ms-10 me-10 center">
				<a href="#" class="link">FUN 더보기 ></a>
			</div>
			
			<div class="cell ms-10 me-10">
				<label>쇼츠</label>
			</div>
			<div class = "cell ms-10 me-10 center" style="background-color:green">
					<p>1</p>
					<p>2</p>
					<p>3</p>
					쇼츠 가로형 스크롤
					<p>4</p>
					<p>5</p>
					<p>6</p>
			</div>			
			<div class="cell ms-10 me-10 center">
				<a href="#" class="link">쇼츠 더보기 ></a>
			</div>
			
			<div class="cell ms-10 me-10">
				<label>사용후기</label>
			</div>
			<div class = "cell ms-10 me-10 center" style="background-color:green">
				<p>1</p>
				<p>2</p>
				<p>3</p>
				사용후기 가로형 스크롤 1-3번 게시글 loop
				<p>4</p>
				<p>5</p>
				<p>6</p>
			</div>	
			<div class = "cell flex-box">			
				<div class="cell ms-10 me-10 center w-50p">
					<p>사용후기 4</p>
				</div>
				
				<div class="cell ms-10 me-10 center w-50p">
					<p>사용후기 5</p>
				</div>
			</div>
			<div class = "cell flex-box">			
				<div class="cell ms-10 me-10 center w-50p">
					<p>사용후기 6</p>
				</div>
				
				<div class="cell ms-10 me-10 center w-50p">
					<p>사용후기 7</p>
				</div>
			</div>
			<div class="cell ms-10 me-10 center">
				<a href="#" class="link">사용후기 더보기 ></a>
			</div>
			
			<div class="cell ms-10 me-10">
				<label>동물위키</label>
			</div>
			<div class = "cell flex-box">			
				<div class="cell ms-10 me-10 center w-100p">
					<p>동물위키 1</p>
				</div>
				<div class="cell ms-10 me-10 center w-100p">
					<p>동물위키 2</p>
				</div>
				<div class="cell ms-10 me-10 center w-100p">
					<p>동물위키 3</p>
				</div>
			</div>
			<div class = "cell flex-box">			
				<div class="cell ms-10 me-10 center w-100p">
					<p>동물위키 4</p>
				</div>
				<div class="cell ms-10 me-10 center w-100p">
					<p>동물위키 5</p>
				</div>
				<div class="cell ms-10 me-10 center w-100p">
					<p>동물위키 6</p>
				</div>
			</div>
			<div class="cell ms-10 me-10 center">
				<a href="#" class="link">동물위키 더보기 ></a>
			</div>
			
			<div class="cell ms-10 me-10">
				<label>체험단</label>
			</div>
			<div class = "cell flex-box">			
				<div class="cell ms-10 me-10 center w-50p">
					<p>체험단 1</p>
					<p>체험단 3</p>
					<p>체험단 5</p>
					<p>체험단 7</p>
				</div>
				
				<div class="cell ms-10 me-10 center w-50p">
					<p>체험단 2</p>
					<p>체험단 4</p>
					<p>체험단 6</p>
					<p>체험단 8</p>
				</div>
			</div>
			<div class="cell ms-10 me-10 center">
				<a href="#" class="link">체험단 더보기 ></a>
			</div>
			
			<div class = "cell ms-10 me-10 center" style="background-color:green">
				<p>1</p>
				<p>2</p>
				광고판인가?		
				<p>3</p>
				<p>4</p>
			</div>
		</div>
		
		
		<div class = "cell flex-vertical w-25p">
			<div class = "cell ms-10 me-10 center" style="background-color:red">
				<p>1</p>
				<p>2</p>
				<p>3</p>
				로그인 및 회원 정보				
				<p>4</p>
				<p>5</p>
				<p>6</p>
			</div>
			
			<div class = "cell ms-10 me-10">
				<label class="left" style="font-size: 1.4em; font-weight:bold;">새글</label>
				<div class = "new-board-list-wrapper center">새글 영역</div>
			</div>
			
			<div class = "cell ms-10 me-10">
				<label class="left" style="font-size: 1.4em; font-weight:bold;">랭킹</label>
				<div class = "ranking-list-wrapper center">랭킹 영역</div>
			</div>
		</div>
	</div>
</div>


<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>