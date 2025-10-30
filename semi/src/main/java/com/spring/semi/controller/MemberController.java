package com.spring.semi.controller;

import java.io.IOException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.spring.semi.dao.AnimalDao;
import com.spring.semi.dao.BoardDao;
import com.spring.semi.dao.MemberDao;
import com.spring.semi.dto.AnimalDto;
import com.spring.semi.dto.MemberDto;
import com.spring.semi.error.TargetNotfoundException;
import com.spring.semi.service.EmailService;
import com.spring.semi.service.MediaService;
import com.spring.semi.vo.BoardListVO;

import jakarta.mail.MessagingException;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/member")
public class MemberController {

	@Autowired
	private MemberDao memberDao;
	@Autowired
	private MediaService mediaService;
	@Autowired
	private AnimalDao animalDao;
	@Autowired
	private EmailService emailService;
	@Autowired
	private BoardDao boardDao;

	
	@GetMapping("/join")
	public String join() {
		return "/WEB-INF/views/member/join.jsp";
	}
	
	@PostMapping("/join")
	public String join(
			@ModelAttribute MemberDto memberDto,
			@RequestParam MultipartFile media
			) throws IllegalStateException, IOException {
		memberDao.insert(memberDto);
		if(media.isEmpty() == false) {
			int media_no = mediaService.save(media);
			memberDao.connect(memberDto.getMemberId(), media_no);
		}
		
		return "redirect:joinFinish";
	}
	
	@GetMapping("/joinFinish")
	public String joinFinish() {
		return "/WEB-INF/views/member/joinFinish.jsp";
	}
	
	@GetMapping("/login")
	public String login() {
		return "/WEB-INF/views/member/login.jsp";
	}
	
	@PostMapping("/login")
	public String login(
			@ModelAttribute MemberDto memberDto,
			HttpSession session
			) {
		MemberDto findDto = memberDao.selectOne(memberDto.getMemberId());
		if(findDto == null) return "redirect:/?error";
		if(findDto.getMemberPw().equals(memberDto.getMemberPw()) == false) return "redirect:login?error";
		
		session.setAttribute("loginId", findDto.getMemberId());
		session.setAttribute("loginLevel", findDto.getMemberLevel());
		memberDao.updateForLogin(findDto.getMemberId());
		
		return "redirect:/";
	}
	
	@GetMapping("/logout")
	public String logout(
			HttpSession session
			) {
		session.removeAttribute("loginId");
		session.removeAttribute("loginLevel");
		
		return "redirect:/";
	}
	
	@GetMapping("/edit")
	public String edit(
			HttpSession session,
			Model model
			) {
		String loginId = (String) session.getAttribute("loginId");
		MemberDto memberDto = memberDao.selectOne(loginId);
		List<AnimalDto> animalList = animalDao.selectList(loginId);
		model.addAttribute("animalList", animalList);
		model.addAttribute("memberDto", memberDto);
		return "/WEB-INF/views/member/edit.jsp";
	}
	
	@PostMapping("/edit")
	public String edit(
			HttpSession session,
			@ModelAttribute MemberDto memberDto
			) throws IllegalStateException, IOException {
		String loginId = (String) session.getAttribute("loginId");
		MemberDto originDto = memberDao.selectOne(loginId);
		if(originDto.getMemberPw().equals(memberDto.getMemberPw()) == false) return "redirect:edit?error";
		
		
		memberDto.setMemberId(loginId);
		memberDao.updateForUser(memberDto);
		
		return "redirect:mypage";
		
	}
	
	@GetMapping("/password")
	public String password() {
		return "/WEB-INF/views/member/password.jsp";
	}
	
	@PostMapping("/password")
	public String passwrod(
			HttpSession session,
			@RequestParam(name = "change_pw") String change_pw,
			@RequestParam(name = "current_pw") String member_pw
			) {
		String loginId = (String) session.getAttribute("loginId");
		MemberDto findDto = memberDao.selectOne(loginId);
		if(member_pw.equals(findDto.getMemberPw()) == false) return "redirect:password?error";
		memberDao.updateForUserPassword(change_pw, findDto.getMemberId());
		
		return "redirect:mypage";
	}
	
	@GetMapping("/mypage")
	public String mypage(
			Model model, 
			HttpSession session
			) {
		String loginId = (String) session.getAttribute("loginId");
		
		if(loginId == null) {
			return "redirect:/member/join";
		}
		
		MemberDto memberDto = memberDao.selectOne(loginId);
		List<AnimalDto> animalList = animalDao.selectList(loginId);
		
		//작성글 리스트
		List<BoardListVO> boardListVO = boardDao.selectByMemberId(loginId);
		
		//삭제된 글 리스트 
		List<BoardListVO> deletedBoardListVO = boardDao.selectDeletedByMemberId(loginId);
		
		model.addAttribute("animalList", animalList);
		model.addAttribute("memberDto", memberDto);
		model.addAttribute("boardListVO", boardListVO);
		model.addAttribute("deletedBoardListVO", deletedBoardListVO);
				
		return "/WEB-INF/views/member/mypage.jsp";
	}
	
	@GetMapping("/drop")
	public String drop() {
		return "/WEB-INF/views/member/drop.jsp";
	}
	
	@PostMapping("/drop")
	public String drop(
			HttpSession session,
			@RequestParam String member_pw
			) {
		String loginId = (String) session.getAttribute("loginId");
		MemberDto findDto = memberDao.selectOne(loginId);
		if(member_pw.equals(findDto.getMemberPw()) == false) return "redirect:drop?error";
		memberDao.delete(loginId);
		session.removeAttribute("loginId");
		session.removeAttribute("loginLevel");
		return "/WEB-INF/views/member/thankyou.jsp";
	}
	
	@GetMapping("/profile")
	public String profile(
			@RequestParam String member_id
			) {
		try {
			int media_no = memberDao.findMediaNo(member_id);
			return "redirect:/media/download?mediaNo=" + media_no;
		} catch(Exception e) {
			return "redirect:/image/error/no-image.png";
		}
	}
	
	@GetMapping("/detail")
	public String detail(
			Model model,
			@RequestParam String memberNickname
			) {
		MemberDto findDto = memberDao.selectForNickname(memberNickname);
		if(findDto == null) throw new TargetNotfoundException("존재하지않는 회원");
		List<AnimalDto> animalList = animalDao.selectList(findDto.getMemberId());
		model.addAttribute("memberDto", findDto);
		model.addAttribute("animalList", animalList);
		
		return "/WEB-INF/views/member/detail.jsp";
	}
	
	@GetMapping("/findId")
	public String findId() {
		return "/WEB-INF/views/member/findId.jsp";
	}
	
	@PostMapping("/findId")
	public String findId(
			@RequestParam String memberEmail
			) throws MessagingException, IOException {
		MemberDto findDto = memberDao.selectForEmail(memberEmail);
		if(findDto == null) throw new TargetNotfoundException("해당 이메일이 등록된 회원이 없습니다.");
		emailService.sendEmailForFindId(findDto);
		
		return "redirect:findResult";
	}
	
	@GetMapping("/findResult")
	public String findIdResult() {
		return "/WEB-INF/views/member/findResult.jsp";
	}
	
	@GetMapping("/findPw")
	public String findPw() {
		return "/WEB-INF/views/member/findPw.jsp";
	}
	
	@PostMapping("/findPw")
	public String findPw(
			@RequestParam String memberEmail
			) throws MessagingException, IOException {
		MemberDto findDto = memberDao.selectForEmail(memberEmail);
		if(findDto == null) throw new TargetNotfoundException("해당 이메일이 등록된 회원이 없습니다.");
		
		emailService.sendEmailForFindPw(findDto);
		
		return "redirect:findResult";
	}
	
	@RequestMapping("/donation")
	public String donation( @RequestParam(name = "rewardType", required = false) String rewardType, // <-- 콤마 필요
	        Model model,
	        HttpSession session) {
		String loginId = (String) session.getAttribute("loginId");
		MemberDto memberDto = memberDao.selectOne(loginId);
		
		if(loginId == null) {
			return "redirect:/member/join";
		}
		
		model.addAttribute("point", memberDto.getMemberPoint());
		model.addAttribute("rewardType", rewardType);
		 
		return "/WEB-INF/views/member/donation.jsp";
	}
	
	@RequestMapping("/pointUse")
	public String pointUse() {
		return "/WEB-INF/views/member/pointUse.jsp";
	}
	
	
	
}