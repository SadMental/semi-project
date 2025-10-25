package com.spring.semi.controller;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.spring.semi.dao.HeaderDao;
import com.spring.semi.dto.HeaderDto;
@Controller
@RequestMapping("/admin/header")
public class HeaderController {
	@Autowired
   private HeaderDao headerDao;
   /** 목록 페이지 */
	@GetMapping("/list")
	public String list(Model model) {
	    List<HeaderDto> headerList = headerDao.selectAll();
	   
	    // 확인용 출력
	    System.out.println("headerList.size() = " + headerList.size());
	    for(HeaderDto header : headerList) {
	        System.out.println(header.getHeaderNo() + " / " + header.getHeaderName());
	    }
	    model.addAttribute("headerList", headerList);
	  
	    return "/WEB-INF/views/admin/header/list.jsp";
	}
   /** 등록 페이지 */
   @GetMapping("/add")
   public String addPage() {
       return "/WEB-INF/views/admin/header/add.jsp";
   }
   /** 등록 처리 */
   @PostMapping("/add")
   public String add(@RequestParam String headerName) {
       HeaderDto headerDto = new HeaderDto();
       headerDto.setHeaderName(headerName);

       headerDao.insert(headerDto); // DTO로 전달
       return "redirect:list";
   }
 
   /** 수정 페이지 */
   @GetMapping("/edit")
   public String editPage(@RequestParam int headerNo, Model model) {
       HeaderDto headerDto = headerDao.selectOne(headerNo);
       model.addAttribute("headerDto", headerDto);
       return "/WEB-INF/views/admin/header/edit.jsp";
   }
   /** 수정 처리 */
   @PostMapping("/edit")
   public String edit(@ModelAttribute HeaderDto headerDto) {
       headerDao.update(headerDto);
       return "redirect:list";
   }
   @PostMapping("/delete")
   public String delete(@RequestParam int headerNo) {
       headerDao.delete(headerNo);
       return "redirect:list";
   }
}
