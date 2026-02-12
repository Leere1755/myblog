package service.board;

import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import mapper.BoardDao;

public class BoardDetailService {
    public void execute(HttpServletRequest request, HttpServletResponse response) {
        
        Object bIdxObj = request.getAttribute("bIdx");
        
        if (bIdxObj == null) {
            String paramBIdx = request.getParameter("bIdx");
            if (paramBIdx != null) {
                bIdxObj = Integer.parseInt(paramBIdx);
            }
        }

        if (bIdxObj == null) {
            System.out.println("サービスエラー: 投稿番号(bIdx)がありません。");
            return; 
        }

        try {
            int bIdx = (bIdxObj instanceof Integer) ? (int) bIdxObj : Integer.parseInt(bIdxObj.toString());
            
            BoardDao dao = BoardDao.getInstance();

            Map<String, Object> post = dao.getPostDetail(bIdx); 

            if (post != null) {
                String postWriterId = (String) post.get("writerId");

                List<Map<String, Object>> commentList = dao.getCommentList(bIdx, postWriterId);

                request.setAttribute("post", post);
                request.setAttribute("commentList", commentList);
                request.setAttribute("bIdx", bIdx); 
                
                System.out.println("サービス成功: " + bIdx + "番の投稿データをロードしました。");
            } else {
                System.out.println("サービス通知: " + bIdx + "番の投稿が見つかりません。");
            }
            
        } catch (NumberFormatException e) {
            System.out.println("サービスエラー: 投稿番号の数字変換に失敗 -> " + bIdxObj);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}