<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<script src="/js/login.js"></script>
<script type="text/template" id="ranking-template">
	<div class="cell w-100p flex-box ranking-wrapper">
        <span class="number me-10">1</span>
        <img src="#" style="width:32px" class="ranking-profile ms-10">

        <div class="ranking-wrapper flex-box flex-vertical" style="width:60%">
            <a class="ranking-nickname left link" href="#">닉네임</a>
            <span class="ranking-description text-ellipsis left" style="color:gray; font-size: 0.8em;">설명</span>
        </div>
        
        <div class="ranking-heart flex-box" style="width:30%">
            <i class="fa-solid fa-heart red"></i>
            <span class="ranking-member-point">100</span>
        </div>
    </div>
</script>
<script type="text/template" id="new-board-template">
    <div class="cell w-100p new-board-wrapper flex-box">
		<div class="left flex-fill">
        	<a class="new-board-title link" href="#">제목</a>
		</div>
		<div class="right">
        	<span class="new-board-time" style="color:#e67e22;">시간</span>
		</div>
    </div>
</script>

<script src="/js/sidebar.js"></script>

	<c:if test="${pageContext.request.requestURI != '/WEB-INF/views/member/join.jsp'}">
		 <div class="cell flex-box flex-vertical w-25p">
            <div class="cell ms-10 me-10 center">
            	<c:choose>
	            	<c:when test="${sessionScope.loginId != null && sessionScope.loginLevel == '0' }">
	            		<div class="cell">
		            		<div class="flex-box">
			                	<img src="/member/profile?member_id=${sessionScope.loginId }" width="50" height="50">
			                	<div class="flex-box flex-center">
									<span>${memberDto.memberNickname }</span>
			                	</div>
		            		</div>
		            		<div class="cell">
		            			<div class="flex-box">
		            				<span>보유 포인트 : ${memberDto.memberPoint }</span>
		            				<hr>
		            				<span>사용 포인트 : ${memberDto.memberUsedPoint }</span>
		            			</div>
		            		</div>
		            		<div class="cell">
		            			<a href="/mail/list/receive" class="btn btn-neutral w-50p">우편함</a>
		            		</div>
		            		<div class="flex-box">
								<div class="cell">
									<a href="/member/mypage" class="btn btn-neutral">내 정보</a>
			            		</div>					
								<div class="cell">
									<a href="/member/logout" class="btn btn-neutral">로그아웃</a>
			            		</div>					
		            		</div>
	            		</div>
	            	</c:when>
					<c:when test="${sessionScope.loginId != null && sessionScope.loginLevel >= '1' }">
						<div class="cell">
		            		<div class="flex-box">
			                	<img src="/member/profile?member_id=${sessionScope.loginId }" width="50" height="50">
			                	<div class="flex-box flex-center">
									<span>${memberDto.memberNickname }</span>
			                	</div>
		            		</div>
		            		<div class="cell">
		            			<div class="flex-box">
		            				<span>보유 포인트 : ${memberDto.memberPoint }</span>
		            				<hr>
		            				<span>사용 포인트 : ${memberDto.memberUsedPoint }</span>
		            			</div>
		            		</div>
		            		<div class="cell">
		            			<a href="/mail/list/receive" class="btn btn-neutral w-50p">우편함</a>
		            		</div>
		            		<div class="flex-box">
								<div class="cell">
									<a href="/member/mypage" class="btn btn-neutral">내 정보</a>
			            		</div>					
								<div class="cell">
									<a href="/member/logout" class="btn btn-neutral">로그아웃</a>
			            		</div>					
		            		</div>
	            		</div>
					</c:when>
					<c:otherwise>
						<form id="login-form">
							<div class="cell">
								<label>아이디</label>
								<input class="field w-100p" type="text" name="memberId">
								<div class="fail-feedback"></div>
							</div>
							<div class="cell">
								<label>비밀번호</label>
								<input class="field w-100p" type="password" name="memberPw">
								<div class="fail-feedback"></div>
							</div>
							<div class="cell center">
								<button class="btn btn-positive btn-login w-100p" type="submit">로그인</button>
							</div>
							<hr>
							<div class="cell center">
								<a href="/member/findId" class="link gray">아이디 찾기</a>
								<span class="gray">|</span>
								<a href="/member/findPw" class="link gray">비밀번호 찾기</a>
								<span class="gray">|</span>
								<a class="link gray" href="/member/join">회원가입</a>
							</div>
						</form>
					</c:otherwise>
            	</c:choose>
            </div>

            <div class="cell ms-10 me-10">
                <label class="left" style="font-size: 1.4em; font-weight:bold;">새글</label>
                <div class="new-board-list-wrapper center">새글 영역</div>
            </div>

            <div class="cell ms-10 me-10">
                <label class="left" style="font-size: 1.4em; font-weight:bold;">랭킹</label>
                <div class="ranking-list-wrapper center">랭킹 영역</div>
            </div>
        </div>
	</c:if>
