package service.member;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import domain.MemberVo;
import mapper.MemberDao; // DAO import
import service.Action;

public class MemberRegister implements Action {

    @Override
    public void command(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");

        MemberVo vo = new MemberVo();
        vo.setId(request.getParameter("Id"));
        vo.setPw(request.getParameter("password")); 
        vo.setName(request.getParameter("userName"));
        vo.setTel(request.getParameter("userTel"));
        vo.setEmail(request.getParameter("userEmail"));
        
        if (vo.getId() == null || vo.getId().isEmpty() || 
            vo.getPw() == null || vo.getPw().isEmpty() || 
            vo.getName() == null || vo.getName().isEmpty() || 
            vo.getTel() == null || vo.getTel().isEmpty() || 
            vo.getEmail() == null || vo.getEmail().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"result\": -1}"); 
            return;
        }

        try {
            int result = MemberDao.getInstance().setMemberInsert(vo);

            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("utf-8");

            if (result == 1) {
                response.getWriter().write("1"); 
            } else {
                response.getWriter().write("0"); 
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.setContentType("application/json; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"result\": -1, \"message\": \"サバエラが発生しました。\"}");
        }
    }
}
