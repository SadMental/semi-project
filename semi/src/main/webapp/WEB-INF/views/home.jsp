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
                    <c:forEach var="boardDto" items="${community_board_list}" varStatus="st">
                        <c:if test="${st.index % 2 == 0}">
                            <tr>
                        </c:if>

                        <td>
                            <div class="cell w-50 mt-5 mb-5 ms-5 me-5 left">
                                <label class="community-board-title">${boardDto.boardTitle}</label>
                                <div class="cell">
                                    <img src="/member/profile?member_id="+${boardDto.boardWriter} style="width:20px;">
                                    <label class="community-board-nickname"
                                        style="font-size:0.8em;">${boardDto.boardWriter}</label>
                                    <i class="fa-solid fa-eye"></i>
                                    <label class="community-board-view"
                                        style="font-size:0.8em;">${boardDto.boardView}</label>
                                    <i class="fa-solid fa-comment-dots"></i>
                                    <label class="community-board-reply"
                                        style="font-size:0.8em;">${boardDto.boardReply}</label>
                                    <i class="fa-solid fa-heart red"></i>
                                    <label class="community-board-like"
                                        style="font-size:0.8em;">${boardDto.boardLike}</label>
                                    <label class="community-board-time"
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
                <a href="/board/community/list" class="link">커뮤니티 더보기 ></a>
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
                <a href="/board/petfluencer/list" class="link">펫 플루언서 더보기 ></a>
            </div>

            <div class="cell ms-10 me-10">
                <label>FUN</label>
            </div>
            <div class="cell flex-box">
                <table>
                    <c:forEach var="boardDto" items="${fun_board_list}" varStatus="st">
                        <c:if test="${st.index % 2 == 0}">
                            <tr>
                        </c:if>
                        <td>
                            <div class="cell w-50 mt-5 mb-5 ms-5 me-5 left">
                            	<div class = "flex-box">
	                            	<img src="/board/fun/image?boardNo=${boardDto.boardNo}" style="width:60px;" class="left">
	                            	<div class="fun-container w-100p flex-box flex-vertical left">
                            			<a href="/board/fun/detail?boardNo=${boardDto.boardNo}" class="link">
			                                <label class="fun-board-title" style="height:75%;">${boardDto.boardTitle}</label>
			                                <div class="flex-box">
			                                	<i class="fa-solid fa-eye" style="color:gray;""></i> 
			                                	<label style="color:gray; font-size: 0.7em;">${boardDto.boardView}명이 이 콘텐츠를 보았어요!</label>
		                            		</div>
                            			</a>
	                            	</div>
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
                <a href="/board/fun/list" class="link">FUN 더보기 ></a>
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

		
        
    


<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>