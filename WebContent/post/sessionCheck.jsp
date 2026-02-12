<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    if (session.getAttribute("userId") == null) {
%>
    <script>
        alert("ログインが必要です。");
        location.href = "<%= request.getContextPath() %>/login2.jsp";
    </script>
<%
        return;
    }
%>