package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import mapper.BoardDao;
import mapper.LetterDao;
import mapper.MemberDao;
import domain.MemberVo;
import service.member.MemberRegister;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

@WebServlet("/")
public class FrontController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");
        doAction(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("utf-8");
        doAction(request, response);
    }

    protected void doAction(HttpServletRequest request, HttpServletResponse response) {
        try {
            String uri = request.getRequestURI();
            String contextPath = request.getContextPath();
            String action = uri.substring(contextPath.length());
            
            if (action.equals("/") || action.isEmpty()) {
                response.sendRedirect(contextPath + "/main");
                return;
            }
            
            if (action.contains(".")) {
                return; 
            }

            String page = null;
            
            System.out.println("統合コントローラ: " + action);
            
            if (action.equals("/wal")) {
                page = "/letter/wal.jsp";
            } 
            
            else if (action.equals("/sendMail")) {
                new service.letter.LetterSendService().execute(request, response);
                return;
            }
            
            else if (action.equals("/login") && request.getMethod().equals("POST")) {
                new service.member.MemberLoginService().execute(request, response);
                return; 
            }
            
            else if (action.equals("/logout")) {
                HttpSession session = request.getSession();
                session.invalidate();
                response.sendRedirect(contextPath + "/index");
                return;
            }
            
            else if (action.equals("/writeSave")) {
                new service.board.BoardWriteService().execute(request, response);
                return;
            }
            

            else if (action.startsWith("/addDeleteRequest")) {
                new service.board.BoardDeleteRequestService().execute(request, response);
                
                String bIdx = request.getParameter("bIdx");
                if (bIdx != null) {
                    response.sendRedirect(contextPath + "/viewPost/" + bIdx);
                } else {
                    response.sendRedirect(contextPath + "/list");
                }
                return; 
            }
            
            else if (action.equals("/commentSave")) {
                new service.board.BoardCommentService().execute(request, response);
                return;
            }
            
            else if (action.startsWith("/commentDelete")) {
                String[] parts = action.split("/");
                if (parts.length >= 4) {
                    request.setAttribute("cIdx", parts[2]); 
                    request.setAttribute("bIdx", parts[3]); 

                    new service.board.BoardCommentDeleteService().execute(request, response);
                    
                    String bIdx = parts[3]; 
                    response.sendRedirect(contextPath + "/viewPost/" + bIdx);
                } else {
                    response.sendRedirect(contextPath + "/list");
                }
                return; 
            }
            
            else if (action.startsWith("/postDelete")) {
                String bIdx = null;
                String[] parts = action.split("/");
                
                if (parts.length >= 3) {
                    bIdx = parts[2];
                } else {
                    bIdx = request.getParameter("bIdx");
                }

                if (bIdx != null) {
                    request.setAttribute("bIdx", bIdx); 
                    new service.board.BoardDeleteService().command(request, response);
                    
                    response.sendRedirect(contextPath + "/list");
                    return; 
                } else {
                    response.sendRedirect(contextPath + "/list");
                    return;
                }
            }
            
            else if (action.equals("/reportPost")) {
                new service.board.ReportService().execute(request, response);
                return;
            }
            
            else if (action.equals("/admin")) {
                java.util.List<java.util.Map<String, Object>> reportList = mapper.BoardDao.getInstance().getReportList();
                request.setAttribute("reportList", reportList);
                page = "/admin/admin.jsp"; 
            }
            
            else if (action.equals("/main") || action.equals("/")) {
                page = "/member/member2.jsp";
            } 
            
            else if (action.equals("/member")) {
                page = "/member/member7.jsp";
            } 
            
            else if (action.equals("/login")) {
                if (request.getMethod().equals("GET")) {
                    page = "/login/login2.jsp";
                } else {
                	new service.member.MemberLoginService().execute(request, response);
                    return;
                }
            }
            
            else if (action.equals("/checkId")) {
                String userId = request.getParameter("Id");
                int result = MemberDao.getInstance().checkUserIdExists(userId);
                
                response.setContentType("text/plain; charset=UTF-8");
                response.getWriter().write(String.valueOf(result));
                return; 
            }

            else if (action.equals("/checkEmail")) {
                String userEmail = request.getParameter("email");
                int result = MemberDao.getInstance().checkEmailExists(userEmail);
                
                response.setContentType("text/plain; charset=UTF-8");
                response.getWriter().write(String.valueOf(result));
                return; 
            }
            
            else if (action.equals("/checkTel")) {
                String userTel = request.getParameter("userTel");
                int result = MemberDao.getInstance().checkTel(userTel);
                
                response.getWriter().write(String.valueOf(result));
                return;
            }
            
            else if (action.equals("/register")) {
                new MemberRegister().command(request, response);
                return;
            } 
            
            else if (action.equals("/index")) {
                page = "/blog/index2.jsp";
            } 
            
            else if (action.equals("/photo")) {
                java.util.List<domain.PhotoVo> photoList = mapper.BoardDao.getInstance().getPhotoList();
                
                request.setAttribute("photoList", photoList);
                
                page = "/content/photo.jsp";
            }
            
            else if (action.equals("/list")) {
                new service.board.BoardListService().execute(request, response);
                page = "/board/list.jsp";
            } 
            
            else if (action.equals("/write")) {
                page = "/post/write.jsp";
            }
            
            else if (action.equals("/writeSave")) {
            	new service.board.BoardWriteService().execute(request, response);
                return;
            }
            
            else if (action.startsWith("/viewPost")) {
                String bIdx = null;
                String[] parts = action.split("/");
                
                if (parts.length >= 3) {
                    bIdx = parts[2];
                } else {
                    bIdx = request.getParameter("bIdx");
                }

                if (bIdx != null) {
                    try {
                        request.setAttribute("bIdx", Integer.parseInt(bIdx)); 
                    } catch (NumberFormatException e) {
                        System.err.println("無効な投稿番号です (Invalid bIdx): " + bIdx);
                        request.setAttribute("bIdx", 0); 
                    }
                }
                
                new service.board.BoardDetailService().execute(request, response);
                
                if (request.getAttribute("post") == null) {
                    response.sendRedirect(contextPath + "/list");
                    return;
                }
                
                page = "/post/viewPost.jsp";
            }
            
            else if (action.startsWith("/postEdit")) {
                String bIdx = null;
                String[] parts = action.split("/");
                
                if (parts.length >= 3) {
                    bIdx = parts[2];
                } else {
                    bIdx = request.getParameter("bIdx");
                }

                if (bIdx != null) {
                    request.setAttribute("bIdx", bIdx); 
                    new service.board.BoardEditService().command(request, response);
                    page = "/post/editPost.jsp";
                } else {
                    response.sendRedirect(contextPath + "/list");
                    return;
                }
            }
            
            else if (action.equals("/postUpdate")) {
                new service.board.BoardUpdateService().command(request, response);
                return; 
            }
            
            else if (action.equals("/mypage")) {
                HttpSession session = request.getSession();
                String userId = (String) session.getAttribute("userId");

                if (userId == null) {
                    response.sendRedirect(contextPath + "/login");
                    return;
                }

                MemberVo user = MemberDao.getInstance().getUserById(userId);
                request.setAttribute("user", user);
                
                page = "/member/mypage.jsp"; 
            }
            
            else if (action.equals("/checkCurrentPw")) {
                String inputPw = request.getParameter("currentPw");
                MemberVo sessionUser = (MemberVo) request.getSession().getAttribute("user");
                
                response.setContentType("text/plain; charset=UTF-8");
                
                if (sessionUser != null && sessionUser.getPw().equals(inputPw)) {
                    response.getWriter().write("match");
                } else {
                    response.getWriter().write("mismatch");
                }
                return; 
            }
            
            else if (action.equals("/updateProfile")) {
                new service.member.MemberUpdateService().execute(request, response);
                return; 
            }
            
            else if (action.equals("/withdraw")) {
                new service.member.MemberWithdrawService().execute(request, response);
                return;
            }
            
            if (page != null) {
                request.getRequestDispatcher(page).forward(request, response);
            } else {
                if(!action.equals("/main")) {
                    response.sendRedirect(contextPath + "/main");
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}