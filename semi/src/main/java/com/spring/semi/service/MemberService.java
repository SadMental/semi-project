package com.spring.semi.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.spring.semi.dao.AnimalDao;
import com.spring.semi.dao.BoardDao;
import com.spring.semi.dao.BoardLikeDao;
import com.spring.semi.dao.MailDao;
import com.spring.semi.dao.MediaDao;
import com.spring.semi.dao.MemberDao;
import com.spring.semi.dto.AnimalDto;
import com.spring.semi.dto.MailDto;
import com.spring.semi.dto.MemberDto;
import com.spring.semi.vo.MemberVO;

@Service
public class MemberService {

    @Autowired
    private MemberDao memberDao;
    @Autowired
    private MediaDao mediaDao;
    @Autowired
    private BoardLikeDao boardLikeDao;
    @Autowired
    private BoardDao boardDao;
    @Autowired
    private AnimalDao animalDao;
    @Autowired
    private MailDao mailDao;
    
    @Transactional
    public boolean deleteMember(String memberId, String memberPw) {
    	MemberDto memberDto = memberDao.selectOne(memberId);
    	
    	if(memberDto.getMemberPw().equals(memberPw) == false) return false;
    	
    	memberDao.delete(memberId);
    	
    	try {
    		int mediaNo = memberDao.findMediaNo(memberId);
    		mediaDao.delete(mediaNo);
    	} catch (Exception e) {}
    	
    	List<AnimalDto> animalList = animalDao.selectList(memberId);
    	for(AnimalDto dto : animalList) {
    		animalDao.delete(dto.getAnimalNo());
    		try {
    			int mediaNo = animalDao.findMediaNo(dto.getAnimalNo());
    			mediaDao.delete(mediaNo);
    		} catch (Exception e) {}
    	}
    	
    	List<MailDto> mailList = mailDao.selectList(memberId);
    	for(MailDto dto : mailList) {
    		mailDao.delete(dto.getMailNo());
    	}
    	
    	
    	List<Integer> board_like_list = boardLikeDao.selectListByMemberId(memberId);
    	for(int like : board_like_list) {
    		boardDao.updateBoardLike(like);
    	}
    	
    	
    	return true;
    }

    // 작성자 정보 조회 + 포인트 기반 등급/뱃지 계산
    public MemberVO getMemberInfo(String memberId) {
        MemberDto dto = memberDao.selectOne(memberId); // DB 조회
        if (dto == null) return null;

        int point = dto.getMemberPoint();
        int level;
        String grade;
        String badgeName = "";
        String emoji = "";

        if (point >= 5000) {
            level = 5; grade = "level5";
        } else if (point >= 2000) {
            level = 4; grade = "level4";
        } else if (point >= 1000) {
            level = 3; grade = "level3";
        } else if (point >= 500) {
            level = 2; grade = "level2";
        } else {
            level = 1; grade = "level1";
        }

        switch (level) {
            case 1 -> { badgeName = "열혈 회원"; emoji = "🐰"; }
            case 2 -> { badgeName = "활발 회원"; emoji = "🐶"; }
            case 3 -> { badgeName = "인기 회원"; emoji = "🐱"; }
            case 4 -> { badgeName = "베테랑 회원"; emoji = "🐹"; }
            case 5 -> { badgeName = "우두머리"; emoji = "🏆"; }
        }

        return MemberVO.builder()
                .memberId(dto.getMemberId())
                .memberNickname(dto.getMemberNickname())
                .memberPoint(point)
                .memberLevel(level)
                .grade(grade)
                .badgeName(badgeName)
                .emoji(emoji)
                .build();
    }
}
