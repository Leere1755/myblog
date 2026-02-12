package service.board;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import mapper.BoardDao;

public class BoardDeleteRequestService {

    public void execute(HttpServletRequest request, HttpServletResponse response) {
        try {
            String uri = request.getRequestURI();
            String contextPath = request.getContextPath();
            String action = uri.substring(contextPath.length());

            String idx = request.getParameter("idx");
            String targetType = request.getParameter("targetType"); 
            String authorType = request.getParameter("authorType"); 
            String reason = request.getParameter("reason");
            String password = request.getParameter("password");
            String bIdx = request.getParameter("bIdx");

            if ((idx == null || idx.isEmpty()) && action.startsWith("/addDeleteRequest/")) {
                String[] parts = action.split("/");
                if (parts.length >= 3) {
                    idx = parts[2];
                }
            }

            System.out.println("======= [DEBUG] 削除依頼の処理開始 =======");
            System.out.println("対象番号(idx): " + idx);
            System.out.println("対象タイプ(targetType): " + targetType); 
            System.out.println("作成者タイプ(authorType): " + authorType);
            System.out.println("現在の投稿番号(bIdx): " + bIdx); 
            System.out.println("====================================");

            int result = BoardDao.getInstance().insertDeleteRequest(idx, targetType, authorType, reason, password);

            response.setContentType("text/html; charset=UTF-8");
            java.io.PrintWriter out = response.getWriter();
            
            if (result > 0) {
                out.println("<script>");
                out.println("alert('削除依頼が正常に受け付けられました。');");
                
                if (bIdx != null && !bIdx.trim().isEmpty()) {
                    out.println("location.href='" + contextPath + "/viewPost/" + bIdx + "';");
                } else {
                    out.println("location.href='" + contextPath + "/list';");
                }
                out.println("</script>");
            } else {
                out.println("<script>");
                out.println("alert('受付中にエラーが発生しました。DBを確認してください。');");
                out.println("history.back();");
                out.println("</script>");
            }
            out.flush();

        } catch (Exception e) {
            System.out.println("[ERROR] 削除依頼サービス実行中に例外発生！");
            e.printStackTrace();
        }
    }
}