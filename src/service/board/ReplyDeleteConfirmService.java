package service.board;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import mapper.BoardDao;

public class ReplyDeleteConfirmService {

    public void execute(HttpServletRequest request, HttpServletResponse response) {
        try {
            String cIdxStr = request.getParameter("idx");
            
            if (cIdxStr == null || cIdxStr.isEmpty()) {
                response.sendRedirect("adminReportList"); 
                return;
            }

            int cIdx = Integer.parseInt(cIdxStr);
            BoardDao dao = BoardDao.getInstance();

            int result = dao.deleteComment(cIdx);

            response.setContentType("text/html; charset=UTF-8");
            java.io.PrintWriter out = response.getWriter();

            if (result > 0) {
                
                out.println("<script>");
                out.println("alert('コメントが正常に削除されました。');");
                out.println("location.href='adminReportList';"); 
                out.println("</script>");
            } else {
                out.println("<script>");
                out.println("alert('削除失敗: 既に削除されたかエラーが発生しました。');");
                out.println("history.back();");
                out.println("</script>");
            }
            out.flush();

        } catch (Exception e) {
            System.out.println("[ERROR]管理者コメント削除承認中に例外発生！");
            e.printStackTrace();
        }
    }
}