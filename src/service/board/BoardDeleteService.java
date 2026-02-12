package service.board;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import mapper.BoardDao;
import service.Action;

public class BoardDeleteService implements Action {

    @Override
    public void command(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Object bIdxObj = request.getAttribute("bIdx");
            int bIdx = 0;
            
            if (bIdxObj != null) {
                if (bIdxObj instanceof Integer) {
                    bIdx = (int) bIdxObj;
                } else {
                    bIdx = Integer.parseInt(String.valueOf(bIdxObj));
                }
            } 
            else {
                String param = request.getParameter("bIdx");
                if (param != null) bIdx = Integer.parseInt(param);
            }

            if (bIdx <= 0) {
                System.out.println("削除失敗：投稿番号(bIdx)が正しくありません。");
                response.sendRedirect(request.getContextPath() + "/list");
                return;
            }

            int result = BoardDao.getInstance().deletePost(bIdx);

            if (result > 0) {
                response.sendRedirect(request.getContextPath() + "/list");
            } else {
                response.setContentType("text/html; charset=UTF-8");
                response.getWriter().println("<script>alert('削除に失敗しました。'); history.back();</script>");
            }
        } catch (Exception e) {
            System.err.println("BoardDeleteServiceでエラーが発生しました。");
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/list");
        }
    }
}