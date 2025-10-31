$(function(){
	
	$(".btn-find-send").on("click", function (e) {
		e.preventDefault();
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
			success: function(response){
				if(response){ // 이메일 존재
					$("#send-email").submit();
				}
				else { // 이메일 없음
					alert("해당 이메일이 등록되어 있지 않습니다.");
				}
			},
			complete:function(){
				$(".btn-find-send").prop("disabled", false);
				$(".btn-find-send").find("i").removeClass("fa-spinner fa-spin").addClass("fa-paper-plane");
				$(".btn-find-send").find("span").text("이메일 전송완료");
			}
			
	    });
	});
})