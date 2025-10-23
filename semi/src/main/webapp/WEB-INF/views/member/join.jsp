<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<link href="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.js"></script>
<link rel="stylesheet" type="text/css" href="/summernote/custom-summernote.css">
<script src="/summernote/custom-summernote.js"></script>
<script src="/js/email-cert.js"></script> 
<script src="/js/member-join.js"></script>
    <style>
        input {
            background-color: rgb(243, 234, 225);
            border-color: transparent;
            border-radius: 25px;
            margin-top: 6px;
            font-size: 20px;
            padding: 5px 10px 5px 10px;
            border: none;
            text-align: center;
        }

        input:focus {
            outline: none;
            border: none;
            background-color: rgb(233, 216, 198);
        }

        label {
            font-size: 20px;
        }
        button {
        	margin-left: 75px;
        }
    </style>
    
	<form action="join" method="post" enctype="multipart/form-data" autocomplete="off">
	<div class="container w-600">
		<div class="cell">
			<label>
				<span>아이디</span>
				<i class="fa-solid fa-asterisk orange"></i>
			</label>
			<input class="w-100p" type="text" name="memberId">
		</div>
		<div class="cell">
			<label>
				<span>비밀번호</span>
				<i class="fa-solid fa-asterisk orange"></i>
			</label>
			<input class="w-100p" type="password" name="memberPw">
		</div>
		<div class="cell">
			<label>
				<span>닉네임</span>
				<i class="fa-solid fa-asterisk orange"></i>
			</label>
			<input class="w-100p" type="text" name="memberNickname">
		</div>
	  	<div class="cell">
	  		<div class="cell">
	  			<label>
	  				<span>이메일</span>
	  			</label>
				<input class="flex-fill w-100p" type="text" inputmode="email" name="memberEmail">
			</div>
			<div class="cell">
				<button type="button" class="btn-cert-send btn btn-positive w-75p">
					<i class="fa-solid fa-paper-plane"></i>
					<span>인증메일 전송</span>
				</button> 
				<div class="cell">
					<div class="fail-feedback">올바른 이메일 형식이 아닙니다</div>
					<div class="fail2-feedback">이미 등록된 이메일입니다.</div>
				</div>
			</div>
			<div class="cell cert-input-area" style="display: none;">
				<div class="cell">
					<input type="text" inputmode="numeric"
						class="cert-input w-100p" placeholder="인증번호 입력" >
				</div>
				<div class="cell">
					<button type="button" class="btn-cert-check btn btn-positive w-75p">
						<i class="fa-solid fa-mail"></i>
						<span>인증번호 확인</span>
					</button> 
					<div class="success-feedback">이메일 인증이 완료되었습니다</div>
				  	<div class="fail2-feedback">인증번호가 올바르지 않거나 유효시간이 초과되었습니다</div>
					<input type="hidden" name="memberAuth" value="f">
					<button class="auth-btn btn btn-positive ms-20" type="button" style="border-radius: 50%; background-color: rgb(0, 172, 51); color: white; display: none;">
						<i class="fa-solid fa-check"></i>
					</button>
				</div>
			</div>
	  	</div>
	  	
		<div class="cell">
			<label>
				<span>소개글</span>
				<!-- <i class="fa-solid fa-asterisk red"></i> -->
			</label>
			<textarea class="summernote-editor w-100p" name="memberDescription"></textarea>
		</div>
		<div class="cell center">
			<input type="file"  name="media" class="w-100p" accept="image/*">
			<img class="img-preview" src="/image/error/no-image.png" width="100">
		</div>
		<div class="cell">
			<button type="submit" class="btn btn-positive w-75p">가입하기</button>
		</div>
	</div>
</form>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>