/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Timer;


import DAO.UserDAO;
import java.util.Timer;
import java.util.TimerTask;

public class ExpirationCheckScheduler {

    private static Timer timer; // Đối tượng Timer để quản lý các task định kỳ

    public static void start() {
        if (timer == null) {
            timer = new Timer(true); // Timer chạy nền

            // Đặt thời gian chạy kiểm tra mỗi 24 giờ
            timer.scheduleAtFixedRate(new TimerTask() {
                @Override
                public void run() {
                    // Gọi phương thức kiểm tra và cập nhật role cho tất cả người dùng
                    UserDAO userDAO = new UserDAO();
                    userDAO.checkAndUpdateRoleIfExpiredForAllUsers();
                }

            }, 0, 24 * 60 * 60 * 1000); // Mỗi 24 giờ (24 * 60 * 60 * 1000 milliseconds)
        }
        // Phương thức dừng Timer nếu không còn cần thiết

    }

    public static void stop() {
        if (timer != null) {
            timer.cancel(); // Hủy bỏ tất cả các task đã lên lịch và dừng Timer
        }
    }
}
