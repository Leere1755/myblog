package service.member;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mapper.MemberDao; // MemberDao가 있는 실제 패키지 경로로 수정하세요!

@WebServlet("/checkEmail")
public class CheckEmailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        
        MemberDao dao = MemberDao.getInstance();
        
        int result = dao.checkEmail(email);
        
        response.setContentType("text/plain; charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        if (result == 0) {
            out.print("usable");    
        } else {
            out.print("not-usable"); 
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}