<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="domain.PhotoVo"%>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>photo</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/content/photo.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script>const contextPath = "<%=request.getContextPath()%>";</script>
<script src="${pageContext.request.contextPath}/content/photo.js"></script>
</head>

<body>
	<main>
		<section class="gallery-section">
			<div class="main-container">
				<h1 class="title">記憶</h1>
				<div class="gallery-grid">
					<%
						List<PhotoVo> photoList = (List<PhotoVo>) request.getAttribute("photoList");

					if (photoList != null && !photoList.isEmpty()) {
						int i = 1;
						for (PhotoVo photo : photoList) {
					%>
					<div class="grid-item">
						<div class="img-box">
							<img
								src="${pageContext.request.contextPath}/images/<%= photo.getFileName() %>"
								alt="写真" />
						</div>
						<p class="caption">
							(<%=i%>)
						</p>
					</div>
					<%
						i++;
					}
					}
					%>
				</div>
			</div>
		</section>
	</main>
	<div class="floating-home-btn"
		onclick="location.href='${pageContext.request.contextPath}/index';">
		<span class="material-icons">arrow_back</span>
	</div>
	<footer>
		<p>&copy; 2026 Leere. All rights reserved.</p>
	</footer>
	<div id="photoViewerModal" class="photo-viewer-overlay">
		<span class="photo-viewer-close-btn" id="closePhotoViewerModal">&times;</span>
		<img class="photo-viewer-content" id="viewerPhoto">
		<div id="photoViewerCaption" class="photo-viewer-caption-text"></div>
	</div>
</body>

<script>
document.addEventListener('DOMContentLoaded', function() {
	const modal = document.getElementById('modal'); 
	const closeModal = document.getElementById('close-modal'); 


	const photoViewerModal = document.getElementById('photoViewerModal');
	const viewerPhoto = document.getElementById('viewerPhoto'); 
	const closePhotoViewerModalBtn = document.getElementById('closePhotoViewerModal');
	const bodyElement = document.body; 


	const galleryImages = document.querySelectorAll('.gallery-grid .grid-item img');

	galleryImages.forEach(img => {
		img.addEventListener('click', function() {
			photoViewerModal.style.display = 'flex';

			setTimeout(() => {
				photoViewerModal.classList.add('show');
			}, 10); 

			viewerPhoto.src = this.src;

			bodyElement.style.overflow = 'hidden';
		});
	});

	function closePhotoViewerModal() {
		photoViewerModal.classList.remove('show');

		photoViewerModal.addEventListener('transitionend', function handler() {
			photoViewerModal.removeEventListener('transitionend', handler);

			photoViewerModal.style.display = 'none';

			const menuModal = document.getElementById('modal');
			if (menuModal && menuModal.style.display !== 'flex') {
				bodyElement.style.overflow = ''; 
			} else if (!menuModal) {
				bodyElement.style.overflow = '';
			}
		});
	}

	closePhotoViewerModalBtn.addEventListener('click', closePhotoViewerModal);

	photoViewerModal.addEventListener('click', function(event) {
		if (event.target === photoViewerModal) {
			closePhotoViewerModal();
		}
	});
}); 
</script>
</html>