<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>login2</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/login/login2.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>

<body>
	<div class="container">
		<h2 class="title">
			こんにちは！<br>Draw My Lifeです
		</h2>
		<form id="loginForm" method="post" action="/login/login.do">
			<div class="input-group">
				<label for="userId">ID</label> <input type="text" id="userId"
					name="userId" placeholder="IDを入力してください" required>
			</div>
			<div class="input-group">
				<label for="userPw">PW</label> <input type="password" id="userPw"
					name="userPw" placeholder="PWを入力してください" required>
			</div>
			<div class="button-wrapper">
				<div id="errorMessage"></div>
				<div class="floating-home-btn" id="submitButton">
					<span class="material-icons">arrow_forward</span>
				</div>
			</div>
		</form>
	</div>
	<div class="my-app-button-container"  onclick="location.href='${pageContext.request.contextPath}/main'">
		<span class="my-app-text">Draw My Life</span>
	</div>
	<script>
	$(document).ready(function () {
		  const contextPath = "${pageContext.request.contextPath}";

		  $("#submitButton").on("click", function (event) {
		    event.preventDefault();

		    const userId = $("#userId").val();
		    const userPassword = $("#userPw").val();

		    if (userId === "" || userPassword === "") {
		      $("#errorMessage").text("IDとPWを入力してください.");
		      return;
		    }

		    $.ajax({
		      type: "POST",
		      url: contextPath + "/login",
		      data: {
		        userId: userId,
		        userPassword: userPassword,
		      },
		      dataType: "json", 
		      success: function (response) {
		        if (response.success) {
		          alert(userId + "様、ようこそ！");

		          window.location.href = contextPath + "/index";
		        } else {
		          $("#errorMessage").text(
		            response.message || "ログイン情報を確認してください。"
		          );
		        }
		      },
		      error: function (xhr, status, error) {
		        console.error("通信失敗:", error);
		        alert("サーバー通信中にエラーが発生しました。");
		      },
		    });
		  });
		});
	</script>
</body>
</html>