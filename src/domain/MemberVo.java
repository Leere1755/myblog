package domain;

public class MemberVo {

    private int idx;
    private String name;
    private String id;
    private String pw;
    private String tel;
    private String email;
    private String profileImgPath; 

    public String getProfileImgPath() {
        return profileImgPath;
    }

    public void setProfileImgPath(String profileImgPath) {
        this.profileImgPath = profileImgPath;
    }

    public int getIdx() {
        return idx;
    }

    public void setIdx(int idx) {
        this.idx = idx;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getPw() {
        return pw;
    }

    public void setPw(String pw) {
        this.pw = pw;
    }

    public String getTel() {
        return tel;
    }

    public void setTel(String tel) {
        this.tel = tel;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    @Override
    public String toString() {
        return "MemberVo{" +
                "idx=" + idx +
                ", name='" + name + '\'' +
                ", id='" + id + '\'' +
                ", tel='" + tel + '\'' +
                ", email='" + email + '\'' +
                ", profileImgPath='" + profileImgPath + '\'' + 
                '}';
    }
}
