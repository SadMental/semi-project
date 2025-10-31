$(function(){
	
	$(".btn-find-send").on("click", function () {
		var email = $("[name=memberEmail]").val()
	    $.ajax({
	        url: "/rest/member/findSend",
	        method: "post",
	        data: { memberEmail: email },
	        success: function (response) {
				if(response){					
					$("[name=memberEmail]").removeClass("success fail fail2").addClass("success");
					return;
				}
				$("[name=memberEmail]").removeClass("success fail fail2").addClass("fail2");
	        },
			beforeSend:function(){
				$(".btn-find-send").prop("disabled", true);
				$(".btn-find-send").find("i").removeClass("fa-paper-plane").addClass("fa-spinner fa-spin");
				$(".btn-find-send").find("span").text("이메일 발송중");
			},
			complete:function(){
				$(".btn-cert-send").prop("disabled", false);
				$(".btn-cert-send").find("i").removeClass("fa-spinner fa-spin").addClass("fa-paper-plane");
				$(".btn-cert-send").find("span").text("이메일 전송완료");
			}
			
	    });
	});
})