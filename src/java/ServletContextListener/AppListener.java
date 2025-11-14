/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ServletContextListener;

import Timer.ExpirationCheckScheduler;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class AppListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Bắt đầu kiểm tra hết hạn khi ứng dụng khởi động
        ExpirationCheckScheduler.start();
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Dừng các thread khi ứng dụng bị dừng
        ExpirationCheckScheduler.stop();  // Dừng các thread đang chạy
    }
}
