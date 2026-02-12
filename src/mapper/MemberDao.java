package mapper;


import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;

import java.sql.Connection;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Base64;

import domain.MemberVo;
import util.DBmanager;

public class MemberDao {
    private static MemberDao instance = new MemberDao();
    private MemberDao() {}
    
    public static MemberDao getInstance() {
        return instance;
    }

    public int checkUserIdExists(String id) {
        String sql = "SELECT COUNT(*) FROM member WHERE id = ?";
        
        try (Connection conn = DBmanager.getInstance().getDBmanager();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, id);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return 1;
            } else {
                return 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return -1; 
        }
    }
    
    public int checkEmailExists(String email) {
        String sql = "SELECT COUNT(*) FROM member WHERE email = ?"; 
        
        try (Connection conn = DBmanager.getInstance().getDBmanager();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    return 1; 
                } else {
                    return 0; 
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return -1;
        }
    }
    
    public int setMemberInsert(MemberVo vo) { 
        String sql = "INSERT INTO member (idx, name, id, pw, tel, email) VALUES (member_seq.nextval, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBmanager.getInstance().getDBmanager();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, vo.getName());
            pstmt.setString(2, vo.getId());
            pstmt.setString(3, vo.getPw());
            pstmt.setString(4, vo.getTel());
            pstmt.setString(5, vo.getEmail());
            
            return pstmt.executeUpdate() > 0 ? 1 : 0; 
            
        } catch (SQLException e) {
            e.printStackTrace(); 
            System.out.println("会員登録中にエラーが発生: " + e.getMessage()); 
            return -1; 
        }
    }
    
    public int getSelectIdPw(String userId, String userPassword) throws SQLException { 
        String sql = "SELECT COUNT(*) FROM MEMBER WHERE id = ? AND pw = ?"; 
        
        try (Connection conn = DBmanager.getInstance().getDBmanager();
             PreparedStatement psmt = conn.prepareStatement(sql)) {
            
            psmt.setString(1, userId);
            psmt.setString(2, userPassword); 
            
            ResultSet rs = psmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) == 1 ? 1 : 0;  
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
        return -1;  
    }

    public MemberVo getUserById(String id) {
        MemberVo vo = null;
        String sql = "SELECT * FROM member WHERE id = ?";  
        
        try (Connection conn = DBmanager.getInstance().getDBmanager();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, id);  

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    vo = new MemberVo();
                    vo.setIdx(rs.getInt("idx"));
                    vo.setId(rs.getString("id"));
                    vo.setPw(rs.getString("pw"));
                    vo.setName(rs.getString("name"));
                    vo.setEmail(rs.getString("email"));
                    vo.setTel(rs.getString("tel"));

                    String profileImgPath = rs.getString("profileImgPath"); 
                    vo.setProfileImgPath(profileImgPath);  
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return vo;
    }

    public int updateUserWithImage(MemberVo member) throws SQLException {
        String sql = "UPDATE member SET pw = ?, name = ?, email = ?, tel = ?, profileImgPath = ? WHERE id = ?";

        try (Connection conn = DBmanager.getInstance().getDBmanager();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, member.getPw());
            pstmt.setString(2, member.getName());
            pstmt.setString(3, member.getEmail());
            pstmt.setString(4, member.getTel());
            pstmt.setString(5, member.getProfileImgPath());  
            pstmt.setString(6, member.getId());

            return pstmt.executeUpdate();
        }
    }
    
    public int checkTel(String tel) {
        int result = 0;
        String sql = "SELECT COUNT(*) FROM member WHERE tel = ?";
        
        try (Connection conn = DBmanager.getInstance().getDBmanager();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, tel);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    result = rs.getInt(1); 
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
    
    public int checkEmail(String email) {
        int result = 0;
        String sql = "SELECT COUNT(*) FROM member WHERE email = ?"; 
        
        try (Connection conn = DBmanager.getInstance().getDBmanager();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    result = rs.getInt(1);
                }
            }
            System.out.println("チェックしたメール: " + email + " | 結果カウント: " + result);
            
        } catch (Exception e) {
            System.out.println("重複チェック中にエラーが発生！");
            e.printStackTrace();
        }
        return result;
    }
    
    public int deleteMember(String id, int idx) {
        int result = 0;
        Connection conn = null;
        PreparedStatement pstmtBoard = null;
        PreparedStatement pstmtMember = null;

        String sqlDeleteBoard = "DELETE FROM board WHERE writer_idx = ?"; 
        String sqlDeleteMember = "DELETE FROM member WHERE id = ?"; 

        try {
            conn = DBmanager.getInstance().getDBmanager();
            conn.setAutoCommit(false); 

            pstmtBoard = conn.prepareStatement(sqlDeleteBoard);
            pstmtBoard.setInt(1, idx); 
            pstmtBoard.executeUpdate();

            pstmtMember = conn.prepareStatement(sqlDeleteMember);
            pstmtMember.setString(1, id);
            result = pstmtMember.executeUpdate();

            conn.commit(); 
        } catch (Exception e) {
            if (conn != null) try { conn.rollback(); } catch (Exception ex) {}
            e.printStackTrace();
        } finally {
        }
        return result;
    }
}