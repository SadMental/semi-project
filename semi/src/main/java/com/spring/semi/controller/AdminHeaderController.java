package com.spring.semi.controller;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.semi.dao.HeaderDao;
import com.spring.semi.dto.HeaderDto;
@Controller
@RequestMapping("/admin/header")
public class AdminHeaderController {
	@Autowired
   private HeaderDao headerDao;
   /** 목록 페이지 */
	@GetMapping("/{type}/list")
	public String list(
			Model model,
			@PathVariable String type
			) {
	    List<HeaderDto> headerList = headerDao.selectList(type);
	    model.addAttribute("headerList", headerList);
	    return "/WEB-INF/views/admin/header/list.jsp";
	}
	
   /** 등록 페이지 */
   @GetMapping("/{type}/add")
   public String addPage(
		   @PathVariable String type
		   ) {
       return "/WEB-INF/views/admin/header/add.jsp";
   }
   /** 등록 처리 */
   @PostMapping("/{type}/add")
   public String add(
		   @ModelAttribute HeaderDto headerDto,
		   @PathVariable String type
		   ) {
	   int seq = headerDao.sequence(type);
	   headerDto.setHeaderNo(seq);
	   headerDao.insert(headerDto, type); // DTO로 전달
	   return "redirect:list";
   }
 
   /** 수정 페이지 */
   @GetMapping("/{type}/edit")
   public String editPage(
		   @RequestParam int headerNo, 
		   @PathVariable String type,
		   Model model
		   ) {
       HeaderDto headerDto = headerDao.selectOne(headerNo, type);

       model.addAttribute("headerDto", headerDto);
       return "/WEB-INF/views/admin/header/edit.jsp";
   }
   /** 수정 처리 */
   @PostMapping("/{type}/edit")
   public String edit(
		   @ModelAttribute HeaderDto headerDto,
		   @PathVariable String type
		   ) {
     
       headerDao.update(headerDto, type);
       return "redirect:list";
   }
   @PostMapping("/{type}/delete")
   public String delete(
		   @RequestParam int headerNo,
		   @PathVariable String type
		   ) {
       headerDao.delete(headerNo, type);
       return "redirect:list";
   }
}
