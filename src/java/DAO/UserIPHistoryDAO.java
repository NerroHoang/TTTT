/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.*;
/**
 *
 * @author Admin
 */
public class UserIPHistoryDAO extends DBConnection{
    
    private Connection conn;

    public UserIPHistoryDAO() {
        conn = getConnection(); // Kết nối cơ sở dữ liệu
    }

    // Lấy lịch sử các địa chỉ IP của người dùng
    public List<String> getUserIPHistory(int userID) throws SQLException {
        List<String> ipHistory = new ArrayList<>();
        String sql = "SELECT ipAddress FROM [dbo].[UserIPHistory] WHERE userID = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userID);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                ipHistory.add(rs.getString("ipAddress"));
            }
        }
        return ipHistory;
    }

    // Thêm một địa chỉ IP mới vào lịch sử
    public void addUserIP(int userID, String ipAddress) throws SQLException {
        String sql = "INSERT INTO [dbo].[UserIPHistory](userID, ipAddress, loginDate, isCurrentIP) VALUES (?, ?, GETDATE(), 1)";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userID);
            stmt.setString(2, ipAddress);
            stmt.executeUpdate();
        }
    }

    // Cập nhật trạng thái "isCurrentIP" cho tất cả các IP cũ của người dùng
    public void updateUserIPStatus(int userID) throws SQLException {
        String sql = "UPDATE [dbo].[UserIPHistory] SET isCurrentIP = 0 WHERE userID = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userID);
            stmt.executeUpdate();
        }
    }

    // Đặt trạng thái ban cho người dùng
    public void setBanStatus(int userID, boolean isBanned) throws SQLException {
        String sql = "UPDATE Users SET is_banned = ? WHERE userID = ?";
        
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setBoolean(1, isBanned);
            stmt.setInt(2, userID);
            stmt.executeUpdate();
        }
    }
}
