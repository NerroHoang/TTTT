package DAO;

import bean.FlashcardDetailBean;
import model.Flashcard;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class FlashcardDao extends DBConnection {

    // Thêm Flashcard
    public boolean addFlashcard(Flashcard flashcard) {
        String sql = "INSERT INTO Flashcard (sectionId, question, answer, createdAt, updatedAt) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, flashcard.getSectionId());
            ps.setString(2, flashcard.getQuestion());
            ps.setString(3, flashcard.getAnswer());
            ps.setTimestamp(4, Timestamp.valueOf(flashcard.getCreatedAt()));
            ps.setTimestamp(5, Timestamp.valueOf(flashcard.getUpdatedAt()));
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // lấy danh sách thông tin của các flashcard của section
    public List<FlashcardDetailBean> getFlashcardsInforBySectionId(int sectionId) {
        String sql = "SELECT flashcardId, question, answer FROM Flashcard WHERE sectionId = ?";
        List<FlashcardDetailBean> flashcards = new ArrayList<>();

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, sectionId); // Gán giá trị sectionId vào câu lệnh SQL

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    // Tạo đối tượng FlashcardBean
                    FlashcardDetailBean flashcard = new FlashcardDetailBean();
                    flashcard.setFlashcardId(rs.getInt("flashcardId")); // ID flashcard
                    flashcard.setQuestion(rs.getString("question"));    // Nội dung câu hỏi
                    flashcard.setAnswer(rs.getString("answer"));        // Nội dung câu trả lời

                    // Thêm flashcard vào danh sách
                    flashcards.add(flashcard);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return flashcards; // Trả về danh sách flashcard
    }

    // Lấy danh sách tất cả Flashcards
    public List<Flashcard> getAllFlashcards() {
        List<Flashcard> flashcards = new ArrayList<>();
        String sql = "SELECT * FROM Flashcard";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Flashcard flashcard = new Flashcard();
                flashcard.setFlashcardId(rs.getInt("flashcardId"));
                flashcard.setSectionId(rs.getInt("sectionId"));
                flashcard.setQuestion(rs.getString("question"));
                flashcard.setAnswer(rs.getString("answer"));
                flashcard.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());
                flashcard.setUpdatedAt(rs.getTimestamp("updatedAt").toLocalDateTime());
                flashcards.add(flashcard);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return flashcards;
    }

    // Xóa Flashcard theo ID
    public boolean deleteFlashcard(int flashcardId) {
        String sql = "DELETE FROM Flashcard WHERE flashcardId = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, flashcardId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    //xóa flashcards của section

    public boolean deleteFlashcardsBySectionId(int sectionId) {
        String sql = "DELETE FROM Flashcard WHERE sectionId = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, sectionId); // Gán sectionId vào câu lệnh SQL
            int rowsDeleted = ps.executeUpdate(); // Thực thi câu lệnh xóa
            return rowsDeleted > 0; // Trả về true nếu có flashcards được xóa
        } catch (Exception e) {
            e.printStackTrace(); // Ghi log lỗi
        }
        return false; // Trả về false nếu có lỗi
    }

    // Cập nhật Flashcard thông thường
    public boolean updateFlashcard(Flashcard flashcard) {
        String sql = "UPDATE Flashcard SET question = ?, answer = ?, updatedAt = ? WHERE flashcardId = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, flashcard.getQuestion());
            ps.setString(2, flashcard.getAnswer());
            ps.setTimestamp(3, Timestamp.valueOf(flashcard.getUpdatedAt()));
            ps.setInt(4, flashcard.getFlashcardId());
            return ps.executeUpdate() > 0; // Trả về true nếu cập nhật thành công
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false; // Trả về false nếu có lỗi
    }

    // Lấy danh sách Flashcard cho người dùng free (chỉ các Section public)
    public List<Flashcard> getFlashcardsForFreeUser() {
        String sql = "SELECT f.* FROM Flashcard f JOIN Section s ON f.sectionId = s.sectionId WHERE s.status = 'public'";
        List<Flashcard> flashcards = new ArrayList<>();
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Flashcard flashcard = new Flashcard();
                flashcard.setFlashcardId(rs.getInt("flashcardId"));
                flashcard.setSectionId(rs.getInt("sectionId"));
                flashcard.setQuestion(rs.getString("question"));
                flashcard.setAnswer(rs.getString("answer"));
                flashcard.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());
                flashcard.setUpdatedAt(rs.getTimestamp("updatedAt") != null
                        ? rs.getTimestamp("updatedAt").toLocalDateTime()
                        : null);
                flashcards.add(flashcard);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return flashcards;
    }

    // Cập nhật Flashcard dành riêng cho người dùng premium
    public boolean updateFlashcardForPremiumUser(Flashcard flashcard, int userId) {
        String sql = """
            UPDATE Flashcard 
            SET question = ?, answer = ?, updatedAt = ? 
            WHERE flashcardId = ? 
              AND sectionId IN (SELECT sectionId FROM Section WHERE userId = ?)
            """;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, flashcard.getQuestion());
            ps.setString(2, flashcard.getAnswer());
            ps.setTimestamp(3, Timestamp.valueOf(flashcard.getUpdatedAt()));
            ps.setInt(4, flashcard.getFlashcardId());
            ps.setInt(5, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    //đếm số lượng flashcard của 1 section
    // Đếm số lượng flashcard của một section

    public int countFlashCardOfSection(int sectionId) {
        String sql = "SELECT COUNT(*) FROM Flashcard WHERE sectionId = ?";
        int number = 0;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sectionId); // Gán giá trị sectionId vào câu lệnh SQL
            try (ResultSet rs = ps.executeQuery()) { // Thực hiện truy vấn
                if (rs.next()) {
                    number = rs.getInt(1); // Lấy giá trị đếm từ cột đầu tiên
                }
            }
        } catch (Exception e) {
            e.printStackTrace(); // In lỗi ra console để debug
        }
        return number; // Trả về số lượng flashcard
    }

    // Hiển thị danh sách Flashcards
    public void displayList(List<Flashcard> flashcards) {
        for (Flashcard f : flashcards) {
            System.out.println("Question: " + f.getQuestion());
            System.out.println("Answer: " + f.getAnswer());
        }
    }

//    // Hàm main để kiểm tra các chức năng
//    public static void main(String[] args) {
//        FlashcardDao dao = new FlashcardDao();
//
//        // Test lấy Flashcard cho người dùng free
//        System.out.println("=== TEST LẤY FLASHCARD CHO NGƯỜI DÙNG FREE ===");
//        List<Flashcard> publicFlashcards = dao.getFlashcardsForFreeUser();
//        for (Flashcard flashcard : publicFlashcards) {
//            System.out.println("- Flashcard ID: " + flashcard.getFlashcardId() + ", Question: " + flashcard.getQuestion());
//        }
//
//        // Test cập nhật Flashcard cho người dùng premium
//        System.out.println("\n=== TEST CẬP NHẬT FLASHCARD CHO NGƯỜI DÙNG PREMIUM ===");
//        Flashcard updateFlashcard = new Flashcard();
//        updateFlashcard.setFlashcardId(1); // ID Flashcard cần cập nhật
//        updateFlashcard.setSectionId(2); // Flashcard thuộc Section của premium user
//        updateFlashcard.setQuestion("Updated Question Test?");
//        updateFlashcard.setAnswer("Updated Answer Test");
//        updateFlashcard.setUpdatedAt(LocalDateTime.now());
//
//        if (dao.updateFlashcardForPremiumUser(updateFlashcard, 2)) {
//            System.out.println("Cập nhật Flashcard thành công!");
//        } else {
//            System.out.println("Cập nhật Flashcard thất bại!");
//        }
//    }
    public static void main(String[] args) {
        FlashcardDao dao = new FlashcardDao();
        Flashcard flashcard = new Flashcard();
        flashcard.setSectionId(6);
        flashcard.setQuestion("5+5=?");
        flashcard.setAnswer("10");
        flashcard.setCreatedAt(LocalDateTime.now());
        flashcard.setUpdatedAt(LocalDateTime.now());
        dao.addFlashcard(flashcard);
    }
}
