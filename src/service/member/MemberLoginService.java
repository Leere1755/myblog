package service.member;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import mapper.MemberDao;
import domain.MemberVo;

public class MemberLoginService {
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String userId = request.getParameter("userId");
        String userPassword = request.getParameter("userPassword");
        
        response.setContentType("application/json; charset=UTF-8");
        
        int result = MemberDao.getInstance().getSelectIdPw(userId, userPassword);
        
        if (result == 1) {
            HttpSession session = request.getSession();
            MemberVo member = MemberDao.getInstance().getUserById(userId);
            
            System.out.println("DBから取得した画像パス: " + member.getProfileImgPath());
            
            session.setAttribute("userId", userId);
            session.setAttribute("userIdx", member.getIdx());

            session.setAttribute("user", member); 
            
            System.out.println("ログイン成功！セッション保存ID: " + session.getAttribute("userId"));
            response.getWriter().write("{\"success\": true}");
        } else {
            response.getWriter().write("{\"success\": false, \"message\": \"ログイン失敗\"}");
        }
    }
}