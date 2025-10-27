<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<!-- swiper cdn -->
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@12/swiper-bundle.min.css" />
<script src="https://cdn.jsdelivr.net/npm/swiper@12/swiper-bundle.min.js"></script>

<style>
    .text-ellipsis {
        display: inline-block;
        width: 150px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }

    .cell.w-100p {
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .new-board-title {
        display: inline-block;
        width: 130px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        text-align: left;
    }

    .new-board-time {
        flex-shrink: 0;
        color: #e67e22;
        font-size: 0.9em;
        text-align: right;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        font-size: 1.05rem;
    }

    table thead {
        background-color: #e9d8c6;
    }

    table th,
    table td {
        padding: 14px 12px;
        border-bottom: 1px solid #d3bfa6;
        text-align: center;
    }

    table tr:hover {
        background-color: #f3eae1;
    }

    .swiper {
        width: 100%;
        height: 320px;
    }

    .swiper-slide {
        display: flex;
        justify-content: center;
    }

    .card {
        position: relative;
        width: 200px;
        border-radius: 10px;
        overflow: hidden;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15);
        font-family: sans-serif;
        background-color: white;
    }

    .card img {
        width: 100%;
        height: 260px;
        object-fit: cover;
        display: block;
    }

    .overlay-btn {
        position: absolute;
        top: 8px;
        left: 8px;
        background-color: rgba(255, 255, 255, 0.8);
        border: none;
        border-radius: 50%;
        padding: 6px;
        cursor: pointer;
    }

    .overlay-btn i {
        font-size: 16px;
        color: #333;
    }

    .like-badge {
        position: absolute;
        bottom: 68px;
        right: 8px;
        background-color: rgba(255, 64, 64, 0.9);
        color: white;
        font-size: 14px;
        border-radius: 10px;
        padding: 4px 8px;
        display: flex;
        align-items: center;
        gap: 4px;
    }

    .card-container {
        padding: 8px;
        padding-top:0px;
    }

    .card-title {
        font-weight: bold;
        font-size: 14px;
        margin: 4px 0;
    }

    .card-writer {
        font-size: 13px;
        color: #666;
    }

    .card-info {
        display: flex;
        align-items: center;
        font-size: 12px;
        color: gray;
        gap: 6px;
        margin-top: 2px;
    }
</style>

<script>
    moment.locale('ko');
</script>
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
	$(function () {
	    newboard_list();
	    ranking_list();
	    free_board_list();
	
	    function newboard_list() {
	        $.ajax({
	            url: "/rest/main/newboard",
	            method: "post",
	            success: function (response) {
	                $(".new-board-list-wrapper").empty();
	                for (var i = 0; i < response.length; i++) {
	                    var newboard = response[i];
	                    var origin = $("#new-board-template").text();
	                    var html = $.parseHTML(origin);
	                    $(html).find(".new-board-title").text(newboard.boardTitle);
	                    $(html).find(".new-board-time").text(newboard.formattedWtime);
	                    $(".new-board-list-wrapper").append(html);
	                }
	            }
	        });
	    }
	
	    function ranking_list() {
	        $.ajax({
	            url: "/rest/main/ranking",
	            method: "post",
	            success: function (response) {
	                $(".ranking-list-wrapper").empty();
	                var number = 1;
	                for (var i = 0; i < response.length; i++) {
	                    var ranking = response[i];
	                    var origin = $("#ranking-template").text();
	                    var html = $.parseHTML(origin);
	                    $(html).find(".ranking-profile").attr("src", "/member/profile?member_id=" + ranking.memberId);
	                    $(html).find(".number").text(number++);
	                    $(html).find(".ranking-nickname").text(ranking.memberNickname);
	                    $(html).find(".ranking-description").text(ranking.memberDescription);
	                    $(html).find(".ranking-member-point").text(ranking.memberPoint);
	                    $(".ranking-list-wrapper").append(html);
	                }
	            }
	        });
	    }
	
        function free_board_list() {
        	$(".free-board-time").each(function() {
    			var free_board_time_text = $(this).text().trim();
    			var free_board_time_time = moment(free_board_time_text);
				$(this).text(free_board_time_time.fromNow());
    		});
        }
	});
</script>

<script type="text/javascript">
$(function () {
    var swiper = new Swiper(".swipers", {
        slidesPerView: 4.8,
        spaceBetween: 20,
        loop: true,
        speed: 800,
        autoplay: {
            delay: 5000,
            disableOnInteraction: false,
        },
        slidesPerGroup: 1,
    });
});
</script>

<div class="container w-1200">
    <div class="cell flex-box">
        <div class="cell flex-vertical w-75p">
            <div class="cell flex-box">
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

            <div class="cell ms-10 me-10">
            	<i class="fa-solid fa-comment-sms"></i>
                <label>커뮤니티</label>
            </div>
            <div class="cell flex-box">
                <!-- 			테이블 한 줄에 2행씩 찍는 방법 -->
                <table>
                    <c:forEach var="boardDto" items="${free_board_list}" varStatus="st">
                        <c:if test="${st.index % 2 == 0}">
                            <tr>
                        </c:if>

                        <td>
                            <div class="cell w-50 mt-5 mb-5 ms-5 me-5 left">
                                <label class="free-board-title">${boardDto.boardTitle}</label>
                                <div class="cell">
                                    <img src="#" style="width:20px;">
                                    <label class="free-board-nickname"
                                        style="font-size:0.8em;">${boardDto.boardWriter}</label>
                                    <i class="fa-solid fa-eye"></i>
                                    <label class="free-board-view"
                                        style="font-size:0.8em;">${boardDto.boardView}</label>
                                    <i class="fa-solid fa-comment-dots"></i>
                                    <label class="free-board-reply"
                                        style="font-size:0.8em;">${boardDto.boardReply}</label>
                                    <i class="fa-solid fa-heart red"></i>
                                    <label class="free-board-like"
                                        style="font-size:0.8em;">${boardDto.boardLike}</label>
                                    <label class="free-board-time"
                                        style="font-size:0.8em;">${boardDto.boardWtime}</label>
                                </div>
                            </div>
                        </td>

                        <c:if test="${st.index % 2 == 1}">
                            </tr>
                        </c:if>
                    </c:forEach>

                    <!-- 				홀수 개일 때 마지막 행 닫기 -->
                    <c:if test="${numbers.size() % 2 != 0}">
                        </tr>
                    </c:if>
                </table>
            </div>
            <div class="cell ms-10 me-10 center">
                <a href="/board/free/list" class="link">커뮤니티 더보기 ></a>
            </div>

           <div class="cell ms-10 me-10">
                <label>펫플루언서</label>
            </div>
            <div class="cell ms-10 me-10 center">
                <div class="swiper swipers">
                    <div class="swiper-wrapper">
                        <c:forEach var="boardDto" items="${petfluencer_board_list}">
                            <div class="swiper-slide">
                                <div class="card">
                                	<a href="/board/petfluencer/detail?boardNo=${boardDto.boardNo}" class="link">
	                                    <img src="/board/petfluencer/image?boardNo=${boardDto.boardNo}">
	                                    <button class="overlay-btn"><i class="fa fa-camera"></i></button>
	                                    <div class="like-badge"><i class="fa fa-heart"></i> ${boardDto.boardLike}</div>
	                                    <div class="card-container">
	                                        <div class="card-title">${boardDto.boardTitle}</div>
	                                        <div class="card-writer">${boardDto.boardWriter}</div>
	                                        <div class="card-info">
	                                            <i class="fa fa-eye"></i> ${boardDto.boardView}
	                                            <i class="fa fa-comment"></i> ${boardDto.boardReply}
	                                        </div>
	                                    </div>
                                	</a>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </div>
            </div>
            <div class="cell ms-10 me-10 center">
                <a href="#" class="link">펫 플루언서 더보기 ></a>
            </div>

            <div class="cell ms-10 me-10">
                <label>FUN</label>
            </div>
            <div class="cell flex-box">
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
            <div class="cell ms-10 me-10 center" style="background-color:green">
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
            <div class="cell ms-10 me-10 center" style="background-color:green">
                <p>1</p>
                <p>2</p>
                <p>3</p>
                사용후기 가로형 스크롤 1-3번 게시글 loop
                <p>4</p>
                <p>5</p>
                <p>6</p>
            </div>
            <div class="cell flex-box">
                <div class="cell ms-10 me-10 center w-50p">
                    <p>사용후기 4</p>
                </div>

                <div class="cell ms-10 me-10 center w-50p">
                    <p>사용후기 5</p>
                </div>
            </div>
            <div class="cell flex-box">
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
            <div class="cell flex-box">
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
            <div class="cell flex-box">
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
            <div class="cell flex-box">
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
        </div>


        <div class="cell flex-vertical w-25p">
            <div class="cell ms-10 me-10 center" style="background-color:red">
                <p>1</p>
                <p>2</p>
                <p>3</p>
                로그인 및 회원 정보
                <p>4</p>
                <p>5</p>
                <p>6</p>
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
    </div>
</div>


<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>