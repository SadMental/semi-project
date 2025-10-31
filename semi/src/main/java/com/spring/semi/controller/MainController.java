package com.spring.semi.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.spring.semi.dao.BoardDao;
import com.spring.semi.vo.BoardVO;

@Controller
public class MainController // controller는 @Autowired를 위해 등록하지 않아도 된다
{
	// 게시판별 캐시를 Map으로 관리
    private final Map<String, List<BoardVO>> cache = new ConcurrentHashMap<>();
    private final Map<String, Long> cacheTime = new ConcurrentHashMap<>();
    private static final long CACHE_LIFETIME = 1000 * 60 * 5; // 5분
	
	@Autowired
	private BoardDao boardDao;
	
	
	@RequestMapping("/")
	public String home(Model model)
	{
		// 게시판별 ID
        String[] boards = {"community_board_list", "petfluencer_board_list", "fun_board_list", "animal_wiki_board_list", "review_board_scroll", "review_board_list"};

        for (String boardCategoryName : boards) {
            List<BoardVO> list = getBoardList(boardCategoryName);
            model.addAttribute(boardCategoryName, list);
        }

        return "/WEB-INF/views/home.jsp";
	}
	
	private List<BoardVO> getBoardList(String boardCategoryName) {
	    if (!isCacheExpired(boardCategoryName)) {
	        // 만료되지 않았으면 캐시 사용
	        return cache.get(boardCategoryName);
	    }

	    // 캐시가 없거나 만료되었으면 DB 조회
	    List<BoardVO> list;
	    switch (boardCategoryName) {
	        case "community_board_list":
	            list = boardDao.selectListWithPagingForMainPage(1, 1, 8);
	            break;
	        case "petfluencer_board_list":
	            list = boardDao.selectListWithPagingForMainPage(3, 1, 10);
	            break;
	        case "fun_board_list":
	            list = boardDao.selectListWithPagingForMainPage(24, 1, 8);
	            break;
	        case "animal_wiki_board_list":
	            list = boardDao.selectListWithPagingForMainPage(7, 1, 6);
	            break;
	        case "review_board_scroll":
	            List<BoardVO> temp = boardDao.selectListWithPagingForMainPage(5, 1, 3);
	            List<BoardVO> reviewScroll = new ArrayList<>();
	            reviewScroll.addAll(temp);
	            reviewScroll.addAll(temp); // 수량 맞춤
	            list = reviewScroll;
	            break;
	        case "review_board_list":
	            list = boardDao.selectListWithPagingForMainPage(5, 4, 7);
	            break;
	        default:
	            list = new ArrayList<>();
	    }

	    // 캐시 갱신
	    cache.put(boardCategoryName, list);
	    cacheTime.put(boardCategoryName, System.currentTimeMillis());

	    return list;
	}
	
	// 게시판별 캐시 만료 확인
	private boolean isCacheExpired(String boardCategoryName) {
	    if (!cache.containsKey(boardCategoryName) || !cacheTime.containsKey(boardCategoryName)) {
	        // 캐시가 아예 없으면 만료로 간주
	        return true;
	    }

	    long now = System.currentTimeMillis();
	    long lastUpdate = cacheTime.get(boardCategoryName);

	    // 캐시 수명 초과 여부 확인
	    return now - lastUpdate > CACHE_LIFETIME;
	}
	
	// 251031이윤석.boardDao에 추가하니 무한루프 문제가 생겨서 게시판 컨트롤러마다 적는다
	public void clearBoardCache(String boardCategoryName) {
        cache.remove(boardCategoryName);
        cacheTime.remove(boardCategoryName);
        //System.out.println("🧹 " + boardCategoryNo + " 캐시 초기화됨");
    }
}