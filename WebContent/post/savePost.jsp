<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.sql.*" %>

<%
    request.setCharacterEncoding("UTF-8");
    String title = request.getParameter("title");
    String content = request.getParameter("content");

    Object userObj = session.getAttribute("userIdx");
    
    
    System.out.println("保存試行 -タイトル: " + title + ", 作成者番号: " + userObj);

    String url = "jdbc:oracle:thin:@localhost:1521:xe";
    String id = "draw"; 
    String pw = "1399";
    
    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        Class.forName("oracle.jdbc.driver.OracleDriver");
        conn = DriverManager.getConnection(url, id, pw);
        conn.setAutoCommit(true);

        String sql = "INSERT INTO BOARD (B_IDX, TITLE, CONTENT, WRITER_IDX, CREATEDAT) VALUES (BOARD_SEQ.NEXTVAL, ?, ?, ?, SYSDATE)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, title);
        pstmt.setString(2, content);
        
        if(userObj != null) {
            pstmt.setInt(3, Integer.parseInt(userObj.toString()));
        } else {
            out.println("<script>alert('ログインが必要です。'); history.back();</script>");
            return;
        }
        
        int result = pstmt.executeUpdate();
        if(result > 0) {
            response.sendRedirect("list.jsp");
        }
    } catch(Exception e) {
        e.printStackTrace();
        out.println("エラー発生: " + e.getMessage());
    } finally {
        if(pstmt != null) pstmt.close();
        if(conn != null) conn.close();
    }
%>