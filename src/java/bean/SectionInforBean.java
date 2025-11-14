
package bean;

import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

public class SectionInforBean {
    private int sectionId;
    private String title;
    private String authorName; // Tên người tạo học phần (username từ bảng User)
    private String status; // Trạng thái của học phần (public/private)
    private LocalDateTime createdAt;
    private int numberFlashCard;

    // Getters và Setters
    public int getSectionId() {
        return sectionId;
    }

    public void setSectionId(int sectionId) {
        this.sectionId = sectionId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthorName() {
        return authorName;
    }

    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public int getNumberFlashCard() {
        return numberFlashCard;
    }

    public void setNumberFlashCard(int numberFlashCard) {
        this.numberFlashCard = numberFlashCard;
    }
    
    @Override
    public String toString() {
        return "SectionBean{" +
                "sectionId=" + sectionId +
                ", title='" + title + '\'' +
                ", authorName='" + authorName + '\'' +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
    public Date getCreatedAtAsDate() {
        return Date.from(createdAt.atZone(ZoneId.systemDefault()).toInstant());
    }
}
