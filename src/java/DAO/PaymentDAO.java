/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import model.Payment;

public class PaymentDAO {

    // 1. Lấy tất cả giao dịch (SỬA TÊN CỘT payment_id, payment_code...)
    public List<Payment> getAllPayments() {
        List<Payment> list = new ArrayList<>();
        // SQL Server dùng dấu ngoặc vuông [] để bọc tên cột tránh lỗi
        String sql = "SELECT payment_id, userID, payment_code, bank, amount, payment_date FROM Payment ORDER BY payment_id DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                list.add(new Payment(
                        rs.getInt("payment_id"),      // Sửa thành payment_id
                        rs.getInt("userID"),
                        rs.getString("payment_code"), // Sửa thành payment_code
                        rs.getString("bank"),
                        rs.getInt("amount"),
                        rs.getString("payment_date")  // Sửa thành payment_date
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Thêm giao dịch mới
    public void insertPayment(Payment p) {
        String sql = "INSERT INTO Payment (userID, payment_code, bank, amount, payment_date) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, p.getUserID());
            ps.setString(2, p.getPaymentCode());
            ps.setString(3, p.getBank());
            ps.setInt(4, p.getAmount());
            ps.setString(5, p.getPaymentDate());
            
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // 3. Lấy lịch sử giao dịch của 1 User
    public List<Payment> getPaymentsByUserID(int userID) {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT payment_id, userID, payment_code, bank, amount, payment_date FROM Payment WHERE userID = ? ORDER BY payment_id DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, userID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Payment(
                            rs.getInt("payment_id"),
                            rs.getInt("userID"),
                            rs.getString("payment_code"),
                            rs.getString("bank"),
                            rs.getInt("amount"),
                            rs.getString("payment_date")
                    ));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 4. Tính Tổng Doanh Thu
    public long getTotalRevenue() {
        long total = 0;
        String sql = "SELECT SUM(amount) FROM Payment";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            if (rs.next()) {
                total = rs.getLong(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return total;
    }

    public Map<String, Long> getRevenueLast6Months() {
        // Dùng TreeMap để tự động sắp xếp theo key (2025-10, 2025-11...)
        Map<String, Long> sortedData = new TreeMap<>();
        
        // Định dạng chính xác theo ảnh bạn gửi: 03-11-2025 15:25:03
        SimpleDateFormat inputFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm:ss");
        
        // Định dạng để nhóm (Năm-Tháng)
        SimpleDateFormat groupFormat = new SimpleDateFormat("yyyy-MM");

        // Chỉ lấy cột cần thiết
        String sql = "SELECT amount, payment_date FROM Payment";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while(rs.next()){
                String dateStr = rs.getString("payment_date"); // Lấy chuỗi: "03-11-2025..."
                long amount = rs.getLong("amount");
                
                if(dateStr == null || dateStr.trim().isEmpty()) continue;
                
                try {
                    // Chuyển chuỗi thành Date
                    Date date = inputFormat.parse(dateStr);
                    // Chuyển Date thành key nhóm "2025-11"
                    String key = groupFormat.format(date); 
                    
                    // Cộng dồn tiền vào tháng đó
                    sortedData.put(key, sortedData.getOrDefault(key, 0L) + amount);
                } catch (Exception e) {
                    // Nếu dòng nào sai định dạng thì bỏ qua, không làm crash chương trình
                    System.out.println("Skipping invalid date: " + dateStr);
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // --- Chuyển đổi sang Map kết quả để hiển thị (Thg 11) ---
        Map<String, Long> finalResult = new LinkedHashMap<>();
        List<String> keys = new ArrayList<>(sortedData.keySet());
        
        // Lấy tối đa 6 tháng gần nhất từ cuối danh sách
        int start = Math.max(0, keys.size() - 6);
        for (int i = start; i < keys.size(); i++) {
            String keyYearMonth = keys.get(i); // Ví dụ: "2025-11"
            long value = sortedData.get(keyYearMonth);
            
            // Tách chuỗi để lấy tháng. keyYearMonth.split("-")[1] là "11"
            String[] parts = keyYearMonth.split("-");
            String displayKey = "Thg " + Integer.parseInt(parts[1]); 
            
            finalResult.put(displayKey, value);
        }
        
        return finalResult;
    }

    // 6. Lấy các giao dịch gần đây (SỬA TÊN CỘT)
    public List<Payment> getRecentTransactions(int limit) {
        List<Payment> list = new ArrayList<>();
        // Sửa tên cột cho khớp DB
        String sql = "SELECT TOP " + limit + " payment_id, userID, payment_code, bank, amount, payment_date "
                   + "FROM Payment ORDER BY payment_id DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
             
            while (rs.next()) {
                list.add(new Payment(
                        rs.getInt("payment_id"),
                        rs.getInt("userID"),
                        rs.getString("payment_code"),
                        rs.getString("bank"),
                        rs.getInt("amount"),
                        rs.getString("payment_date")
                ));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // Main test nhanh
    public static void main(String[] args) {
        PaymentDAO dao = new PaymentDAO();
        System.out.println("--- Chart Data ---");
        System.out.println(dao.getRevenueLast6Months());
        
        System.out.println("--- Recent List ---");
        System.out.println(dao.getRecentTransactions(2));
    }
}