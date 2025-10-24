<%@ page contentType="text/html; charset=UTF-8" %>
<jsp:include page="/WEB-INF/views/template/header.jsp" />

<style>
  body {
    background-color: #f4ede6;
    color: #5b3a29;
    margin: 0;
    padding: 0;
  }

  .container.w-400 {
    max-width: 400px;
    margin: 60px auto;
    padding: 30px 35px;
    border-radius: 15px;
    background-color: #ffffffdd;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
    font-family: 'Noto Sans KR', sans-serif;
  }

  h1 {
    font-size: 2rem;
    font-weight: 700;
    margin-bottom: 30px;
    text-align: center;
  }

  label {
    display: block;
    font-weight: 600;
    margin-bottom: 8px;
  }

  input[type="text"] {
    width: 100%;
    padding: 10px 12px;
    border: 1px solid #d6c2a6;
    border-radius: 10px;
    font-size: 1rem;
    color: #5b3a29;
    box-sizing: border-box;
    margin-bottom: 25px;
  }

  input[type="text"]:focus {
    outline: none;
    border-color: #a67c52;
    box-shadow: 0 0 5px #a67c52;
  }

  button[type="submit"] {
    width: 100%;
    padding: 12px 0;
    background-color: #a67c52;
    color: #fff5e9;
    font-size: 1.1rem;
    font-weight: 700;
    border: none;
    border-radius: 12px;
    cursor: pointer;
    transition: background-color 0.3s ease;
  }

  button[type="submit"]:hover {
    background-color: #ba8f65;
  }

  .back-link {
    display: block;
    margin-top: 30px;
    text-align: center;
    color: #5b3a29;
    text-decoration: none;
    font-weight: 600;
  }

  .back-link:hover {
    text-decoration: underline;
  }
</style>

<div class="container w-400">
  <h1>새로운 게시판 등록</h1>

  <form action="add" method="post">
    <label for="categoryName">카테고리 이름:</label>
    <input type="text" id="categoryName" name="categoryName" required autocomplete="off" />

    <button type="submit">등록하기</button>
  </form>

  <a href="list" class="back-link">목록으로 돌아가기</a>
</div>

<jsp:include page="/WEB-INF/views/template/footer.jsp" />
