<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>

<%
    String loginId = (String) session.getAttribute("userId"); 
%>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>write</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/post/write.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>

<body>
	<main>
		<section>
			<div class="container">
				<div class="header-row">
					<a class="logo-title">Draw My life</a>
					<div class="top-button-group">
						<a href="${pageContext.request.contextPath}/list" class="btn-cancel"
							onclick="return confirm('作成中の内容は保存されません。終了しますか？')">キャンセル</a>
						<button type="submit" form="editorForm" class="btn-red">投稿する</button>
					</div>
				</div>
				<div class="editor-toolbar">
					<div class="toolbar-group">
						<div class="dropdown">
    						<button type="button" class="btn-text" id="current-font">フォント
        						<span class="material-icons">arrow_drop_down</span>
    						</button>
    					<div class="dropdown-content">
        					<a href="javascript:void(0)" onclick="format('fontName', 'NanumGothic')">Nanum Gothic (KR)</a>
        					<a href="javascript:void(0)" onclick="format('fontName', 'NotoSansJP')">Noto Sans (JP)</a>
        					<a href="javascript:void(0)" onclick="format('fontName', 'NotoSerifJP')">Noto Serif (JP)</a>
    					</div>
						</div>

						<div class="dropdown">
							<button type="button" class="btn-text" id="current-lineheight">行間 
								<span class="material-icons">arrow_drop_down</span>
							</button>
							<div class="dropdown-content">
								<a href="javascript:void(0)" onclick="setLineHeight('1.0')">1.0</a>
								<a href="javascript:void(0)" onclick="setLineHeight('1.6')">1.6</a>
								<a href="javascript:void(0)" onclick="setLineHeight('2.0')">2.0</a>
							</div>
						</div>
					</div>

					<div class="toolbar-divider"></div>

					<div class="toolbar-group">
						<button type="button" title="太字">
							<b>B</b>
						</button>
						<button type="button" title="斜体">
							<i>I</i>
						</button>
						<button type="button" title="下線">U</button>
						<button type="button" title="打ち消し線">S</button>
						<div style="display: none;">
							<input type="color" id="foreColorInput" onchange="format('foreColor', this.value)"> 
							<input type="color" id="hiliteColorInput" onchange="format('hiliteColor', this.value)">
						</div>

						<button type="button" title="文字色" onclick="document.getElementById('foreColorInput').click()">
							<span class="material-icons">format_color_text</span>
						</button>
						<button type="button" title="文字背景色" onclick="document.getElementById('hiliteColorInput').click()">
							<span class="material-icons">format_color_fill</span>
						</button>
					</div>
					<div class="toolbar-divider"></div>

					<div class="toolbar-group">
						<button type="button" title="左揃え">
							<span class="material-icons">format_align_left</span>
						</button>
						<button type="button" title="中央揃え">
							<span class="material-icons">format_align_center</span>
						</button>
						<div class="dropdown">
							<button type="button" title="行間">
								<span class="material-icons">format_line_spacing</span>
							</button>
							<div class="dropdown-content">
								<a href="javascript:void(0)" onclick="setLineHeight('1.0')">1.0</a>
								<a href="javascript:void(0)" onclick="setLineHeight('1.6')">1.6</a>
								<a href="javascript:void(0)" onclick="setLineHeight('2.0')">2.0</a>
							</div>
						</div>
					</div>
					<div class="toolbar-divider"></div>

					<div class="toolbar-group">
						<button type="button" title="写真">
							<span class="material-icons">image</span>写真
						</button>
						<div class="dropdown">
							<button type="button" title="ステッカー">
								<span class="material-icons">sentiment_satisfied</span>ステッカー
							</button>
							<div class="dropdown-content sticker-list">
								<a href="javascript:void(0)" onclick="insertSticker('😀')">😀</a>
								<a href="javascript:void(0)" onclick="insertSticker('❤️')">❤️</a>
								<a href="javascript:void(0)" onclick="insertSticker('✨')">✨</a>
								<a href="javascript:void(0)" onclick="insertSticker('🎉')">🎉</a>
								<a href="javascript:void(0)" onclick="insertSticker('👍')">👍</a>
								<a href="javascript:void(0)" onclick="insertSticker('🍀')">🍀</a>
							</div>
						</div>
						<button type="button" title="引用">
							<span class="material-icons">format_quote</span>引用
						</button>
						<button type="button" title="区切り線">
							<span class="material-icons">horizontal_rule</span>区切り線
						</button>
						<button type="button" title="リンク">
							<span class="material-icons">link</span>リンク
						</button>
						<button type="button" title="場所">
							<span class="material-icons">place</span>場所
						</button>
					</div>
				</div>
				<form action="${pageContext.request.contextPath}/writeSave" method="post" id="editorForm">
    				<div class="title-area">
        			<div class="options-wrapper" style="padding: 10px 0; display: flex; align-items: center; gap: 15px;">
			            <% if (loginId != null) { %>
			                <label style="font-size: 14px; color: #555; cursor: pointer; display: flex; align-items: center; gap: 5px;">
			                    <input type="checkbox" name="isAnonymous" value="Y" style="margin: 0;">匿名で投稿
			                </label>
			            <% } else { %>
			                <input type="hidden" name="isAnonymous" value="Y"> <div style="display: flex; align-items: center; gap: 8px;">
			                    <span class="material-icons" style="font-size: 18px; color: #FF4500;">lock</span>
			                    <input type="password" name="guestPw" id="guestPw" placeholder="削除パスワードを入力" required style="border: 1px solid #ddd; padding: 6px 10px; border-radius: 4px; width: 150px; font-size: 13px; outline-color: #FF4500;">
			                </div>
			            <% } %>
        			</div>
        				<input type="text" name="title" class="title-input" placeholder="タイトルを入力してください。">
    				</div>

    				<div class="content-area">
       					<div id="editor" class="content-input" contenteditable="true" data-placeholder="今の気持ちや日常を記録してみましょう。"></div>
        					<input type="hidden" name="content" id="hiddenContent">
    				</div>
			</form>
			</div>
		</section>
	</main>
<footer>
	<p>&copy; 2026 Leere. All rights reserved.</p>
</footer>
</body>

<script>
function format(command, value = null) {
	const editor = document.getElementById('editor');
	if (!editor) return;
	editor.focus();
	document.execCommand(command, false, value);
	updateToolbar();
}

function setLineHeight(value) {
	const editor = document.getElementById('editor');
	if (!editor) return;
	editor.style.lineHeight = value;
}

function insertPlace() {
	const placeName = prompt('場所の名前を入力してください:');
	if (placeName) {
		const editor = document.getElementById('editor');
		editor.focus();
		const mapUrl = "https://map.naver.com/v5/search/" + encodeURIComponent(placeName);
		const placeTag = `
	            <a href="${mapUrl}" target="_blank" style="text-decoration: none !important;">
	                <span class="place-box" contenteditable="false" style="display: inline-flex; align-items: center; background: #fff5f0; border-radius: 4px; padding: 4px 8px; margin: 0 4px; color: #ff4500; font-weight: bold; border: 1px solid #ff4500; cursor: pointer;">
	                    <span class="material-icons" style="font-size: 16px; margin-right: 4px;">place</span>
	                    ${placeName}
	                </span>
	            </a>&nbsp;
	        `;
		document.execCommand('insertHTML', false, placeTag);
	}
}

function insertSticker(emoji) {
	format('insertText', emoji);
}

function toggleQuote() {
	const editor = document.getElementById('editor');
	editor.focus();
	const selection = window.getSelection();
	if (!selection || !selection.rangeCount) return;
	let node = selection.getRangeAt(0).commonAncestorContainer;
	if (node.nodeType === 3) node = node.parentNode;
	const closestBlockquote = node.closest('blockquote');
	if (closestBlockquote) {
		document.execCommand('formatBlock', false, 'div');
	} else {
		document.execCommand('formatBlock', false, 'blockquote');
	}
	updateToolbar();
}

function updateToolbar() {
	const buttons = document.querySelectorAll('.toolbar-group button');
	buttons.forEach(btn => {
		const title = btn.getAttribute('title');
		let isActive = false;
		try {
			if (title === '太字') isActive = document.queryCommandState('bold');
			if (title === '斜体') isActive = document.queryCommandState('italic');
			if (title === '下線') isActive = document.queryCommandState('underline');
			if (title === '打ち消し線') isActive = document.queryCommandState('strikeThrough');
		} catch (e) { }
		if (isActive) btn.classList.add('active');
		else btn.classList.remove('active');
	});
}

document.addEventListener('DOMContentLoaded', function() {
	const editor = document.getElementById('editor');
	const form = document.getElementById('editorForm');
	const hiddenContent = document.getElementById('hiddenContent');

	if (form) {
		form.addEventListener('submit', function() {
			hiddenContent.value = editor.innerHTML;
		});
	}

	const dropdowns = document.querySelectorAll('.dropdown');
	dropdowns.forEach(group => {
		group.addEventListener('mouseenter', function() {
			const content = this.querySelector('.dropdown-content');
			if (content) {
				const rect = this.getBoundingClientRect();
				content.style.top = rect.bottom + 'px';
				content.style.left = rect.left + 'px';
				content.style.display = 'block';
			}
		});
		group.addEventListener('mouseleave', function() {
			const content = this.querySelector('.dropdown-content');
			if (content) content.style.display = 'none';
		});

		const items = group.querySelectorAll('.dropdown-content a');
		items.forEach(item => {
			item.addEventListener('click', function() {
				const btnText = group.querySelector('.btn-text');
				if (btnText && !this.closest('.sticker-list')) {
					btnText.innerHTML = this.textContent + ' <span class="material-icons">arrow_drop_down</span>';
				}
			});
		});
	});

	const buttons = document.querySelectorAll('.toolbar-group button');
	buttons.forEach(btn => {
		btn.addEventListener('click', function() {
			const title = this.getAttribute('title');
			if (title === '太字') format('bold');
			else if (title === '斜体') format('italic');
			else if (title === '下線') format('underline');
			else if (title === '打ち消し線') format('strikeThrough');
			else if (title === '左揃え') format('justifyLeft');
			else if (title === '中央揃え') format('justifyCenter');
			else if (title === '引用') toggleQuote();
			else if (title === '区切り線') format('insertHorizontalRule');
			else if (title === 'リンク') {
				const url = prompt('リンク先のURL:', 'https://');
				if (url && url !== 'https://') format('createLink', url);
			}
			else if (title === '写真') {
				const url = prompt('画像のURL:');
				if (url) format('insertImage', url);
			}
			else if (title === '場所') insertPlace();
			setTimeout(updateToolbar, 10);
		});
	});

	if (editor) {
		editor.addEventListener('keyup', updateToolbar);
		editor.addEventListener('mouseup', updateToolbar);
	}
});
</script>
</html>