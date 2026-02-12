<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="mapper.BoardDao"%>

<%
	Map<String, Object> post = (Map<String, Object>) request.getAttribute("post");
List<Map<String, Object>> commentList = (List<Map<String, Object>>) request.getAttribute("commentList");
int bIdx = (int) request.getAttribute("bIdx");

BoardDao dao = BoardDao.getInstance();
String currentSessionId = session.getId();

int likeCount = dao.getLikeCount(bIdx);
int myLikeStatus = dao.checkMyLike(bIdx, currentSessionId);

Map<String, Object> prevNext = dao.getPrevNextPost(bIdx);
Integer prevIdx = (Integer) prevNext.get("prevIdx");
String prevTitle = (String) prevNext.get("prevTitle");
Integer nextIdx = (Integer) prevNext.get("nextIdx");
String nextTitle = (String) prevNext.get("nextTitle");

String title = (String) post.get("title");
String content = (String) post.get("content");

String wDate = (post.get("createdat") != null) ? String.valueOf(post.get("createdat")) : "日付なし";

String writerName = post.get("writerName") != null ? (String) post.get("writerName") : "匿名";

String rawProfile = (post.get("profileImg") != null) ? String.valueOf(post.get("profileImg")).trim() : "";
String profileImg;

if (rawProfile.isEmpty() || rawProfile.equalsIgnoreCase("null")) {
	profileImg = request.getContextPath() + "/images/49.jpg";
} else if (rawProfile.startsWith("http")) {
	profileImg = rawProfile;
} else {
	String pathSeparator = rawProfile.startsWith("/") ? "" : "/";
	profileImg = request.getContextPath() + pathSeparator + rawProfile;
}
%>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>viewPost</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/post/viewPost.css">
<link rel="stylesheet"
	href="https://fonts.googleapis.com/icon?family=Material+Icons">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
</head>

<body>
	<main>
		<section>
			<div class="container">
				<div
					style="margin-bottom: 40px; display: flex; justify-content: space-between; align-items: center;">
					<a href="${pageContext.request.contextPath}/index"
						class="logo-title">Draw My life</a>
					<div class="search-container" id="search-container">
						<form id="search-form"
							action="${pageContext.request.contextPath}/list" method="get"
							style="display: inline;">
							<input type="text" id="search-input" name="query" placeholder="検索ワードを入力してください" 
       style="display: none; border: none; border-bottom: 2px solid red; outline: none; width: 180px; font-size: 13px; font-family: 'PRETENDARDJP-SEMIBOLD';" />
						</form>
						<div class="icon left" id="search-icon" style="cursor: pointer;">
							<span class="material-icons">search</span>
						</div>
					</div>
				</div>

				<a href="${pageContext.request.contextPath}/list"
					class="post-category" style="text-decoration: none;">ことば</a>
				<h1 class="view-title"><%=title%></h1>

				<div class="profile-section">
					<div class="profile-info">
						<img src="<%=profileImg%>" alt="Profile" class="profile-img"
							onerror="this.src='${pageContext.request.contextPath}/images/49.jpg'">
						<div>
							<span class="author-name"><%=writerName%></span> <span
								class="post-date"><%=wDate%></span>
						</div>
					</div>
				<div class="profile-right">
    <%
        String loginIdForPost = (String) session.getAttribute("userId");
        
        Object wIdObj = post.get("writerId");
        if (wIdObj == null) wIdObj = post.get("WRITER_ID");
        if (wIdObj == null) wIdObj = post.get("writerid");
        
        String writerId = (wIdObj != null) ? String.valueOf(wIdObj).trim() : "";

        boolean isOwner = (loginIdForPost != null && !writerId.isEmpty() && 
                          !"null".equalsIgnoreCase(writerId) && 
                          loginIdForPost.equalsIgnoreCase(writerId));

        if (isOwner) {
    %>
        <span class="btn-admin btn-edit" 
              onclick="location.href='${pageContext.request.contextPath}/postEdit/<%=bIdx%>'" 
              style="cursor: pointer; padding: 4px 12px; border: 1px solid #ddd; border-radius: 4px;">修正</span>
        <span class="btn-admin btn-delete" 
              onclick="if(confirm('本当に削除しますか？')){ location.href='${pageContext.request.contextPath}/postDelete/<%=bIdx%>'; }" 
              style="cursor: pointer; padding: 4px 12px; border: 1px solid #ff4b4b; color: #ff4b4b; border-radius: 4px;">削除</span>
    <%
        } else {
            if (loginIdForPost != null) { 
    %>
        <span onclick="reportPost('<%=bIdx%>')" 
              style="cursor: pointer; border: 1px solid #ff4d4d; padding: 2px 8px; color: #ff4d4d; border-radius: 2px; font-size: 13px; font-weight: bold;">通報</span>
    <%
            } else if (writerId.isEmpty() || "null".equalsIgnoreCase(writerId)) {
    %>
        <span onclick="openDeleteModal('<%=bIdx%>', 'GUEST')" 
              class="btn-req" 
              style="cursor: pointer; border: 1px solid #666; padding: 2px 8px; color: #666; border-radius: 2px; font-size: 13px; margin-left: 5px;">削除依頼</span>
    <%
            }
    %>
        <span id="more-btn" class="material-icons" 
              style="cursor: pointer; font-size: 20px; color: #666; vertical-align: middle; margin-left: 5px;">more_vert</span>
    <%
        }
    %>
</div>
				</div>

				<div class="view-content"><%=content%></div>
				<div class="post-footer-bar">
					<div class="footer-left">
						<div class="stat-item" id="like-btn" style="cursor: pointer;">
							<span class="material-icons heart-icon" id="heart-icon"
								style="color: <%=(myLikeStatus == 1) ? "#ff4b4b" : ""%>;"><%=(myLikeStatus == 1) ? "favorite" : "favorite_border"%></span>
							<span>いいね <b id="like-count" style="color: #333;"><%=likeCount%></b></span>
						</div>

						<div class="stat-item" id="comment-btn" style="cursor: pointer;">
							<span class="material-icons">chat_bubble_outline</span> <span>コメント
								<b style="color: #333;"><%=commentList.size()%></b>
							</span>
						</div>
					</div>

					<div class="footer-right">
						<div id="go-to-top"
							style="display: flex; align-items: center; cursor: pointer; color: #999; gap: 4px;">
							<span style="font-size: 13px;">トップへ</span> <span
								class="material-icons" style="font-size: 20px;">arrow_upward</span>
						</div>
					</div>
				</div>
		<div id="comment-section" style="display: none;">
    <h4>
        コメント(<%=commentList.size()%>)
    </h4>
    <%
        for (Map<String, Object> cmt : commentList) {
            String cUser = (cmt.get("nickname") != null) ? String.valueOf(cmt.get("nickname")) : "匿名";

            String rawCProfile = (cmt.get("profileImg") != null) ? String.valueOf(cmt.get("profileImg")).trim() : "";
            String cProfile;
            if (rawCProfile.isEmpty() || rawCProfile.equalsIgnoreCase("null")) {
                cProfile = request.getContextPath() + "/images/49.jpg";
            } else if (rawCProfile.startsWith("http")) {
                cProfile = rawCProfile;
            } else {
                String cPathSeparator = rawCProfile.startsWith("/") ? "" : "/";
                cProfile = request.getContextPath() + cPathSeparator + rawCProfile;
            }

            Object cUserIdObj = (cmt.get("userid") != null) ? cmt.get("userid") : cmt.get("USERID");
            String cUserId = (cUserIdObj != null) ? String.valueOf(cUserIdObj) : "";

            int cIdx = 0;
            Object idxObj = (cmt.get("idx") != null) ? cmt.get("idx") : cmt.get("IDX");
            if (idxObj != null)
                cIdx = Integer.parseInt(String.valueOf(idxObj));
    %>
    <div id="comment_<%= cIdx %>" style="margin-bottom: 12px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #f9f9f9; padding-bottom: 8px;">
        <div style="display: flex; align-items: center; flex-wrap: wrap; gap: 8px;">
            <img src="<%=cProfile%>"
                style="width: 24px; height: 24px; border-radius: 50%; object-fit: cover;"
                onerror="this.src='${pageContext.request.contextPath}/images/49.jpg'">

            <% if ("投稿者".equals(cUser)) { %>
            <span style="background-color: #ff4b4b; color: white; font-size: 10px; padding: 2px 7px; border-radius: 12px; font-weight: bold; display: inline-flex; align-items: center; gap: 3px; margin-right: 4px;">
                <span class="material-icons" style="font-size: 12px;">edit</span>投稿者
            </span>
            <% } else { %>
            <b style="color: #333; font-size: 13px;"><%=cUser%></b>
            <% } %>

            <span style="color: #eee; font-size: 11px;">|</span> 
            <span style="color: #444; font-size: 14px; margin-left: 4px;">
                <%=(cmt.get("content") != null) ? cmt.get("content") : cmt.get("CONTENT")%>
            </span> 
            <small style="color: #ccc; margin-left: 8px; font-size: 11px;">
                <%=(cmt.get("createdat") != null) ? String.valueOf(cmt.get("createdat")) : "たった今"%>
            </small>
        </div>
        
        <div>
        <%
            boolean isMyComment = (loginIdForPost != null && !cUserId.isEmpty() && loginIdForPost.equalsIgnoreCase(cUserId));

            if (isMyComment) {
        %>
            <a href="javascript:void(0);"
               style="color: #ff4b4b; text-decoration: none; font-size: 11px; border: 1px solid #ff4b4b; padding: 1px 5px; border-radius: 3px;"
               onclick="if(confirm('本当に削除しますか？')) { location.href='${pageContext.request.contextPath}/commentDelete/<%=cIdx%>/<%=bIdx%>'; }">削除</a>
        <%
            } else {
                if (loginIdForPost != null) { 
        %>
            <span style="color: #ff4d4d; font-size: 11px; border: 1px solid #ff4d4d; padding: 1px 5px; border-radius: 3px; cursor: pointer;"
                  onclick="reportComment('<%=cIdx%>')">通報</span>
        <%
                } else if (cUserId.isEmpty() || "null".equalsIgnoreCase(cUserId)) {
        %>
            <a href="javascript:void(0);"
               style="color: #666; text-decoration: none; font-size: 11px; border: 1px solid #ccc; padding: 1px 5px; border-radius: 3px; margin-left: 5px;"
               onclick="openDeleteModal('<%=cIdx%>', 'REPLY')">削除依頼</a>
        <%
                }
            }
        %>
        </div>
    </div>
    <%
        }
    %>
</div>

				<form action="${pageContext.request.contextPath}/commentSave"
					method="post" style="margin-top: 20px;">
					<input type="hidden" name="bIdx" value="<%=bIdx%>">
					<div class="mode-selector"
						style="margin-bottom: 10px; display: flex; gap: 15px; align-items: center;">
						<%
							if (session.getAttribute("user") != null) {
						%>
						<span style="font-weight: bold; font-size: 12px; color: #666;">表示名:</span>
						<label
							style="cursor: pointer; font-size: 13px; display: flex; align-items: center; gap: 4px;">
							<input type="radio" name="displayMode" value="0">実名
						</label> <label
							style="cursor: pointer; font-size: 13px; display: flex; align-items: center; gap: 4px;">
							<input type="radio" name="displayMode" value="1">ニックネーム
						</label> <label
							style="cursor: pointer; font-size: 13px; display: flex; align-items: center; gap: 4px;">
							<input type="radio" name="displayMode" value="2" checked>匿名
						</label>
						<%
							} else {
						%>
						<span
							style="font-size: 12px; color: #999; background: #f5f5f5; padding: 4px 8px; border-radius: 4px;">🔒
							非会員は匿名で投稿され、削除するにはパスワードが必要です。</span> <input type="hidden"
							name="displayMode" value="2">
						<%
							}
						%>
					</div>

					<div style="display: flex; gap: 8px; align-items: center;">
						<input type="text" name="content" placeholder="コメントを入力してください。"
							required
							style="flex: 1; height: 35px; padding: 0 12px; border: 1px solid #ddd; border-radius: 4px; outline: none;">

						<%
							if (session.getAttribute("user") == null) {
						%>
						<input type="password" name="password" placeholder="パスワード"
							required
							style="width: 100px; height: 35px; padding: 0 10px; border: 1px solid #ddd; border-radius: 4px; outline: none;">
						<%
							}
						%>

						<button type="submit" class="comment-submit-btn">登録</button>
					</div>
				</form>

				<div class="pagination"
					style="display: flex; justify-content: space-between; align-items: center; padding: 0; margin-top: 90px;">
					<div style="flex: 1; text-align: left;">
						<%
							if (prevIdx != null) {
						%>
						<a href="${pageContext.request.contextPath}/viewPost/<%=prevIdx%>"
							style="text-decoration: none; color: #333;"> <span
							style="color: #999; font-size: 12px;">&lt;前の記事</span><br>
							<div
								style="font-weight: bold; margin-top: 5px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 150px;"><%=prevTitle%></div>
						</a>
						<%
							}
						%>
					</div>

					<div style="flex: 1; text-align: center;">
						<a href="${pageContext.request.contextPath}/list"
							style="text-decoration: none; color: red; border: 2px solid red; padding: 7px 18px; border-radius: 20px; font-size: 13px; font-weight: bold; transition: all 0.2s;"
							onmouseover="this.style.backgroundColor='#fff5f5';"
							onmouseout="this.style.backgroundColor='transparent';">一覧へ</a>
					</div>

					<div style="flex: 1; text-align: right;">
						<%
							if (nextIdx != null) {
						%>
						<a href="${pageContext.request.contextPath}/viewPost/<%=nextIdx%>"
							style="text-decoration: none; color: #333;"> <span
							style="color: #999; font-size: 12px;">次の記事 &gt;</span><br>
							<div
								style="font-weight: bold; margin-top: 5px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 150px; margin-left: auto;"><%=nextTitle%></div>
						</a>
						<%
							}
						%>
					</div>
				</div>

				<div id="share-modal" class="share-modal-overlay">
					<div class="share-modal-content">
						<div class="share-modal-header">
							<h3 style="margin: 0; font-size: 18px;">共有する</h3>
							<span id="close-share-modal" class="material-icons"
								style="cursor: pointer; color: red;">close</span>
						</div>
						<div class="share-icons-grid">
							<div class="share-icon-item">
								<img src="../images/71.jpg" alt="ブログ"><span>ブログ</span>
							</div>
							<div class="share-icon-item">
								<img src="../images/73.jpg" alt="コミュニティ"><span>コミュニティ</span>
							</div>
							<div class="share-icon-item">
								<img src="../images/72.jpg" alt="カカオトーク"><span>カカオトーク</span>
							</div>
						</div>
						<div class="share-url-copy">
							<input type="text" id="share-url-input" readonly value="">
							<button id="modal-copy-btn">コピー</button>
						</div>
					</div>
				</div>
			</div>

			<div class="floating-home-btn" id="submitButton">
				<span class="material-icons">arrow_back</span>
			</div>
		</section>
	</main>

	<div id="deleteRequestModal" class="share-modal-overlay">
		<div class="share-modal-content"
			style="max-width: 500px; width: 90%; padding: 0; border-radius: 8px;">
			<div class="share-modal-header"
				style="padding: 15px 20px; border-bottom: 1px solid #eee; display: flex; justify-content: space-between; align-items: center;">
				<h3
					style="margin: 0; font-size: 18px; font-weight: bold; line-height: 1;">削除依頼</h3>
				<span id="close-delete-modal" class="material-icons"
					style="cursor: pointer; color: #ff4b4b;">close</span>
			</div>

			<div style="padding: 20px 25px 25px 25px;">
				<p
					style="font-size: 13px; color: #666; margin-top: -30px !important; margin-bottom: 15px; line-height: 1.5;">理由とパスワードを入力してください。</p>
				<input type="hidden" id="modal-target-idx"> <input
					type="hidden" id="modal-author-type">
				<div style="margin-bottom: 12px;">
					<label
						style="font-size: 12px; font-weight: bold; display: block; margin-bottom: 5px; color: #333;">理由</label>
					<textarea id="modal-reason" placeholder="例: 本人ですが、削除を希望します。"
						style="width: 100%; height: 85px; padding: 12px; border: 1px solid #ddd; border-radius: 4px; resize: none; box-sizing: border-box; font-size: 14px;"></textarea>
				</div>

				<div id="modal-pw-field" style="margin-bottom: 20px;">
					<label
						style="font-size: 12px; font-weight: bold; display: block; margin-bottom: 5px; color: #333;">パスワード</label>
					<input type="password" id="modal-pw" placeholder="パスワードを入力してください。"
						style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; font-size: 14px;">
				</div>

				<button onclick="submitDeleteRequest()"
					style="width: 100%; padding: 14px; background: #ff4b4b; color: #fff; border: none; border-radius: 4px; cursor: pointer; font-weight: bold; font-size: 16px; box-sizing: border-box;">送信する</button>
			</div>
		</div>
	</div>
</body>

<script>
window.reportPost = function(bIdx) {
 const reason = prompt("この投稿を通報しますか？\n通報の理由を入力してください。");
 if (reason === null) return; 
 if (reason.trim() === "") {
     alert("理由を入力してください。");
     return;
 }

 fetch('${pageContext.request.contextPath}/reportPost', {
     method: 'POST',
     headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
     body: "bIdx=" + bIdx + "&reason=" + encodeURIComponent(reason)
 })
 .then(res => res.text())
 .then(data => {
     if (data === "success") { alert("通報を受け付けました。"); }
     else if (data === "login_required") { 
         alert("ログインが必要です。");
         location.href = '${pageContext.request.contextPath}/login';
     } else { alert("エラーが発生しました。"); }
 })
 .catch(err => console.error("Report Error:", err));
};

window.reportComment = function(cIdx) {
    const reason = prompt("このコメントを通報しますか？\n通報の理由を入力してください。");
    if (reason === null) return; 
    if (reason.trim() === "") {
        alert("理由を入力してください。");
        return;
    }

    fetch('${pageContext.request.contextPath}/reportComment', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: "cIdx=" + cIdx + "&reason=" + encodeURIComponent(reason)
    })
    .then(res => res.text())
    .then(data => {
        if (data === "success") { 
            alert("通報を受け付けました。"); 
        } else if (data === "login_required") { 
            alert("ログインが必要です。");
            location.href = '${pageContext.request.contextPath}/login';
        } else { 
            alert("エラーが発生しました。"); 
        }
    })
    .catch(err => console.error("Report Error:", err));
};

window.openDeleteModal = function(idx, type) {
 document.getElementById('modal-target-idx').value = idx;
 document.getElementById('modal-author-type').value = type;
 const pwField = document.getElementById('modal-pw-field');
 if (pwField) {
     pwField.style.display = (type === 'GUEST' || type === 'REPLY') ? 'block' : 'none';
 }
 document.getElementById('deleteRequestModal').style.display = 'flex';
};

window.submitDeleteRequest = function() {
 const idx = document.getElementById('modal-target-idx').value;
 const type = document.getElementById('modal-author-type').value;
 const reason = document.getElementById('modal-reason').value;
 const pw = document.getElementById('modal-pw').value;

 if(!reason.trim()) { alert("理由を入力してください。"); return; }

 const targetType = (type === 'REPLY') ? 'REPLY' : 'POST';
 
 let url = `${pageContext.request.contextPath}/addDeleteRequest/` + idx + 
           `?targetType=` + targetType + 
           `&authorType=` + type + 
           `&reason=` + encodeURIComponent(reason) +
           `&bIdx=<%=bIdx%>`; 
 
 if(type === 'GUEST') {
     if(!pw) { alert("パスワードを入力してください。"); return; }
     url += `&password=` + encodeURIComponent(pw);
 }
 location.href = url;
};

document.addEventListener('DOMContentLoaded', function() {
 const searchIcon = document.getElementById('search-icon');
 const searchInput = document.getElementById('search-input');
 const searchForm = document.getElementById('search-form');
 let searchTimeout;

 if(searchIcon && searchInput) {
     searchIcon.addEventListener('click', function() {
         if (searchInput.style.display === 'none' || searchInput.style.display === '') {
             searchInput.style.display = 'block';
             searchInput.focus();
         } else {
             if (searchInput.value.trim() !== "") { searchForm.submit(); }
             else { searchInput.style.display = 'none'; }
         }
     });
     searchInput.addEventListener('keypress', (e) => {
         if (e.key === 'Enter') {
             e.preventDefault();
             if (searchInput.value.trim() !== "") { searchForm.submit(); }
             else { searchInput.style.display = 'none'; }
         }
     });
 }

 const likeBtn = document.getElementById('like-btn');
 const heartIcon = document.getElementById('heart-icon');
 const likeCountElem = document.getElementById('like-count');
 if(likeBtn) {
     likeBtn.addEventListener('click', function() {
         $.ajax({
             url: "${pageContext.request.contextPath}/postLike",
             type: "POST",
             data: { bIdx: "<%=bIdx%>" },
             success: function(data) {
                 const res = data.split("|");
                 heartIcon.innerText = (res[0] === "1") ? "favorite" : "favorite_border";
                 heartIcon.style.color = (res[0] === "1") ? "#ff4b4b" : "";
                 likeCountElem.innerText = res[1];
             }
         });
     });
 }

 const commentBtn = document.getElementById('comment-btn');
 const commentSection = document.getElementById('comment-section');
 
 if(commentBtn) {
     commentBtn.addEventListener('click', () => {
         commentSection.style.display = (commentSection.style.display === 'none') ? 'block' : 'none';
     });
 }

 const moreBtn = document.getElementById('more-btn');
 const moreDropdown = document.getElementById('more-dropdown');
 const openShareBtn = document.getElementById('open-share-modal');
 const shareModal = document.getElementById('share-modal');
 const urlInput = document.getElementById('share-url-input');

 moreBtn?.addEventListener('click', (e) => {
     e.stopPropagation();
     if(moreDropdown) moreDropdown.style.display = (moreDropdown.style.display === 'none') ? 'block' : 'none';
 });

 openShareBtn?.addEventListener('click', () => {
     shareModal.style.display = 'flex';
     if(urlInput) urlInput.value = window.location.href; 
     if(moreDropdown) moreDropdown.style.display = 'none';
 });

 document.getElementById('modal-copy-btn')?.addEventListener('click', () => {
     urlInput.select();
     navigator.clipboard.writeText(urlInput.value).then(() => alert('URLをコピーしました。'));
 });

 document.getElementById('close-share-modal')?.addEventListener('click', () => shareModal.style.display = 'none');
 document.getElementById('close-delete-modal')?.addEventListener('click', () => {
     document.getElementById('deleteRequestModal').style.display = 'none';
 });

 document.getElementById('go-to-top')?.addEventListener('click', () => window.scrollTo({ top: 0, behavior: 'smooth' }));
 document.getElementById('submitButton')?.addEventListener('click', () => {
     location.href = "${pageContext.request.contextPath}/list";
 });

 window.addEventListener('click', (e) => {
     if (moreDropdown && !moreBtn?.contains(e.target)) moreDropdown.style.display = 'none';
     if (e.target === shareModal) shareModal.style.display = 'none';
     if (e.target === document.getElementById('deleteRequestModal')) {
         document.getElementById('deleteRequestModal').style.display = 'none';
     }
 });
 
 const urlParams = new URLSearchParams(window.location.search);
 const targetCommentId = urlParams.get('targetComment');

 if (targetCommentId) {
     const commentSection = document.getElementById('comment-section');
     if (commentSection) commentSection.style.display = 'block';

     const targetElement = document.getElementById('comment_' + targetCommentId);
     if (targetElement) {
         setTimeout(() => {
             targetElement.scrollIntoView({ behavior: 'smooth', block: 'center' });
             
             targetElement.style.backgroundColor = '#fff9c4';
             setTimeout(() => { targetElement.style.backgroundColor = 'transparent'; }, 2000);
         }, 300); 
     }

     const cleanUrl = window.location.pathname;
     window.history.replaceState({}, document.title, cleanUrl);
 }
});
</script>
</html>