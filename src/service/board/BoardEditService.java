package service.board;

import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mapper.BoardDao;
import service.Action;

public class BoardEditService implements Action {
    @Override
    public void command(HttpServletRequest request, HttpServletResponse response) {
        Object bIdxAttr = request.getAttribute("bIdx");
        String bIdxParam = (bIdxAttr != null) ? String.valueOf(bIdxAttr) : request.getParameter("bIdx");
        
        if (bIdxParam != null) {
            try {
                int bIdx = Integer.parseInt(bIdxParam);
                BoardDao dao = BoardDao.getInstance(); 
                Map<String, Object> post = dao.getPostDetail(bIdx);
                
                request.setAttribute("post", post);
                request.setAttribute("bIdx", bIdx);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}