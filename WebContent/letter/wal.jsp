<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>wal</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/letter/wal.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>

<body>
   <div class="container">
    <h2>
    	<span class="red-italic">Dear.</span> <span class="underline">イレ</span>
    </h2>
    <hr class="thick-line">
    <main>
        <form id="letterForm" action="${pageContext.request.contextPath}/sendMail" method="POST" enctype="multipart/form-data">
            <textarea placeholder="ここに内容を入力してください" rows="5" name="content"></textarea>
            <div class="file-upload">
                <span id="fileName" class="file-name">選択されたファイルがありません</span>
                <label for="fileInput" class="file-label">ファイル選択</label>
                <input type="file" id="fileInput" name="fileName" style="display: none;" />
            </div>
            <hr class="thick-line">
            <h2 class="right-align">
                <span class="red-italic">from.</span>
                <span class="underline">
                    <input type="text" id="userName" class="name-input custom-font" name="userName"/>
                </span>
            </h2>
        </form> 
    </main>
</div>
<div class="floating-back-btn" onclick="goToHome()">
    <span class="material-icons">arrow_back</span>
</div>
<div class="floating-home-btn" id="submitButton" onclick="sendLetterAndGoHome()">
    <span class="material-icons">send</span>
</div>
</body>

<script>
document.getElementById('fileInput').addEventListener('change', function(event) {
 const file = event.target.files[0];
 const fileNameDisplay = document.getElementById('fileName');
 if (file) {
     fileNameDisplay.textContent = file.name;
 } else {
     fileNameDisplay.textContent = '選択ファイルが存在しません';
 }
});

function sendLetterAndGoHome() {
    const userName = document.getElementById('userName').value;

    alert("手紙が送信されました。");

    document.body.classList.add('fade-out'); 
    
    setTimeout(function() {
        document.getElementById('letterForm').submit();
    }, 500); 
}
function goToHome() {
    if(confirm("作成中の内容は保存されません。ホームに戻りますか？")) {
        document.body.classList.add('fade-out'); 
        setTimeout(function() {
            location.href = "${pageContext.request.contextPath}/index"; 
        }, 500);
    }
}
</script>
</html>