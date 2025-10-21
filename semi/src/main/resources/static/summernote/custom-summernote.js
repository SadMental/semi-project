$(function(){
    $(".summernote-editor").summernote({
        height: 250, // set editor height
        minHeight: 200, // set minimum height of editor
        maxHeight: 400, // set maximum height of editor

        placeholder:"내용을 입력하세요.",
        toolbar:[
        ["font", ["style", "fontname", "fontsize", "forecolor", "backcolor"]],
        ["style", ["bold", "italic", "underline", "strikethrough"]],
        ["attach", ["picture"]],
        ["tool", ["ol", "ul", "paragraph", "table", "hr", "fullscreen"]],
        ],
		
		callbacks: {
            onImageUpload: function(files) {
                console.log("파일 업로드 중...");

                // FormData 생성
                var form = new FormData();
				for(var i=0; i<files.length;i++)
                	form.append("media", files[i]);

                // Ajax 업로드
                $.ajax({
                    processData: false,
                    contentType: false,
                    url: "/rest/media/temps",
                    method: "post",
                    data: form,
                    success: function(response) { // response == 업로드된 파일번호(int)
						for(var i=0;i<response.length;i++){
	                        var img = $("<img>").attr("src", "/media/download?mediaNo=" 
								+ response[i]).attr("data-pk", response[i]).addClass("custom-image");
	                        $(".summernote-editor").summernote("insertNode", img[0]);							
						}
                    }
                });
            }
        }
    });
});