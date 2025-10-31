moment.locale('ko');

$(function () {
    /* newboard_list();
    ranking_list();

    free_board_list(); */
    
    Promise.all([
    	newboard_list(),
    	ranking_list()
    ]).then(() => {
    	free_board_list()
    })

    function newboard_list() {
        return $.ajax({
            url: "/rest/main/newboard",
            method: "post",
            data: {},
            success: function (response) {
                var wrapper = $(".new-board-list-wrapper")
                wrapper.empty()
				var htmlBuffer = [];
				
                for (var i = 0; i < response.length; i++) {
                    var newboard = response[i];

                    var html = $($.parseHTML($("#new-board-template").text()))
                    
                    var url = "/board/" + newboard.categoryName + "/detail?boardNo=" + newboard.boardNo
					
                    html.find(".new-board-title").text(newboard.boardTitle).attr("href", url);
                    html.find(".new-board-time").text(newboard.formattedWtime);
                    
                    htmlBuffer.push(html);

                    /* $(".new-board-list-wrapper").append(html); */
                }
                wrapper.append(htmlBuffer)
            }
        });
    }

    function ranking_list() {
        return $.ajax({
            url: "/rest/main/ranking",
            method: "post",
            data: {},
            success: function (response) {
                var wrapper = $(".ranking-list-wrapper")
                wrapper.empty()
                
                var htmlBuffer = [];

                var number = 1;
                for (var i = 0; i < response.length; i++) {
                    var ranking = response[i];

                    /* var origin = $("#ranking-template").text(); */
                    var html = $($.parseHTML($("#ranking-template").text()));

                    html.find(".ranking-profile").attr("src", "/member/profile?member_id=" + ranking.memberId);
                    html.find(".number").text(number);
                    number++;
                    
                    var url = "/member/detail?memberNickname=" + ranking.memberNickname

                    html.find(".ranking-nickname").text(ranking.memberNickname).attr("href", url);
                    html.find(".ranking-description").text(ranking.memberDescription);

                    html.find(".ranking-member-point").text(ranking.memberPoint);

                    /* $(".ranking-list-wrapper").append(html); */
                    htmlBuffer.push(html)
                }
                wrapper.append(htmlBuffer);
            }
        });
    }

    function free_board_list() {
    	/* $(".free-board-time").each(function() {
			var free_board_time_text = $(this).text().trim();
			var free_board_time_time = moment(free_board_time_text);
			$(this).text(free_board_time_time.fromNow());
		});  */
		var times = $(".free-board-time")
		if(times.length == 0) return
		
		var now = moment()
		
		times.each(function (){
			var text = $(this).text().trim()
			var time = moment(text)
			$(this).text(time.from(now))
		})
    }
});