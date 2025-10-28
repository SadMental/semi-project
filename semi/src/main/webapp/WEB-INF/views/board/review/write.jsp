<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<!-- summernote -->
<link href="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.js"></script>
<link rel="stylesheet" type="text/css" href="/summernote/custom-summernote.css">
<script src="/summernote/custom-summernote.js"></script>
<link rel="stylesheet" type="text/css" href="./commons.css">

<style>
  body {
    background-color: #f4ede6;
    color: #5b3a29;
    margin: 0;
    padding: 0;
  }
  
  .container.w-800 {
    max-width: 800px;
    margin: 40px auto;
    padding: 30px 35px;
    border-radius: 15px;
  }
  
  h1 {
    font-size: 2.8rem;
    font-weight: 700;
    margin-bottom: 20px;
  }


  input.field.w-100 {
    width: 100%;
    padding: 12px 15px;
    border: 2px solid #c9a66b;
    border-radius: 10px;
    font-size: 1.1rem;
    color: #5b3a29;
  }
  
  input.field.w-100:focus {
    outline: none;
    border-color: #7e5a3c;
    box-shadow: 0 0 8px #a57a50;
  }
  .cell.right {
    text-align: right;
  }
  button.btn.btn-positive {
    background-color: #7e5a3c;
    color: #f9f6f1;
    border: none;
    padding: 12px 28px;
    font-size: 1.1rem;
    font-weight: 700;
    border-radius: 12px;
    cursor: pointer;
  }
  
  button.btn.btn-positive:hover {
    background-color: #a67849;
  }
  .mt-20 {
  margin-top: 20px;
	}
		
</style>
<script src="https://cdn.jsdelivr.net/gh/hiphop5782/score@latest/score.js"></script>
<script type = "text/javascript">
    $(function(){
        $(".star-editor").score({
            starColor:"#f1c40f",
            //backgroundColor:"#dfe6e9",
            editable:true,//false
            integerOnly:true,//false
            zeroAvailable:true,
            send:{
                sendable:true,
                name:"boardScore",//star
            },
        });
    });
</script>


<form autocomplete="off" action="write" method="post" enctype="multipart/form-data">
  <div class="container w-800">
      <div class="cell center">
          <h1>사용후기 작성</h1>
      </div>
      <div class="cell center">
          이 글은 정보게시판에 업로드 됩니다.<br>
          <em>다른 사람에게 도움이 되는 유익한 글을 작성해주세요!</em>
      </div>
        <div class="cell flex-box">
			<select name="boardHeader" class="field w-100 mt-2">
			    <option value="">-- 분류 선택 --</option>
			    <c:forEach var="headerDto" items="${headerList}">
					<option value="${headerDto.headerNo}">${headerDto.headerName}</option>
				</c:forEach>
			</select>
			<select name="boardAnimalHeader" class="field w-100 mt-2">
			    <option value="">-- 분류 선택 --</option>
			    <c:forEach var="animalHeaderDto" items="${animalHeaderList}">
					<option value="${animalHeaderDto.animalHeaderNo}">${animalHeaderDto.animalHeaderName}</option>
				</c:forEach>
			</select>
			<select name="boardTypeHeader" class="field w-100 mt-2">
			    <option value="">-- 분류 선택 --</option>
			    <c:forEach var="typeHeaderDto" items="${typeHeaderList}">
					<option value="${typeHeaderDto.typeHeaderNo}">${typeHeaderDto.typeHeaderName}</option>
				</c:forEach>
			</select>
		</div>
		
		<div class = "cell">
            <div name="boardScore" class="star-editor" data-max="5"></div>
        </div>
      <div class="cell mt-20">
          <input type="text" name="boardTitle" class="field w-100" placeholder="제목을 입력하세요.">
      </div>
      
      <div class="cell mt-20">
          <textarea name="boardContent" class="summernote-editor"></textarea>
      </div>
      
      <div class = "cell">
      		<label>썸네일</label>
            <input type = "file"
            name = "media" accept = ".png,.jpg" class = "field w-100" required>
       </div>
      
      <div class="cell right mt-20">
          <button class="btn btn-positive">등록하기</button>
      </div>
  </div>
</form>

<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>