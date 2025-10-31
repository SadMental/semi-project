<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

    <style>
        .point-zone {
            background: linear-gradient(90deg, rgb(155, 189, 45) 0%, rgba(180, 219, 70, 1) 35%, rgba(253, 236, 179, 1) 100%);
            color: white;
            padding: 20px;
            border-radius: 13px;
        }

        .point-use {
            background-color: white;
            color: rgb(170, 161, 29);
            font-weight: bold;
            border: 1px solid white;
            border-radius: 9px;
            font-size: 20px;
            padding: 10px;
            text-decoration: none;
            position: absolute;
            top: -20px;
            right: 5px;
        }

        .move {
            text-decoration: none;
            color: black;
            margin-left: 5px;
        }

        .move:hover {
            color: rgb(122, 32, 5);
        }

        .bbt {
            font-size: 16px;
            color: #ffffff;
            width: 82px;
            height: 35px;
            border-radius: 8px;
            border: none;
            box-shadow: 0 0 10px rgba(161, 161, 161, 0.5);
            background-color: rgb(155, 189, 45);
            padding: 3px;
            cursor: pointer;
        }
/*         .reply-bonus, */
/*         .petfluencer-bonus, */
/*         .community-bonus, */
/*         .adoption-bonus, */
/*         .info-bonus { */
/*             display: none;  */
/*         } */
    </style>
    
    <script src="./confirm.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script type="text/javascript">
        $(function () {
            $(".bbt").on("click", function () {
                var text = "http://localhost:8080";

                navigator.clipboard.writeText(text)
                    .then(() => {
                        alert("복사가 완료되었습니다!");
                    })
                    .catch(err => {
                        console.error("클립보드 복사 실패: ", err);
                        alert("복사에 실패했습니다");
                    });
            });
            
            $(".point-use").on("click", function () {
            	if("${memberDto.memberPoint }" <= 0) {
            		alert("아직 펫콩이 부족해요. 다음에 따뜻한 마음을 전해볼까요? 🐶");
            		return;
            	} 
            	
            	
            	if(!confirm("한국유기동물복지협회(https://animalwa.org/)로 기부하시겠습니까?")){
            		return;
            	}
            	
            $.ajax({
            	url:"/member/usePoint",
            	method:"get",
            	data:{'a':'a'},
            	success: function(response) {
            		if(response == "success") {
            			alert("기부가 완료되었습니다.");
            			location.reload();
            		}
            	}
            });
            
            
            });
            
            var rewardType = "${rewardType}";
            if(rewardType) {
                switch(rewardType) {
                    case '댓글':
                        $(".reply-bonus").show();
                        break;
                    case '펫플루언서':
                        $(".petfluencer-bonus").show();
                        break;
                    case '자유게시판':
                        $(".community-bonus").show();
                        break;
                    case '분양게시판':
                        $(".adoption-bonus").show();
                        break;
                    case '정보게시판':
                        $(".info-bonus").show();
                        break;
                }
            }
            
            
        });

    </script>
    
    <div class="container mt-20" style="width: 850px">
        <div class="cell point-zone" style="position: relative; padding: 20px;">
            <div style="position: relative; z-index: 2; margin-bottom: 5px;">보유 펫콩</div>
            <div class="ms-10 point" style="font-weight: bold; font-size: 20px; position: relative; z-index: 2;">
                <i class="fa-solid fa-bone me-5" style="font-size: 20px;"></i>
                <span style="font-size: 25px;">
                <fmt:formatNumber value="${memberDto.memberPoint - memberDto.memberUsedPoint}" pattern="###,###"/>
                </span>
                <a href="" class="point-use">펫콩 기부하기</a>
            </div>
        </div>
        <div style="font-size: 10px; color: transparent;">빈공간1</div>
        <div class="cell flex-box" style="padding: 20px; border: 1px solid rgb(218, 216, 216); border-radius: 13px;">
            <div class="w-90p flex-box" style="align-items: center;">
                <i class="fa-solid fa-user-group me-10" style="color:rgb(76, 95, 15);"></i>
                <span>친구초대로 펫콩 얻기 (1,000p)</span>
            </div>
            <div class="w-10p">
                <button onclick="copyUrl('http://localhost:8080/')" class="bbt" type="button">링크 복사</button>
            </div>
        </div>
        <div style="font-size: 10px; color: transparent;">빈공간2</div>
        <div class="cell" style="padding: 20px; border: 1px solid rgb(218, 216, 216); border-radius: 13px;">
            <div class="cell flex-box">
                <div style="font-weight: 700; font-size: 18px;" class="w-70p">
                    <i class="fa-solid fa-flag mb-20 me-20" style="color: rgb(230, 233, 70);"></i>
                    펫콩 미션
                </div>
                <div class="cell w-30p" style="color: rgb(158, 157, 157); font-weight: 700; margin-left: 275px;">미션별 보상
                    내역</div>
            </div>
            <div style="color: transparent; font-size: 8px;">공백</div>
            <!-- 댓글쓰기---------------------------------------------------------------------------------- -->
            <div class="cell flex-box" style="align-items: center;">
                <i class="fa-solid fa-comment-dots w-5p"
                    style="color: rgb(101, 158, 8, 0.733); padding: 10px; font-size: 20px;"></i>
                <span class="w-5p ms-5" style="font-weight: 700; color: #5899ff">[일일]</span>
                <span class="w-15p" style="font-weight: 700;">
                    <a href="/" class="move ms-10">댓글 쓰기</a>
                </span>
                <span class="w-50p"></span>
                <span class="w-20p ms-30" style="color: gray;">
                    1회당 보상
                    <i class="fa-solid fa-bone ms-5" style="color: rgb(101, 158, 8, 0.733);"></i>
                    <span style="color: rgb(101, 158, 8, 0.733); font-weight: bold;" class="ms-5">20</span>
                </span>
            </div>
            <hr style="border: none; border-top: 1px solid rgb(218, 216, 216);">
            <!-- 펫플루언서 글쓰기---------------------------------------------------------------------------------- -->
            <div class="cell flex-box" style="align-items: center;">
                <i class="fa-solid fa-pen-to-square w-5p"
                    style="color: rgb(101, 158, 8, 0.733); padding: 10px; font-size: 20px;"></i>
                <span class="w-5p ms-5" style="font-weight: 700; color: #5899ff">[일일]</span>
                <span class="w-30p" style="font-weight: 700;">
                    <a href="/board/petfluencer/list" class="move ms-10">펫플루언서 글쓰기</a>
                </span>
                <span class="w-35p"></span>
                <span class="w-20p ms-30" style="color: gray;">
                    1회당 보상
                    <i class="fa-solid fa-bone ms-5" style="color: rgb(101, 158, 8, 0.733);"></i>
                    <span style="color: rgb(101, 158, 8, 0.733); font-weight: bold;" class="ms-5">50</span>
                </span>
            </div>
            <hr style="border: none; border-top: 1px solid rgb(218, 216, 216);">
            <!-- 자유게시판 글쓰기---------------------------------------------------------------------------------- -->
            <div class="cell flex-box" style="align-items: center;">
                <i class="fa-solid fa-pen-to-square w-5p"
                    style="color: rgb(101, 158, 8, 0.733); padding: 10px; font-size: 20px;"></i>
                <span class="w-5p ms-5" style="font-weight: 700; color: #5899ff">[일일]</span>
                <span class="w-30p" style="font-weight: 700;">
                    <a href="/board/community/list" class="move ms-10">자유게시판 글쓰기</a>
                </span>
                <span class="w-35p"></span>
                <span class="w-20p ms-30" style="color: gray;">
                    1회당 보상
                    <i class="fa-solid fa-bone ms-5" style="color: rgb(101, 158, 8, 0.733);"></i>
                    <span style="color: rgb(101, 158, 8, 0.733); font-weight: bold;" class="ms-5">50</span>
                </span>
            </div>
            <hr style="border: none; border-top: 1px solid rgb(218, 216, 216);">
            <!-- 분양게시판 글쓰기---------------------------------------------------------------------------------- -->
            <div class="cell flex-box" style="align-items: center;">
                <i class="fa-solid fa-pen-to-square w-5p"
                    style="color: rgb(101, 158, 8, 0.733); padding: 10px; font-size: 20px;"></i>
                <span class="w-5p ms-5" style="font-weight: 700; color: #5899ff">[일일]</span>
                <span class="w-30p" style="font-weight: 700;">
                    <a href="/board/adoption/list" class="move ms-10">분양게시판 글쓰기</a>
                </span>
                <span class="w-35p"></span>
                <span class="w-20p ms-30" style="color: gray;">
                    1회당 보상
                    <i class="fa-solid fa-bone ms-5" style="color: rgb(101, 158, 8, 0.733);"></i>
                    <span style="color: rgb(101, 158, 8, 0.733); font-weight: bold;" class="ms-5">60</span>
                </span>
            </div>
            <hr style="border: none; border-top: 1px solid rgb(218, 216, 216);">
            <!-- 정보게시판 글쓰기---------------------------------------------------------------------------------- -->
            <div class="cell flex-box" style="align-items: center;">
                <i class="fa-solid fa-pen-to-square w-5p"
                    style="color: rgb(101, 158, 8, 0.733); padding: 10px; font-size: 20px;"></i>
                <span class="w-5p ms-5" style="font-weight: 700; color: #5899ff">[일일]</span>
                <span class="w-30p" style="font-weight: 700;">
                    <a href="/board/info/list" class="move ms-10">정보게시판 글쓰기</a>
                </span>
                <span class="w-35p"></span>
                <span class="w-20p ms-30" style="color: gray;">
                    1회당 보상
                    <i class="fa-solid fa-bone ms-5" style="color: rgb(101, 158, 8, 0.733);"></i>
                    <span style="color: rgb(101, 158, 8, 0.733); font-weight: bold;" class="ms-5">70</span>
                </span>
            </div>

            <!-- <div class="cell mt-20">
                <span style="font-weight: 700; color: #5899ff">[일일] </span>
                <span style="font-weight: 700;">
                    <a href="#" class="move">하트(좋아요) 누르기</a>
                    자유게시판 링크
                </span>
                <span style="color: gray; margin-left: 40px;">
                    1회당 보상
                    <i class="fa-solid fa-bone ms-5" style="color: rgb(101, 158, 8, 0.733);"></i>
                    <span style="color: rgb(101, 158, 8, 0.733); font-weight: bold;" class="ms-5">10</span>
                </span>
            </div> -->
        </div>
        <div style="font-size: 10px; color: transparent;">빈공간1</div>
        <div class="cell" style="padding: 20px; border: 1px solid rgb(218, 216, 216); border-radius: 13px;">
            <div class="cell flex-box">
                <div style="font-weight: 700; font-size: 18px;" class="w-70p">
                    <i class="fa-brands fa-gratipay mb-20 me-20" style="color: rgb(230, 233, 70);"></i>
                    펫콩 획득 / 사용내역 (아직 미구현)
                </div>
            </div>
            <div style="color: transparent; font-size: 8px;">공백</div>
            <!-- 사용내역--------------------------------------------------------------------------------- -->
            <div class="cell flex-box reply-bonus" style="align-items: center;">
                <i class="fa-solid fa-coins me-10 w-5p"
                    style="color: rgb(96, 156, 0); padding: 10px; font-size: 20px;"></i>
                <span class="w-15p" style="font-weight: 700; color: gray">2025.10.29</span>
                <span class="w-30p" style="font-weight: 700;">
                    댓글 쓰기 보상
                </span>
                <div class="w-55p right"
                    style="margin-right: 55px; color: rgb(101, 158, 8, 0.733); font-weight: bold; font-size: 18px;">+20P
                </div>
            </div>
            <hr class="reply-bonus" style="border: none; border-top: 1px solid rgb(218, 216, 216);">
            <div class="cell flex-box petfluencer-bonus" style="align-items: center;">
                <i class="fa-solid fa-coins me-10 w-5p"
                    style="color: rgb(96, 156, 0); padding: 10px; font-size: 20px;"></i>
                <span class="w-15p" style="font-weight: 700; color: gray">2025.10.29</span>
                <span class="w-30p" style="font-weight: 700;">
                    펫플루언서 글쓰기 보상
                </span>
                <div class="w-55p right"
                    style="margin-right: 55px; color: rgb(101, 158, 8, 0.733); font-weight: bold; font-size: 18px;">+50P
                </div>
            </div>
            <hr class="petfluencer-bonus" style="border: none; border-top: 1px solid rgb(218, 216, 216);">
            <div class="cell flex-box community-bonus" style="align-items: center;">
                <i class="fa-solid fa-coins me-10 w-5p"
                    style="color: rgb(96, 156, 0); padding: 10px; font-size: 20px;"></i>
                <span class="w-15p" style="font-weight: 700; color: gray">2025.10.29</span>
                <span class="w-30p" style="font-weight: 700;">
                    자유게시판 글쓰기 보상
                </span>
                <div class="w-55p right"
                    style="margin-right: 55px; color: rgb(101, 158, 8, 0.733); font-weight: bold; font-size: 18px;">+50P
                </div>
            </div>
            <hr class="community-bonus"; style="border: none; border-top: 1px solid rgb(218, 216, 216);">
            <div class="cell flex-box adoption-bonus" style="align-items: center;">
                <i class="fa-solid fa-coins me-10 w-5p"
                    style="color: rgb(96, 156, 0); padding: 10px; font-size: 20px;"></i>
                <span class="w-15p" style="font-weight: 700; color: gray">2025.10.29</span>
                <span class="w-30p" style="font-weight: 700;">
                    분양게시판 글쓰기 보상
                </span>
                <div class="w-55p right"
                    style="margin-right: 55px; color: rgb(101, 158, 8, 0.733); font-weight: bold; font-size: 18px;">+60P
                </div>
            </div>
            <hr class="adoption-bonus"; style="border: none; border-top: 1px solid rgb(218, 216, 216);">
            <div class="cell flex-box info-bonus" style="align-items: center;">
                <i class="fa-solid fa-coins me-10 w-5p"
                    style="color: rgb(96, 156, 0); padding: 10px; font-size: 20px;"></i>
                <span class="w-15p" style="font-weight: 700; color: gray">2025.10.29</span>
                <span class="w-30p" style="font-weight: 700;">
                    정보게시판 글쓰기 보상
                </span>
                <div class="w-55p right"
                    style="margin-right: 55px; color: rgb(101, 158, 8, 0.733); font-weight: bold; font-size: 18px;">+70P
                </div>
            </div>
            <hr class="info-bonus"; style="border: none; border-top: 1px solid rgb(218, 216, 216);">
        </div>
    </div>
    
<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>