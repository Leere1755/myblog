package domain;

import java.sql.Timestamp;

public class PhotoVo {
    private int idx;           
    private String fileName;    
    private String title;      
    private Timestamp regDate;  

    public PhotoVo() {}

    public PhotoVo(int idx, String fileName, String title, Timestamp regDate) {
        this.idx = idx;
        this.fileName = fileName;
        this.title = title;
        this.regDate = regDate;
    }

    public int getIdx() { return idx; }
    public void setIdx(int idx) { this.idx = idx; }

    public String getFileName() { return fileName; }
    public void setFileName(String fileName) { this.fileName = fileName; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public Timestamp getRegDate() { return regDate; }
    public void setRegDate(Timestamp regDate) { this.regDate = regDate; }
}