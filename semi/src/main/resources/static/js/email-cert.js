var state = {
    memberEmailValid: false // default 인증안됨 
};

$(function () {
	
	var authBtn = $("[name=memberAuth]")
   	if(authBtn.val() == 'f'){
   		$("[name=memberEmail]").removeAttr("readonly")
   		$(".btn-cert-send").show()
	   	$(".auth-btn").removeClass("bggreen bgred").addClass("bgred")
   	} else {
	  	$(".auth-edit-btn").show()
	  	$(".auth-btn").removeClass("bggreen bgred").addClass("bggreen")
   	}
   	$(".auth-edit-btn").on("click", function () {
		$("[name=memberEmail]").removeAttr("readonly").focus()
		$(".auth-edit-btn").hide()
		$(".btn-cert-send").show()
	})
	
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

	
    $(".btn-cert-send").on("click", function () { //인증번호 보내기 완료
		
        var email = $("[name=memberEmail]").val();
        var regex = /^(.*?)@(.*?)$/;
        var valid = regex.test(email);

        $(".success-feedback, .fail-feedback, .fail2-feedback").hide();
        $(".cell.flex-box .auth-btn").hide();

        if (valid == false) {
            $("[name=memberEmail]").removeClass("success fail fail2").addClass("fail");
            $(".fail-feedback").show();
            state.memberEmailValid = false;
            return;
        }

        $.ajax({
            url: "/rest/member/certSend",
            method: "post",
            data: { certEmail: email },
            success: function (response) {
				if(response){					
                	$(".cert-input-area").show();
				} else {
					$("[name=memberEmail]").removeClass("success fail fail2").addClass("fail2");
					$(".fail2-feedback").show();
				}
            },

            // beforeSend:function() {

            // }
        });
    });

    $(".btn-cert-check").on("click", function () { //인증번호 확인

        var certNumber = $(".cert-input").val();
        var regex = /^[0-9]{5}$/;
        var valid = regex.test(certNumber);


        if (valid == false) {
            $("[name=memberEmail]").removeClass("success fail fail2").addClass("fail");
			$(".cert-input").removeClass("success fail fail2").addClass("fail2");
            state.memberEmailValid = false;
            return;
        }

        var certEmail = $("[name=memberEmail]").val();
        $.ajax({
            url: "/rest/member/certCheck",
            method: "post",
            data: { certEmail: certEmail, certNumber: certNumber },
            success: function (response) {
                if (response) {
                    $(".cert-input").removeClass("success fail fail2").val("").hide();
                    $("[name=memberEmail]").removeClass("success fail fail2").addClass("success")
                        .prop("readonly", true);
                    state.memberEmailValid = true;
                    $(".btn-cert-check").hide();
                    $(".auth-btn").show();
                    $("[name=memberAuth]").val("t");
					$(".auth-btn").addClass("bggreen");
                }
                else {
                    $(".cert-input").removeClass("success fail fail2").addClass("fail2");
                    state.memberEmailValid = false;
                }
            }
        });
    });
	
});