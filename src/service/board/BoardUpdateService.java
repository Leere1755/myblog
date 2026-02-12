package service.board;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import mapper.BoardDao;
import service.Action;

public class BoardUpdateService implements Action {
    @Override
    public void command(HttpServletRequest request, HttpServletResponse response) {
        try {
            int bIdx = Integer.parseInt(request.getParameter("bIdx"));
            String title = request.getParameter("title");
            String content = request.getParameter("content");

            BoardDao dao = BoardDao.getInstance();
            int result = dao.updatePost(bIdx, title, content);

            if (result > 0) {
                response.sendRedirect(request.getContextPath() + "/viewPost/" + bIdx);
            } else {
                response.sendRedirect(request.getContextPath() + "/list");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}