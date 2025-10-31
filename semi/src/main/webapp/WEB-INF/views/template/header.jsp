<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="cp" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>3d Semi-Project</title>

<link rel="stylesheet" type="text/css" href="/css/commons.css">
<link rel="stylesheet" type="text/css"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">

<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<!-- momentjs CDN-->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.30.1/moment.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.30.1/locale/ko.min.js"></script>
<!-- reCAPTCHA api -->
<script src="https://www.google.com/recaptcha/api.js" async defer></script>

</head>

<style>
:root {
	--brown: #4e3d2a;
	--beige: #eadac1;
	--bg: #fff;
	--line: #eadac1;
	--text: #4e3d2a;
}

.kh-header {
	background: var(--bg);
	border-bottom: 1px solid var(--line);
}

.kh-header__wrap {
	display: flex;
	align-items: flex-start;
	gap: 24px;
	padding: 16px 28px 18px;
}

.kh-brand {
		width:140px;
		height:140px;
		position: relative;
		border-radius: 50%;
		overflow: hidden;
}

/* .kh-brand__logoCard {
	width: inherit;
	height: inherit;
	border: 1px solid var(--line);
	border-radius: 10%;
	display: flex;
	align-items: center;
	justify-content: center;
	background: #fff;
} */

.kh-brand__logoImg {
	width: 140px;
	height: 140px;
	overflow:hidden;
	object-fit: contain;
}

.kh-brand__title {
	margin-top: 10px;
	font-weight: 700;
	color: var(--text);
	letter-spacing: 0.5px;
}

.kh-top {
	flex: 1;
}

.kh-nav {
	display: flex;
	align-items: center;
	gap: 10px;
	padding: 16px 24px;
	border: 1px solid var(--line);
	border-radius: 12px; 
	box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05); 
}

.kh-pill {
	display: inline-block;
	padding: 8px 16px;
	border: 1px solid var(--brown);
	border-radius: 9999px;
	text-decoration: none;
	color: var(--brown);
	background: var(--beige);
	font-weight: 700;
}

.kh-pill--active {
	background: var(--brown);
	color: var(--beige);
	border-color: var(--brown);
}

.kh-pill:hover {
	filter: brightness(0.95);
	transform: translateY(-1px);
}

@media ( max-width :960px) {
	.kh-header__wrap {
		gap: 16px;
		padding: 12px 16px;
	}
	.kh-brand {
		width: 120px;
	}
	.kh-pill {
		padding: 7px 14px;
	}
}

.kh-top {
	flex: 1;
	display: flex;
	justify-content: center;
}
/* 헤더 버튼 스타일 */
.kh-nav .btn {
  display: inline-block;
  padding: 8px 16px;
  border-radius: 9999px;
  font-weight: 700;
  text-decoration: none;
  transition: all 0.2s ease; /* hover 변화를 부드럽게 */
}

/* 긍정 버튼 */
.kh-nav .btn-positive {
  background-color: #6ca3ae;
  color: #fff;
  border: 1px solid #6ca3ae;
}

/* 메뉴 버튼 */
.kh-nav .btn-menu {
  background-color: #fffbf5;
  color: #6ca3ae;
  border: 1px solid #6ca3ae;
}

/* 삭제 버튼 예시 */
.kh-nav .btn-negative {
  background-color: #800020;
  color: #fff;
  border: 1px solid #800020;
}

/* hover 효과 */
.kh-nav .btn:hover {
  filter: brightness(0.9); /* 밝기 조절 */
  transform: translateY(-2px); /* 살짝 들어올리기 */
  cursor: pointer;
}

/* 반응형 조정 */
@media (max-width: 960px) {
  .kh-nav .btn {
    padding: 7px 14px;
  }
}


</style>
<div class="container w-1200">
  <header class="kh-header">
    <div class="kh-header__wrap">
      <div class="kh-top">
        <aside class="kh-brand me-20">
          <!-- <div class="kh-brand__logoCard w-100"> -->
            <img src="${cp}/image/logo.png" alt="KH PETIQUE"
                 class="kh-brand__logoImg">
          <!-- </div> -->
        </aside>
        <nav class="kh-nav flex-box flex-center" style="gap:10px;">
          <!-- 메뉴 버튼 스타일 적용 -->
          <a class="btn btn-positive" href="/">HOME</a>
          <a class="btn btn-menu" href="/board/community/list">COMMUNITY</a>
          <a class="btn btn-menu" href="/board/info/list">INFO</a>
          <a class="btn btn-menu" href="/board/adoption/list">SERVICE</a>
          <a class="btn btn-menu" href="/admin/category/list">MENU</a>
        </nav>
      </div>
    </div>
  </header>

  <div class="cell flex-box">