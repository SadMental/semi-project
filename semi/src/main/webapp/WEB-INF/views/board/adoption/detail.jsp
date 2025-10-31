<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
	<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
	<jsp:include page="/WEB-INF/views/template/header.jsp" />
	
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.4/moment.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.4/locale/ko.min.js"></script>
	
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
	<script src="https://cdn.jsdelivr.net/npm/twemoji@14.0.2/dist/twemoji.min.js" defer></script>
	
	<style>
	/* 🎨 전체 배경 및 기본 글꼴 설정 */
	body {
		background-color: #f4ede6;
		color: #5b3a29;
		font-family: "Pretendard", "Noto Sans KR", sans-serif;
	}
	
	/* 🏠 메인 컨테이너 (게시글 + 댓글 전체를 감쌈) */
	.container.w-800 {
		max-width: 800px;
		margin: 40px auto;
		padding: 30px 35px;
		border-radius: 15px;
		background-color: #ffffffdd;
		box-shadow: 0 4px 12px rgba(0,0,0,0.08);
	}
	
	/* 📰 게시글 상세 영역 */
	.detail-wrapper {
		background-color: #fffdfb;
		border-radius: 15px;
		padding: 0;
		box-shadow: none;
		margin: 0 auto;
		border: none;
	}
	
	/* 🏷 제목 */
	.detail-wrapper .board-title {
		font-size: 1.9rem;
		font-weight: 700;
		color: #5b3a29;
		margin-bottom: 20px;
		padding-bottom: 12px;
		border-bottom: 3px double #d6c2a6;
		word-break: keep-all;
	}
	
	/* 📄 메타 정보 */
	.detail-wrapper .board-meta {
		background-color: #fffdf9;
		border: 2px solid #d8c3a5;
		border-radius: 14px;
		padding: 15px 20px;
		margin-bottom: 25px;
		box-shadow: 0 3px 10px rgba(0,0,0,0.05);
	}
	.detail-wrapper .board-meta table {
		width: 100%;
		border-collapse: collapse;
	}
	.detail-wrapper .board-meta th {
		width: 100px;
		text-align: left;
		padding: 6px 10px;
		color: #6b4f34;
		font-weight: 600;
	}
	.detail-wrapper .board-meta td {
		padding: 6px 10px;
		color: #3e3e3e;
	}
	
	/* ✏️ 게시글 본문 */
	.detail-wrapper .board-content {
		background-color: #fffefb;
		border: 1px solid #e6d4c3;
		border-radius: 15px;
		padding: 25px 30px;
		line-height: 1.8;
		font-size: 1.1rem;
		color: #4e3523;
		box-shadow: inset 0 2px 5px rgba(0,0,0,0.03);
		margin-bottom: 25px;
		word-break: break-word;
		white-space: pre-line;
	}
	.detail-wrapper .board-content img {
		max-width: 100%;
		display: block;
		margin: 10px auto;
		border-radius: 10px;
	}
	
	/* 🎛 버튼 영역 */
	.detail-wrapper .action-buttons {
		display: flex;
		justify-content: flex-end;
		gap: 10px;
		background: transparent;
		margin-top: 15px;
	}
	.detail-wrapper .action-buttons a,
	.detail-wrapper .action-buttons button {
		border: none;
		border-radius: 10px;
		padding: 8px 16px;
		font-size: 0.95rem;
		cursor: pointer;
		font-weight: 600;
		transition: all 0.2s ease;
	}
	
	/* 📚 목록 버튼 */
	.detail-wrapper .btn-list {
		background-color: rgba(130, 130, 130, 0.1);
		color: #4e3523;
	}
	.detail-wrapper .btn-list:hover {
		background-color: rgba(130, 130, 130, 0.25);
	}
	
	/* 🪶 수정 버튼 */
	.detail-wrapper .btn-edit {
		background-color: rgba(166, 124, 82, 0.2);
		color: #7b4e36;
	}
	.detail-wrapper .btn-edit:hover {
		background-color: rgba(166, 124, 82, 0.35);
	}
	
	/* 🗑 삭제 버튼 */
	.detail-wrapper .btn-delete {
		background-color: rgba(205, 77, 77, 0.15);
		color: #a03030;
	}
	.detail-wrapper .btn-delete:hover {
		background-color: rgba(205, 77, 77, 0.3);
	}
	
    /* ------------------------------------------- */
    /* ⭐ 댓글 헤더 및 정렬 버튼 스타일 추가/수정 ⭐ */
    /* ------------------------------------------- */

    /* 💬 댓글 헤더 컨테이너 추가: 제목, 개수, 정렬 버튼을 감쌈 */
	.reply-header-container {
		display: flex; /* <---- ⭐ 이 부분이 중요합니다. */
		justify-content: space-between; 
		align-items: flex-end; 
		margin-top: 30px;
		border-top: 1px solid #e6d4c3;
		padding-top: 15px;
	}
    
	/* 💬 댓글 목록 제목 (스타일은 그대로) */
	.reply-section-title {
		font-size: 1.5rem;
		font-weight: 700;
		color: #5b3a29;
		/* margin-top과 padding-top은 부모 컨테이너로 이동하여 제거 */
        margin-top: 0; 
        padding-top: 0;
	}
    
	/* ⭐ 정렬 버튼 스타일 */
	.sort-buttons .btn-sort {
		background: none;
		border: none;
		padding: 5px 10px;
		color: #a67c52;
		font-weight: 600;
		cursor: pointer;
		transition: color 0.2s, background-color 0.2s;
		border-radius: 8px;
		font-size: 0.95rem;
	}
	/* 현재 활성화된 버튼 */
	.sort-buttons .btn-sort.active {
		color: #5b3a29;
		background-color: #f7f1eb;
		border: 1px solid #d9c7b3;
	}
	/* 호버 스타일 */
	.sort-buttons .btn-sort:not(.active):hover {
		color: #7b4e36;
		background-color: #f4ede6;
	}
    /* ------------------------------------------- */
	
	/* 💬 댓글 목록 전체 */
	.reply-list-wrapper {
		margin-top: 15px;
		display: flex;
		flex-direction: column;
		gap: 12px;
	}
	
	/* 🌿 각 댓글 카드 (말풍선 스타일) */
	.reply-wrapper {
		background: #fffdfb;
		border-radius: 15px;
		padding: 15px 18px 12px;
		box-shadow: 0 3px 8px rgba(0,0,0,0.05);
		position: relative;
		border: 1px solid #e6d4c3;
		max-width: 100%;
		transition: transform 0.15s ease, box-shadow 0.2s ease;
	}
	.reply-wrapper:hover {
		transform: translateY(-2px);
		box-shadow: 0 5px 12px rgba(166, 124, 82, 0.12);
	}
	
	/* ✨ 작성자, 시간 */
	.reply-wrapper b {
		color: #5b3a29;
		font-weight: 600;
		margin-right: 5px;
	}
	.reply-wrapper small {
		color: #a67c52;
		font-size: 0.9rem;
	}
	
	/* 🧡 댓글 내용 */
	.reply-content {
		font-size: 1rem;
		line-height: 1.6;
		color: #4e3523;
		margin-top: 6px;
		white-space: pre-wrap;
		word-break: break-word;
	}
	.reply-content img.emoji {
		width: 1.4em;
		height: 1.4em;
		vertical-align: middle;
	}
	
	/* ❤️ 좋아요 버튼 */
	.reply-like {
		cursor: pointer;
		color: #a67c52;
		margin-right: 15px;
		display: inline-flex;
		align-items: center;
		gap: 4px;
		transition: color 0.2s ease;
	}
	.reply-like i {
		transition: transform 0.2s;
	}
	.reply-like:hover i {
		transform: scale(1.2);
	}
	.reply-like.active {
		color: #e74c3c;
	}
	
	/* 🔘 버튼 기본 스타일 */
	.btn {
		padding: 6px 12px;
		border-radius: 10px;
		cursor: pointer;
		border: none;
		font-weight: 600;
		transition: all 0.2s ease;
		font-size: 0.9rem;
	}
	.btn-edit { background-color: #a67c52; color: #fff5e9; }
	.btn-edit:hover { background-color: #c18f65; }
	.btn-delete { background-color: #a94442; color: #fff2f0; }
	.btn-delete:hover { background-color: #922d2b; }
	.btn-positive { background-color: #5b3a29; color: white; }
	.btn-positive:hover { background-color: #7b4e36; }
	
	/* 😊 댓글 입력창 */
	.reply-write-wrapper {
		background: linear-gradient(135deg, #fdf8f4, #fffaf7);
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
	
	/* ✏️ 입력 텍스트 */
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
	
	/* 😄 버튼 영역 */
	.reply-write-wrapper .cell.right {
		display: flex;
		justify-content: flex-end;
		align-items: center;
		gap: 10px;
		margin-top: 10px;
		position: relative;
	}
	
	/* 😍 이모지 버튼 */
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
	
	/* 🚀 댓글 작성 버튼 */
	.reply-btn-write {
		background-color: #5b3a29;
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
		background-color: #a67c52;
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
		z-index: 9999;
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
	
	.emoji-picker-container {
	  z-index: 99999;
	}
	.emoji-picker-container img.emoji {
	  pointer-events: auto !important;
	  cursor: pointer;
	  z-index: 9999;
	}
	</style>
	
	<div class="container w-800">
	
	<div class="detail-wrapper">
	<c:if test="${not empty typeHeaderDto}">
	    <div class="board-title">[${typeHeaderDto.headerName}] ${boardDto.boardTitle}</div>
	</c:if>
	
	<div class="board-meta">
	    <table>
	      <tr>
	        <th>작성자</th>
	        <td>${boardDto.boardWriter}</td>
	        <th>작성일</th>
	        <td><fmt:formatDate value="${boardDto.boardWtime}" pattern="yyyy-MM-dd HH:mm" /></td>
	      </tr>
	      <tr>
	        <th>수정일</th>
	        <td colspan="3"><fmt:formatDate value="${boardDto.boardEtime}" pattern="yyyy-MM-dd HH:mm" /></td>
	      </tr>
	      <tr>
	        <th>동물분류</th>
	        <td colspan="3">${animalHeaderDto.headerName}</td>
	      </tr>
	    </table>
	  </div>
	
	  <div class="board-content">
	    ${boardDto.boardContent}
	  </div>
	
	  <div class="action-buttons">
	    <a href="list" class="btn-list">📜 목록</a>
	    <c:if test="${sessionScope.loginId == boardDto.boardWriter}">
	      <a href="edit?boardNo=${boardDto.boardNo}" class="btn-edit">✏ 수정</a>
	      <a href="delete?boardNo=${boardDto.boardNo}" class="btn-delete"
	         onclick="return confirm('정말 삭제하시겠습니까?');">🗑 삭제</a>
	    </c:if>
	  </div>
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
				<textarea class="reply-input" rows="4" name="replyContent" placeholder="좋은 댓글을 남겨주세요" style="width:100%; resize:none;"></textarea>
				<div class="cell right" style="margin-top:10px;">
					<button id="emoji-btn" type="button" class="btn btn-emoji"><i class="fa-regular fa-face-smile"></i></button>
					<button type="button" class="btn btn-positive reply-btn-write">댓글 작성</button>
					<div id="emoji-picker-container" class="emoji-picker-container"></div>
				</div>
			</div>
		</c:if>
	
	</div> <script>
	$(function() {
	
		const params = new URLSearchParams(location.search);
		const boardNo = params.get("boardNo");
	    if (!boardNo) {
	        console.error("Board number (boardNo) not found in URL parameters.");
	        $(".reply-section-title").text("⚠️ 게시글 번호를 찾을 수 없어 댓글 기능을 사용할 수 없습니다.");
	        return;
	    }
	
		const emojiContainer = $('#emoji-picker-container');
		const emojiButton = $('#emoji-btn');
		const replyInput = $('.reply-input');
	    const loginId = "${sessionScope.loginId}";
        
        // ⭐ 1. 정렬 기준 변수 초기화 (기본값: time)
	    let currentSort = "time"; 
	
		//---------------------------------------------------
		// ✅ 이모지 목록 생성 (Twemoji 정상 표시)
		//---------------------------------------------------
		const emojiList = [
			"😀","😍","😂","🤣","😅","😭","🥺","😘","😎","🥳",
			"😇","🤩","🤔","😱","🥵","🥶","😭","🎉","🚀","🔥",
			"🌟","✨","🦄","🐶","❤️"
		];
	
		// Twemoji 파서 실행 함수 (Twemoji CDN 스크립트 로드 후 사용 가능)
	    function safeTwemojiParse(element) {
	        if (typeof twemoji !== 'undefined') {
	            twemoji.parse(element, { folder: 'svg', ext: '.svg' });
	        }
	    }
        
		emojiContainer.html(emojiList.join(''));
		safeTwemojiParse(emojiContainer[0]);
	
		let emojiOpen = false;
        
        // 이모지 로직은 기존대로 유지
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
			const emoji = $(this).attr('alt') || $(this).data('original-emoji');
			const input = replyInput[0];
			const start = input.selectionStart, end = input.selectionEnd;
			
			if (emoji) {
				input.value = input.value.substring(0, start) + emoji + input.value.substring(end);
				input.selectionStart = input.selectionEnd = start + emoji.length;
				input.focus();
			}
			
			emojiContainer.hide();
			emojiOpen = false;
		});
	
		//---------------------------------------------------
		// ⭐ 2. 정렬 버튼 클릭 이벤트 처리 ⭐
		//---------------------------------------------------
        $(".sort-buttons .btn-sort").on("click", function() {
            // 클릭된 버튼의 data-sort 값을 가져옴
            const sortType = $(this).data("sort"); 
            
            // 현재 정렬 기준이 아니면 업데이트
            if (currentSort !== sortType) {
                currentSort = sortType;
                
                // 버튼 스타일 업데이트
                $(".sort-buttons .btn-sort").removeClass("active");
                $(this).addClass("active");
                
                // 목록 다시 로드
                loadList();
            }
        });
        
		//---------------------------------------------------
		// ✅ 댓글 목록 로드 (정렬 기준 반영 및 댓글 수 업데이트)
		//---------------------------------------------------
		function loadList() {
			// 댓글 목록 로드 시 로딩 표시
			$(".reply-list-wrapper").html('<div style="text-align: center; padding: 20px; color: #a67c52;">댓글을 불러오는 중입니다...</div>');
			
			$.ajax({
				url: "/rest/reply/list",
				method: "GET", 
				// ⭐ currentSort 변수를 API 요청에 포함
				data: { 
                    replyTarget: boardNo,
                    sort: currentSort // 추가된 정렬 파라미터
                },
				dataType: "json",
				success: function(resp) {
				    const list = resp.list || [];
                    
                    // ⭐ 3. 댓글 총 개수 업데이트
                    $("#reply-count").text(resp.boardReply || 0); 
                    
				    $(".reply-list-wrapper").empty();
				    
				    if (list.length === 0) {
				        $(".reply-list-wrapper").html(
				            '<div style="text-align: center; padding: 20px; color: #a67c52;">아직 댓글이 없습니다. 첫 댓글을 작성해보세요!</div>'
				        );
				    } else {
				        list.forEach(reply => {
				            const isOwner = loginId === reply.replyWriter;
				            // writer는 게시글 작성자
                            const isWriter = "${boardDto.boardWriter}" === reply.replyWriter; 

                            // 댓글 작성자가 게시글 작성자일 경우 아이콘이나 뱃지를 추가할 수 있습니다.
                            const writerBadge = isWriter ? '<span style="color:#7b4e36; font-size: 0.85em; margin-left: 5px;">(글쓴이)</span>' : '';
                            
				            const html = `
							  <div class="reply-wrapper" data-reply-no="\${reply.replyNo}">
							    <div>
							      <b>\${reply.replyWriter}</b>\${writerBadge}
							      <small style="color:#a67c52;">(\${moment(reply.replyWtime).fromNow()})</small>
							    </div>
							    <div class="reply-content">\${reply.replyContent}</div>
							    <div class="reply-actions" style="margin-top:8px;">
							      <span class="reply-like" data-reply-no="\${reply.replyNo}">
							        <i class="fa-regular fa-heart"></i> <span class="count">\${reply.replyLike}</span>
							      </span>
							      \${isOwner ? '<button class="btn btn-edit">수정</button> <button class="btn btn-delete">삭제</button>' : ''}
							    </div>
							  </div>
				            `;
				            $(".reply-list-wrapper").append(html);
				        });
				    }
					safeTwemojiParse(document.querySelector(".reply-list-wrapper"));
	
	                // 댓글 로드 후, 좋아요 상태를 체크
	                list.forEach(reply => {
	                    checkLikeStatus(reply.replyNo);
	                });
				},
				error: function(xhr, status, error) {
					console.error("댓글 목록 로드 실패. 서버 응답 확인 필요:", xhr.status, error);
					// 서버 측 엔드포인트가 없거나 오류가 났을 때 사용자에게 알림
                    $("#reply-count").text("0"); // 오류 시 개수 초기화
					$(".reply-list-wrapper").html('<div style="text-align: center; padding: 20px; color: #a03030; font-weight: 600;">⚠️ 댓글 로드 중 오류가 발생했습니다. (서버 API 확인 필요)</div>');
				}
			});
		}
	
	    // 좋아요 상태를 체크하여 아이콘 업데이트 (기존 로직 유지)
	    function checkLikeStatus(replyNo) {
	        if (!loginId) return;
	
	        $.get("/rest/reply/like/check", { replyNo: replyNo }, function(resp) {
	            const likeSpan = $(`.reply-like[data-reply-no=\${replyNo}] i`);
	            if (resp.like) {
	                likeSpan.removeClass("fa-regular").addClass("fa-solid").addClass("active");
	            } else {
	                likeSpan.removeClass("fa-solid").addClass("fa-regular").removeClass("active");
	            }
	        }).fail(function() {
				// 에러 처리
	        });
	    }
	
	
		loadList();
	
		//---------------------------------------------------
		// ✅ 댓글 작성 (작성 후 loadList() 호출 시 정렬 기준이 유지됨)
		//---------------------------------------------------
			$(".reply-btn-write").on("click", function() {
			    const content = replyInput.val();
			    if (!content.trim()) {
			        console.warn("댓글 내용을 입력해주세요.");
			        return;
			    }
	
			    const $this = $(this);
			    $this.prop('disabled', true).text('작성 중...');
	
			    $.post("/rest/reply/write", {
			        replyTarget: boardNo,
			        replyCategoryNo: "${boardDto.boardCategoryNo}",
			        replyContent: content
			    }, function(resp) {
			        loadList(); 
			        
			        replyInput.val("");
			        $this.prop('disabled', false).text('댓글 작성');
			        replyInput.blur(); 
			        
			    }).fail(function(xhr, status, error) {
			        console.error("댓글 작성 실패:", error);
			        $this.prop('disabled', false).text('댓글 작성');
			    });
			});
	
		//---------------------------------------------------
		// ✅ 댓글 수정 모드 토글 (기존 로직 유지)
		//---------------------------------------------------
		$(".reply-list-wrapper").on("click", ".btn-edit", function() {
			const wrapper = $(this).closest(".reply-wrapper");
	        const contentDiv = wrapper.find(".reply-content");
			const content = contentDiv.text().trim(); 
	        
	        contentDiv.hide();
	        wrapper.find(".reply-actions").hide();
	
	        const editorHtml = `
	            <div class="edit-mode-container" style="margin-top: 10px;">
	                <textarea class="reply-editor" rows="3" style="width:100%;">\${content}</textarea>
	                <div style="text-align: right; margin-top: 5px;">
	                    <button class="btn btn-positive btn-save">저장</button>
	                    <button class="btn btn-list btn-cancel">취소</button>
	                </div>
	            </div>
	        `;
	        wrapper.append(editorHtml);
	        wrapper.find(".reply-editor").focus();
		});
	
		// ✅ 댓글 수정 취소 (기존 로직 유지)
		$(".reply-list-wrapper").on("click", ".btn-cancel", function() {
	        const wrapper = $(this).closest(".reply-wrapper");
	        wrapper.find(".edit-mode-container").remove();
	        wrapper.find(".reply-content").show();
	        wrapper.find(".reply-actions").show();
		});
	
		// ✅ 댓글 수정 저장 (수정 후 loadList() 호출 시 정렬 기준이 유지됨)
		$(".reply-list-wrapper").on("click", ".btn-save", function() {
			const wrapper = $(this).closest(".reply-wrapper");
			const replyNo = wrapper.data("reply-no");
			const newContent = wrapper.find(".reply-editor").val();
	
	        if (!newContent.trim()) {
	            console.warn("수정할 내용을 입력해주세요.");
	            return;
	        }
	
			$.post("/rest/reply/edit", { replyNo: replyNo, replyContent: newContent }, function() {
				loadList();
			}).fail(function() {
	            console.error("댓글 수정 실패");
	        });
		});
	
		//---------------------------------------------------
		// ✅ 댓글 삭제 (삭제 후 loadList() 호출 시 정렬 기준이 유지됨)
		//---------------------------------------------------
		$(".reply-list-wrapper").on("click", ".btn-delete", function() {
			if (!window.confirm("정말 삭제하시겠습니까?")) return;
			const replyNo = $(this).closest(".reply-wrapper").data("reply-no");
			$.post("/rest/reply/delete", { replyNo: replyNo }, function() {
				loadList();
			}).fail(function() {
	            console.error("댓글 삭제 실패");
	        });
		});
	
		//---------------------------------------------------
		// ✅ 댓글 좋아요 토글 (기존 로직 유지)
		//---------------------------------------------------
		$(".reply-list-wrapper").on("click", ".reply-like", function() {
	        if (!loginId) {
	            console.warn("좋아요는 로그인 후 이용 가능합니다.");
	            return;
	        }
	
			const replyNo = $(this).data("reply-no");
			const heart = $(this).find("i");
			const count = $(this).find(".count");
	
			$.post("/rest/reply/like/action", { replyNo: replyNo }, function(resp) {
				count.text(resp.count);
				heart.toggleClass("fa-solid", resp.like)
					 .toggleClass("fa-regular", !resp.like)
					 .toggleClass("active", resp.like);
			}).fail(function() {
	            console.error("좋아요 처리 실패");
	        });
		});
	
	});
	</script>
	
	<jsp:include page="/WEB-INF/views/template/footer.jsp" />