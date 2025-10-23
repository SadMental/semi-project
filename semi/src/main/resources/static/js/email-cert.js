var state = {
    memberEmailValid: false // default 인증안됨 
};

$(function () {
    //아이디 피드백
    $(".id-feedback, .id2-feedback, .pw-feedback, .pw2-feedback").hide();

    $("[name=memberId]").on("blur", function () {
        var idVal = $(this).val();
        var regex = /^[A-Za-z0-9]{1,20}$/;
        if (!regex.test(idVal)) {
            $(".id-feedback").show();
        }
        else {
            $(".id-feedback").hide();
        }

        //아이디 중복인 경우
        $.ajax({
            url: "/rest/member/checkId", 
            method: "post",
            data: {memberId: idVal},
            success: function(response) {
                if(response) {
                    $(".id2-feedback").show();
                    $(".id-feedback").hide();
                }
                else {
                    $(".id2-feedback").hide();
                }
            }
        });
    });

    //비번 피드백
    $("[name=memberPw]").on("blur", function () {
        var pwVal = $(this).val();
        if(pwVal.length == 0) {
            $(".pw-feedback").show();
            return;
        }

        var pwVal = $(this).val();
        var regexAll = /^[A-Za-z0-9!@#$]{8,20}$/;
        var regex1 = /[A-Za-z]+/;
        var regex2 = /[0-9]+/;
        var regex3 = /[!@#$]+/;
        var valid = regexAll.test(pwVal) 
                    && regex1.test(pwVal)
                    && regex2.test(pwVal)
                    && regex3.test(pwVal);
        if(!valid) {
            $(".pw2-feedback").show();
            $(".pw-feedback").hide();
        }
        else {
            $(".pw2-feedback").hide();
        }
    });

    //인증번호 보내기 완료
    $(".btn-cert-send").on("click", function () { 

        var email = $("[name=memberEmail]").val();
        var regex = /^(.*?)@(.*?)$/;
        var valid = regex.test(email);

        $(".success-feedback, .fail-feedback, .fail2-feedback, .fail3-feedback").hide();
        $(".cell.flex-box .auth-btn").hide();

        if (valid == false) {
            $("[name=memberEmail]").removeClass("success fail fail2 fail3").addClass("fail");
            $(".fail-feedback").show();
            state.memberEmailValid = false;
            return;
        }

        $.ajax({ //이메일 중복 확인 먼저
            url: "http://localhost:8080/rest/member/checkEmail",
            method: "post",
            data: { memberEmail : email },
            success: function (response) {
                if(response) {
                    $(".fail3-feedback").show();
                }
                else {
                    $(".fail3-feedback").hide();

                    // 중복 없을 시 certSend 실행
                    $.ajax({ 
                        url: "http://localhost:8080/rest/member/certSend",
                        method: "post",
                        data: { certEmail: email },
                        success: function (response) {
                            $(".cert-input").show();
                        },
                    });
                }
            },
        });
        
    });
    
    //인증번호 확인
    $(".btn-cert-check").on("click", function () {

        var certNumber = $(".cert-input").val();
        var regex = /^[0-9]{5}$/;
        var valid = regex.test(certNumber);

        $(".success-feedback, .fail-feedback, .fail2-feedback, .fail3-feedback, .auth-btn").hide();

        if (valid == false) {
            $("[name=memberEmail]").removeClass("success fail fail2 fail3").addClass("fail");
            $(".fail2-feedback").show();
            state.memberEmailValid = false;
            return;
        }

        var certEmail = $("[name=memberEmail]").val();
        $.ajax({
            url: "http://localhost:8080/rest/member/certCheck",
            method: "post",
            data: { certEmail: certEmail, certNumber: certNumber },
            success: function (response) {
                if (response) {
                    $(".cert-input").removeClass("success fail fail2 fail3").val("").hide();
                    $("[name=memberEmail]").removeClass("success fail fail2 fail3").addClass("success")
                        .prop("readonly", true);
                    $(".success-feedback").show();
                    state.memberEmailValid = true;
                    $(".btn-cert-check").hide();
                    $(".auth-btn").show();
                    $("[name=memberAuth]").val("t");
                    $(".fail2-feedback").hide();
                    $(".btn-cert-send").hide();
                }
                else {
                    $(".cert-input").removeClass("success fail fail2 fail3").addClass("fail2");
                    $(".fail2-feedback").show();
                    state.memberEmailValid = false;
                }
            }
        });
    });
});