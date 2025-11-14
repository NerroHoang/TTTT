package DAO;

import bean.SectionDetailBean;
import bean.SectionInforBean;
import model.Section;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.sql.Statement;

public class SectionDao extends DBConnection {

    //lấy section bằng id
    public Section getSectionById(int sectionId) {
        String sql = "SELECT sectionId, userId, title, description, status, createdAt, updatedAt, status FROM Section WHERE sectionId = ?";
        Section section = null;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, sectionId); // Gán giá trị sectionId vào câu lệnh SQL

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Tạo đối tượng Section và ánh xạ dữ liệu từ ResultSet
                    section = new Section();
                    section.setSectionId(rs.getInt("sectionId"));
                    section.setUserId(rs.getInt("userId")); // Lấy userId
                    section.setTitle(rs.getString("title"));
                    section.setDescription(rs.getString("description"));
                    section.setStatus(rs.getString("status"));
                    section.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());
                    section.setUpdatedAt(rs.getTimestamp("updatedAt").toLocalDateTime());
                }
            }
        } catch (Exception e) {
            e.printStackTrace(); // Ghi log lỗi
        }

        return section; // Trả về đối tượng Section hoặc null nếu không tìm thấy
    }

    // Lấy danh sách Section public
    public List<Section> getPublicSections() {
        String sql = "SELECT * FROM Section WHERE status = 'public'";
        List<Section> sections = new ArrayList<>();
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Section section = new Section();
                section.setSectionId(rs.getInt("sectionId"));
                section.setUserId(rs.getInt("userId"));
                section.setTitle(rs.getString("title"));
                section.setDescription(rs.getString("description"));
                section.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());
                section.setUpdatedAt(rs.getTimestamp("updatedAt") != null
                        ? rs.getTimestamp("updatedAt").toLocalDateTime()
                        : null);
                section.setStatus(rs.getString("status"));
                sections.add(section);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sections;
    }

    // Lấy thông tin chi tiết của section dựa vào sectionId
    public SectionDetailBean getSectionDetailById(int sectionId) {
        String sql = "SELECT s.sectionId, s.title, s.description, s.status, s.createdAt "
                + "FROM Section s "
                + "WHERE s.sectionId = ?";

        SectionDetailBean sectionDetail = null;

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, sectionId); // Gán giá trị sectionId vào câu lệnh SQL

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    sectionDetail = new SectionDetailBean();
                    sectionDetail.setSectionId(rs.getInt("sectionId"));       // ID của section
                    sectionDetail.setTitle(rs.getString("title"));            // Tiêu đề
                    sectionDetail.setDescription(rs.getString("description"));// Mô tả
                    sectionDetail.setStatus(rs.getString("status"));          // Trạng thái
                    sectionDetail.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime()); // Thời gian tạo
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return sectionDetail;
    }

    // Trả về danh sách học phần dưới dạng Bean với giới hạn số lượng
    public List<SectionInforBean> getRecentSectionsForUser(int userId, int limit) {
        String sql = "SELECT TOP (?) s.sectionId, s.title, u.username AS authorName, s.status, s.createdAt "
                + "FROM Section s "
                + "JOIN [Users] u ON s.userId = u.userID "
                + "WHERE s.userId = ? "
                + "ORDER BY s.createdAt DESC";

        List<SectionInforBean> sectionBeans = new ArrayList<>();
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit); // Giới hạn số lượng học phần
            ps.setInt(2, userId); // Lấy học phần của user cụ thể

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SectionInforBean bean = new SectionInforBean();
                    bean.setSectionId(rs.getInt("sectionId"));
                    bean.setTitle(rs.getString("title"));
                    bean.setAuthorName(rs.getString("authorName"));
                    bean.setStatus(rs.getString("status"));
                    bean.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());
                    sectionBeans.add(bean);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sectionBeans;
    }

    // lấy tất cả các section của user đã tạo
    public List<SectionInforBean> getAllSectionsOfUser(int userId) {
        String sql = "SELECT s.sectionId, s.title, u.username AS authorName, s.status, s.createdAt, "
                + "(SELECT COUNT(*) FROM Flashcard f WHERE f.sectionId = s.sectionId) AS numberFlashCard "
                + "FROM Section s "
                + "JOIN [Users] u ON s.userId = u.userID "
                + "WHERE s.userId = ? "
                + "ORDER BY s.updatedAt DESC";

        List<SectionInforBean> sectionBeans = new ArrayList<>();
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId); // Lấy các section của user cụ thể

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SectionInforBean bean = new SectionInforBean();
                    bean.setSectionId(rs.getInt("sectionId"));
                    bean.setTitle(rs.getString("title"));
                    bean.setAuthorName(rs.getString("authorName"));
                    bean.setStatus(rs.getString("status"));
                    bean.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());
                    bean.setNumberFlashCard(rs.getInt("numberFlashCard")); // Số lượng flashcard
                    sectionBeans.add(bean);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sectionBeans;
    }
    // Lấy các section có status là public, sắp xếp theo updatedAt, hỗ trợ phân trang

    public List<SectionInforBean> getPublicSectionsExcludingUser(int userId, int offset, int limit) {
        String sql = "SELECT s.sectionId, s.title, u.username AS authorName, s.status, s.createdAt, s.updatedAt, "
                + "(SELECT COUNT(*) FROM Flashcard f WHERE f.sectionId = s.sectionId) AS numberFlashCard "
                + "FROM Section s "
                + "JOIN [Users] u ON s.userId = u.userID "
                + "WHERE s.status = 'public' AND s.userId != ? "
                + "ORDER BY s.updatedAt DESC, s.sectionId ASC " // Đảm bảo thứ tự duy nhất
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        List<SectionInforBean> sectionBeans = new ArrayList<>();
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, offset);
            ps.setInt(3, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SectionInforBean bean = new SectionInforBean();
                    bean.setSectionId(rs.getInt("sectionId"));
                    bean.setTitle(rs.getString("title"));
                    bean.setAuthorName(rs.getString("authorName"));
                    bean.setStatus(rs.getString("status"));
                    bean.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());
                    bean.setNumberFlashCard(rs.getInt("numberFlashCard"));
                    sectionBeans.add(bean);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return sectionBeans;
    }

    // Lấy danh sách tất cả Section mà người dùng có quyền truy cập
    public List<Section> getSectionsForUser(int userId, int roles) {
        String sql;
        if (roles != 3) {
            // Premium: Xem tất cả (public và private của chính mình)
            sql = "SELECT * FROM Section WHERE status = 'public' OR (status = 'private' AND userId = ?)";
        } else {
            // Free: Chỉ xem public
            sql = "SELECT * FROM Section WHERE status = 'public'";
        }

        List<Section> sections = new ArrayList<>();
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            if (roles != 3) {
                ps.setInt(12211, userId); // Truyền userId cho premium
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Section section = new Section();
                    section.setSectionId(rs.getInt("sectionId"));
                    section.setUserId(rs.getInt("userId"));
                    section.setTitle(rs.getString("title"));
                    section.setDescription(rs.getString("description"));
                    section.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());
                    section.setUpdatedAt(rs.getTimestamp("updatedAt") != null
                            ? rs.getTimestamp("updatedAt").toLocalDateTime()
                            : null);
                    section.setStatus(rs.getString("status"));
                    sections.add(section);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sections;
    }

    private int getAccountTypeByUserId(int userId) {
        String sql = "SELECT roles FROM [Users] WHERE userID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(2, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("roles");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 3; // Mặc định trả về 'free' nếu không tìm thấy user hoặc có lỗi
    }

    // Cập nhật Section (dành cho người dùng premium)
    public boolean updateSection(Section section) {
        String sql = "UPDATE Section SET title = ?, description = ?, updatedAt = ?, status = ? WHERE sectionId = ? AND userId = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, section.getTitle());
            ps.setString(2, section.getDescription());
            ps.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
            ps.setString(4, section.getStatus());
            ps.setInt(5, section.getSectionId());
            ps.setInt(6, section.getUserId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Xóa Section (dành cho người dùng premium)
    public boolean deleteSection(int sectionId) {
        String sql = "DELETE FROM Section WHERE sectionId = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sectionId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    // Phương thức thêm Section (dành cho người dùng premium)

    public int addSection(Section section) {
        String sql = "INSERT INTO Section (userId, title, description, createdAt, updatedAt, status) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, section.getUserId());
            ps.setString(2, section.getTitle());
            ps.setString(3, section.getDescription());
            ps.setTimestamp(4, Timestamp.valueOf(section.getCreatedAt()));
            ps.setTimestamp(5, section.getUpdatedAt() != null ? Timestamp.valueOf(section.getUpdatedAt()) : null);
            ps.setString(6, section.getStatus());

            // Thực hiện câu lệnh INSERT
            int affectedRows = ps.executeUpdate();

            // Kiểm tra nếu có dòng dữ liệu bị ảnh hưởng (tức là phần tử đã được thêm vào database)
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);  // Trả về ID vừa được tạo
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;  // Nếu có lỗi hoặc không có bản ghi nào bị ảnh hưởng, trả về -1
    }
    // Phương thức kiểm tra xem userId có phải là tác giả của sectionId không

    public boolean isAuthor(int userId, int sectionId) {
        String sql = "SELECT 1 FROM Section WHERE sectionId = ? AND userId = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, sectionId); // sectionId
            ps.setInt(2, userId); // userId

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // Nếu có dòng dữ liệu, chứng tỏ userId là tác giả
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false; // Trả về false nếu không phải là tác giả
    }
    // Tìm kiếm các section theo tên

    // Tìm kiếm các section theo tên với điều kiện status = 'public'
    public List<SectionInforBean> searchSectionsByName(String sectionName) {
        String sql = "SELECT s.sectionId, s.title, u.username AS authorName, s.status, s.createdAt, "
                + "(SELECT COUNT(*) FROM Flashcard f WHERE f.sectionId = s.sectionId) AS numberFlashCard "
                + "FROM Section s "
                + "JOIN [Users] u ON s.userId = u.userID "
                + "WHERE s.title LIKE ? AND s.status = 'public' "
                + "ORDER BY s.createdAt DESC";

        List<SectionInforBean> sectionBeans = new ArrayList<>();
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + sectionName + "%"); // Thêm ký tự wildcard để tìm kiếm gần đúng

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SectionInforBean bean = new SectionInforBean();
                    bean.setSectionId(rs.getInt("sectionId"));
                    bean.setTitle(rs.getString("title"));
                    bean.setAuthorName(rs.getString("authorName"));
                    bean.setStatus(rs.getString("status"));
                    bean.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());
                    bean.setNumberFlashCard(rs.getInt("numberFlashCard")); // Số lượng flashcard
                    sectionBeans.add(bean);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sectionBeans;
    }

//    // Hàm main để kiểm tra
//    public static void main(String[] args) {
//    SectionDao sectionDao = new SectionDao();
//    Scanner scanner = new Scanner(System.in);
//
//    // Nhập ID người dùng
//    System.out.println("Nhập ID người dùng: ");
//    int userId = scanner.nextInt();
//
//    // Xác định loại tài khoản từ userId
//    String accountType = sectionDao.getAccountTypeByUserId(userId);
//
//    // Lấy danh sách section tương ứng với loại tài khoản
//    System.out.println("\n=== DANH SÁCH SECTION TƯƠNG ỨNG VỚI NGƯỜI DÙNG ID: " + userId + " ===");
//    List<Section> sections = sectionDao.getSectionsForUser(userId, accountType);
//    for (Section section : sections) {
//        System.out.println("Section ID: " + section.getSectionId()
//                + ", Title: " + section.getTitle()
//                + ", Status: " + section.getStatus());
//    }
    public static void main(String[] args) {
        SectionDao sectionDao = new SectionDao();
        List<SectionInforBean> infor = sectionDao.getPublicSectionsExcludingUser(3, 0, 8);
        for (SectionInforBean sectionInforBean : infor) {
            System.out.println(sectionInforBean.getTitle());
        }
    }
//}
}
