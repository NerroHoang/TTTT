/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import DAO.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.*;
import java.util.Calendar;
import model.Users;

/**
 *
 * @author Admin
 */
public class UpgradeServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet UpgradeServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UpgradeServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("currentUser");

        if (user != null) {
            int selectedPackage = Integer.parseInt(request.getParameter("selectedPackage"));  // Gói dịch vụ được chọn
            int userBalance = user.getBalance();
            int coinsRequired = 0;

            // Xác định số coin yêu cầu tùy theo gói
            if (selectedPackage == 20) {
                coinsRequired = 20;
            } else if (selectedPackage == 50) {
                coinsRequired = 50;
            }

            // Kiểm tra số dư của người dùng
            if (userBalance >= coinsRequired) {
                // Cập nhật gói và số dư
                int newBalance = userBalance - coinsRequired;

                // Tính ngày hết hạn dựa trên gói
                Calendar calendar = Calendar.getInstance();
                if (selectedPackage == 20) {
                    calendar.add(Calendar.MONTH, 1);  // Gói 20 Coin - Hết hạn sau 1 tháng
                } else if (selectedPackage == 50) {
                    calendar.add(Calendar.MONTH, 3);  // Gói 50 Coin - Hết hạn sau 3 tháng
                }
                Date expirationDate = new Date(calendar.getTimeInMillis());

                // Cập nhật cơ sở dữ liệu
                UserDAO userDAO = new UserDAO();
                boolean isUpdated = userDAO.updateUserRoleAndBalance(user.getUserID(), newBalance, 2, expirationDate);  // Cập nhật số dư, role và ngày hết hạn
                userDAO.addMoneyToBalance(coinsRequired, 1);
                if (isUpdated) {
                    
                    // Lưu lại thông tin đã cập nhật vào session
                    user.setBalance(newBalance);
                    user.setRole(2);
                    user.setExpirationDate(expirationDate);

                    // Chuyển hướng đến trang thành công
                    response.sendRedirect("updateDone.jsp");
                } else {
                    // Nếu cập nhật thất bại
                    request.setAttribute("errorMessage", "Có lỗi khi nâng cấp tài khoản. Vui lòng thử lại.");
                    request.getRequestDispatcher("error.jsp").forward(request, response);
                }
            } else {
                // Nếu số dư không đủ
                request.setAttribute("errorMessage", "Số dư không đủ để nâng cấp. Vui lòng nạp thêm coin.");
                request.getRequestDispatcher("recharge.jsp").forward(request, response);
            }
        } else {
            // Người dùng chưa đăng nhập
            response.sendRedirect("login.jsp");
        }
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
