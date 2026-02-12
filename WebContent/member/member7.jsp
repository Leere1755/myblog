<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="path" value="${pageContext.request.contextPath}" />

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>member</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/member/member7.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>

<body>
	<div class="container">
	<div class="form-wrapper">
    <h2>
        初めまして！ <br>あなたの情報を入力してください
    </h2>

    <div class="input-group">
        <label for="userId">ID</label>
        <input type="text" id="userId" name="Id" placeholder="IDを入力してください" required>
        <span id="userIdError" style="color: red;"></span>
    </div>

    <div class="input-group">
        <label for="userPw">PW</label>
        <input type="password" id="userPw" name="password" placeholder="PWを入力してください" required>
        <span id="userPwError"></span>
    </div>

    <div class="input-group">
        <label for="userName">名前</label>
        <input type="text" id="userName" name="userName" placeholder="名前を入力してください" required>
        <span id="userNameError"></span>
    </div>
    
    <div class="input-group">
        <label for="userEmail">Email</label>
        <input type="email" id="userEmail" name="userEmail" placeholder="Emailを入力してください" required>
        <span id="userEmailError"></span>
    </div>
    
    <div class="input-group">
        <label for="userTel">電話番号</label>
        <input type="tel" id="userTel" name="userTel" placeholder="電話番号を入力してください" required>
        <span id="userTelError"></span>
    </div>
    </div> <div class="my-app-button-container" onclick="location.href='${path}/main'">
        <span class="my-app-text">Draw My Life</span>
    </div>

    <div class="floating-home-btn" id="submitButton">
        <span class="material-icons">arrow_forward</span>
    </div>
    </div>
</body>

<script>
$(document).ready(function() {
    let timers = {};

    const messages = {
        userId: { required: 'IDは必須入力値です。', format: 'ID는 4～12文字、英語와数字のみ可能です。' },
        userPw: { required: 'パスワードは必須入力値です。', format: '8文字以上の英数字で入力してください。' },
        userName: { required: '名前は必須入力値です。', format: '2文字以上で入力してください。' },
        userTel: { required: '電話番号は必須入力値です。', format: '正しい電話番号を入力してください。' },
        userEmail: { required: 'メールアドレスは必須入力項目です。', format: '無効なメール形式です。' }
    };

    function validate(id, regex, msgKey) {
        const val = $('#' + id).val().trim();
        const $errorSpan = $('#' + id + 'Error');

        if (val.length === 0) {
            $errorSpan.text(messages[msgKey].required).css('color', 'red');
            return false;
        }
        
        if (regex && !regex.test(val)) {
            $errorSpan.text(messages[msgKey].format).css('color', 'red');
            return false;
        }

        if (id !== 'userId' && id !== 'userEmail') {
            let successMsg = "";
            if(id === 'userPw') successMsg = "使用可能なパスワードです。";
            if(id === 'userName') successMsg = "使用可能な名前です。";
            if(id === 'userTel') successMsg = "利用可能な電話番号です。";
            
            $errorSpan.text(successMsg).css('color', 'pink'); 
        } else {
            $errorSpan.text("");
        }
        
        return true;
    }
    $('#userId').on('input', function() {
        const userId = $(this).val().trim();
        clearTimeout(timers.userId);
        if (validate('userId', /^[a-zA-Z0-9]{4,12}$/, 'userId')) {
            timers.userId = setTimeout(function() {
                $.ajax({
                    type: 'post',
                    url: '${path}/checkId',
                    data: { Id: userId },
                    success: function(res) {
                        if ($.trim(res) == "1") $('#userIdError').text('すでに使用中のIDです。').css('color', 'red');
                        else $('#userIdError').text('使用可能なIDです').css('color', 'pink');
                    }
                });
            }, 300);
        }
    });

    $('#userPw').on('input', function() {
        validate('userPw', /^[A-Za-z0-9!@#$%^&*]{8,}$/, 'userPw');
    });

    $('#userName').on('input', function() {
        validate('userName', /^[a-zA-Z가-힣ぁ-んァ-ン一-龯\s]{2,20}$/, 'userName');
    });

    $('#userEmail').on('input', function() {
        const userEmail = $(this).val().trim();
        clearTimeout(timers.userEmail);
        if (validate('userEmail', /^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/, 'userEmail')) {
            timers.userEmail = setTimeout(function() {
                $.ajax({
                    type: 'post',
                    url: '${path}/checkEmail',
                    data: { email: userEmail },
                    success: function(res) {
                        if ($.trim(res) == "1") $('#userEmailError').text('すでに使用中のメールアドレスです。').css('color', 'red');
                        else $('#userEmailError').text('利用可能なメールアドレスです。').css('color', 'pink');
                    }
                });
            }, 300);
        }
    });

    $('#userTel').on('input', function() {
        const userTel = $(this).val().trim();
        clearTimeout(timers.userTel); 

        if (validate('userTel', /^[0-9-]{10,15}$/, 'userTel')) {
            
            timers.userTel = setTimeout(function() {
                $.ajax({
                    type: 'post',
                    url: '${path}/checkTel',
                    data: { userTel: userTel },
                    success: function(res) {
                        if ($.trim(res) == "1") {
                            $('#userTelError').text('すでに使用中の電話番号です。').css('color', 'red');
                        } else {
                            $('#userTelError').text('使用可能な電話番号です。').css('color', 'pink');
                        }
                    }
                });
            }, 300);
        }
    });

    function isSuccess(elementId) {
        const $el = $(elementId);
        const color = $el.css('color').replace(/\s/g, '');
        const text = $el.text().trim();

        const isRed = (color === 'rgb(255,0,0)' || color === 'red');
        return text.length > 0 && !isRed;
    }

    $('#submitButton').on('click', function() {
        const isIdOk = isSuccess('#userIdError');
        const isPwOk = isSuccess('#userPwError');
        const isNameOk = isSuccess('#userNameError');
        const isEmailOk = isSuccess('#userEmailError');
        const isTelOk = isSuccess('#userTelError');

        if (isIdOk && isPwOk && isNameOk && isEmailOk && isTelOk) {
            $.ajax({
                type: 'post',
                url: '${path}/register',
                data: {
                    Id: $('#userId').val().trim(),
                    password: $('#userPw').val().trim(),
                    userName: $('#userName').val().trim(),
                    userTel: $('#userTel').val().trim(),
                    userEmail: $('#userEmail').val().trim()
                },
                success: function(res) {
                    if ($.trim(res) == "1") {
                        alert('会員登録が正常に完了しました。');
                        window.location.href = '${path}/login';
                    } else {
                        alert('登録に失敗しました。');
                    }
                }
            });
        } else {
            alert('すべての項目を正しく入力してください。');
            console.log("失敗項目:", {isIdOk, isPwOk, isNameOk, isEmailOk, isTelOk});
        }
    });
});
</script>
</html>