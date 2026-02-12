package service.board;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import mapper.BoardDao;

public class BoardCommentDeleteService {
    public void execute(HttpServletRequest request, HttpServletResponse response) {
        try {
            String cIdxStr = (String) request.getAttribute("cIdx");
            
            System.out.println("コメント削除サービス呼び出し - 受け取った cIdx: " + cIdxStr);

            if (cIdxStr != null && !cIdxStr.isEmpty()) {
                int cIdx = Integer.parseInt(cIdxStr);
                
                BoardDao dao = BoardDao.getInstance();
                int result = dao.deleteComment(cIdx);
                
                if (result > 0) {
                    System.out.println("削除成功: [" + cIdx + "] 番のコメントが削除されました。");
                } else {
                    System.out.println("削除失敗: 該当する番号のコメントが存在しないか、DBエラーです。");
                }
            } else {
                System.out.println("削除エラー: 渡された cIdx の値が空です。");
            }
            
        } catch (Exception e) {
            System.err.println("BoardCommentDeleteService で例外が発生しました:");
            e.printStackTrace();
        }
    }
}