package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mapper.BoardDao;

@WebServlet({"/reportIgnore", "/postDelete", "/replyDeleteConfirm"})
public class AdminActionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");
        
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String action = uri.substring(contextPath.length());
        
        String idx = request.getParameter("idx");
        
        BoardDao dao = BoardDao.getInstance();
        
        System.out.println("Admin Action: " + action + " | Target ID: " + idx);

        try {
            if (idx != null && !idx.isEmpty()) {
                
                if (action.equals("/reportIgnore")) {
                    dao.ignoreReport(idx);
                } 
                
                else if (action.equals("/postDelete")) {
                    int result = dao.deletePost(idx);
                    if (result > 0) {
                        dao.deleteRequestAfterAction(Integer.parseInt(idx), "POST");
                        dao.deleteRequestAfterAction(Integer.parseInt(idx), "REPORT");
                    }
                } 
                
                else if (action.equals("/replyDeleteConfirm")) {
                    int cIdx = Integer.parseInt(idx);
                    int result = dao.deleteComment(cIdx);
                    if (result > 0) {
                        dao.deleteRequestAfterAction(cIdx, "REPLY");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(contextPath + "/admin");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}