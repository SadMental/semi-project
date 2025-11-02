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


body {
	background-color: #f4ede6; 
	color: #5b3a29; 
	font-family: "Pretendard", "Noto Sans KR", sans-serif;
}

.container.w-800 {
	max-width: 800px;
	margin: 40px auto;
	padding: 30px 35px;
	border-radius: 15px;
	background-color: #ffffffdd; 
		box-shadow: 0 4px 12px rgba(0,0,0,0.08);
}

.detail-wrapper {
	background-color: #fffdfb;
	border-radius: 15px;
	padding: 0;
	box-shadow: none;
	margin: 0 auto;
	border: none;
}

.detail-wrapper .board-title {
	font-size: 1.9rem;
	font-weight: 700;
	color: #5b3a29;
	margin-bottom: 20px;
	padding-bottom: 12px;
	border-bottom: 3px double #d6c2a6; /* 갈색 계열 밑줄 */
	word-break: keep-all;
}

.animal-profile-image-wrapper {
   text-align: center;
   margin-bottom: 25px;
   padding: 15px;
   border: 1px dashed #d6c2a6;
   border-radius: 15px;
   background-color: #fcfaf8;
}
.animal-profile-image-wrapper .profile-img {
   width: 200px;
   height: 200px;
   object-fit: cover;
   border-radius: 50%;
   border: 5px solid #a67c52;
   box-shadow: 0 4px 10px rgba(0, 0, 0, 0.15);
   transition: transform 0.3s ease;
}
.animal-profile-image-wrapper .profile-img:hover {
   transform: scale(1.05);
}

/* 🖼️ 메타 정보 레이아웃 복구 및 스타일 조정 (테이블 복원) */
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
/* th와 td의 폭 조정으로 레이아웃 깨짐 방지 */
.detail-wrapper .board-meta th {
	width: 80px; /* 항목 이름 폭 축소 */
	min-width: 70px;
	text-align: left;
	padding: 6px 10px;
	color: #6b4f34;
	font-weight: 600;
	white-space: nowrap; /* 항목 이름 줄바꿈 방지 */
}
.detail-wrapper .board-meta td {
	padding: 6px 10px;
	color: #3e3e3e;
	width: 40%; /* td 폭 설정 */
	word-break: break-word;
}
.detail-wrapper .board-meta tr td:nth-child(even) {
    width: 40%; /* 두 번째 td에 폭 할당 */
}
.detail-wrapper .board-meta tr th:nth-child(2) {
    width: 80px; /* 두 번째 th에도 폭 할당 */
}

.animal-summary-box {
   background-color: #f7f1eb;
   border: 2px solid #a67c52;
   border-radius: 12px;
   padding: 18px 25px;
   margin-bottom: 25px;
   font-size: 1.15rem;
   font-weight: 500;
   color: #4e3523;
   line-height: 1.6;
}
.animal-summary-box strong {
   font-weight: 700;
   color: #7e5a3c;
   display: block;
   margin-bottom: 8px;
   font-size: 1.25rem;
   border-bottom: 1px dashed #d6c2a6;
   padding-bottom: 5px;
}

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
}
.detail-wrapper .board-content img {
	max-width: 100%;
	display: block;
	margin: 10px auto;
	border-radius: 10px;
}

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

.detail-wrapper .btn-list {
	background-color: rgba(130, 130, 130, 0.1);
	color: #4e3523;
}
.detail-wrapper .btn-list:hover {
	background-color: rgba(130, 130, 130, 0.25);
}

.detail-wrapper .btn-edit {
	background-color: rgba(166, 124, 82, 0.2);
	color: #7b4e36;
}
.detail-wrapper .btn-edit:hover {
	background-color: rgba(166, 124, 82, 0.35);
}

.detail-wrapper .btn-delete {
	background-color: rgba(205, 77, 77, 0.15);
	color: #a03030;
}
.detail-wrapper .btn-delete:hover {
	background-color: rgba(205, 77, 77, 0.3);
}

.reply-header-container {
	display: flex;
	justify-content: space-between;
	align-items: flex-end;
	margin-top: 30px;
	border-top: 1px solid #e6d4c3;
	padding-top: 15px;
}
.reply-section-title {
	font-size: 1.5rem;
	font-weight: 700;
	color: #5b3a29;
   margin-top: 0;
   padding-top: 0;
}
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
.sort-buttons .btn-sort.active {
	color: #5b3a29;
	background-color: #f7f1eb;
	border: 1px solid #d9c7b3;
}
.sort-buttons .btn-sort:not(.active):hover {
	color: #7b4e36;
	background-color: #f4ede6;
}

.reply-list-wrapper {
	margin-top: 15px;
	display: flex;
	flex-direction: column;
	gap: 12px;
}

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

.reply-wrapper b {
	color: #5b3a29;
	font-weight: 600;
	margin-right: 5px;
}
.reply-wrapper small {
	color: #a67c52;
	font-size: 0.9rem;
}

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
.btn-cancel { /* 취소 버튼 */
	background-color: rgba(130, 130, 130, 0.1);
	color: #4e3523;
}
.btn-cancel:hover {
	background-color: rgba(130, 130, 130, 0.25);
}

.reply-write-wrapper {
	background: #fffaf7; /* 단순한 옅은 배경 */
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
</style>
<div class="container w-800">
<div class="detail-wrapper">
<c:if test="${not empty adoptDetailVO.typeHeaderName}">
   <div class="board-title">[${adoptDetailVO.typeHeaderName}] ${adoptDetailVO.boardTitle}</div>
</c:if>

<div class="animal-profile-image-wrapper">
   <c:choose>
       <c:when test="${adoptDetailVO.mediaNo != null and adoptDetailVO.mediaNo > 0}">
           <img class="profile-img" 
                src="/animal/profile?animalNo=${adoptDetailVO.animalNo}"
                alt="${adoptDetailVO.animalName}의 프로필 사진"
                title="${adoptDetailVO.animalName}의 프로필 사진"
                onerror="this.onerror=null; this.src='https://placehold.co/200x200/d6c2a6/ffffff?text=No+Image'">
       </c:when>
       <c:otherwise>
           <img class="profile-img"
                src="https://placehold.co/200x200/d6c2a6/ffffff?text=No+Image"
                alt="프로필 사진 (이미지 없음)"
                title="프로필 사진 (이미지 없음)">
       </c:otherwise>
   </c:choose>
</div>

<div class="board-meta">
   <table>
     <tr>
		<tr>
			<th>[작성자]</th>
					<td>${adoptDetailVO.memberNickname}<c:if
							test="${not empty adoptDetailVO.badgeImage}">${adoptDetailVO.badgeImage}</c:if>
						<c:if test="${not empty adoptDetailVO.levelName}">
							<span class="level-badge">${adoptDetailVO.levelName}</span>
						</c:if>
					</td>
		  <th>작성일</th>
		  <td><fmt:formatDate value="${adoptDetailVO.boardWtime}" pattern="yyyy-MM-dd HH:mm" /></td>
		</tr>
		<tr>
		  <th>수정일</th>
		  <td><fmt:formatDate value="${adoptDetailVO.boardEtime}" pattern="yyyy-MM-dd HH:mm" /></td>
		  <th>동물 이름</th>
		  <td>${adoptDetailVO.animalName}</td>
		</tr>
		<tr>
		  <th>동물분류</th>
		  <td>${adoptDetailVO.animalHeaderName}</td>
		  <th>분양상태</th>
		  <td>
		    <c:choose>
		      <c:when test="${adoptDetailVO.animalPermission eq 't'}">
		        <span style="color:#2ecc71; font-weight:700;">✅ 분양 가능</span>
		      </c:when>
		      <c:when test="${adoptDetailVO.animalPermission eq 'f'}">
		        <span style="color:#e74c3c; font-weight:700;">❌ 분양 완료</span>
		      </c:when>
		      <c:otherwise>-</c:otherwise>
		    </c:choose>
		  </td>
		</tr>
   </table>
 </div>
 <div class="animal-summary-box">
     <strong>🐾 동물 간단 소개 (핵심 정보)</strong>
     ${adoptDetailVO.animalContent}
 </div>
  <div class="board-content">
   ${adoptDetailVO.boardContent}
 </div>
 <div class="action-buttons">
   <a href="list" class="btn-list">📜 목록</a>
   <c:if test="${sessionScope.loginId == adoptDetailVO.boardWriter}">
     <a href="edit?boardNo=${adoptDetailVO.boardNo}" class="btn-edit">✏ 수정</a>
     <a href="delete?boardNo=${adoptDetailVO.boardNo}" class="btn-delete"
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
<script>
$(function() {
   const params = new URLSearchParams(location.search);
   const boardNo = params.get("boardNo");
   if (!boardNo) return;
   const emojiContainer = $('#emoji-picker-container');
   const emojiButton = $('#emoji-btn');
   const replyInput = $('.reply-input');
   // JSTL을 통해 로그인 ID를 가져옵니다. 로그인되어 있지 않으면 빈 문자열("")입니다.
   const loginId = "${sessionScope.loginId}";
   let currentSort = "time";
   // 💡 Moment.js를 사용하여 시간을 보기 좋게 포맷하는 함수 추가
   function formatTime(timestamp) {
       // Moment.js가 로드되었는지 확인하고, 한국어 로케일을 사용합니다.
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
   const emojiList = ["😀","😂","😍","🤣","😅","😊","😎","😘","😎","🤩","🥰","🤔","😮","🥳","👏","🎉","🎁","🎈","🎂","✨","🦄","🐶","❤️"];
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
	   
	    // ⭐ DAO/Controller에서 loginId를 사용하여 liked를 계산하므로, loginId를 함께 전달합니다.
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
	                   
	                    // ✅ 요청에 따라 reply.liked 속성을 사용하여 초기 아이콘 클래스를 설정합니다.
	                    const heartIconClass = reply.liked ? 'fa-solid' : 'fa-regular';
	                    const likeSpanClass = reply.liked ? 'active' : '';
	                   
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
	                                    <i class="fa-heart \${heartIconClass}"></i> <span class="count">\${reply.replyLike}</span>
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
           replyCategoryNo: "${adoptDetailVO.boardCategoryNo}",
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
</div>
<jsp:include page="/WEB-INF/views/template/footer.jsp" />
