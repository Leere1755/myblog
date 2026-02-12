<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="회원가입 페이지">
    <title>회원가입2</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <link rel="stylesheet" href="../styles/회원가입3s.css"> <!-- CSS 파일 링크 -->
    <script>
        // 클릭 이벤트 핸들러
        function redirectToPage() {
            window.location.href = '../blog/회원가입4.jsp'; // 이동할 페이지의 URL
        }

        // 페이지 로드 시 클릭 이벤트 추가
        window.onload = function() {
            document.body.addEventListener('click', redirectToPage);
        };
    </script>
</head>
<body>
    <div class="sub-message" style="position: absolute; bottom: 50px; left: 50px;">Draw My Life.</div>
</body>
</html>