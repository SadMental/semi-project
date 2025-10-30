$(function(){
	

	
	// 분양 여부 버튼 클릭
   $(".btn-animal").on("click", function(){
       var animalButton = $(this).closest(".animal-wrapper").find(".btn-animal")
       var permission = animalButton.attr('data-permission')
	   var input = $("[name=animalPermission]")
       if(permission === 'f') {
           animalButton.attr("data-permission", 't')
           animalButton.find("span").text("분양가능")
		   input.val('t')
       } else {
           animalButton.attr("data-permission", 'f')
           animalButton.find("span").text("분양불가")
		   input.val('f')
       }
   });
   
   
});