        var state = {
        memberEmailValid: false // default 인증안됨 
        };

$(function () {
	
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

        $(".success-feedback, .fail-feedback, .fail2-feedback", ".auth-btn").hide();

        if (valid == false) {
            $("[name=memberEmail]").removeClass("success fail fail2").addClass("fail");
            $(".fail-feedback").show();
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
                    $(".success-feedback").show();
                    state.memberEmailValid = true;
                    $(".btn-cert-check").hide();
                    $(".auth-btn").show();
                    $("[name=memberAuth]").val("t");
                    $(".fail2-feedback").hide();
                }
                else {
                    $(".cert-input").removeClass("success fail fail2").addClass("fail2");
                    $(".fail2-feedback").show();
                    state.memberEmailValid = false;
                }
            }
        });
    });
});