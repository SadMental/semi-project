<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<style>
    .text-ellipsis {
        display: inline-block;
        /* 또는 block */
        width: 150px;
        /* 최대 너비 설정 */
        white-space: nowrap;
        /* 한 줄로 유지 */
        overflow: hidden;
        /* 넘친 텍스트 숨기기 */
        text-overflow: ellipsis;
        /* ... 표시 */
    }

    .cell.w-100p {
        display: flex;
        justify-content: space-between;
        /* 제목 왼쪽, 시간 오른쪽 */
        align-items: center;
        /* 수직 가운데 정렬 */
    }

    .new-board-title {
        display: inline-block;
        width: 130px;
        /* 길이 제한 */
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        /* ... 처리 */
        text-align: left;
    }

    .new-board-time {
        flex-shrink: 0;
        /* 시간 줄어들지 않게 */
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

            <div class="cell ms-10 me-10 center" style="background-color:green">
                <p>1</p>
                <p>2</p>
                <p>3</p>
                광고판인가?
                <p>4</p>
                <p>5</p>
                <p>6</p>
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
            <div class="cell ms-10 me-10 center" style="background-color:green">
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

            <div class="cell ms-10 me-10 center" style="background-color:green">
                <p>1</p>
                <p>2</p>
                광고판인가?
                <p>3</p>
                <p>4</p>
            </div>
        </div>

		
        
    


<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>