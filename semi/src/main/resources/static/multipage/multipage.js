$(function(){
    // $(".page").not(":first").hide()
    $(".page").hide().first().show()
    $(".btn-next").on("click", function(){
        var current_page = $(".page").index($(".page:visible")) + 1
        var total_page = $(".page").length
        if(current_page < total_page){
            $(this).closest(".page").hide()
            $(this).closest(".page").next(".page").fadeToggle()
            refresh_page()
        } else {
            alert("마지막 페이지입니다.")
        }
    })
    $(".btn-prev").on("click", function(){
        var current_page = $(".page").index($(".page:visible")) + 1
        if(current_page > 1){
            $(this).closest(".page").hide()
            $(this).closest(".page").prev(".page").fadeToggle()
            refresh_page()
        } else {
            alert("첫 페이지입니다.")
        }
    })

    refresh_page()
    function refresh_page(){
        var total_page = $(".page").length
        $(".total-page").text(total_page)

        var current_page = $(".page").index($(".page:visible")) + 1
        $(".current-page").text(current_page)
        
        var percent = current_page * 100 / total_page
        $(".progressbar > .guage").css("width", percent+"%")
    }
})