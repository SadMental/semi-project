$(function(){
	
	// 동물 등록리스트 추가 버튼 클릭
	$(".btn-add-animal").on("click", function(){
       	var origin = $("#animal-template").text(); // 글자를 불러오고
       	var html = $.parseHTML(origin); // HTML 구조로 재해석
       	$(".target").append(html);
   	});
	
	// 분양 여부 버튼 클릭
   $(document).on("click", ".btn-animal", function(){
       var animalButton = $(this).closest(".animal-wrapper").find(".btn-animal")
       var permission = animalButton.attr('data-permission')
       if(permission === 'f') {
           animalButton.attr("data-permission", 't')
           animalButton.find("span").text("분양가능")
       } else {
           animalButton.attr("data-permission", 'f')
           animalButton.find("span").text("분양불가")
       }
   });
   
   // 삭제버튼 클릭
   $(document).on("click", ".animal-cancel", function(){
	   var wrapper = $(this).closest(".animal-wrapper")
	   var animalNo = wrapper.attr("data-animal-no")
	   console.log(animalNo)
	   if(animalNo == "new"){
		   wrapper.remove();
		   return;
	   }
	   $.ajax({
		   url : '/rest/animal/delete',
		   method : 'post',
		   data : {animalNo : animalNo},
		   success : function () {
			   wrapper.remove();
			}
	   })		
   });
   
   // 등록 버튼 클릭
   $(document).on("click", ".animal-access", function(){
	   var wrapper = $(this).closest(".animal-wrapper")
       var animalName = wrapper.find(".animal-name").val()
       var animalPermission = wrapper.find(".btn-animal").attr("data-permission")
       var animalContent = wrapper.find(".animal-content").val()
       var animalNo = wrapper.attr("data-animal-no")
	   var files = wrapper.find("[name=media]").prop("files")
	   var form = new FormData()
	   if(files.length != 0) {
			form.append("media", files[0])
	   }
	   form.append("animalName", animalName)
	   form.append("animalPermission", animalPermission)
	   form.append("animalContent", animalContent)
       if(animalNo == "new"){
           $.ajax({
				processData : false,
				contentType : false,
           		url : "/rest/animal/add",
               	method : "post",
               	data : form,
               	success : function(response){
            		wrapper.attr("data-animal-no", response)
            	   	wrapper.find(".animal-access").toggle();
            	   	wrapper.find(".animal-edit").toggle();
            	   	wrapper.find(".animal-name").attr("readonly", "readonly")
            	   	wrapper.find(".animal-content").attr("readonly", "readonly")
            	   	wrapper.find(".btn-animal").attr("disabled", "disabled")
				   	wrapper.find("[name=media]").prop("type", "hidden")
            	   
               }
           })
       } else {
			form.append("animalNo", animalNo)
    	   	$.ajax({
				processData : false,
				contentType : false,
              	url : "/rest/animal/edit",
               	method : "post",
               	data : form,
               	success : function(response){
            	   	wrapper.find(".animal-access").toggle();
            	   	wrapper.find(".animal-edit").toggle();
            	   	wrapper.find(".animal-name").attr("readonly", "readonly")
            	   	wrapper.find(".animal-content").attr("readonly", "readonly")
            	   	wrapper.find(".btn-animal").attr("disabled", "disabled")
				   	wrapper.find("[name=media]").prop("type", "hidden")
               }
           })
       }
   });
   
   // 수정 버튼 클릭
   $(document).on("click", ".animal-edit", function() {
	   var wrapper = $(this).closest(".animal-wrapper")
	   wrapper.find(".animal-access").toggle();
   	   wrapper.find(".animal-edit").toggle();
   	   wrapper.find(".animal-name").removeAttr("readonly")
   	   wrapper.find(".animal-content").removeAttr("readonly")
   	   wrapper.find(".btn-animal").removeAttr("disabled")
	   wrapper.find("[name=media]").prop("type", "file")
	});
   
});