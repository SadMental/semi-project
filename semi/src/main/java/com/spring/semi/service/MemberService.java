package com.spring.semi.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.semi.dao.MemberDao;
import com.spring.semi.dto.MemberDto;
import com.spring.semi.vo.MemberVO;

@Service
public class MemberService {

    @Autowired
    private MemberDao memberDao;

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
