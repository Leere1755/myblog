package service.board;

import java.io.IOException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import domain.MemberVo;
import mapper.BoardDao; // [!중요] BoardDao의 실제 패키지 경로와 맞는지 꼭 확인하세요!

public class ReportService {
    public void execute(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        HttpSession session = request.getSession();
        MemberVo user = (MemberVo) session.getAttribute("user");

        if (user == null) {
            response.getWriter().print("login_required");
            return;
        }

        try {
            String bIdxStr = request.getParameter("bIdx");
            String reason = request.getParameter("reason");
            
            if (bIdxStr == null || bIdxStr.isEmpty()) {
                response.getWriter().print("fail");
                return;
            }

            int bIdx = Integer.parseInt(bIdxStr);
            String reporterId = user.getId();

            int result = BoardDao.getInstance().insertReport(bIdx, reporterId, reason);

            if (result > 0) {
                response.getWriter().print("success");
            } else {
                response.getWriter().print("fail");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().print("error");
        }
    }
}