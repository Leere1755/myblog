package mapper;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import domain.PhotoVo;
import util.DBmanager;

public class BoardDao {
    private static BoardDao instance = new BoardDao();
    private BoardDao() {}
    public static BoardDao getInstance() {
        return instance;
    }
    
    public List<PhotoVo> getPhotoList() {
        List<PhotoVo> list = new ArrayList<>();
        String sql = "SELECT IDX, FILE_NAME, REG_DATE FROM WAL_LETTERS WHERE FILE_NAME IS NOT NULL ORDER BY REG_DATE DESC";

        try (Connection conn = DBmanager.getInstance().getDBmanager();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                PhotoVo vo = new PhotoVo();
                vo.setIdx(rs.getInt("IDX"));
                vo.setFileName(rs.getString("FILE_NAME"));
                vo.setRegDate(rs.getTimestamp("REG_DATE"));
                
                list.add(vo);
            }
        } catch (SQLException e) {
            System.err.println("ギャラリーリストの読み込み中にエラーが発生しました。");
            e.printStackTrace();
        }
        return list;
    }
    
    public int getTotalCount(String keyword) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM BOARD B " +
                     "LEFT JOIN MEMBER M ON B.WRITER_IDX = M.IDX " +
                     "WHERE (B.TITLE LIKE ? OR B.CONTENT LIKE ? " +
                     "OR (B.IS_ANONYMOUS = 'N' AND M.NAME LIKE ?) " +
                     "OR B.B_IDX IN (SELECT B_IDX FROM COMMENTS WHERE CONTENT LIKE ?))";
        
        try (Connection conn = DBmanager.getInstance().getDBmanager();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            String searchPattern = (keyword == null || keyword.trim().isEmpty()) ? "%%" : "%" + keyword + "%";
            
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setString(3, searchPattern);
            pstmt.setString(4, searchPattern);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }
    
    public int insertReport(int bIdx, String reporterId, String reason) {
        int result = 0;
        String sql = "INSERT INTO BOARD_REPORT (RIDX, B_IDX, REPORTER_ID, REASON, R_DATE) " +
                     "VALUES (BOARD_REPORT_SEQ.NEXTVAL, ?, ?, ?, SYSDATE)";
        
        try (Connection conn = DBmanager.getInstance().getDBmanager();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, bIdx);          
            pstmt.setString(2, reporterId);  
            pstmt.setString(3, reason);      
            
            result = pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        
        return result;
    }
    
    public List<Map<String, Object>> getBoardList(int startRow, int endRow, String keyword) {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT * FROM (" +
                     "  SELECT ROWNUM as RN, A.* FROM (" +
                     "    SELECT B.B_IDX, B.TITLE, TO_CHAR(B.CREATEDAT, 'YYYY-MM-DD') as createdat " + 
                     "    FROM BOARD B " +
                     "    LEFT JOIN MEMBER M ON B.WRITER_IDX = M.IDX " + 
                     "    WHERE (B.TITLE LIKE ? OR B.CONTENT LIKE ? " + 
                     "    OR (B.IS_ANONYMOUS = 'N' AND M.NAME LIKE ?) " + 
                     "    OR B.B_IDX IN (SELECT B_IDX FROM COMMENTS WHERE CONTENT LIKE ?)) " + 
                     "    ORDER BY B.B_IDX DESC" +
                     "  ) A" +
                     ") WHERE RN BETWEEN ? AND ?";

        try (Connection conn = DBmanager.getInstance().getDBmanager();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            String searchPattern = (keyword == null || keyword.trim().isEmpty()) ? "%%" : "%" + keyword + "%";
            pstmt.setString(1, searchPattern);
            pstmt.setString(2, searchPattern);
            pstmt.setString(3, searchPattern);
            pstmt.setString(4, searchPattern);
            pstmt.setInt(5, startRow);
            pstmt.setInt(6, endRow);

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    map.put("bIdx", rs.getInt("B_IDX"));
                    map.put("title", rs.getString("TITLE"));
                    map.put("wDate", rs.getString("createdat")); 
                    map.put("createdat", rs.getString("createdat")); 
                    list.add(map);
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }
    
    public Map<String, Object> getPostDetail(int id) {
        Map<String, Object> post = null;
        String sql = "SELECT B.B_IDX, B.TITLE, B.CONTENT, B.IS_ANONYMOUS, " + 
                     "TO_CHAR(B.CREATEDAT, 'YYYY. MM. DD. HH24:MI') as createdat, " + 
                     "M.NAME, M.PROFILEIMGPATH, M.ID as WRITER_ID " + 
                     "FROM BOARD B " + 
                     "LEFT JOIN MEMBER M ON B.WRITER_IDX = M.IDX " + 
                     "WHERE B.B_IDX = ?";

        try (Connection conn = DBmanager.getInstance().getDBmanager();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    post = new HashMap<>();
                    post.put("id", rs.getInt("B_IDX"));
                    post.put("title", rs.getString("TITLE"));
                    post.put("content", rs.getString("CONTENT"));
                    post.put("createdat", rs.getString("createdat"));
                    
                    String writerId = rs.getString("WRITER_ID");
                    post.put("writerId", writerId); 
                    
                    String isAnon = rs.getString("IS_ANONYMOUS");
                    post.put("isAnonymous", isAnon); 

                    if ("Y".equals(isAnon)) {
                        post.put("writerName", "匿名");
                        post.put("profileImg", "default_profile.png");
                    } else {
                        post.put("writerName", rs.getString("NAME") != null ? rs.getString("NAME") : "ゲスト");
                        post.put("profileImg", rs.getString("PROFILEIMGPATH"));
                    }
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return post;
    }
    
    public int toggleLike(int bIdx, String sessionId) {
        int result = -1;
        String checkSql = "SELECT COUNT(*) FROM BOARD_LIKE WHERE B_IDX = ? AND USER_ID = ?";
        
        try (Connection conn = DBmanager.getInstance().getDBmanager()) {
            int count = 0;
            try (PreparedStatement pstmt = conn.prepareStatement(checkSql)) {
                pstmt.setInt(1, bIdx);
                pstmt.setString(2, sessionId); // userId 대신 sessionId 투입
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) count = rs.getInt(1);
                }
            }

            if (count > 0) {
                String deleteSql = "DELETE FROM BOARD_LIKE WHERE B_IDX = ? AND USER_ID = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(deleteSql)) {
                    pstmt.setInt(1, bIdx);
                    pstmt.setString(2, sessionId);
                    pstmt.executeUpdate();
                    result = 0; 
                }
            } else {
                String insertSql = "INSERT INTO BOARD_LIKE (LIKE_IDX, B_IDX, USER_ID) VALUES (SEQ_BOARD_LIKE_IDX.NEXTVAL, ?, ?)";
                try (PreparedStatement pstmt = conn.prepareStatement(insertSql)) {
                    pstmt.setInt(1, bIdx);
                    pstmt.setString(2, sessionId);
                    pstmt.executeUpdate();
                    result = 1; 
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public int getLikeCount(int bIdx) {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM BOARD_LIKE WHERE B_IDX = ?";
        
        try (Connection conn = DBmanager.getInstance().getDBmanager();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, bIdx);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }

    public int checkMyLike(int bIdx, String sessionId) {
        int result = 0;
        String sql = "SELECT COUNT(*) FROM BOARD_LIKE WHERE B_IDX = ? AND USER_ID = ?";
        
        try (Connection conn = DBmanager.getInstance().getDBmanager();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, bIdx);
            pstmt.setString(2, sessionId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    result = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
    
    public int deletePost(int bIdx) {
        int result = 0;
        String sql = "DELETE FROM BOARD WHERE B_IDX = ?";
        
        try (Connection conn = DBmanager.getInstance().getDBmanager();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, bIdx);
            result = pstmt.executeUpdate();
            System.out.println("投稿の削除に成功: " + result);
            
        } catch (SQLException e) {
            System.err.println("投稿の削除中にエラーが発生！");
            e.printStackTrace();
        }
        return result;
    }
    
    private Map<String, String> nicknameMap = new HashMap<>();
    private String[] animals = {
        "幸せなリス", "賢いフクロウ", "勇敢なライオン", "可愛いア라이그마", "のんびりパンダ", 
        "素早いイルカ", "眠いナ마케モノ", "お利口なレトリバー", "怒ったオウム", "働き者のミツバチ",
        "照れ屋なウサギ", "お腹ペコペコなカバ", "優雅な白鳥", "いたずらっ子のサル", "頼もしいゾウ",
        "おしゃれなペンギン", "歌うウグイス", "踊るツル", "速いチーター", "寝坊助なコアラ",
        "用意周到なキツネ", "正直な珍島犬", "貴重なユニコーン", "神秘的なネコ", "たくましいトラ"
    };

    public List<Map<String, Object>> getCommentList(int bIdx, String postWriterId) {
        List<Map<String, Object>> list = new ArrayList<>();
        
        String sql = "SELECT C.ID, C.USERID, C.USERNAME, C.CONTENT, C.DISPLAY_MODE, " +
                     "TO_CHAR(C.CREATEDAT, 'MM.DD HH24:MI') as createdat, " +
                     "M.NAME as MEM_NICK, M.PROFILEIMGPATH " + 
                     "FROM COMMENTS C " +
                     "LEFT JOIN MEMBER M ON C.USERID = M.ID " + 
                     "WHERE C.B_IDX = ? " +
                     "ORDER BY C.ID ASC";

        try (Connection conn = DBmanager.getInstance().getDBmanager();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, bIdx);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> map = new HashMap<>();
                    
                    String userId = rs.getString("USERID");     
                    String memName = rs.getString("MEM_NICK");  
                    int displayMode = rs.getInt("DISPLAY_MODE"); 
                    
                    map.put("idx", rs.getInt("ID"));
                    map.put("userid", userId);
                    map.put("content", rs.getString("CONTENT"));
                    map.put("displayMode", displayMode);
                    map.put("createdat", rs.getString("createdat"));
                    
                    String finalNickname = "";

                    if (userId == null || userId.trim().isEmpty() || userId.equalsIgnoreCase("null")) {
                        finalNickname = "匿名(ゲスト)"; 
                    } 
                    else if (userId.equals(postWriterId)) {
                        finalNickname = "投稿者";
                    } 
                    else {
                        if (displayMode == 0) {
                            finalNickname = (memName != null && !memName.trim().isEmpty()) ? memName : userId;
                        } 
                        else if (displayMode == 1) {
                            if (!nicknameMap.containsKey(userId)) {
                                int randIdx = (int) (Math.random() * animals.length);
                                nicknameMap.put(userId, animals[randIdx]);
                            }
                            finalNickname = nicknameMap.get(userId);
                        } 
                        else {
                            finalNickname = "匿名"; 
                        }
                    }
                    
                    map.put("nickname", finalNickname);
                    
                    String pImg = rs.getString("PROFILEIMGPATH");
                    if (pImg != null && !pImg.isEmpty() && displayMode == 0) {
                        map.put("profileImg", pImg);
                    } else {
                        map.put("profileImg", "default_profile.png");
                    }

                    list.add(map);
                }
            }
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return list;
    }
    
    public int insertComment(int bIdx, String userid, String username, String content, int displayMode, String password) {
        int result = 0;
        String sql = "INSERT INTO COMMENTS (ID, B_IDX, USERID, USERNAME, CONTENT, DISPLAY_MODE, PASSWORD, CREATEDAT) "
                   + "VALUES (COMMENTS_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?, SYSDATE)";
                   
        try (Connection conn = DBmanager.getInstance().getDBmanager();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, bIdx);
            pstmt.setString(2, userid);
            pstmt.setString(3, username);
            pstmt.setString(4, content);
            pstmt.setInt(5, displayMode);
            pstmt.setString(6, password); 
            
            result = pstmt.executeUpdate();
        } catch (Exception e) {
            System.err.println("コメントの保存中にエラーが発生:");
            e.printStackTrace();
        }
        return result;
    }
    
    public int deleteComment(int cIdx) {
        int result = 0;
        String sql = "DELETE FROM COMMENTS WHERE ID = ?";
        
        try (Connection conn = DBmanager.getInstance().getDBmanager();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, cIdx);
            result = pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public int insertBoard(String title, String content, Integer writerIdx, String isAnonymous) {
        int result = 0;
        String sql = "INSERT INTO BOARD (B_IDX, TITLE, CONTENT, WRITER_IDX, IS_ANONYMOUS, CREATEDAT) " +
                     "VALUES (BOARD_SEQ.NEXTVAL, ?, ?, ?, ?, SYSDATE)";

        try (Connection conn = DBmanager.getInstance().getDBmanager();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, title);
            pstmt.setString(2, content);
            
            if (writerIdx == null || writerIdx == 0) {
                pstmt.setNull(3, java.sql.Types.INTEGER);
            } else {
                pstmt.setInt(3, writerIdx);
            }
            
            pstmt.setString(4, isAnonymous); 
            result = pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
    
    public int updatePost(int bIdx, String title, String content) {
        int result = 0;
        String sql = "UPDATE BOARD SET TITLE = ?, CONTENT = ? WHERE B_IDX = ?";

        try (Connection conn = DBmanager.getInstance().getDBmanager();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, title);
            pstmt.setString(2, content);
            pstmt.setInt(3, bIdx);
            
            result = pstmt.executeUpdate();
            System.out.println("投稿の更新成功否: " + result); 
            
        } catch (SQLException e) {
            System.err.println("投稿の更新中にDBエラーが発生！");
            e.printStackTrace();
        }
        return result;
    }
    
    public Map<String, Object> getPrevNextPost(int bIdx) {
        Map<String, Object> map = new HashMap<>();
        String prevSql = "SELECT * FROM (SELECT B_IDX, TITLE FROM BOARD WHERE B_IDX < ? ORDER BY B_IDX DESC) WHERE ROWNUM = 1";
        String nextSql = "SELECT * FROM (SELECT B_IDX, TITLE FROM BOARD WHERE B_IDX > ? ORDER BY B_IDX ASC) WHERE ROWNUM = 1";

        try (Connection conn = DBmanager.getInstance().getDBmanager()) {
            try (PreparedStatement pstmt = conn.prepareStatement(prevSql)) {
                pstmt.setInt(1, bIdx);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        map.put("prevIdx", rs.getInt("B_IDX"));
                        map.put("prevTitle", rs.getString("TITLE"));
                    }
                }
            }
            try (PreparedStatement pstmt = conn.prepareStatement(nextSql)) {
                pstmt.setInt(1, bIdx);
                try (ResultSet rs = pstmt.executeQuery()) {
                    if (rs.next()) {
                        map.put("nextIdx", rs.getInt("B_IDX"));
                        map.put("nextTitle", rs.getString("TITLE"));
                    }
                }
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return map;
    }
    
    public List<Map<String, Object>> getReportList() {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT * FROM (" +
                     "  SELECT TO_CHAR(R.RIDX) AS ID, " +
                     "         TO_CHAR(R.B_IDX) AS B_IDX, " +
                     "         NULL AS TARGET_IDX, " +
                     "         CAST(R.REPORTER_ID AS VARCHAR2(100)) AS SENDER, " +
                     "         CAST(R.REASON AS VARCHAR2(1000)) AS REASON, " +
                     "         TO_CHAR(R.R_DATE, 'YYYY-MM-DD HH24:MI') AS REG_DATE, " +
                     "         CAST(B.TITLE AS VARCHAR2(300)) AS TITLE, " +
                     "         'REPORT' AS TYPE " + 
                     "  FROM BOARD_REPORT R " +
                     "  JOIN BOARD B ON R.B_IDX = B.B_IDX " +
                     "  UNION ALL " +
                     "  SELECT TO_CHAR(D.REQUEST_ID) AS ID, " +
                     "         TO_CHAR(B.B_IDX) AS B_IDX, " + 
                     "         TO_CHAR(D.TARGET_IDX) AS TARGET_IDX, " + 
                     "         'GUEST' AS SENDER, " +
                     "         CAST(D.REASON AS VARCHAR2(1000)) AS REASON, " +
                     "         TO_CHAR(D.REG_DATE, 'YYYY-MM-DD HH24:MI') AS REG_DATE, " +
                     "         CAST(B.TITLE AS VARCHAR2(300)) AS TITLE, " +
                     "         CAST(D.TARGET_TYPE AS VARCHAR2(20)) AS TYPE " +
                     "  FROM DELETE_REQUESTS D " +
                     "  LEFT JOIN COMMENTS C ON D.TARGET_IDX = C.ID AND D.TARGET_TYPE = 'REPLY' " +
                     "  LEFT JOIN BOARD B ON (D.TARGET_TYPE = 'POST' AND D.TARGET_IDX = B.B_IDX) " +
                     "                    OR (D.TARGET_TYPE = 'REPLY' AND C.B_IDX = B.B_IDX) " +
                     ") ORDER BY REG_DATE DESC";

        try (Connection conn = DBmanager.getInstance().getDBmanager();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("ID", rs.getString("ID"));
                map.put("B_IDX", rs.getString("B_IDX"));
                map.put("TARGET_IDX", rs.getString("TARGET_IDX"));
                map.put("SENDER", rs.getString("SENDER"));
                map.put("REASON", rs.getString("REASON"));
                map.put("REG_DATE", rs.getString("REG_DATE"));
                map.put("TITLE", rs.getString("TITLE"));
                map.put("TYPE", rs.getString("TYPE")); 
                list.add(map);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
    
    public int deletePost(String bIdx) {
        int result = 0;
        String sql = "DELETE FROM BOARD WHERE B_IDX = ?";
        
        try (Connection conn = DBmanager.getInstance().getDBmanager();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, Integer.parseInt(bIdx)); 
            result = pstmt.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }

    public int ignoreReport(String id) {
        int result = 0;
        String sql1 = "DELETE FROM BOARD_REPORT WHERE RIDX = ?";
        String sql2 = "DELETE FROM DELETE_REQUESTS WHERE REQUEST_ID = ?";

        try (Connection conn = DBmanager.getInstance().getDBmanager()) {
            int targetId = Integer.parseInt(id);

            try (PreparedStatement pstmt1 = conn.prepareStatement(sql1)) {
                pstmt1.setInt(1, targetId);
                result += pstmt1.executeUpdate();
            }
            try (PreparedStatement pstmt2 = conn.prepareStatement(sql2)) {
                pstmt2.setInt(1, targetId);
                result += pstmt2.executeUpdate();
            }
            
            System.out.println("却下処理完了 (総削除件数: " + result + ")");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    
    public int insertDeleteRequest(String idx, String type, String authorType, String reason, String pw) {
        int result = 0;
        String sql = "INSERT INTO DELETE_REQUESTS (REQUEST_ID, TARGET_IDX, TARGET_TYPE, REASON, GUEST_PW, REG_DATE) "
                   + "VALUES (DELETE_REQUESTS_SEQ.NEXTVAL, ?, ?, ?, ?, SYSDATE)";
        
        try (Connection conn = DBmanager.getInstance().getDBmanager();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, Integer.parseInt(idx)); 
            pstmt.setString(2, type);               
            pstmt.setString(3, "[" + authorType + "] " + reason); 
            
            if (pw == null || pw.trim().isEmpty()) {
                pstmt.setNull(4, java.sql.Types.VARCHAR);
            } else {
                pstmt.setString(4, pw);
            }
            
            result = pstmt.executeUpdate();
            System.out.println("削除リクエストのDB保存に成功！");
        } catch (SQLException e) {
            System.err.println("DAO実行中にDBエラーが発生！");
            e.printStackTrace(); 
        }
        return result; 
    }
    
    public int deleteRequestAfterAction(int targetIdx, String type) {
        int result = 0;
        String sql = "DELETE FROM DELETE_REQUESTS WHERE TARGET_IDX = ? AND TARGET_TYPE = ?";
        try (Connection conn = DBmanager.getInstance().getDBmanager();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, targetIdx);
            pstmt.setString(2, type);
            result = pstmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return result;
    }
} 