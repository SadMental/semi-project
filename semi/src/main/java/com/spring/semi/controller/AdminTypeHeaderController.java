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

import com.spring.semi.dao.TypeHeaderDao;
import com.spring.semi.dto.TypeHeaderDto;

@Controller
@RequestMapping("/admin/typesetting")
public class AdminTypeHeaderController {

    @Autowired
    private TypeHeaderDao typeHeaderDao;

    /** 목록 페이지 */
    @GetMapping("/list")
    public String list(Model model) {
        List<TypeHeaderDto> list = typeHeaderDao.selectAll();
        model.addAttribute("typeHeaderList", list);
        return "/WEB-INF/views/admin/typesetting/list.jsp";
    }

    /** 등록 페이지 */
    @GetMapping("/add")
    public String addPage() {
        return "/WEB-INF/views/admin/typesetting/add.jsp";
    }

    /** 등록 처리 */
    @PostMapping("/add")
    public String add(@RequestParam String typeHeaderName) {
        TypeHeaderDto dto = new TypeHeaderDto();
        dto.setTypeHeaderNo(typeHeaderDao.sequence()); 
        dto.setTypeHeaderName(typeHeaderName);
        typeHeaderDao.insert(dto);
        return "redirect:list";
    }

    /** 수정 페이지 */
    @GetMapping("/edit")
    public String editPage(@RequestParam int typeHeaderNo, Model model) {
        TypeHeaderDto dto = typeHeaderDao.selectOne(typeHeaderNo);
        model.addAttribute("typeHeaderDto", dto);
        return "/WEB-INF/views/admin/typesetting/edit.jsp";
    }

    /** 수정 처리 */
    @PostMapping("/edit")
    public String edit(@ModelAttribute TypeHeaderDto dto) {
        typeHeaderDao.update(dto);
        return "redirect:/admin/typesetting/list";
    }

    /** 삭제 */
    @PostMapping("/delete")
    public String delete(@RequestParam int typeHeaderNo) {
        typeHeaderDao.delete(typeHeaderNo);
        return "redirect:list";
    }
}
