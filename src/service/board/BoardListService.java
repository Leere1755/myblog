package service.board;

import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import mapper.BoardDao;

public class BoardListService {
    public void execute(HttpServletRequest request, HttpServletResponse response) {
        
        String pageParam = request.getParameter("page");
        int curPage = 1; 

        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                curPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                curPage = 1; 
            }
        }
        
        String keyword = request.getParameter("query");
        
        if (keyword == null || keyword.isEmpty()) {
            keyword = request.getParameter("searchKeyword");
        }
        
        if (keyword == null) {
            keyword = "";
        }
        
        int pageSize = 10;
        int startRow = (curPage - 1) * pageSize + 1;
        int endRow = curPage * pageSize;

        BoardDao dao = BoardDao.getInstance();
        int totalCount = dao.getTotalCount(keyword);
        List<Map<String, Object>> postList = dao.getBoardList(startRow, endRow, keyword);

        request.setAttribute("postList", postList);
        request.setAttribute("totalCount", totalCount);
        request.setAttribute("searchKeyword", keyword);
        request.setAttribute("curPage", curPage);
        request.setAttribute("pageSize", pageSize);
    }
}