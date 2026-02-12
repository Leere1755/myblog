<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>main</title>
<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
<link rel="stylesheet" href="${pageContext.request.contextPath}/member/member2.css">
</head>

<body class="my-app-body fade">
	<div class="my-app-container">
		<div class="my-app-button-container">
			<span class="my-app-text">Draw My Life</span>
			<span class="my-app-underline"></span>
			<a class="my-app-link" onclick="redirectToPage('${pageContext.request.contextPath}/member')">会員登録</a>
			<a class="my-app-link" onclick="redirectToPage('${pageContext.request.contextPath}/login')">ログイン</a>
		</div>
	</div>
	<footer>
		<p>&copy; 2026 Leere. All rights reserved.</p>
	</footer>
	<div class="floating-home-btn" id="submitButton" onclick="redirectToPage('${pageContext.request.contextPath}/index')">
		<span class="material-icons">home</span>
	</div>
	
	<script>
		function redirectToPage(page) {
			document.body.classList.add('fade-out');
			setTimeout(function() {
				window.location.href = page; 
			}, 500); 
		}
	</script>
</body>
</html>