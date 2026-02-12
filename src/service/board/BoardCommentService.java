package service.board;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import mapper.BoardDao;
import domain.MemberVo;

public class BoardCommentService {
    public void execute(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("utf-8");

            int bIdx = Integer.parseInt(request.getParameter("bIdx"));
            String content = request.getParameter("content");
            String modeStr = request.getParameter("displayMode");
            int displayMode = (modeStr != null) ? Integer.parseInt(modeStr) : 2;
            
            String password = request.getParameter("password"); 

            HttpSession session = request.getSession();
            MemberVo member = (MemberVo) session.getAttribute("user");

            String username = "匿名";
            String userid = null; 

            if (member != null) {
                username = member.getName(); 
                userid = member.getId(); 
                
            } else {
                displayMode = 2; 
                username = "匿名(ゲスト)";
                userid = null;
            }

            BoardDao dao = BoardDao.getInstance();
            int result = dao.insertComment(bIdx, userid, username, content, displayMode, password);

            String contextPath = request.getContextPath();
            if (result > 0) {
                response.sendRedirect(contextPath + "/viewPost?bIdx=" + bIdx + "#comment-section");
            } else {
                response.setContentType("text/html; charset=UTF-8");
                response.getWriter().println("<script>alert('登録に失敗しました。'); history.back();</script>");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}