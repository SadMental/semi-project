<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<style>

body {
   background-color: #F9F6F1; 
   color: #774F3B;
   font-family: 'Noto Sans KR', sans-serif; 
   margin: 0; padding: 0;
}
.list-page-wrapper {
	max-width: 900px; 
	margin: 50px auto;
	padding: 40px;
	border-radius: 25px; 
	background-color: #FFFFFF;
	box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
	
}
h1 {
   font-size: 2.8rem;
   font-weight: 800;
   margin-bottom: 20px;
   text-align: center;
   color: #774F3B;
   display: flex;
   justify-content: center;
   align-items: center;
}
h1::before {
   content: "🐾";
   margin-right: 15px;
   font-size: 1.5em;
   animation: bounce 2s infinite;
}
@keyframes bounce {
   0%, 20%, 50%, 80%, 100% {transform: translateY(0);}
   40% {transform: translateY(-5px);}
   60% {transform: translateY(-2px);}
}
table { width: 100%; border-collapse: separate; border-spacing: 0; margin-top: 20px; }
table thead { background-color: #EED9C4; } 
table th, table td {
   padding: 15px 12px;
   text-align: center;
   border: none;
   color: #5B3A29;
}
table th { font-weight: 700; }
table tbody tr { transition: background-color 0.3s, transform 0.2s; }
table tbody tr:hover {
   background-color: #FFF0E8; 
     transform: translateY(-2px);
   box-shadow: 0 4px 8px rgba(0, 0, 0, 0.05);
}
table tbody tr:first-child td:first-child { border-top-left-radius: 15px; }
table tbody tr:first-child td:last-child { border-top-right-radius: 15px; }
table tbody tr:last-child td:first-child { border-bottom-left-radius: 15px; }
table tbody tr:last-child td:last-child { border-bottom-right-radius: 15px; }
a { color: #5B3A29; text-decoration: none; transition: color 0.2s; }
a:hover { color: #FFB8A2; } 

.btn.btn-positive {
	background-color: #FFB8A2;
   color: #5B3A29;
   border: none;
   padding: 12px 25px;
	font-size: 1.1rem;
   font-weight: 700;
   border-radius: 20px;
   cursor: pointer;
	text-decoration: none;
   display: inline-block;
   box-shadow: 0 3px 6px rgba(0, 0, 0, 0.15);
   transition: all 0.2s;
}
.btn.btn-positive:hover {
   background-color: #FF9E87;
   transform: translateY(-2px);
   box-shadow: 0 5px 10px rgba(0, 0, 0, 0.15);
}
.cell.right { text-align: right; }
.no-posts { text-align: center; padding: 40px 0; color: #A97B5F; font-size: 1.2rem; }
/* 카테고리 섹션 */
.category-section {
   border: 1px solid #EED9C4;
   border-radius: 20px;
   padding: 20px;
   background-color: #FFFFFF; /* 내부 섹션은 흰색 */
   margin-bottom: 30px;
   box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
}
.category-row {
   display: flex;
   align-items: center;
   margin-bottom: 15px;
   padding-bottom: 10px;
   border-bottom: 1px dashed #EED9C4;
}
.category-row:last-child { border-bottom: none; margin-bottom: 0; padding-bottom: 0; }
.group-title {
   font-weight: 700;
   color: #A97B5F;
   margin-right: 20px;
   min-width: 90px;
   text-align: left;
   font-size: 1rem;
}

.header-group {
   display: flex;
   flex-wrap: wrap;
   overflow: visible; 
   padding: 0 5px;
   gap: 8px; 
}

.category-btn, .type-btn {
   text-decoration: none;
   white-space: nowrap;
   font-size: 14px;
   padding: 8px 16px;
   border-radius: 9999px;
   transition: all 0.2s;
   font-weight: 600;
   line-height: 1;
   margin-bottom: 8px;
}
.category-btn {
   background-color: #EED9C4; 
   color: #774F3B;
}
.category-btn:hover {
   background-color: #FFB8A2; 
   color: #5B3A29;
   transform: scale(1.05);
}
.category-btn.active {
   background-color: #A97B5F; 
   color: #fff;
   box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
}
.type-btn {
   background-color: #F7F3ED;
   color: #A97B5F;
   border: 1px solid #EED9C4;
}
.type-btn:hover {
   background-color: #EED9C4;
   transform: scale(1.05);
}
.type-btn.type-active {
   background-color: #A97B5F;
   color: #fff;
   border: 1px solid #A97B5F;
}
/* 정렬 기준 버튼 스타일 */
.sort-group .sort-btn {
   text-decoration: none;
   color: #774F3B;
   padding: 4px 10px;
   border-radius: 10px;
   margin-left: 10px;
   transition: background-color 0.2s;
}
.sort-group .sort-btn:hover {
   background-color: #F7F3ED;
}
.sort-group .sort-btn.active {
   font-weight: 700;
   background-color: #EED9C4;
}

.all-view-and-search {
   justify-content: space-between !important;
   align-items: center;
   flex-wrap: wrap;
   gap: 15px;
   padding-left: 0;
   padding-right: 0;
}
.all-view-button-group {
   display: flex;
   align-items: center;
   gap: 10px;
}
.search-form-inline {
   display: flex;
   gap: 5px;
   align-items: center;
   background-color: #F7F3ED;
   border: 1px solid #EED9C4;
   border-radius: 15px;
   padding: 5px;
}
.search-form-inline select, .search-form-inline input[type="text"] {
   padding: 6px 10px;
   border: none;
   background-color: transparent; 
   border-radius: 10px;
   color: #5B3A29;
   font-size: 14px;
   appearance: none;
}
.search-form-inline select {
   border-right: 1px solid #EED9C4;
   padding-right: 15px;
   cursor: pointer;
}
.search-form-inline input[type="text"] {
   width: 150px;
   outline: none;
}
.btn.btn-positive.btn-search-icon {
   padding: 8px 12px;
   font-size: 0.9rem;
   border-radius: 10px;
   background-color: #A97B5F;
   color: #FFFFFF;
   box-shadow: none;
   transition: background-color 0.2s;
}
.btn.btn-positive.btn-search-icon:hover {
   background-color: #774F3B;
   transform: none;
   box-shadow: none;
}
.reply-count {
   font-weight: 700;
   color: #FFB8A2;
   margin-left: 5px;
}
</style>
<div class="list-page-wrapper">
	<div class="page-header-area">
		    <h1>${category.categoryName}</h1>
		</div>
		<div class="category-section">
		   
		    <div class="category-row all-view-and-search" style="border-bottom:2px solid #EED9C4; padding-bottom:15px;">
		       
               <div class="all-view-button-group">
                 
                   <a href="list?animalHeaderName=&typeHeaderName=&orderBy=${selectedOrderBy}&keyword="
                      class="category-btn
                             <c:if test='${empty selectedAnimalHeaderName and empty selectedTypeHeaderName and empty pageVO.keyword}'>active</c:if>">
                       🏠 전체보기
                   </a>
                  
                   <c:if test="${pageVO.keyword != null && pageVO.keyword != ''}">
                       <span style="font-size:0.95rem; color:#A97B5F; font-weight: 600;">
                           '${pageVO.keyword}' 검색 결과
                       </span>
                   </c:if>
               </div>
              
         
               <form action="list" method="get" class="search-form-inline">
                  
              
                   <c:if test="${selectedAnimalHeaderName != null}">
                       <input type="hidden" name="animalHeaderName" value="${selectedAnimalHeaderName}">
                   </c:if>
                   <c:if test="${selectedTypeHeaderName != null}">
                       <input type="hidden" name="typeHeaderName" value="${selectedTypeHeaderName}">
                   </c:if>
                   <c:if test="${selectedOrderBy != null}">
                       <input type="hidden" name="orderBy" value="${selectedOrderBy}">
                   </c:if>
                   <select name="column" title="검색 기준 선택">
		                <option value="board_title" <c:if test="${pageVO.column eq 'board_title'}">selected</c:if>>제목</option>
		                <option value="board_writer" <c:if test="${pageVO.column eq 'board_writer'}">selected</c:if>>아이디</option>
		                <option value="member_nickname" <c:if test="${pageVO.column eq 'member_nickname'}">selected</c:if>>닉네임</option>            
		                <option value="animal_header_name" <c:if test="${pageVO.column eq 'animal_header_name'}">selected</c:if>>동물 분류명</option>
		                <option value="type_header_name" <c:if test="${pageVO.column eq 'type_header_name'}">selected</c:if>>게시판타입</option>
		            </select>
                  
                 
		            <input type="text"
                          name="keyword"
                          value="<c:out value="${pageVO.keyword}"/>"
                          placeholder="검색어를 입력해 주세요">
                         
		            <button type="submit" class="btn btn-positive btn-search-icon" title="검색">
                       <i class="fas fa-search"></i>
                   </button>
		        </form>
		    </div>
		   
		    <div class="category-row">
		        <span class="group-title">동물 분류</span>
		        <span class="header-group">
		            <c:forEach var="animal" items="${animalList}">
		                <a href="list?animalHeaderName=${animal.headerName}&typeHeaderName=${selectedTypeHeaderName}&orderBy=${selectedOrderBy}&keyword=<c:out value="${pageVO.keyword}"/>&column=<c:out value="${pageVO.column}"/>"
		                   class="category-btn
		                          <c:if test='${selectedAnimalHeaderName eq animal.headerName}'>active</c:if>">
		                    <i class="fas fa-paw"></i> ${animal.headerName}
		                </a>
		            </c:forEach>
		        </span>
		    </div>
		  
		    <div class="category-row">
		        <span class="group-title">게시판 타입</span>
		        <span class="header-group">
		            <c:forEach var="type" items="${typeList}">
		                <a href="list?animalHeaderName=${selectedAnimalHeaderName}&typeHeaderName=${type.headerName}&orderBy=${selectedOrderBy}&keyword=<c:out value="${pageVO.keyword}"/>&column=<c:out value="${pageVO.column}"/>"
		                   class="type-btn
		                          <c:if test='${selectedTypeHeaderName eq type.headerName}'>type-active</c:if>">
		                    <i class="fas fa-tag"></i> ${type.headerName}
		                </a>
		            </c:forEach>
		        </span>
		    </div>
		    
		    <div class="category-row" style="justify-content:flex-end; border-top:1px solid #EED9C4; padding-top:15px; margin-bottom: 0;">
		        <span class="sort-group">
		        
		            <a href="list?animalHeaderName=${selectedAnimalHeaderName}&typeHeaderName=${selectedTypeHeaderName}&orderBy=wtime&keyword=<c:out value="${pageVO.keyword}"/>&column=<c:out value="${pageVO.column}"/>"
		               class="sort-btn<c:if test='${selectedOrderBy eq "wtime"}'> active</c:if>">
		                <i class="fas fa-clock"></i> 최신순
		            </a>
		            <a href="list?animalHeaderName=${selectedAnimalHeaderName}&typeHeaderName=${selectedTypeHeaderName}&orderBy=view&keyword=<c:out value="${pageVO.keyword}"/>&column=<c:out value="${pageVO.column}"/>"
		               class="sort-btn<c:if test='${selectedOrderBy eq "view"}'> active</c:if>">
		                <i class="fas fa-eye"></i> 조회순
		            </a>
		        </span>
		    </div>
		</div>
	
		<div class="cell right write-button-area" style="margin-top: 25px; margin-bottom: 25px;">
		    <c:choose><c:when test="${sessionScope.loginId != null}">
		            <a href="write" class="btn btn-positive">
                       <i class="fas fa-pencil-alt"></i> 글쓰기
                   </a>
		        </c:when><c:otherwise>
		            <p style="color:#A97B5F;">
                       <a href="/member/login" style="color:#FFB8A2; font-weight:700;">로그인</a>을 해야 글을 작성할 수 있습니다
                   </p>
		        </c:otherwise></c:choose>
		</div>
		
		<c:choose><c:when test="${empty boardList}">
		        <div class="no-posts">
                   <i class="fas fa-dog" style="font-size: 2rem; display: block; margin-bottom: 10px;"></i>
                   <i class="fas fa-cat" style="font-size: 2rem; display: block; margin-bottom: 10px;"></i>
                   현재 등록된 귀여운 아가들이 없어요 😭
               </div>
		    </c:when><c:otherwise>
		        <table>
					<thead>
					    <tr>
					        <th style="width: 5%;">No</th>
					        <th style="width: 10%;">분류</th>
					        <th style="width: 10%;">종류</th>
					        <th style="width: 22%;">제목</th>
					        <th style="width: 23%;">작성자</th>
					        <th style="width: 12%;">분양여부</th> <th style="width: 9%;">조회수</th>
					        <th style="width: 9%;">작성일</th>
					    </tr>
					</thead>
					<tbody>
					    <c:forEach var="boardDto" items="${boardList}">
					        <tr>
					            <td>${boardDto.boardNo}</td>
					            <td>${boardDto.typeHeaderName}</td>
					            <td>${boardDto.animalHeaderName}</td>
					            <td style="text-align: left; padding-left: 20px; font-weight: 600;">
					                <a href="detail?boardNo=${boardDto.boardNo}">
					                   <i class="fas fa-heart" style="color:#FFB8A2; margin-right:5px;"></i>
					                    ${boardDto.boardTitle}
					                    <c:if test="${boardDto.boardReply > 0}">
					                        <span class="reply-count">(${boardDto.boardReply})</span>
					                    </c:if>
					                </a>
					            </td>
					            <td>
					                ${boardDto.memberNickname}
					                <c:if test="${not empty boardDto.badgeImage}">
					                    ${boardDto.badgeImage}
					                </c:if>
					                <c:if test="${not empty boardDto.levelName}">
					                    <span class="level-badge">${boardDto.levelName}</span>
					                </c:if>
					            </td>
					            
					            <td style="font-size: 1.2em;">
					                <c:choose>
					                    <c:when test="${boardDto.animalPermission eq 't' or boardDto.animalPermission eq '분양 가능'}">
					                        <span title="분양 가능" style="color: green;">✅</span> 
					                    </c:when>
					                    <c:otherwise>
					                        <span title="분양 완료" style="color: red;">❌</span> 
					                    </c:otherwise>
					                </c:choose>
					            </td>
					            <td><i class="fas fa-eye" style="margin-right: 5px;"></i> ${boardDto.boardView}</td>
					            <td style="font-size: 0.9em; color:#A97B5F;">
					               <fmt:parseDate value="${boardDto.boardWtime}" pattern="yyyy-MM-dd HH:mm:ss" var="wtimeDate" />
					               <fmt:formatDate value="${wtimeDate}" pattern="yy.MM.dd" />
					           </td>
					        </tr>
					    </c:forEach>
					</tbody>
		            <tfoot>
		                <tr>
		                    <td colspan="7" style="border-top: 1px solid #EED9C4; padding-top: 20px;">
		                        <span style="font-weight:700; color:#A97B5F;">
                                   <i class="fas fa-list-alt"></i> 목록 정보:
                               </span>
                               ${pageVO.begin} - ${pageVO.end} / 총 ${pageVO.dataCount}개
		                    </td>
		                </tr>
		                <tr>
		                    <td colspan="7" style="text-align:center;">
		                        <jsp:include page="/WEB-INF/views/template/pagination.jsp" />
		                    </td>
		                </tr>
		            </tfoot>
		        </table>
		    </c:otherwise></c:choose>
</div>
<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>
