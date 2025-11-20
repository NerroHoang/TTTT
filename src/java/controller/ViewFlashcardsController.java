/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.FlashcardDao;
import DAO.SectionDao;
import bean.FlashcardDetailBean;
import bean.SectionDetailBean;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;



@WebServlet(name = "ViewFlashcardsController", urlPatterns = {"/ViewFlashcardsController"})
public class ViewFlashcardsController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String sectionIdParam = request.getParameter("sectionId");
        int sectionId = (sectionIdParam != null && !sectionIdParam.isEmpty()) ? Integer.parseInt(sectionIdParam) : 0;

        if (sectionId > 0) {
            SectionDao sectionDao = new SectionDao();
            FlashcardDao flashcardDao = new FlashcardDao();

            // Lấy thông tin section và flashcards
            SectionDetailBean section = sectionDao.getSectionDetailById(sectionId);
            List<FlashcardDetailBean> flashcards = flashcardDao.getFlashcardsInforBySectionId(sectionId);

            // Đưa dữ liệu vào request để hiển thị trên JSP
            request.setAttribute("section", section);
            request.setAttribute("flashcards", flashcards);
        } else {
            request.setAttribute("message", "Học phần không hợp lệ hoặc không tồn tại.");
        }

        // Chuyển tiếp đến trang JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/page/view-flashcard.jsp");
        dispatcher.forward(request, response);
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
