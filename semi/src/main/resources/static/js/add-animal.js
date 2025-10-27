$(function(){
   $(".btn-add-animal").on("click", function(){
       	var origin = $("#animal-template").text(); // 글자를 불러오고
       	var html = $.parseHTML(origin); // HTML 구조로 재해석
       	$(".target").append(html);
   	});
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
   $(document).on("click", ".animal-access", function(){
	   var wrapper = $(this).closest(".animal-wrapper")
       var animalName = wrapper.find(".animal-name").val()
       var animalPermission = wrapper.find(".btn-animal").attr("data-permission")
       var animalContent = wrapper.find(".animal-content").val()
       var animalNo = wrapper.attr("data-animal-no")
       if(animalNo == "new"){
           $.ajax({
               url : "/rest/animal/add",
               method : "post",
               data : {
        	   		animalName : animalName, 
       	   			animalPermission : animalPermission,
       				animalContent : animalContent	
               },
               success : function(response){
            	   wrapper.attr("data-animal-no", response)
            	   wrapper.find(".animal-access").toggle();
            	   wrapper.find(".animal-edit").toggle();
            	   wrapper.find(".animal-name").attr("readonly", "readonly")
            	   wrapper.find(".animal-content").attr("readonly", "readonly")
            	   wrapper.find(".btn-animal").attr("disabled", "disabled")
            	   
               }
           })
       } else {
    	   $.ajax({
               url : "/rest/animal/edit",
               method : "post",
               data : {
            	   animalNo : animalNo,
					animalName : animalName, 
					animalPermission : animalPermission,
					animalContent : animalContent	
               },
               success : function(response){
            	   wrapper.find(".animal-access").toggle();
            	   wrapper.find(".animal-edit").toggle();
            	   wrapper.find(".animal-name").attr("readonly", "readonly")
            	   wrapper.find(".animal-content").attr("readonly", "readonly")
            	   wrapper.find(".btn-animal").attr("disabled", "disabled")
               }
           })
       }
   });
   $(document).on("click", ".animal-edit", function() {
	   var wrapper = $(this).closest(".animal-wrapper")
	   wrapper.find(".animal-access").toggle();
   	   wrapper.find(".animal-edit").toggle();
   	   wrapper.find(".animal-name").removeAttr("readonly")
   	   wrapper.find(".animal-content").removeAttr("readonly")
   	   wrapper.find(".btn-animal").removeAttr("disabled")
	});
   
});