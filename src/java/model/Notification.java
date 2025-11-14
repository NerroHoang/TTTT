package model;

public class Notification {

    private int notiID;
    private String notiName;
    private String notiCreateDate;
    private int userID;

    // Constructors
    public Notification() {
    }

    public Notification(int notiID, String notiName, String notiCreateDate, int userID) {
        this.notiID = notiID;
        this.notiName = notiName;
        this.notiCreateDate = notiCreateDate;
        this.userID = userID;
    }

    // Getters and Setters
    public int getNotiID() {
        return notiID;
    }

    public void setNotiID(int notiID) {
        this.notiID = notiID;
    }

    public String getNotiName() {
        return notiName;
    }

    public void setNotiName(String notiName) {
        this.notiName = notiName;
    }

    public String getNotiCreateDate() {
        return notiCreateDate;
    }

    public void setNotiCreateDate(String notiCreateDate) {
        this.notiCreateDate = notiCreateDate;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    @Override
    public String toString() {
        return "Notification{"
                + "notiID=" + notiID
                + ", notiName='" + notiName + '\''
                + ", notiCreateDate='" + notiCreateDate + '\''
                + ", userID=" + userID
                + '}';
    }
}