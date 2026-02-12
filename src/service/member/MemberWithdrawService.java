package service.member;

import java.io.IOException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import domain.MemberVo;
import mapper.MemberDao;

public class MemberWithdrawService {

	public void execute(HttpServletRequest request, HttpServletResponse response) throws IOException {
	    String inputPw = request.getParameter("userPw");
	    HttpSession session = request.getSession();
	    
	    MemberVo sessionUser = (MemberVo) session.getAttribute("user");

	    response.setContentType("text/plain; charset=UTF-8");

	    System.out.println("入力されたPW: " + inputPw);
	    if (sessionUser != null) {
	        System.out.println("セッションのPW: " + sessionUser.getPw());
	        System.out.println("セッションのID: " + sessionUser.getId());
	    } else {
	        System.out.println("セッションユーザーがnullです！");
	    }
	    if (sessionUser != null && sessionUser.getPw().equals(inputPw)) {
	        int result = MemberDao.getInstance().deleteMember(sessionUser.getId(), sessionUser.getIdx());
	        
	        if (result > 0) {
	            session.invalidate(); 
	            response.getWriter().write("success");
	        } else {
	            response.getWriter().write("fail");
	        }
	    }
	}
}