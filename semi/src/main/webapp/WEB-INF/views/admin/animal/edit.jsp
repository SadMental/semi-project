<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<jsp:include page="/WEB-INF/views/template/header.jsp"></jsp:include>
<link href="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.9.0/dist/summernote-lite.min.js"></script>
<link rel="stylesheet" type="text/css" href="/summernote/custom-summernote.css">
<script src="/summernote/custom-summernote.js"></script>
<script src="/js/edit-animal.js"></script>

<div class="container w-600">
	<form action="edit" method="post" enctype="multipart/form-data" autocomplete="off">
		<div class="cell animal-wrapper mt-20" data-animal-no="new">
			<div class="cell center">
				<input type="file" name="media" class="field w-100p" accept="image/*">
				<img class="img-preview" src="/animal/profile?animalNo=${animalDto.animalNo }" width="100">
			</div>
			<input type="hidden" name="animalNo" value="${animalDto.animalNo }">
			<input type="hidden" name="animalMaster" value="${animalDto.animalMaster }">
			<div class="cell">
				<label> <span>동물이름</span>
				</label> <input class="field w-100p animal-name" type="text"
					name="animalName" value="${animalDto.animalName }">
			</div>
			<div class="cell">
				<label> <span>동물 소개</span>
				</label>
				<textarea class="animal-content w-100p text-summernote-editor" name="animalContent">${animalDto.animalContent }</textarea>
			</div>
			<div class="cell">
				<button class="btn btn-neutral btn-animal" data-permission="${animalDto.animalPermission }"
					type="button">
					<i class="fa-solid fa-home"></i> <span>분양${animalDto.animalPermission == 'f'? '불가':'가능'}</span>
				</button>
				<input type="hidden" name="animalPermission" value="${animalDto.animalPermission }">
			</div>
			<div class="cell center">
				<button class="btn btn-positive w-50p" type="submit">수정하기</button>
			</div>
		</div>
	</form>
</div>
<jsp:include page="/WEB-INF/views/template/footer.jsp"></jsp:include>