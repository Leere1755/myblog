package service.board;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import mapper.BoardDao;

public class BoardWriteService {
	public void execute(HttpServletRequest request, HttpServletResponse response) {
	    try {
	        String title = request.getParameter("title");
	        String content = request.getParameter("content");
	        String isAnonymousParam = request.getParameter("isAnonymous"); 

	        HttpSession session = request.getSession();
	        
	        Integer writerIdx = (Integer) session.getAttribute("userIdx"); 
	        
	        String isAnonymous = "N"; 

	        if (writerIdx == null) {
	            isAnonymous = "Y";
	        } else {
	            if ("Y".equals(isAnonymousParam)) {
	                isAnonymous = "Y";
	            } else {
	                isAnonymous = "N";
	            }
	        }

	        BoardDao dao = BoardDao.getInstance();
	        int result = dao.insertBoard(title, content, writerIdx, isAnonymous); 

	        if (result > 0) {
	            response.sendRedirect(request.getContextPath() + "/list");
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}
}