package com.spring.semi.service;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.semi.dao.CategoryDao;
import com.spring.semi.vo.CategoryDetailVO;

@Service
public class CategoryService {

    @Autowired
    private CategoryDao categoryDao;

    public CategoryDetailVO getCategoryDetailByName(String categoryName) {
        // 1.기본 카테고리 정보 + 게시글 개수 조회
        CategoryDetailVO category = categoryDao.selectBasicCategoryStatsByName(categoryName);

        if (category == null) {
            return null;  // 해당 카테고리 없음
        }

        // 2.마지막 사용 시간 조회
        category.setLastUseTime(categoryDao.selectLastUseTime(category.getCategoryNo()));

        // 3.마지막 사용자 조회
        category.setLastUser(categoryDao.selectLastUser(category.getCategoryNo()));

        return category;
    }
}


