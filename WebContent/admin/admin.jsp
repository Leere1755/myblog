<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>

<%
    String sessionUserId = (String) session.getAttribute("userId"); 
    
    if (sessionUserId == null || !"admin".equals(sessionUserId)) {
        out.println("<script>");
        out.println("  alert('管理者のみアクセス可能なページです。');");
        out.println("  location.href = '" + request.getContextPath() + "/list';");
        out.println("</script>");
        return; 
    }

    List<Map<String, Object>> reportList = (List<Map<String, Object>>) request.getAttribute("reportList"); 
%>

<!DOCTYPE html>
<html lang="ja">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>admin</title>
<link rel="stylesheet" href="${pageContext.request.contextPath}/admin/admin.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
</head>

<body>
    <div class="admin-box">
        <div class="admin-tabs">
            <button class="tab-btn active" onclick="openTab('report-section')">🚨 通報管理</button>
            <button class="tab-btn" onclick="openTab('post-delete-section')">📩 投稿削除依頼</button>
            <button class="tab-btn" onclick="openTab('reply-delete-section')">💬 コメント削除依頼</button>
        </div>

        <div id="report-section" class="tab-content active">
            <h2>🚨通報投稿管理リスト</h2>
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>通報番号</th>
                        <th>対象タイトル</th>
                        <th>通報者</th>
                        <th>理由</th>
                        <th>通報日</th>
                        <th>処置</th>
                    </tr>
                </thead>
                <tbody>
            <% if(reportList != null && !reportList.isEmpty()) { 
                boolean hasReport = false;
                int reportTotal = 0;
                for(Map<String, Object> countR : reportList) {
                    if("REPORT".equals(String.valueOf(countR.get("TYPE")))) reportTotal++;
                }

                for(Map<String, Object> r : reportList) { 
                    if(!"REPORT".equals(String.valueOf(r.get("TYPE")))) continue; 
                    hasReport = true;
            %>
                <tr>
                    <td class="r-idx">#<%= reportTotal-- %></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/viewPost/<%= r.get("B_IDX") %>" target="_blank">
                            <%= r.get("TITLE") %>
                        </a>
                    </td>
                    <td><%= r.get("SENDER") %></td>
                    <td><span class="reason-tag"><%= r.get("REASON") %></span></td>
                    <td class="r-date"><%= r.get("REG_DATE") %></td>
                    <td>
                        <div class="action-buttons">
                            <button type="button" class="btn-del" onclick="handleAction('postDelete', '<%= r.get("B_IDX") %>')">承認</button>
                            <button type="button" class="btn-ignore" onclick="handleAction('reportIgnore', '<%= r.get("ID") %>')">却下</button>
                        </div>
                    </td>
                </tr>
            <% } 
                if(!hasReport) { %> <tr><td colspan="6" class="empty-msg">通報履歴がありません。</td></tr> <% }
            } else { %>
                <tr><td colspan="6" class="empty-msg">データが存在しません。</td></tr>
            <% } %>
                </tbody>
            </table>
        </div>

        <div id="post-delete-section" class="tab-content">
            <h2>📩 非会員投稿削除依頼管理</h2>
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>依頼番号</th>
                        <th>対象区分</th>
                        <th>内容要約</th>
                        <th>理由</th>
                        <th>依頼日</th>
                        <th>処置</th>
                    </tr>
                </thead>
                <tbody>
            <% 
                if(reportList != null && !reportList.isEmpty()) { 
                    boolean hasDeleteReq = false;
                    int postTotal = 0;
                    for(Map<String, Object> countR : reportList) {
                        if("POST".equals(String.valueOf(countR.get("TYPE")))) postTotal++;
                    }

                    for(Map<String, Object> r : reportList) { 
                        if(!"POST".equals(String.valueOf(r.get("TYPE")))) continue; 
                        hasDeleteReq = true;
            %>
                <tr>
                    <td class="r-idx">#<%= postTotal-- %></td>
                    <td><span class="type-tag">投稿</span></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/viewPost/<%= r.get("B_IDX") %>" target="_blank">
                            <%= r.get("TITLE") %>
                        </a>
                    </td>
                    <td><%= r.get("REASON") %></td>
                    <td class="r-date"><%= r.get("REG_DATE") %></td>
                    <td>
                        <div class="action-buttons">
                            <button type="button" class="btn-del" onclick="handleAction('postDelete', '<%= r.get("B_IDX") %>')">削除承認</button>
                            <button type="button" class="btn-ignore" onclick="handleAction('reportIgnore', '<%= r.get("ID") %>')">却下</button>
                        </div>
                    </td>
                </tr>
            <% } 
                if(!hasDeleteReq) { %> <tr><td colspan="6" class="empty-msg">受理済みの投稿削除依頼はありません。</td></tr> <% }
            } %>
                </tbody>
            </table>
        </div>

        <div id="reply-delete-section" class="tab-content">
            <h2>💬非会員コメント削除依頼リスト</h2>
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>依頼番号</th>
                        <th>原文タイトル</th>
                        <th>理由</th>
                        <th>依頼日</th>
                        <th>処置</th>
                    </tr>
                </thead>
                <tbody>
            <% 
                if(reportList != null && !reportList.isEmpty()) { 
                    boolean hasReplyReq = false;
                    int replyTotal = 0;
                    for(Map<String, Object> countR : reportList) {
                        if("REPLY".equals(String.valueOf(countR.get("TYPE")))) replyTotal++;
                    }

                    for(Map<String, Object> r : reportList) { 
                        if(!"REPLY".equals(String.valueOf(r.get("TYPE")))) continue; 
                        hasReplyReq = true;
                        
                        String bIdx = String.valueOf(r.get("B_IDX"));
                        Object tIdxObj = r.get("TARGET_IDX");
                        String targetIdx = (tIdxObj != null) ? String.valueOf(tIdxObj) : "";
            %>
                <tr>
                    <td class="r-idx">#<%= replyTotal--%></td>
                    <td>
                    <a href="${pageContext.request.contextPath}/viewPost/<%= bIdx %><%= !targetIdx.isEmpty() ? "?targetComment=" + targetIdx : "" %>" target="_blank">
                            <%= r.get("TITLE") %>
                        </a>
                    </td>
                    <td style="text-align: left;"><%= r.get("REASON") %></td>
                    <td class="r-date"><%= r.get("REG_DATE") %></td>
                    <td>
                        <div class="action-buttons">
                            <button type="button" class="btn-del" onclick="handleAction('replyDeleteConfirm', '<%= targetIdx %>')">削除承認</button>
                            <button type="button" class="btn-ignore" onclick="handleAction('reportIgnore', '<%= r.get("ID") %>')">却下</button>
                        </div>
                    </td>
                </tr>
            <% } 
                if(!hasReplyReq) { %> <tr><td colspan="5" class="empty-msg">受理済みのコメント削除依頼はありません。</td></tr> <% }
            } %>
                </tbody>
            </table>
        </div>
    </div>

    <div class="floating-home-btn" onclick="location.href='${pageContext.request.contextPath}/list';">
        <span class="material-icons">arrow_back</span>
    </div>

    <script>
        function openTab(tabId) {
            document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));
            document.querySelectorAll('.tab-btn').forEach(btn => btn.classList.remove('active'));
            document.getElementById(tabId).classList.add('active');
            event.currentTarget.classList.add('active');
        }

        function handleAction(action, idx) {
            if(!idx || idx === 'null' || idx === '') {
                alert('対象番号(ID)が見つかりません。');
                return;
            }
            if(confirm('本当に実行しますか？')) {
                location.href = '${pageContext.request.contextPath}/' + action + '?idx=' + idx;
            }
        }
    </script>
</body>
</html>