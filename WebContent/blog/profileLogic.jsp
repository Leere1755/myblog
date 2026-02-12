<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="domain.MemberVo" %> 

<%
    MemberVo userVo = (MemberVo) session.getAttribute("user");
    String contextPath = request.getContextPath();
    String displayImg;

    if (userVo == null) {
        displayImg = contextPath + "/images/76.jpg"; 
    } else {
        String photo = userVo.getProfileImgPath(); 
        
        if (photo == null || photo.trim().isEmpty() || photo.equals("null")) {
            displayImg = contextPath + "/images/49.jpg";
        } else {
            displayImg = contextPath + "/" + photo;
        }
    }
%>