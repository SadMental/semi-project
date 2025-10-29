$(function(){
	var origin = $(".image-profile").attr("src");
	$("#profile-input").on("input", function(){
		var list = $("#profile-input").prop("files")
		if(list.length == 0) return;
		
		var form = new FormData(); // <form> 역할
		form.append("media", list[0]);
		$.ajax({
			processData : false, // multipart로 보내기 위해 미리 정의된 전처리 제거
			contentType : false, // multipart로 보내기 위해 미리 정의된 MINE 타입을 제거
			url : "/rest/member/profile",
			method : "post",
			data : form,
			success : function(response){
				var new_origin = origin + "&t=" + new Date().getTime();
				$(".image-profile").attr("src", new_origin);
			}
		});			
	});
	$("#profile-delete").on("click", function(){
		$.ajax({
			url : "/rest/member/delete",
			method : "post",
			data : {},
			success : function(response) {
				$(".image-profile").attr("src", "/image/error/no-image.png")
			}
		})
	});
});
