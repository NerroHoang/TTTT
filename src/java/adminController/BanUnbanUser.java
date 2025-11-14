/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package adminController;

import DAO.AdminDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;

/**
 *
 * @author GoldCandy
 */
public class BanUnbanUser extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        boolean isBan = Boolean.parseBoolean(request.getParameter("isBan"));
        int userID = Integer.parseInt(request.getParameter("userID"));

        // Cập nhật trạng thái ban/unban người dùng
        new AdminDAO().banUnbanUser(userID, isBan);

        // Nếu người dùng bị ban, xóa session của họ
        if (isBan) {
            // Lấy session hiện tại
            HttpSession session = request.getSession();

            // Kiểm tra xem người dùng hiện tại có phải là người bị ban không
            Users currentUser = (Users) session.getAttribute("currentUser");

            if (currentUser != null && currentUser.getUserID() == userID) {
                // Set lại session cho người dùng bị ban, ví dụ: set về null hoặc 0
                session.setAttribute("currentUser", null);  // hoặc session.invalidate(); để logout ngay lập tức
            }
        }

        // Chuyển hướng đến trang danh sách người dùng
        response.sendRedirect("view-all-user.jsp");
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
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
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
