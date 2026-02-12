<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>プロフィール編集</title>
<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
<link rel="stylesheet" href="${pageContext.request.contextPath}/member/mypage.css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>

<body>
	<div class="container">
		<div class="form-wrapper">
			<form id="profileForm" action="${pageContext.request.contextPath}/updateProfile" method="post" enctype="multipart/form-data">

				<div class="input-group">
					<div id="imageContainer" class="image-container">
						<img id="imagePreview" src="${pageContext.request.contextPath}/${user.profileImgPath}" alt="Profile"
							onerror="this.src='${pageContext.request.contextPath}/images/49.jpg';">
					</div>
					<div class="file-upload">
						<span id="fileName" class="file-name">ファイルが選択されていません</span>
						<button type="button" class="edit-btn" onclick="document.getElementById('fileInput').click();">変更</button>
						<button type="button" id="imgSaveBtn" class="save-btn" style="display: none;">保存</button>
						<input type="file" id="fileInput" name="profileimgPath" style="display: none;" onchange="previewImage(event)" />
					</div>
				</div>

				<div class="input-group">
					<label for="id">ID</label> 
					<input type="text" id="id" name="id" value="${user.id}" readonly>
				</div>
				<div style="font-size: 11px; color: #999; margin-top: -5px; margin-left: 95px; margin-bottom: 20px; font-style: italic;">
					* IDは変更できません。
				</div>

				<div class="input-group">
					<label for="current_pw">現在の<br>パスワード</label> 
					<input type="password" id="current_pw" name="current_password" placeholder="現在のパスワードを入力してください">
				</div>

				<div class="input-group">
					<label for="pw">パスワード</label> 
					<input type="password" id="pw" name="password" value="${user.pw}" required readonly>
					<button type="button" class="edit-btn">変更</button>
					<button type="button" class="save-btn" style="display: none;">保存</button>
				</div>

				<div class="input-group" style="margin-bottom: 5px;">
					<label for="name">氏名</label> 
					<input type="text" id="name" name="name" value="${user.name}" readonly>
				</div>
				<div style="font-size: 11px; color: #999; font-style: italic; margin-left: 95px; margin-bottom: 25px;">
					* 氏名の変更は本人確認が必要です。カスタマーセンターへお問い合わせください。
				</div>

				<div class="input-group" style="flex-wrap: wrap;">
					<label for="email">メール<br>アドレス</label> 
					<input type="email" id="email" name="email" value="${user.email}" required readonly>
					<button type="button" class="edit-btn">変更</button>
					<button type="button" class="save-btn" style="display: none;">保存</button>
					<div id="emailCheckMsg" style="width: 100%; font-size: 12px; margin-top: 8px; padding-left: 95px; font-family: 'PRETENDARDJP-BOLD'; text-align: left;"></div>
				</div>

				<div class="input-group">
					<label for="tel">電話番号</label> 
					<input type="tel" id="tel" name="tel" value="${user.tel}" required readonly>
					<button type="button" class="edit-btn">変更</button>
					<button type="button" class="save-btn" style="display: none;">保存</button>
				</div>

				<div class="withdraw-area" style="margin-top: 50px; padding-top: 20px; border-top: 1px dashed #ddd; width: 100%; text-align: right;">
					<span style="font-size: 12px; color: #999; font-style: italic; margin-right: 15px;">アカウントを削除しますか？</span>
					<button type="button" id="withdrawBtn" style="background: none; border: none; color: #999; text-decoration: underline; cursor: pointer; font-family: 'PRETENDARDJP-BOLD'; font-size: 13px;" onclick="withdrawMember()">
						退会する
					</button>
				</div>
			</form>
		</div>
	</div>
	<div class="floating-home-btn"
     onclick="location.href='${pageContext.request.contextPath}/index'"
     style="cursor: pointer;">
    <span class="material-icons">arrow_back</span>
</div>
	<script>
		$(document).ready(function() {
			let isEmailChecked = true;

			function updateProfileData(formElement, successMsg) {
				const formData = new FormData(formElement);
				$.ajax({
					url : '${pageContext.request.contextPath}/updateProfile',
					type : 'POST',
					data : formData,
					contentType : false,
					processData : false,
					success : function(response) {
						alert(successMsg);
						location.reload();
					},
					error : function() {
						alert('更新中にエラーが発生しました。');
					}
				});
			}

			$('#imgSaveBtn').on('click', function() {
				updateProfileData($('#profileForm')[0], 'プロフィール画像が変更されました。');
			});

			$('.edit-btn').on('click', function() {
				const inputField = $(this).siblings('input');
				if (inputField.attr('id') === 'name') {
					alert("氏名の変更は本人確認が必要です。");
					return;
				}
				inputField.prop('readonly', false).focus();
				$(this).hide();
				$(this).siblings('.save-btn').show();
				if (inputField.attr('id') === 'email') isEmailChecked = false;
			});

			$('#email').on('input', function() {
				const email = $(this).val();
				if (email === "${user.email}") {
					$('#emailCheckMsg').text("現在のメールアドレスです。").css("color", "blue");
					isEmailChecked = true;
					return;
				}
				$.ajax({
					url : '${pageContext.request.contextPath}/checkEmail',
					type : 'GET',
					data : { email : email },
					success : function(res) {
						if (res.trim() === "usable") {
							$('#emailCheckMsg').text("使用可能なメールアドレスです。").css("color", "green");
							isEmailChecked = true;
						} else {
							$('#emailCheckMsg').text("既に使用されているメールアドレスです。").css("color", "red");
							isEmailChecked = false;
						}
					}
				});
			});

			// 4. 保存ボタン
			$('.save-btn').not('#imgSaveBtn').on('click', function() {
				const inputField = $(this).siblings('input');
				const fieldId = inputField.attr('id');

				if (fieldId === 'pw') {
					const currentPw = $('#current_pw').val();
					const newPw = $('#pw').val();
					if (!currentPw) {
						alert("現在のパスワードを入力してください。");
						$('#current_pw').focus();
						return;
					}
					$.ajax({
						url : '${pageContext.request.contextPath}/checkCurrentPw',
						type : 'POST',
						data : { currentPw : currentPw },
						success : function(res) {
							if (res.trim() === "match") {
								const confirmPw = prompt("確認のため、新しいパスワードをもう一度入力してください。");
								if (newPw === confirmPw) {
									updateProfileData($('#profileForm')[0], '正常に更新されました。');
								} else {
									alert("新しいパスワードが一致しません。");
								}
							} else {
								alert("現在のパスワードが正しくありません。");
							}
						}
					});
				} else {
					if (fieldId === 'email' && !isEmailChecked) {
						alert("メールアドレスの重複確認が必要です。");
						return;
					}
					updateProfileData($('#profileForm')[0], '正常に更新されました。');
				}
			});
		});

		function previewImage(event) {
			const file = event.target.files[0];
			if (file) {
				const reader = new FileReader();
				reader.onload = function() {
					$('#imagePreview').attr('src', reader.result);
					$('#fileName').text(file.name);
					$('#imgSaveBtn').show();
				};
				reader.readAsDataURL(file);
			}
		}
						
		function withdrawMember() {
			let inputPw = prompt("退会をご希望の場合は、パスワードを入力してください。");
			if (inputPw === null || inputPw.trim() === "") return;

			if (confirm("本当に退会しますか？削除されたデータは復元できません。")) {
				$.ajax({
					type: "POST",
					url: "${pageContext.request.contextPath}/withdraw",
					data: { "userPw": inputPw },
					success: function(response) {
						if (response.trim() === "success") {
							alert("退会が完了しました。ご利用ありがとうございました。");
							location.href = "${pageContext.request.contextPath}/main"; 
						} else {
							alert("パスワードが一致しないか、退会処理に失敗しました。");
						}
					},
					error: function() {
						alert("サーバー通信中にエラーが発生しました。");
					}
				});
			}
		}
	</script>
</body>
</html>