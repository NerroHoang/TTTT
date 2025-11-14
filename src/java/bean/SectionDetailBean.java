package bean;

import java.time.LocalDateTime;

public class SectionDetailBean {

    private int sectionId;      // ID của section
    private String title;       // Tiêu đề
    private String description; // Mô tả chi tiết
    private String status;      // Trạng thái: "private" hoặc "public"
    private LocalDateTime createdAt; // Thời gian tạo

    // Constructor mặc định
    public SectionDetailBean() {}

    // Constructor với các thuộc tính cần thiết
    public SectionDetailBean(int sectionId, String title, String description, String status, LocalDateTime createdAt) {
        this.sectionId = sectionId;
        this.title = title;
        this.description = description;
        this.status = status;
        this.createdAt = createdAt;
    }

    // Getter và Setter
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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

    @Override
    public String toString() {
        return "SectionDetailBean{" +
                "sectionId=" + sectionId +
                ", title='" + title + '\'' +
                ", description='" + description + '\'' +
                ", status='" + status + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
