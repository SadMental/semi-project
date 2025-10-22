<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="cp" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>3d Semi-Project</title>
  
    <!-- css import -->
    <link rel="stylesheet" type="text/css" href="/css/commons.css">
    <link rel="stylesheet" type="text/css" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/7.0.1/css/all.min.css">
    
    <!-- jquery cdn -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <!-- momentjs CDN-->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.30.1/moment.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.30.1/locale/ko.min.js"></script>
    <!-- reCAPTCHA api -->
    <script src="https://www.google.com/recaptcha/api.js" async defer></script>
    
</head>

<style>
:root{
  --brown:#4e3d2a;
  --beige:#eadac1;
  --bg:#fff;
  --line:#eadac1;
  --text:#4e3d2a;
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
	width: 140px;
}

.kh-brand__logoCard {
	width: 88px;
	height: 88px;
	border: 1px solid var(--line);
	display: flex;
	align-items: center;
	justify-content: center;
	background: #fff;
}

.kh-brand__logoImg {
	max-width: 70px;
	max-height: 70px;
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
	padding: 16px 24px; /* 내부 공간 */
	border: 1px solid var(--line); /* 기존 색상 사용 */
	border-radius: 12px; /* 모서리 둥글게 */
	box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05); /* 약한 그림자 */
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
</style>

<header class="kh-header">
	<div class="kh-header__wrap">
		<div class="kh-top">
			<aside class="kh-brand">
				<div class="kh-brand__logoCard">
					<img src="${cp}/image/petCafe.png" alt="KH PETIQUE"
						class="kh-brand__logoImg">
				</div>
				<div class="kh-brand__title">KH PETIQUE</div>
			</aside>
			<nav class="kh-nav">
				<a class="kh-pill kh-pill--active" href="/">HOME</a> <a
					class="kh-pill" href="/board/free/list">COMMUNITY</a> <a
					class="kh-pill" href="/infoBoard/list">INFO</a> <a class="kh-pill"
					href="/board/list">SERVICE</a>
				<c:choose>
			<c:when test="${sessionScope.loginId != null}">
				<a class="kh-pill kh-pill--active" href="/">LOGOUT</a>
			</c:when>
			<c:otherwise>
				<a class="kh-pill kh-pill--active" href="/member/login">LOGIN</a>
			</c:otherwise>
		</c:choose>
				<a class="kh-pill" href="#">MENU</a>
			</nav>
		</div>

	</div>

</header>