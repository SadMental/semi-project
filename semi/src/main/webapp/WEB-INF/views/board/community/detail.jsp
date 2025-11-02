<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/WEB-INF/views/template/header.jsp" />
<link rel="stylesheet" type="text/css" href="/css/board_detail.css">
<script src="https://cdn.jsdelivr.net/npm/twemoji@14.0.2/dist/twemoji.min.js" defer></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">

	<style>
		.reply-write-wrapper {
			background: #fffaf7;
			border: 1px solid #e6d4c3;
			border-radius: 15px;
			padding: 15px 18px 20px;
			margin-top: 25px;
			box-shadow: 0 4px 12px rgba(166, 124, 82, 0.08);
			position: relative;
			transition: all 0.2s ease;
		}
		.reply-write-wrapper:focus-within {
			box-shadow: 0 6px 16px rgba(166, 124, 82, 0.15);
			transform: translateY(-2px);
		}

		.reply-input {
			width: 100%;
			min-height: 90px;
			resize: none;
			padding: 10px 15px;
			border-radius: 10px;
			border: 1px solid #d9c7b3;
			background: #fffefb;
			font-size: 1rem;
			line-height: 1.5;
			color: #5b3a29;
			box-shadow: inset 0 2px 4px rgba(0,0,0,0.03);
			transition: border-color 0.2s ease, box-shadow 0.2s ease;
		}
		.reply-input:focus {
			outline: none;
			border-color: #a67c52;
			box-shadow: 0 0 0 3px rgba(166,124,82,0.15);
		}
		
		.reply-write-wrapper .cell.right {
			display: flex;
			justify-content: flex-end;
			align-items: center;
			gap: 10px;
			margin-top: 10px;
			position: relative;
		}
		
		.btn-emoji {
			background: none;
			border: none;
			color: #a67c52;
			font-size: 1.8rem;
			cursor: pointer;
			padding: 0;
			margin-right: 10px;
			transition: transform 0.15s ease, color 0.2s;
		}
		.btn-emoji:hover {
			color: #5b3a29;
			transform: rotate(8deg) scale(1.1);
		}

		.reply-btn-write {
		 
		    background-color: #5d9cec; 
		    color: #fff;
		    border: none;
		    border-radius: 10px;
		    padding: 10px 20px;
		    font-weight: 600;
		    font-size: 0.95rem;
		    cursor: pointer;
		    transition: background-color 0.25s ease, transform 0.1s ease;
		}
		.reply-btn-write:hover {
		  
		    background-color: #4a8ad8;
		    transform: translateY(-2px);
		}
		.reply-btn-write:active {
		    transform: translateY(0);
		}
		/* 😄 이모지 선택 팝업 */
		.emoji-picker-container {
			display: none;
			position: absolute;
			right: 0;
			bottom: 110%;
			margin-bottom: 8px;
			background: #fffefb;
			border: 1px solid #d3bfa6;
			border-radius: 15px;
			box-shadow: 0 6px 15px rgba(0,0,0,0.1);
			padding: 10px;
			max-width: 260px;
			max-height: 200px;
			overflow-y: auto;
			z-index: 99999;
			right: 0;
		}
		.emoji-picker-container img.emoji {
			width: 28px;
			height: 28px;
			cursor: pointer;
			margin: 5px;
			transition: transform 0.15s;
		}
		.emoji-picker-container img.emoji:hover {
			transform: scale(1.3);
		}
		/* 댓글 수정 모드 스타일 */
		.reply-editor {
		   width: 100%;
		   min-height: 70px;
		   resize: vertical;
		   padding: 10px;
		   border-radius: 10px;
		   border: 1px solid #d9c7b3;
		   background: #fffefb;
		   font-size: 1rem;
		   line-height: 1.5;
		   color: #5b3a29;
		   box-shadow: inset 0 2px 4px rgba(0,0,0,0.03);
		   margin-bottom: 10px;
		}
		.reply-wrapper .btn-save, .reply-wrapper .btn-cancel {
			margin-left: 5px;
		}
		.emoji-picker-container img.emoji {
		 pointer-events: auto !important;
		 cursor: pointer;
		}
		.reply-content img.emoji {
			width: 1.4em; 
			height: 1.4em;
			vertical-align: middle;
		}
	</style>	
		

		<script>
		$(document).ready(function() {
		    const boardNo = ${boardDto.boardNo};
			   
		    if (!boardNo) return;
		    
		    // ====================== 📌 게시글 좋아요 (Board Like) 로직 추가 ======================
		    
		    // JSP를 사용하여 로그인 상태를 클라이언트 변수로 가져옵니다.
		    var isLoggedIn = <%=(session.getAttribute("loginId") != null ? "true" : "false")%>;
		    
		    // 1. 초기 좋아요 상태 및 카운트 확인
		    $.get("/rest/board/check?boardNo=" + boardNo, function(response) {
		        $("#board-like").toggleClass("fa-solid", response.like).toggleClass("fa-regular", !response.like);
		        $("#board-like-count").text(response.count);
		    });

		    // 2. 좋아요 클릭 이벤트 처리
		    if (isLoggedIn) {
		        $("#board-like").css("cursor","pointer").on("click", function() {
		            $.get("/rest/board/action?boardNo=" + boardNo, function(response){
		                $("#board-like").toggleClass("fa-solid", response.like).toggleClass("fa-regular", !response.like);
		                $("#board-like-count").text(response.count);
		            }).fail(function(){ console.error("좋아요 처리 중 오류가 발생했습니다."); }); // alert() 대신 console.error 사용
		        });
		    } else {
		        $("#board-like").css("cursor","default").on("click", function(){ console.warn("좋아요를 누르려면 로그인하세요."); }); // alert() 대신 console.warn 사용
		    }
		    
		    // ====================== 💬 댓글 (Reply) 로직 시작 ======================
			const emojiContainer = $('#emoji-picker-container');
			const emojiButton = $('#emoji-btn');
			const replyInput = $('.reply-input');

			const loginId = "${sessionScope.loginId}";
			let currentSort = "time";
			
			function formatTime(timestamp) {
			      
			    if (typeof moment !== 'undefined') {
			        moment.locale('ko');
			        const now = moment();
			        const time = moment(timestamp);
			          
			        // 하루 이내면 '몇 시간 전'/'몇 분 전'
			        if (now.diff(time, 'days') < 1) {
			            return time.fromNow();
			        }
			        // 같은 해면 'MM-DD HH:mm'
			        else if (now.year() === time.year()) {
			            return time.format('MM-DD HH:mm');
			        }
			        // 아니면 'YYYY-MM-DD HH:mm'
			        else {
			            return time.format('YYYY-MM-DD HH:mm');
			        }
			    }
			    return timestamp; // Moment.js가 없으면 원본 반환
			}
			// 💡 Twemoji 파싱 함수
			function safeTwemojiParse(element) {
			    if (typeof twemoji !== 'undefined') {
			        // 외부 라이브러리 로딩 시점에 따라 지연 실행
			        setTimeout(() => {
			            twemoji.parse(element, { folder: 'svg', ext: '.svg' });
			        }, 50); // 약간의 딜레이를 주어 안정성 확보
			    }
			}
			  
			// ---------------------- 🎨 이모지 목록 설정 ----------------------
			const emojiList = ["😀","😂","😍","🤣","😅","😊","🥰","😘","😎","🤩","🥳","🤔","😮","😇","😋","🎉","🎁","🎂","🎈","✨","🦄","🐶","❤️"];
			emojiContainer.html(emojiList.join(''));
			safeTwemojiParse(emojiContainer[0]); // 초기 이모지 파싱
			let emojiOpen = false;
			emojiButton.on('click', function(e) {
			    e.stopPropagation();
			    emojiContainer.toggle();
			    emojiOpen = !emojiOpen;
			});
			$(document).on('click', function(e) {
			    if (emojiOpen && !$(e.target).closest('#emoji-picker-container, #emoji-btn').length) {
			        emojiContainer.hide();
			        emojiOpen = false;
			    }
			});
			emojiContainer.on('click', 'img.emoji', function() {
			    const emoji = $(this).attr('alt'); // alt 속성에서 이모지 문자 추출
			    const input = replyInput[0];
			    const start = input.selectionStart, end = input.selectionEnd;
			    input.value = input.value.substring(0, start) + emoji + input.value.substring(end);
			    input.selectionStart = input.selectionEnd = start + emoji.length;
			    input.focus();
			    emojiContainer.hide();
			    emojiOpen = false;
			});
			// ---------------------- 🔄 댓글 정렬 버튼 ----------------------
			$(".sort-buttons .btn-sort").on("click", function() {
			    const sortType = $(this).data("sort");
			    if (currentSort !== sortType) {
			        currentSort = sortType;
			        $(".sort-buttons .btn-sort").removeClass("active");
			        $(this).addClass("active");
			        loadList();
			    }
			});
			// 💬 댓글 목록 불러오기
			function loadList() {
			    $(".reply-list-wrapper").html('<div style="text-align:center; padding:20px; color:#a67c52;">댓글을 불러오는 중입니다...</div>');
			   
			    // ⭐ DAO/Controller에서 loginId를 사용하여 isLiked를 계산하므로, loginId를 함께 전달합니다.
			    const requestData = { replyTarget: boardNo, sort: currentSort, loginId: loginId }; // loginId는 빈 문자열이더라도 전달
			   
			    $.ajax({
			        url: "/rest/reply/list",
			        method: "GET",
			        data: requestData,
			        dataType: "json",
			        success: function(resp) {
			            const list = resp.list || [];
			            $("#reply-count").text(resp.boardReply || 0);
			            $(".reply-list-wrapper").empty();
			            if (list.length === 0) {
			                $(".reply-list-wrapper").html('<div style="text-align:center; padding:20px; color:#a67c52;">아직 댓글이 없습니다.</div>');
			            } else {
			                list.forEach(reply => {
			                    // ⭐ isOwner/isWriter는 RestController에서 ReplyListVO에 이미 설정되어 넘어오므로
			                    // 여기서 다시 로그인 ID와 비교할 필요 없이 바로 사용합니다.
			                    const isOwner = reply.owner;
			                    const isWriter = reply.writer;
			                    const writerBadge = isWriter ? '<span style="color:#7b4e36; font-size:0.85em; margin-left:5px;">(글쓴이)</span>' : '';
			                   
			                    // ⭐ 서버에서 넘어온 reply.isLiked 값에 따라 초기 아이콘 클래스를 설정합니다.
			                    const heartIconClass = reply.isLiked ? 'fa-solid' : 'fa-regular';
			                    const likeSpanClass = reply.isLiked ? 'active' : '';
			                   
			                    const formattedTime = formatTime(reply.replyWtime);
			                    const html = `
			                        <div class="reply-wrapper" data-reply-no="\${reply.replyNo}">
			                            <div>
			                                <b>\${reply.replyWriter}</b>\${writerBadge}
			                                <small style="color:#a67c52;">(\${formattedTime})</small>
			                            </div>
			                            <div class="reply-content">\${reply.replyContent}</div>
			                            <div class="reply-actions" style="margin-top:8px;">
			                                <span class="reply-like \${likeSpanClass}" data-reply-no="\${reply.replyNo}">
			                                    <!-- 수정: fa-heart 앞에 fa 클래스를 추가했습니다. -->
			                                    <i class="fa fa-heart \${heartIconClass}"></i> <span class="count">\${reply.replyLike}</span>
			                                </span>
			                                \${isOwner ? '<button class="btn btn-edit">수정</button> <button class="btn btn-delete">삭제</button>' : ''}
			                            </div>
			                        </div>`;
			                    $(".reply-list-wrapper").append(html);
			                });
			            }
			            safeTwemojiParse(document.querySelector(".reply-list-wrapper"));
			        },
			        error: function(jqXHR, textStatus, errorThrown) {
			            console.error("댓글 로드 실패:", textStatus, errorThrown);
			            $(".reply-list-wrapper").html('<div style="text-align:center; padding:20px; color:#a03030;">⚠️ 댓글 로드 실패. 서버 오류 또는 네트워크 상태를 확인하세요.</div>');
			        }
			    });
			}
			loadList();
			// ---------------------- ✏️ 댓글 작성 ----------------------
			$(".reply-btn-write").on("click", function() {
			    const content = replyInput.val().trim();
			    if (!content) return;
			    const btn = $(this);
			    btn.prop("disabled", true).text("작성 중...");
			    $.post("/rest/reply/write", {
			        replyTarget: boardNo,
			        replyCategoryNo: "${boardDto.boardCategoryNo}",
			        replyContent: content
			    }, function() {
			        replyInput.val("");
			        loadList();
			    }).always(function() {
			        btn.prop("disabled", false).text("댓글 작성");
			    });
			});
			// ---------------------- 🧩 댓글 수정 ----------------------
			$(".reply-list-wrapper").on("click", ".btn-edit", function() {
			    const wrapper = $(this).closest(".reply-wrapper");
			      
			    // Twemoji가 적용된 HTML 대신, 원본 텍스트를 가장 정확하게 추출
			    const contentElement = wrapper.find(".reply-content");
			      
			    // img 태그를 포함한 HTML에서 alt 텍스트(이모지 문자)와 일반 텍스트를 추출
			    let content = contentElement.clone().find('img').each(function(){
			        $(this).replaceWith($(this).attr('alt') || ' ');
			    }).end().text().trim();
			      
			    // Twemoji 파싱으로 생긴 공백 등을 제거 후 textarea에 로드
			    if (!content) {
			        content = contentElement.text().trim();
			    }
			    wrapper.find(".reply-content, .reply-actions").hide();
			    wrapper.append(`
			        <div class="edit-mode-container" style="margin-top:10px;">
			            <textarea class="reply-editor" rows="3" style="width:100%;">\${content}</textarea>
			            <div style="text-align:right; margin-top:5px;">
			                <button class="btn btn-positive btn-save">저장</button>
			                <button class="btn btn-cancel">취소</button>
			            </div>
			        </div>`);
			});
			$(".reply-list-wrapper").on("click", ".btn-cancel", function() {
			    const wrapper = $(this).closest(".reply-wrapper");
			    wrapper.find(".edit-mode-container").remove();
			    wrapper.find(".reply-content, .reply-actions").show();
			});
			$(".reply-list-wrapper").on("click", ".btn-save", function() {
			    const wrapper = $(this).closest(".reply-wrapper");
			    const replyNo = wrapper.data("reply-no");
			    const newContent = wrapper.find(".reply-editor").val().trim();
			    if (!newContent) {
			        console.warn("댓글 내용은 비워둘 수 없습니다.");
			        return;
			    }
			      
			    // 버튼 비활성화 및 로딩 표시
			    const btnSave = $(this);
			    btnSave.prop("disabled", true).text("저장 중...");
			      
			    $.post("/rest/reply/edit", { replyNo: replyNo, replyContent: newContent }, function() {
			        loadList();
			    }).always(function() {
			        btnSave.prop("disabled", false).text("저장");
			    });
			});
			// ---------------------- 🗑️ 댓글 삭제 ----------------------
			$(".reply-list-wrapper").on("click", ".btn-delete", function() {
			    // ⭐ 주의: confirm() 대신 custom modal을 사용하는 것이 권장되나, 기존 패턴 유지
			    if (!confirm('정말 삭제하시겠습니까?')) return;
			      
			    const wrapper = $(this).closest(".reply-wrapper");
			    const replyNo = wrapper.data("reply-no");
			      
			    // 삭제 버튼 비활성화
			    const btnDelete = $(this);
			    btnDelete.prop("disabled", true).text("삭제 중...");
			      
			    $.post("/rest/reply/delete", { replyNo: replyNo }, function() {
			        loadList();
			    }).always(function() {
			        btnDelete.prop("disabled", false).text("삭제");
			    });
			});
			// ---------------------- ❤️ 좋아요 ----------------------
			$(".reply-list-wrapper").on("click", ".reply-like", function() {
			    if (!loginId) {
			        // 경고창 대신 console.warn 사용
			        console.warn("좋아요는 로그인 후 이용 가능합니다.");
			        return;
			    }
			    const replyNo = $(this).data("reply-no");
			    const $likeSpan = $(this); // span.reply-like 요소
			    const $heartIcon = $likeSpan.find("i"); // i.fa-heart 요소
			    const $count = $likeSpan.find(".count");
			      
			    // 좋아요 액션 서버 요청
			    $.post("/rest/reply/like/action", { replyNo: replyNo }, function(resp) {
			        // 서버 응답에 따라 카운트와 아이콘 상태 변경
			        $count.text(resp.count);
			          
			        // resp.liked 값(boolean)에 따라 토글합니다.
			        $likeSpan.toggleClass("active", resp.liked);
			        $heartIcon.toggleClass("fa-solid", resp.liked).toggleClass("fa-regular", !resp.liked);
			    });
			});
		});
		</script>

<div class="container w-800">
    <h1> [${boardDto.typeHeaderName}]   ${boardDto.boardTitle}</h1>      


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
			<tr>
				<th>[동물 분류] :</th>
				<td>${boardDto.animalHeaderName}</td>
			</tr>
		</table>
	</div>

		<div class="content">
		<img src = "/board/community/image?boardNo=${boardDto.boardNo}">
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

	<div class="reply-header-container">
		   <h3 class="reply-section-title">💬 댓글 (<span id="reply-count">0</span>개)</h3>
		   <div class="sort-buttons">
		       <button class="btn-sort active" data-sort="time">최신순</button>
		       <button class="btn-sort" data-sort="like">인기순</button>
		   </div>
		</div>
		<div class="reply-list-wrapper"></div>
		<c:if test="${sessionScope.loginId != null}">
		   <div class="reply-write-wrapper" style="position:relative;">
		       <textarea class="reply-input" rows="4" name="replyContent"
		                 placeholder="좋은 댓글을 남겨주세요"
		                 style="width:100%; resize:none;"></textarea>
		       <div class="cell right" style="margin-top:10px;">
		           <button id="emoji-btn" type="button" class="btn btn-emoji">
		               <i class="fa-regular fa-face-smile"></i>
		           </button>
		           <button type="button" class="btn btn-positive reply-btn-write">댓글 작성</button>
		           <div id="emoji-picker-container" class="emoji-picker-container"></div>
		       </div>
		   </div>
		</c:if>

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
	</div>
<jsp:include page="/WEB-INF/views/template/footer.jsp" />