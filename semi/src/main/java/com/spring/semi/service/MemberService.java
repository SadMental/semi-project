package com.spring.semi.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.semi.dao.LevelUpdateDao;
import com.spring.semi.vo.LevelUpdateVO;

@Service
public class MemberService {

    @Autowired
    private LevelUpdateDao levelUpdateDao;

    public List<LevelUpdateVO> getMembersForLevelUpdate() {
        return levelUpdateDao.selectMembersForLevelUpdate();
    }

    public int updateMemberLevels() {
        return levelUpdateDao.updateMemberLevels();
    }
}
