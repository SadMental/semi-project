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

import com.spring.semi.dao.AnimalHeaderDao;
import com.spring.semi.dto.AnimalHeaderDto;

@Controller
@RequestMapping("/admin/animalsetting")
public class AdminAnimalHeaderController {

    @Autowired
    private AnimalHeaderDao animalHeaderDao;

    /** 목록 페이지 */
    @GetMapping("/list")
    public String list(Model model) {
        List<AnimalHeaderDto> list = animalHeaderDao.selectAll();
        model.addAttribute("animalHeaderList", list);
        return "/WEB-INF/views/admin/animalsetting/list.jsp";
    }

    /** 등록 페이지 */
    @GetMapping("/add")
    public String addPage() {
        return "/WEB-INF/views/admin/animalsetting/add.jsp";
    }

    /** 등록 처리 */
    @PostMapping("/add")
    public String add(@RequestParam String animalHeaderName) {
        AnimalHeaderDto dto = new AnimalHeaderDto();
        dto.setAnimalHeaderNo(animalHeaderDao.sequence()); // 시퀀스로 번호 채움
        dto.setAnimalHeaderName(animalHeaderName);

        animalHeaderDao.insert(dto);
        return "redirect:list";
    }

    /** 수정 페이지 */
    @GetMapping("/edit")
    public String editPage(@RequestParam int animalHeaderNo, Model model) {
        AnimalHeaderDto dto = animalHeaderDao.selectOne(animalHeaderNo);
        System.out.println("DTO: " + dto); // DTO 확인
        model.addAttribute("animalHeaderDto", dto);
        return "/WEB-INF/views/admin/animalsetting/edit.jsp";
    }

    /** 수정 처리 */
    @PostMapping("/edit")
    public String edit(@ModelAttribute AnimalHeaderDto dto) {
        // 수정 처리
        animalHeaderDao.update(dto);
        return "redirect:/admin/animalsetting/list";
    }

    /** 삭제 */
    @PostMapping("/delete")
    public String delete(@RequestParam int animalHeaderNo) {
        animalHeaderDao.delete(animalHeaderNo);
        return "redirect:list";
    }
}
