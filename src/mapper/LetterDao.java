package mapper;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import util.DBmanager; // 1. 패키지 경로를 util.DBmanager로 맞췄습니다.

public class LetterDao {
    private static LetterDao instance = new LetterDao();
    private LetterDao() {}
    public static LetterDao getInstance() {
        return instance;
    }

    public int insertLetter(String userName, String content, String fileName) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        int generatedIdx = 0; 
        String sql = "INSERT INTO WAL_LETTERS (IDX, USER_NAME, CONTENT, FILE_NAME, REG_DATE, IS_MAILED) " +
                     "VALUES (WAL_LETTERS_SEQ.NEXTVAL, ?, ?, ?, SYSDATE, 'N')";

        try {
            conn = DBmanager.getInstance().getDBmanager();
            pstmt = conn.prepareStatement(sql, new String[] { "IDX" });
            
            pstmt.setString(1, userName);
            pstmt.setString(2, content);
            pstmt.setString(3, fileName);

            int result = pstmt.executeUpdate();

            if (result > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    generatedIdx = rs.getInt(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
        }
        
        return generatedIdx; 
    }
    
    public void updateMailStatus(int idx) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        String sql = "UPDATE WAL_LETTERS SET IS_MAILED = 'Y' WHERE IDX = ?";

        try {
            conn = DBmanager.getInstance().getDBmanager();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, idx);
            pstmt.executeUpdate();
            System.out.println("DBステータス更新完了 (IDX: " + idx + ")");
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
        }
    }
}