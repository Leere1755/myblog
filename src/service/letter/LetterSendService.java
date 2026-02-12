package service.letter;

import java.io.File;
import java.util.Properties;
import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.mail.*;
import javax.mail.internet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;
import mapper.LetterDao;

public class LetterSendService {
    public void execute(HttpServletRequest request, HttpServletResponse response) throws Exception {
        String savePath = request.getServletContext().getRealPath("/upload");
        int maxSize = 10 * 1024 * 1024;
        
        File uploadDir = new File(savePath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        MultipartRequest multi = new MultipartRequest(request, savePath, maxSize, "utf-8", new DefaultFileRenamePolicy());
        
        
        String userName = multi.getParameter("userName");

        if (userName == null || userName.trim().isEmpty()) {
            userName = "匿名"; 
        }
        String content = multi.getParameter("content");
        String fileName = multi.getFilesystemName("fileName");
        
        int result = LetterDao.getInstance().insertLetter(userName, content, fileName);
        
        if (result > 0) {
            sendEmailWithAttachment(result, userName, content, savePath, fileName); 
            response.sendRedirect(request.getContextPath() + "/index");
        }else {
            response.sendRedirect(request.getContextPath() + "/wal");
        }
    }

    private void sendEmailWithAttachment(int idx, String fromUser, String content, String path, String fileName) {
        final String user = "dlthals1755@gmail.com"; 
        final String password = "jsjcwjjgwlzfmfdq"; 

        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(props, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(user, password);
            }
        });

        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(user));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress("dlthals1755@naver.com")); 
            message.setSubject("[ブログ通知] " + fromUser + "様からの大切なメッセージが届きました。", "UTF-8");

            Multipart multipart = new MimeMultipart();

            MimeBodyPart textPart = new MimeBodyPart();
            textPart.setText(fromUser + "様からのメッセージ内容:\n\n" + content, "UTF-8");
            multipart.addBodyPart(textPart);

            if (fileName != null) {
                MimeBodyPart attachPart = new MimeBodyPart();
                DataSource source = new FileDataSource(path + File.separator + fileName);
                attachPart.setDataHandler(new DataHandler(source));
                attachPart.setFileName(MimeUtility.encodeText(fileName, "UTF-8", "B")); 
                multipart.addBodyPart(attachPart);
            }

            message.setContent(multipart);
            
            Transport.send(message);
            System.out.println("メール送信に成功しました!");
            
            LetterDao.getInstance().updateMailStatus(idx);
            System.out.println("DBステータス更新完了 (IDX: " + idx + ")");
            
        } catch (Exception e) {
            System.out.println("メール送信中にエラーが発生しました!");
            e.printStackTrace();
        }
    }
}