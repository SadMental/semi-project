package com.spring.semi.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.spring.semi.dao.MemberLevelDao;
import com.spring.semi.dto.MemberLevelDto;
import com.spring.semi.error.TargetNotfoundException;
import com.spring.semi.service.MemberService;

@Controller
@RequestMapping("/admin/level")
public class AdminMemberLevelController {

	@Autowired
	private MemberLevelDao memberLevelDao;
	@Autowired
	private MemberService memberService;

	// 목록
	@GetMapping("/list")
	public String list(Model model) {
		List<MemberLevelDto> levels = memberLevelDao.selectAll();
		model.addAttribute("levels", levels);
		return "/WEB-INF/views/admin/level/list.jsp";
	}

	// 상세
	@GetMapping("/detail")
	public String detail(@RequestParam int levelNo, Model model) {
		MemberLevelDto level = memberLevelDao.selectOne(levelNo);
		if (level == null) {
			throw new TargetNotfoundException("해당 회원 등급이 존재하지 않습니다. levelNo=" + levelNo);
		}
		model.addAttribute("level", level);
		return "/WEB-INF/views/admin/level/detail.jsp";
	}

	// 추가
	@GetMapping("/add")
	public String add() {
		return "/WEB-INF/views/admin/level/add.jsp";
	}

	@PostMapping("/add")
	public String addSubmit(MemberLevelDto level) {
		memberLevelDao.insert(level);
		return "redirect:list";
	}

	// 삭제
	@PostMapping("/delete")
	public String delete(@RequestParam int levelNo) {
		MemberLevelDto level = memberLevelDao.selectOne(levelNo);
		if (level == null) {
			throw new TargetNotfoundException("삭제할 회원 등급이 존재하지 않습니다. levelNo=" + levelNo);
		}
		memberLevelDao.delete(levelNo);
		return "redirect:list";
	}

	// 수정 폼
	@GetMapping("/edit")
	public String edit(@RequestParam int levelNo, Model model) {
		MemberLevelDto level = memberLevelDao.selectOne(levelNo);
		if (level == null) {
			throw new TargetNotfoundException("수정할 회원 등급이 존재하지 않습니다. levelNo=" + levelNo);
		}
		model.addAttribute("level", level);
		return "/WEB-INF/views/admin/level/edit.jsp";
	}

	// 수정 처리
	@PostMapping("/edit")
	public String edit(MemberLevelDto level) {
		MemberLevelDto memberLevelDto = memberLevelDao.selectOne(level.getLevelNo());
		if (memberLevelDto == null) {
			throw new TargetNotfoundException("수정할 회원 등급이 존재하지 않습니다. levelNo=" + level.getLevelNo());
		}
		memberLevelDao.update(level);
		return "redirect:detail?levelNo=" + memberLevelDto.getLevelNo();
	}


	@PostMapping("/updateAll")
	public String updateAll() {
	    // 서비스 호출로 전체 회원 등급 갱신
	    memberService.updateMemberLevels();

	    // 결과 메시지 없이 바로 목록으로 이동
	    return "redirect:list";
	}

}
