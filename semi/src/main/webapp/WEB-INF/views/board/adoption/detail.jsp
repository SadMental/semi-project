<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<jsp:include page="/WEB-INF/views/template/header.jsp" />

<!-- jQuery + Moment.js -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.4/moment.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.29.4/locale/ko.min.js"></script>

<!-- Font Awesome + Twemoji -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<script
	src="https://cdn.jsdelivr.net/npm/twemoji@14.0.2/dist/twemoji.min.js"
	defer></script>

<style>
.board-meta {
	background-color: #fffdf9;
	border: 2px solid #d8c3a5;
	border-radius: 12px;
	padding: 15px 20px;
	margin: 20px 0;
	box-shadow: 0 3px 10px rgba(0, 0, 0, 0.05);
}

.board-meta table {
	width: 100%;
	border-collapse: collapse;
}

.board-meta th {
	width: 100px;
	text-align: left;
	padding: 6px 10px;
	color: #6b4f34;
	font-weight: 600;
}

.board-meta td {
	padding: 6px 10px;
	color: #3e3e3e;
}

.board-title {
	font-size: 1.8rem;
	font-weight: bold;
	color: #5b3a29;
	border-bottom: 3px double #d6c2a6;
	padding-bottom: 10px;
	margin-bottom: 15px;
}

body {
	background-color: #f4ede6;
	color: #5b3a29;
	font-family: "Pretendard", "Noto Sans KR", sans-serif;
}

/* 메인 컨테이너 */
.container.w-800 {
	max-width: 800px;
	margin: 40px auto;
	padding: 30px 35px;
	border-radius: 15px;
	background-color: #ffffffdd;
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

/* 제목, 메타, 본문 */
h1 {
	font-size: 2rem;
	font-weight: 700;
	margin-bottom: 15px;
}

.meta {
	font-size: 0.95rem;
	color: #7a5a44;
	margin-bottom: 20px;
}

.content {
	font-size: 1.1rem;
	line-height: 1.6;
	min-height: 200px;
	border-top: 1px solid #d6c2a6;
	padding-top: 20px;
}

/* 💬 댓글 목록 전체 */
.reply-list-wrapper {
	margin-top: 30px;
	display: flex;
	flex-direction: column;
	gap: 12px;
}

/* 🌿 각 댓글 카드 (말풍선 스타일) */
.reply-wrapper {
	background: #fffdfb;
	border-radius: 15px;
	padding: 15px 18px 12px;
	box-shadow: 0 3px 8px rgba(0, 0, 0, 0.05);
	position: relative;
	border: 1px solid #e6d4c3;
	max-width: 95%;
	transition: transform 0.15s ease, box-shadow 0.2s ease;
}

.reply-wrapper:hover {
	transform: translateY(-2px);
	box-shadow: 0 5px 12px rgba(166, 124, 82, 0.12);
}

/* 💬 말풍선 꼬리 */
.reply-wrapper::after {
	content: "";
	position: absolute;
	left: 18px;
	bottom: -8px;
	width: 0;
	height: 0;
	border-left: 8px solid transparent;
	border-right: 8px solid transparent;
	border-top: 8px solid #fffdfb;
	filter: drop-shadow(0 2px 1px rgba(0, 0, 0, 0.05));
}

/* ✨ 작성자, 시간 */
.reply-wrapper b {
	color: #5b3a29;
	font-weight: 600;
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
	margin-right: 10px;
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
}

.btn-edit {
	background-color: #a67c52;
	color: #fff5e9;
}

.btn-edit:hover {
	background-color: #c18f65;
}

.btn-delete {
	background-color: #a94442;
	color: #fff2f0;
}

.btn-delete:hover {
	background-color: #922d2b;
}

.btn-positive {
	background-color: #5b3a29;
	color: white;
}

.btn-positive:hover {
	background-color: #7b4e36;
}

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
	box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.03);
	transition: border-color 0.2s ease, box-shadow 0.2s ease;
}

.reply-input:focus {
	outline: none;
	border-color: #a67c52;
	box-shadow: 0 0 0 3px rgba(166, 124, 82, 0.15);
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
	box-shadow: 0 6px 15px rgba(0, 0, 0, 0.1);
	padding: 10px;
	max-width: 260px;
	max-height: 200px;
	overflow-y: auto;
	z-index: 9999;
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
/* 📰 게시글 상세 영역 */
.detail-wrapper {
	background-color: #fffdfb;
	border-radius: 20px;
	padding: 30px 35px;
	box-shadow: 0 5px 15px rgba(166, 124, 82, 0.1);
	margin: 40px auto;
	max-width: 850px;
	border: 1px solid #e6d4c3;
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
	box-shadow: 0 3px 10px rgba(0, 0, 0, 0.05);
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
	box-shadow: inset 0 2px 5px rgba(0, 0, 0, 0.03);
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

.detail-wrapper .action-buttons a, .detail-wrapper .action-buttons button
	{
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
</style>


<div class="detail-wrapper">
	<c:if test="${not empty typeHeaderDto}">
		<tr>
			<div class="board-title">[${typeHeaderDto.headerName}]
				${boardDto.boardTitle}</div>
		</tr>
	</c:if>

	<div class="board-meta">
		<table>
			<tr>
				<th>작성자</th>
				<td>${boardDto.boardWriter}</td>
				<th>작성일</th>
				<td><fmt:formatDate value="${boardDto.boardWtime}"
						pattern="yyyy-MM-dd HH:mm" /></td>
			</tr>
			<tr>
				<th>수정일</th>
				<td colspan="3"><fmt:formatDate value="${boardDto.boardEtime}"
						pattern="yyyy-MM-dd HH:mm" /></td>
			</tr>
			<tr>
				<th>동물분류</th>
				<td colspan="3">${animalHeaderDto.headerName}</td>
			</tr>
		</table>
	</div>

	<div class="board-content">${boardDto.boardContent}</div>

	<div class="action-buttons">
		<a href="list" class="btn-list">📜 목록</a>
		<c:if test="${sessionScope.loginId == boardDto.boardWriter}">
			<a href="edit?boardNo=${boardDto.boardNo}" class="btn-edit">✏ 수정</a>
			<a href="delete?boardNo=${boardDto.boardNo}" class="btn-delete"
				onclick="return confirm('정말 삭제하시겠습니까?');">🗑 삭제</a>
		</c:if>
	</div>

<hr>
<h3>댓글</h3>
<div class="reply-list-wrapper"></div>

<c:if test="${sessionScope.loginId != null}">
	<div class="reply-write-wrapper"
		style="margin-top: 10px; position: relative;">
		<textarea class="reply-input" rows="4" name="replyContent"
			placeholder="댓글 내용 입력" style="width: 100%; resize: none;"></textarea>
		<div class="cell right" style="margin-top: 10px;">
			<button id="emoji-btn" type="button" class="btn btn-emoji">
				<i class="fa-regular fa-face-smile"></i>
			</button>
			<button type="button" class="btn btn-positive reply-btn-write">댓글
				작성</button>
			<div id="emoji-picker-container" class="emoji-picker-container"></div>
		</div>
	</div>
</c:if>
</div>

<script>
$(function() {

	const params = new URLSearchParams(location.search);
	const boardNo = params.get("boardNo");
	const emojiContainer = $('#emoji-picker-container');
	const emojiButton = $('#emoji-btn');
	const replyInput = $('.reply-input');

	//---------------------------------------------------
	// ✅ 이모지 목록 생성 (Twemoji 정상 표시)
	//---------------------------------------------------
	const emojiList = [
		"😀","😂","😊","🤣","😅","😍","🤩","😘","😎","🥳",
		"😇","😢","😭","😱","🥵","👎","🙏","🎉","🚀","🔥",
		"🌟","🍀","🐶","🐱","❤️"
	];

	// ⚡ 수정된 부분: <span> 제거 → Twemoji가 정상 인식
	emojiContainer.html(emojiList.join(''));
	twemoji.parse(emojiContainer[0], { folder: 'svg', ext: '.svg' });

	let emojiOpen = false;

	// ✅ 이모지 버튼 클릭 시 열기/닫기
	emojiButton.on('click', function(e) {
		e.stopPropagation();
		emojiContainer.toggle();
		emojiOpen = !emojiOpen;
	});

	// ✅ 바깥 클릭 시 닫기
	$(document).on('click', function(e) {
		if (emojiOpen && !$(e.target).closest('#emoji-picker-container, #emoji-btn').length) {
			emojiContainer.hide();
			emojiOpen = false;
		}
	});

	// ✅ 이모지 클릭 시 textarea에 추가
	emojiContainer.on('click', 'img.emoji', function() {
		const emoji = $(this).attr('alt'); // Twemoji는 alt 속성에 원래 이모지 텍스트를 넣음
		const input = replyInput[0];
		const start = input.selectionStart, end = input.selectionEnd;
		input.value = input.value.substring(0, start) + emoji + input.value.substring(end);
		input.selectionStart = input.selectionEnd = start + emoji.length;
		input.focus();
		emojiContainer.hide();
		emojiOpen = false;
	});

	//---------------------------------------------------
	// ✅ 댓글 목록 로드
	//---------------------------------------------------
	function loadList() {
		$.ajax({
			url: "/rest/reply/list",
			method: "POST",
			data: { replyTarget: boardNo },
			dataType: "json",
			success: function(list) {
				$(".reply-list-wrapper").empty();
				list.forEach(reply => {
					const html = `
						<div class="reply-wrapper" data-reply-no="\${reply.replyNo}">
							<div>
								<b>\${reply.replyWriter}</b>
								<small style="color:#a67c52;">(\${moment(reply.replyWtime).fromNow()})</small>
							</div>
							<div class="reply-content">\${reply.replyContent}</div>
							<div class="reply-actions" style="margin-top:5px;">
								<span class="reply-like" data-reply-no="\${reply.replyNo}">
									<i class="fa-regular fa-heart"></i> <span class="count">\${reply.replyLike}</span>
								</span>
								\${reply.owner ? `<button class="btn btn-edit">수정</button> <button class="btn btn-delete">삭제</button>` : ''}
							</div>
						</div>
					`;
					$(".reply-list-wrapper").append(html);
				});
				twemoji.parse(document.querySelector(".reply-list-wrapper"));
			}
		});
	}
	loadList();

	//---------------------------------------------------
	// ✅ 댓글 작성
	//---------------------------------------------------
	$(".reply-btn-write").on("click", function() {
		const content = replyInput.val();
		if (!content.trim()) return;
		$.post("/rest/reply/write", {
			replyTarget: boardNo,
			replyCategoryNo: "${boardDto.boardCategoryNo}",
			replyContent: content
		}, function() {
			replyInput.val("");
			loadList();
		});
	});

	//---------------------------------------------------
	// ✅ 댓글 수정
	//---------------------------------------------------
	$(".reply-list-wrapper").on("click", ".btn-edit", function() {
		const wrapper = $(this).closest(".reply-wrapper");
		const content = wrapper.find(".reply-content").text();
		wrapper.find(".reply-content").replaceWith(`
			<textarea class="reply-editor" rows="3" style="width:100%;">\${content}</textarea>
			<button class="btn btn-positive btn-save">저장</button>
			<button class="btn btn-delete btn-cancel">취소</button>
		`);
	});

	$(".reply-list-wrapper").on("click", ".btn-cancel", function() {
		loadList();
	});

	$(".reply-list-wrapper").on("click", ".btn-save", function() {
		const wrapper = $(this).closest(".reply-wrapper");
		const replyNo = wrapper.data("reply-no");
		const newContent = wrapper.find(".reply-editor").val();
		$.post("/rest/reply/edit", { replyNo: replyNo, replyContent: newContent }, function() {
			loadList();
		});
	});

	//---------------------------------------------------
	// ✅ 댓글 삭제
	//---------------------------------------------------
	$(".reply-list-wrapper").on("click", ".btn-delete", function() {
		if (!confirm("정말 삭제하시겠습니까?")) return;
		const replyNo = $(this).closest(".reply-wrapper").data("reply-no");
		$.post("/rest/reply/delete", { replyNo: replyNo }, function() {
			loadList();
		});
	});

	//---------------------------------------------------
	// ✅ 댓글 좋아요 토글
	//---------------------------------------------------
	$(".reply-list-wrapper").on("click", ".reply-like", function() {
		const replyNo = $(this).data("reply-no");
		const heart = $(this).find("i");
		const count = $(this).find(".count");

		$.post("/rest/reply/like/action", { replyNo: replyNo }, function(resp) {
			count.text(resp.count);
			heart.toggleClass("fa-solid", resp.like)
				 .toggleClass("fa-regular", !resp.like)
				 .toggleClass("active", resp.like);
		});
	});

});
</script>


<jsp:include page="/WEB-INF/views/template/footer.jsp" />

