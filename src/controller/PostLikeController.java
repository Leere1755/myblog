package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import mapper.BoardDao; // Import 확인!

@WebServlet("/postLike")
public class PostLikeController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bIdxStr = request.getParameter("bIdx");
        HttpSession session = request.getSession();
        
        String sessionId = session.getId(); 

        try {
            int bIdx = Integer.parseInt(bIdxStr);
            BoardDao dao = BoardDao.getInstance();
            
            int result = dao.toggleLike(bIdx, sessionId); 
            int totalLikes = dao.getLikeCount(bIdx);

            response.getWriter().print(result + "|" + totalLikes);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}