//package com.spring.semi.service;
//
//import org.jsoup.Jsoup;
//import org.jsoup.nodes.Document;
//import org.jsoup.nodes.Element;
//import org.jsoup.select.Elements;
//import org.springframework.beans.factory.annotation.Autowired;
//import org.springframework.stereotype.Service;
//import org.springframework.transaction.annotation.Transactional;
//
//import com.spring.semi.dao.BoardDao;
//import com.spring.semi.dao.MemberDao;
//import com.spring.semi.dao.ReplyDao;
//import com.spring.semi.dto.BoardDto;
//
//@Service
//@Transactional 
//public class BoardService {
//	
//	@Autowired
//	private BoardDao boardDao;
//	@Autowired
//	private ReplyDao replyDao;
//	@Autowired
//	private MemberDao memberDao;
//	@Autowired
//	private MediaService mediaService;
//
//	public boolean deleteBoardAndPointAndMedia (BoardDto boardDto, int deductionPoint) {
//		int boardNo = boardDto.getBoardNo();
//		
//		String writerId = boardDao.findWriterId(boardNo);
//		if(writerId == null) {
//			return false;
//		}
//		
//		String content = boardDto.getBoardContent();
//		if (content != null && !content.trim().isEmpty()) {
//			try {				
//				Document document = Jsoup.parse(boardDto.getBoardContent());
//				Elements elements = document.select(".custom-image");
//				
//				for (Element element : elements) {
//					String dataPk = element.attr("data-pk");
//					
//					if(dataPk != null && !dataPk.isEmpty()) {
//						int mediaNo = Integer.parseInt(dataPk);
//						mediaService.delete(mediaNo);
//					}
//				}
//			} catch (NumberFormatException e) {
//            } catch (Exception e) {
//                return false;
//            }
//        }
//	
//		boolean boardDeleted = boardDao.delete(boardNo);
//		
//		if(boardDeleted) {
//			boolean isPointDeducted = memberDao.minusPoint(writerId, deductionPoint);
//			
//			return isPointDeducted;
//		}
//		return false;
//	}
//	
//}
