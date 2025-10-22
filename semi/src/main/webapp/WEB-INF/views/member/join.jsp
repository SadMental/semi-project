<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>

<script src="/js/email-cert.js"></script>
<script src="/js/member-join.js"></script>

<link href="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.js"></script>
<link rel="stylesheet" type="text/css" href="/summernote/custom-summernote.css">
<link rel="stylesheet" type="text/css" href="/css/commons.css">
<script src="/js/email-cert.js"></script> 
<script src="/js/member-join.js"></script>
<script src="/summernote/custom-summernote.js"></script>
    <style>
        input {
            background-color: rgb(243, 234, 225);
            border-color: transparent;
            border-radius: 25px;
            margin-top: 6px;
            font-size: 20px;
            padding: 5px 10px 5px 10px;
        }

        input:focus {
            outline: none;
            border: none;
            background-color: rgb(233, 216, 198);
        }

        label {
            font-size: 20px;
        }

<form action="join" method="post" enctype="multipart/form-data" autocomplete="off">
	<div class="container w-600">
		<div class="cell">
			<label>
				<span>아이디</span>
				<i class="fa-solid fa-asterisk red"></i>
			</label>
			<input class="field w-100p" type="text" name="memberId">
		</div>
		<div class="cell">
			<label>
				<span>비밀번호</span>
				<i class="fa-solid fa-asterisk red"></i>
			</label>
			<input class="field w-100p" type="password" name="memberPw">
		</div>
		<div class="cell">
			<label>
				<span>닉네임</span>
				<i class="fa-solid fa-asterisk red"></i>
			</label>
			<input class="field w-100p" type="text" name="memberNickname">
		</div>
	  	<div class="cell">
	  		<label>
	  			<span>이메일</span>
	  		</label>
	  		<div class="cell flex-box">
				<input class="field flex-fill" type="text" inputmode="email" name="memberEmail">
				<button type="button" class="btn-cert-send btn btn-positive w-25p">
					<i class="fa-solid fa-paper-plane"></i>
					<span>인증메일 전송</span>
				</button> 
	  		</div>
			<div class="cell flex-box">
				<input type="text" inputmode="numeric"
					class="field cert-input" placeholder="인증번호 입력">
				<button type="button" class="btn-cert-check btn btn-positive">
					<i class="fa-solid fa-mail"></i>
					<span>인증번호 확인</span>
				</button> 
				<span class="success-feedback">이메일 인증이 완료되었습니다</span>
			  	<span class="fail-feedback">올바른 이메일 형식이 아닙니다</span>
			  	<span class="fail2-feedback">이메일 인증이 완료되지 않았습니다</span>
				<input type="hidden" name="memberAuth" value="f">
				<button class="btn btn-positive ms-20" type="button">
					<i class="fa-solid fa-lock"></i>
					<span>인증</span>
				</button>
			</div>

	  	</div>
	  	
		<div class="cell">
			<label>
				<span>소개글</span>
				<!-- <i class="fa-solid fa-asterisk red"></i> -->
			</label>
			<textarea class="summernote-editor" name="memberDescription"></textarea>
		</div>
		<div class="cell center">
			<input type="file"  name="media" class="field w-100p" accept="image/*">
			<img class="img-preview" src="/image/error/no-image.png" width="100">
		</div>
		<div class="cell center">
			<button type="submit" class="btn btn-positive w-50p">가입하기</button>
		</div>
	</div>
</form>
        .fa-asterisk {
            color: rgb(145, 58, 41);
        }
    </style>
    
	<div class="container w-600">
            <div class="cell">
            <div class="cell">
                <form action="join" method="post">
                    <div class="cell">
                        <label>아이디</label>
                        <i class="fa-solid fa-asterisk"></i><br>
                        <input type="text" name="memberId">
                    </div>
                    <div class="cell">
                        <label>비밀번호</label>
                        <i class="fa-solid fa-asterisk"></i><br>
                        <input type="password" name="memberPw">
                    </div>
                    <!-- 비밀번호 확인 기능 구현 해야함 -->
                    <!-- <div class="cell">
                <label>비밀번호 확인</label><br>
                <input type="text" name="memberPw">
            </div> -->
                    <div class="cell">
                        <label>닉네임</label>
                        <i class="fa-solid fa-asterisk"></i><br>
                        <input type="text" name="memberNickname">
                    </div>
                    <div class="cell">
                        <label>이메일</label><br>
                        <input type="text" inputmode="email" name="memberEmail">
                        <button type="button" class="btn-cert-send">
                            <span>인증메일 보내기</span>
                        </button>
                    </div>
                    <div class="cell">
                        <input type="text" inputmode="numeric" class="cert-input" placeholder="인증번호 입력">
                        <button type="button" class="btn-cert-check">인증번호 확인</button>
                    </div>
                        <span class="success-feedback">이메일 인증이 완료되었습니다</span>
                        <span class="fail-feedback">올바른 이메일 형식이 아닙니다</span>
                        <span class="fail2-feedback">인증번호가 올바르지 않거나 유효시간이 초과되었습니다</span>
                    <div class="cell">
                    	<input type="text" name="memberAuth" value="f">
                    </div>
                    <div class="cell">
                        <label>소개글</label><br> 
                        <textarea class="summernote-editor" name="memberDescription"></textarea>
                    </div>
                    <div class="cell">
                        <label>설명란</label><br> 
                        <textarea name="memberDescription"></textarea>
                    </div>
                    <div class="cell">
                        <label>반려동물</label><br>
                        <input type="text" name="memberAnumal">
                    </div>
                    <div class="cell">
                        <button type="submit">가입하기</button>
                    </div>
                </form>
            </div>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>