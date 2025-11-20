/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.UserDAO;
import DAO.UserIPHistoryDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Users;


public class LoginServlet extends HttpServlet {

    private static final String SUCCESS_USER = "Home";
    private static final String SUCCESS_ADMIN = "admin.jsp";

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet LoginServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoginServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("elearning-html-template/login.html");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            UserDAO userDAO = new UserDAO();
            String hassPassword = userDAO.hashPassword(password);
            System.out.println(email);
            System.out.println(password);

            String status = userDAO.checkLogin(email, hassPassword);
            System.out.println(hassPassword);
            if (status != null) {
                // Lấy địa chỉ IP của người dùng
                String userIP = request.getRemoteAddr();

                // Lưu thông tin người dùng vào session
                int role = userDAO.getUserType(email);
                Users user = userDAO.findByEmail(email);
                int userID = user.getUserID();

                // Kiểm tra lịch sử địa chỉ IP
                UserIPHistoryDAO ipHistoryDAO = new UserIPHistoryDAO();
                List<String> ipHistory = ipHistoryDAO.getUserIPHistory(userID);

                // Kiểm tra ipCount
                int ipCount = ipHistory.size();

                String loginWarning = ""; // Biến để chứa thông báo

                if (ipHistory.contains(userIP) || (ipCount == 0)) {
                    
                    
                    if (ipCount == 0){
                        ipHistoryDAO.addUserIP(userID, userIP);
                    }
                    
                    // Nếu IP đã tồn tại trong lịch sử, cho phép đăng nhập và không ban tài khoản
                    if (ipCount < 3) {
                        HttpSession session = request.getSession();
                        session.setAttribute("currentUser", user); // Lưu thông tin người dùng vào session
                        session.setMaxInactiveInterval(3600*4); // Thời gian hết hiệu lực của session

                        // Xử lý thông báo nếu đăng nhập từ IP mới
                        if (ipCount == 2) {
                            // Đây là lần đầu từ IP thứ ba (chưa ban)
                            loginWarning = "Bạn đang đăng nhập từ máy tính mới, bạn có chắc không?";
                        }
                    }

                    if (role == 3 || role == 2) {
                        // Người dùng thường
                        if (user.isBan()) {
                            response.sendRedirect("banned.jsp");
                        } else {
                            response.sendRedirect("Home");
                        }
                    } else if (role == 1) {
                        // Quản trị viên (admin)
                        response.sendRedirect("admin.jsp");
                    }
                } else {

                    // Lưu IP mới vào lịch sử
                    ipHistoryDAO.addUserIP(userID, userIP);

                    // Cảnh báo khi đăng nhập từ IP mới lần đầu (thông báo)
                    if (ipCount == 2) {
                        loginWarning = "Bạn đang đăng nhập từ một địa chỉ mới. Lần đăng nhập thứ hai từ địa chỉ này sẽ dẫn đến việc ban tài khoản.";
                    }

                    // Nếu đăng nhập lần thứ hai từ IP mới (ipCount = 3), ban tài khoản
                    if (ipCount == 3) {
                        ipHistoryDAO.setBanStatus(userID, true);  // Cập nhật trạng thái ban
                        response.sendRedirect("banned.jsp");
                        return;  // Dừng lại, không cho phép đăng nhập nữa
                    }

                    // Truyền thông báo vào request
                    request.setAttribute("loginWarning", loginWarning);
                    // Chuyển tiếp yêu cầu về login.jsp
                    request.getRequestDispatcher("login.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("errorMessage", "Wrong email or password");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
