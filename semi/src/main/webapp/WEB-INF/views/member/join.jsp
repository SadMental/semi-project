<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>


<link href="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.js"></script>
<link rel="stylesheet" type="text/css" href="/summernote/custom-summernote.css">
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
                        <span class="success-feedback">이메일 인증이 완료되었습니다</span>
                        <span class="fail-feedback">올바른 이메일 형식이 아닙니다</span>
                        <span class="fail2-feedback">인증번호가 올바르지 않거나 유효시간이 초과되었습니다</span>
                        <button type="button" class="btn-cert-check">인증번호 확인</button>
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