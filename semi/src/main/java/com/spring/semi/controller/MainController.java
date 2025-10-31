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
public class MainController 
{
	private Map<String, Object> cache = new ConcurrentHashMap<>();
	private long cacheTime = 0;  // 마지막으로 캐시 갱신한 시각
	private static final long CACHE_LIFETIME = 1000 * 60 * 5; // 5분
	
	@Autowired
	private BoardDao boardDao;
	
	
	@RequestMapping("/")
	public String home(Model model)
	{
		 // 캐시가 없거나 만료되면 갱신
        if (cache.isEmpty() || cacheExpired()) {
            //System.out.println("🔄 캐시 갱신 중... (DB 접근)");

            // --- 원래 코드에 있던 쿼리들만 유지 ---
            List<BoardVO> community_board_list = boardDao.selectListWithPagingForMainPage(1, 1, 8);	
            List<BoardVO> petfluencer_board_list = boardDao.selectListWithPagingForMainPage(3, 1, 10);		
            List<BoardVO> fun_board_list = boardDao.selectListWithPagingForMainPage(24, 1, 8);			
            List<BoardVO> animal_wiki_board_list = boardDao.selectListWithPagingForMainPage(7, 1, 6);	
            List<BoardVO> temp = boardDao.selectListWithPagingForMainPage(5, 1, 3);

            List<BoardVO> review_board_scroll = new ArrayList<>();
            review_board_scroll.addAll(temp);
            review_board_scroll.addAll(temp); // 무한루프용으로 두 배

            List<BoardVO> review_board_list = boardDao.selectListWithPagingForMainPage(5, 4, 7);

            // --- 캐시에 저장 ---
            cache.put("community_board_list", community_board_list);
            cache.put("petfluencer_board_list", petfluencer_board_list);
            cache.put("fun_board_list", fun_board_list);
            cache.put("animal_wiki_board_list", animal_wiki_board_list);
            cache.put("review_board_scroll", review_board_scroll);
            cache.put("review_board_list", review_board_list);

            cacheTime = System.currentTimeMillis(); // 캐시 갱신 시각 기록
        } else {
            //System.out.println("✅ 캐시 재사용 (DB 접근 안 함)");
        }

        // JSP에 캐시된 데이터 전달
        model.addAllAttributes(cache);

        return "/WEB-INF/views/home.jsp";
	}
	
	private boolean cacheExpired() {
	    return (System.currentTimeMillis() - cacheTime) > CACHE_LIFETIME;
	}
}