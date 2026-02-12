<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="profileLogic.jsp" %>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ブログ</title>
<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
<link rel="stylesheet" href="${pageContext.request.contextPath}/blog/index2.css">
</head>

<body>
	<header>
		<div class="icon left" id="home-icon" style="cursor: pointer;">
			<span class="material-icons">home</span>
		</div>
		
		<div class="icon center menu-icon" id="menu-icon">
			<span class="material-icons">menu</span>
		</div>
		
		<div class="search-container" id="search-container">
    	<form id="search-form" action="${pageContext.request.contextPath}/list" method="get" style="display: inline;">
        <input type="text" id="search-input" name="query" placeholder="検索ワードを入力してください"
            style="display: none; border: none; border-bottom: 2px solid red; outline: none;" />
    	</form>
    	<div class="icon left" id="search-icon" style="cursor: pointer;">
        <span class="material-icons">search</span>
    	</div>
	   </div>
    </header>

	<div class="title">Draw My Life</div>

	<footer>
	
		<p>&copy; 2026 Leere. All rights reserved.</p>

           <div class="oval" onclick="<% if (userVo != null) { %>
                location.href='${pageContext.request.contextPath}/mypage';
            <% } else { %>
                		alert('ログインが必要なサービスです。'); 
                		location.href='${pageContext.request.contextPath}/login';
            <% } %>" 
  			style="cursor: pointer;">
				<img src="<%= displayImg %>" alt="Profile Picture" onerror="this.src='${pageContext.request.contextPath}/images/49.jpg';">

			<div class="user-info">
    			<strong style="font-size: 13px; font-family: 'PRETENDARDJP-BOLD';">
        		<%= (userVo != null) ? userVo.getId() : "ゲスト" %>様
    			</strong><br> 
    			<span style="font-size: 13px; font-family: 'PRETENDARDJP-BOLD';">
        		<%= (userVo != null) ? userVo.getId() + "@draw.com" : "guest@draw.com" %>
    			</span><br>
    
    		<% if (userVo != null) { %>
        		<a href="${pageContext.request.contextPath}/logout" style="font-size: 12px; color: red;" class="logout-btn">ログアウト</a>
    		<% } %>
		   </div>
		  </div>
	</footer>

	<div class="modal" id="modal">
		<div class="modal-content">
			<span class="close" id="close-modal">&times;</span>
			<div class="menu-items">
				<p class="menu-item" data-url="${pageContext.request.contextPath}/photo">記憶</p>
				<p class="menu-item" data-url="${pageContext.request.contextPath}/list">ことば</p>
				<p class="menu-item" data-url="${pageContext.request.contextPath}/wal">足跡</p>
			</div>
		</div>
	</div>
</body>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const modal = document.getElementById('modal');
    const closeModal = document.getElementById('close-modal');
    const searchInput = document.getElementById('search-input');
    const searchIcon = document.getElementById('search-icon');
    const searchForm = document.getElementById('search-form');
    const menuIcon = document.getElementById('menu-icon');
    const homeIcon = document.getElementById('home-icon');
    const body = document.body;

    let timeout;

    searchIcon.addEventListener('click', function() {
        if (searchInput.style.display === 'none' || searchInput.style.display === '') {
            searchInput.style.display = 'block';
            searchInput.focus();
        } 
        else {
            if (searchInput.value.trim() !== "") {
                searchForm.submit();
            } else {
                searchInput.style.display = 'none';
            }
        }
    });

    homeIcon.addEventListener('click', () => {
        window.location.href = '${pageContext.request.contextPath}/main'; 
    });

    menuIcon.addEventListener('click', () => {
        modal.style.display = 'flex';
        body.style.overflow = 'hidden';
    });

    closeModal.addEventListener('click', () => {
        modal.style.display = 'none';
        body.style.overflow = '';
    });
    const menuItems = document.querySelectorAll('.menu-item');
    menuItems.forEach(item => {
        item.addEventListener('click', function() {
            const url = this.getAttribute('data-url');
            if (url) {
                window.location.href = url;
            }
        });
    });
});
</script>
</html>