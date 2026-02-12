<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>

<%
	List<Map<String, Object>> postList = (List<Map<String, Object>>) request.getAttribute("postList");
int totalCount = (int) request.getAttribute("totalCount");
String searchKeyword = (String) request.getAttribute("searchKeyword");
int curPage = (int) request.getAttribute("curPage");
int pageSize = (int) request.getAttribute("pageSize");

int totalPages = (int) Math.ceil((double) totalCount / pageSize);
int pageBlock = 5;
int startPage = ((curPage - 1) / pageBlock) * pageBlock + 1;
int endPage = Math.min(startPage + pageBlock - 1, totalPages);
%>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ことば</title>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/board/list.css">
<link rel="stylesheet"
	href="https://fonts.googleapis.com/icon?family=Material+Icons">
</head>

<body>
	<main>
		<div class="top-search-wrapper">
			<form action="${pageContext.request.contextPath}/list" method="post">
				<div class="top-search-bar">
					<input type="text" name="query" value="<%=searchKeyword%>"
						placeholder="どんなお話をお探しですか？">
					<button type="submit">
						<span class="material-icons">search</span>
					</button>
				</div>
			</form>
		</div>
		<section>
			<div class="container">
				<h1 class="title" style="cursor: pointer"
					onclick="location.href='${pageContext.request.contextPath}/list'">ことば</h1>
				<div class="header">
					<span><%=searchKeyword.isEmpty() ? "すべて表示" : "'" + searchKeyword + "'の検索結果"%>
						<strong><%=totalCount%></strong>件の投稿 </span>
					<div style="display: flex; align-items: center; gap: 10px;">
						<%
							String sessionUserId = (String) session.getAttribute("userId");
						if ("admin".equals(sessionUserId)) {
						%>
						<a href="${pageContext.request.contextPath}/admin" class="admin-link">🚨通報履歴管理</a>
						<%
							}
						%>
						<a href="${pageContext.request.contextPath}/write" class="btn-red">新規投稿</a>
					</div>
				</div>
				<table class="post-list">
					<thead>
						<tr>
							<th>番号</th>
							<th>タイトル</th>
							<th class="right">投稿日</th>
						</tr>
					</thead>
					<tbody>
						<%
							if (postList.isEmpty()) {
						%>
						<tr>
							<td colspan="3" style="text-align: center; padding: 50px 0;">
								<p style="margin-bottom: 15px; color: #666;">投稿が見つかりませんでした。</p>
								<button type="button"
									onclick="location.href='${pageContext.request.contextPath}/list'"
									class="btn-red"
									style="cursor: pointer; font-family: 'PRETENDARDJP-SEMIBOLD';">全件表示に戻る</button>
							</td>
						</tr>
						<%
							} else {
						int virtualNum = totalCount - ((curPage - 1) * pageSize);

						for (Map<String, Object> post : postList) {
						%>
						<tr>
							<%-- 가상 번호를 출력하고 1씩 줄입니다 --%>
							<td><%=virtualNum--%></td>
							<td><a
								href="${pageContext.request.contextPath}/viewPost/<%=post.get("bIdx")%>">
									<%=post.get("title")%>
							</a></td>
							<td class="right"><%=post.get("wDate")%></td>
						</tr>
						<%
							}
						}
						%>
					</tbody>
				</table>

				<div class="pagination">
					<%
						if (startPage > 1) {
					%>
					<button onclick="sendPage(<%=startPage - 1%>)">&lt;</button>
					<%
						}
					%>

					<%
						for (int i = startPage; i <= endPage; i++) {
					%>
					<button class="<%=(i == curPage) ? "active" : ""%>"
						onclick="sendPage(<%=i%>)"><%=i%></button>
					<%
						}
					%>

					<%
						if (endPage < totalPages) {
					%>
					<button onclick="sendPage(<%=endPage + 1%>)">&gt;</button>
					<%
						}
					%>
				</div>

				<form id="pagingForm"
					action="${pageContext.request.contextPath}/list" method="post">
					<input type="hidden" name="page" id="pageInput"> <input
						type="hidden" name="query" value="<%=searchKeyword%>">
				</form>
			</div>
		</section>
	</main>
	<footer>
		<p>&copy; 2026 Leere. All rights reserved.</p>
	</footer>
	<div class="floating-home-btn" id="submitButton"
		onclick="location.href='${pageContext.request.contextPath}/index';">
		<span class="material-icons">arrow_back</span>
	</div>

	<script>
function sendPage(pageNumber) {
    document.getElementById('pageInput').value = pageNumber;
    document.getElementById('pagingForm').submit();
}
</script>
</body>
</html>
