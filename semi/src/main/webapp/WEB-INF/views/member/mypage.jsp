<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

    <style>
        .green {
            color: rgb(126, 49, 35) !important;
        }
        .head {
            font-weight: bold;
        }
        .head:hover {
            cursor:pointer;
            color: rgb(126, 49, 35);
        }
        .title {
            padding: 0.3em;
        }
        .hr-details {
            border: solid 1px rgb(233, 231, 231);
        }
        .content {
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            color: rgb(82, 82, 82);
        }
        .no {
            color: rgb(165, 165, 165);
        }
    </style>
    
    <script type="text/javascript">
    $(function () {
        $(".head.write-board").addClass("green");
        $(".write-reply-code, .reply-board-code, .like-board-code").hide();

        $(".head").on("click", function(){
            $(".head").removeClass("green");
            $(this).addClass("green");
        });

        //클릭했을 떄 작성글 리스트 화면
        $(".write-board").on("click", function(){
            $(".write-board-code").show();
            $(".write-reply-code, .reply-board-code, .like-board-code").hide();
        });

        //클릭했을 때 작성댓글 리스트 화면
        $(".write-reply").on("click", function(){
            $(".write-reply-code").show();
            $(".write-board-code, .reply-board-code, .like-board-code").hide();
        });

        //클릭했을 떄 댓글단 글 리스트 화면
        $(".reply-board").on("click", function(){
            $(".reply-board-code").show();
            $(".write-board-code, .write-reply-code, .like-board-code").hide();
        });

        //클릭했을 떄 좋아요한 글 리스트 화면
        $(".like-board").on("click", function(){
            $(".like-board-code").show();
            $(".write-board-code, .write-reply-code, .reply-board-code").hide();
        });
    });
    </script>
    
    <div class="container w-900">
        <div class="cell">
            <table class="table">
                <tr>
                    <th>아이디</th>
                    <td>${memberDto.memberId }</td>
                </tr>
                <tr>
                    <th>닉네임</th>
                    <td>${memberDto.memberNickname }</td>
                </tr>
                <tr>
                    <th>이메일</th>
                    <td>${memberDto.memberEmail }</td>
                </tr>
                <tr>
                    <th>인증여부</th>
                    <td>${memberDto.memberAuth }</td>
                </tr>
                <tr>
                    <th>소개글</th>
                    <td>${memberDto.memberDescription }</td>
                </tr>
                <tr>
                    <th>포인트</th>
                    <td>${memberDto.memberPoint }</td>
                </tr>
                <tr>
                    <c:forEach var="animalDto" items="${animalList }">
                        <th>동물정보</th>
                        <td>
                            <div class="cell" data-animal-no="${animalDto.animalNo }">
                                <div class="cell">
                                    <span>동물 이름 : ${animalDto.animalName }</span>
                                </div>
                                <div class="cell">
                                    <span>동물 소개 : ${animalDto.animalContent }</span>
                                </div>
                                <div class="cell">
                                    <span>
                                        ${(animalDto.animalPermission == 'f')? "분양불가" : "분양가능"}
                                    </span>
                                </div>
                            </div>
                        <td>
                    </c:forEach>
                </tr>
            </table>
            <div class="cell">
                <a type="button" class="btn btn-neutral" href="edit">정보 수정하기</a>
                <a type="button" class="btn btn-neutral" href="password">비밀번호 변경</a>
                <a type="button" class="btn btn-negative" href="drop">회원 탈퇴하기</a>
            </div>
            <br><br>
            <div class="cell flex-box">
                <div class="w-15p center head write-board">작성글</div>
                <div class="w-15p center head write-reply">작성댓글</div>
                <div class="w-15p center head reply-board">댓글단 글</div>
                <div class="w-15p center head like-board">좋아요한 글</div>
                <div class="w-15p center head" style="margin-left: auto;">삭제한 게시글</div>
            </div>
            <hr>
            <div class="cell flex-box">
                <div class="w-80p center title">제목</div>
                <div class="w-10p center title">작성일</div>
                <div class="w-10p center title">조회</div>
            </div>
            <hr class="hr-details">
            <c:forEach var="board" items="${boardListVO}">
                <div class="cell flex-box content write-board-code">
                    <input class="w-5p center content" type="checkbox">
                    <div class="w-10p center content no">
                        ${board.boardNo }
                    </div>
                    <div class="w-65p content" style="padding: 0 1.5em 0 1.5em;">
                        ${board.boardTitle }
                    </div>
                    <div class="w-10p center content">
                        <fmt:formatDate value="${board.boardWtime}" pattern="yyyy.MM.dd" />
                    </div>
                    <div class="w-10p center content">
                        ${board.boardView }
                    </div>
                </div>
                <hr class="hr-details">
            </c:forEach>

            <!-- 작성댓글 코드 구간 -->
<%--             <c:forEach> --%>
                <div class="cell flex-box content write-reply-code"></div>
<%--             </c:forEach> --%>

            <!-- 댓글단 글 코드 구간 -->
<%--             <c:forEach> --%>
                <div class="cell flex-box content reply-board-code"></div>
<%--             </c:forEach>         --%>

            <!-- 좋아요한 글 코드 구간 -->
<%--             <c:forEach> --%>
                <div class="cell flex-box content like-board-code"></div>
<%--             </c:forEach> --%>

            <!-- 삭제한 게시글 추가 고민중 -->

            <div class="cell flex-box">
                <input class="w-5p" type="checkbox">
                <div class="w-10p" style="font-weight: bold;">전체선택</div>
                <button class="right">삭제</button>
                <button class="right">글쓰기</button>
            </div>
        </div>
    </div>


<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>