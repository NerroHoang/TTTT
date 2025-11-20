/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.FlashcardDao;
import DAO.SectionDao;
import DAO.UserDAO;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import model.Users;


@WebServlet(name = "DeleteSectionController", urlPatterns = {"/DeleteSectionController"})
public class DeleteSectionController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String sectionIdParam = request.getParameter("sectionId");
        int sectionId = (sectionIdParam != null && !sectionIdParam.isEmpty()) ? Integer.parseInt(sectionIdParam) : 0;

        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("currentUser");

        if (sectionId > 0) {
            SectionDao sectionDao = new SectionDao();
            FlashcardDao flashcardDao = new FlashcardDao();
            UserDAO userDao = new UserDAO();

            try {
                // Kiểm tra tài khoản Premium
                if (userDao.findByUserID(user.getUserID()).getRole() == 3) {
                    session.setAttribute("notPremium", true);
                    response.sendRedirect(request.getContextPath() + "/MySectionsController");
                    return;
                }

                // Kiểm tra quyền sở hữu Section
                if (!sectionDao.isAuthor(user.getUserID(), sectionId)) {
                    session.setAttribute("notPremium", true);
                    response.sendRedirect(request.getContextPath() + "/MySectionsController");
                    return;
                }

                // Xóa Section
                boolean deleted = sectionDao.deleteSection(sectionId);
                if (deleted) {
                    session.setAttribute("deleteSuccess", true);
                } else {
                    session.setAttribute("deleteMessage", "Xóa học phần thất bại.");
                }
               
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("deleteMessage", "Đã xảy ra lỗi trong quá trình xử lý.");
            }
        }

        response.sendRedirect(request.getContextPath() + "/MySectionsController");
    }

    /**
     * Hiển thị thông báo và chuyển hướng.
     */
    private void showAlertAndRedirect(HttpServletResponse response, String message, String redirectUrl) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            out.println("<script type='text/javascript'>");
            out.println("alert('" + message + "');");
            out.println("window.location.href='" + redirectUrl + "';");
            out.println("</script>");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
