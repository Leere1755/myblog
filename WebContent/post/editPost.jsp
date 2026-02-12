<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ include file="sessionCheck.jsp" %>

<%
    Map<String, Object> post = (Map<String, Object>) request.getAttribute("post");
    int bIdx = (request.getAttribute("bIdx") != null) ? (int) request.getAttribute("bIdx") : 0;
    
    String title = (post != null && post.get("title") != null) ? (String)post.get("title") : "";
    String content = (post != null && post.get("content") != null) ? (String)post.get("content") : "";
%>

<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>editPost</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/post/write.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>

<body>
    <main>
        <section>
            <div class="container">
                <div class="header-row">
                    <a href="${pageContext.request.contextPath}/index" class="logo-title" style="text-decoration:none;">Draw My life</a>
                    <div class="top-button-group">
                        <a href="javascript:history.back();" class="btn-cancel">キャンセル</a>
                        <button type="submit" form="editorForm" class="btn-red">修正完了</button>
                    </div>
                </div>

                <div class="editor-toolbar">
                    <div class="toolbar-group">
                        <button type="button" onclick="format('bold')" title="太字"><b>B</b></button>
                        <button type="button" onclick="format('italic')" title="斜体"><i>I</i></button>
                        <button type="button" onclick="format('underline')" title="下線">U</button>
                        <button type="button" onclick="format('strikeThrough')" title="打ち消し線">S</button>
                    </div>
                    <div class="toolbar-divider"></div>
                    <div class="toolbar-group">
                        <button type="button" onclick="format('justifyLeft')" title="左揃え"><span class="material-icons">format_align_left</span></button>
                        <button type="button" onclick="format('justifyCenter')" title="中央揃え"><span class="material-icons">format_align_center</span></button>
                    </div>
                    <div class="toolbar-divider"></div>
                    <div class="toolbar-group">
                        <button type="button" onclick="const url=prompt('画像 URL:'); if(url) format('insertImage', url);" title="画像">
                            <span class="material-icons">image</span>画像
                        </button>
                        <button type="button" onclick="format('insertHorizontalRule')" title="区切り線">
                            <span class="material-icons">horizontal_rule</span>区切り線
                        </button>
                    </div>
                </div>

                <form action="${pageContext.request.contextPath}/postUpdate" method="post" id="editorForm">
                    <input type="hidden" name="bIdx" value="<%=bIdx%>">

                    <div class="title-area">
                        <input type="text" name="title" class="title-input" 
                               value="<%=title%>" placeholder="タイトルを入力してください。" autofocus required>
                    </div>

                    <div class="content-area">
                        <div id="editor" class="content-input" contenteditable="true" 
                             data-placeholder="あなたの物語を修正してみてください。"><%=content%></div>
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
    document.getElementById('editor').focus();
    document.execCommand(command, false, value);
}

document.addEventListener('DOMContentLoaded', function() {
    const editor = document.getElementById('editor');
    const form = document.getElementById('editorForm');
    const hiddenContent = document.getElementById('hiddenContent');

    if (form) {
        form.addEventListener('submit', function(e) {
            const htmlValue = editor.innerHTML;
            if(htmlValue.trim() === "" || htmlValue === "<br>") {
                alert("内容を入力してください。");
                e.preventDefault();
                return;
            }
            hiddenContent.value = htmlValue;
        });
    }
});
</script>
</html>