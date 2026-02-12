package service.member;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;
import domain.MemberVo;
import mapper.MemberDao;

public class MemberUpdateService {
    public void execute(HttpServletRequest request, HttpServletResponse response) {
        try {
            String savePath = request.getServletContext().getRealPath("images");
            int maxSize = 5 * 1024 * 1024;
            
            MultipartRequest multi = new MultipartRequest(request, savePath, maxSize, "UTF-8", new DefaultFileRenamePolicy());
            
            HttpSession session = request.getSession();
            MemberVo sessionUser = (MemberVo) session.getAttribute("user");

            String id = multi.getParameter("id");
            String pw = multi.getParameter("password");
            String name = multi.getParameter("name");
            String email = multi.getParameter("email");
            String tel = multi.getParameter("tel");
            String fileName = multi.getFilesystemName("profileimgPath");
            
            String profileImgPath;
            if (fileName != null) {
                profileImgPath = "images/" + fileName;
            } else if (sessionUser != null) {
                profileImgPath = sessionUser.getProfileImgPath();
            } else {
                profileImgPath = "images/49.jpg";
            }

            MemberVo updateVo = new MemberVo();
            updateVo.setId(id);
            updateVo.setPw(pw);
            updateVo.setName(name);
            updateVo.setEmail(email);
            updateVo.setTel(tel);
            updateVo.setProfileImgPath(profileImgPath);

            int result = MemberDao.getInstance().updateUserWithImage(updateVo);

            if (result > 0) {
                MemberVo updatedUser = MemberDao.getInstance().getUserById(id); 
                
                session.setAttribute("user", updatedUser); 
                
                response.getWriter().print("success");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}