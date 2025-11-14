/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import DAO.FlashcardDao;
import DAO.SectionDao;
import DAO.UserDAO;
import bean.FlashcardDetailBean;
import bean.SectionDetailBean;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Flashcard;
import model.Section;
import model.Users;

/**
 *
 * @author phuck
 */
@WebServlet(name = "CreateSectionController", urlPatterns = {"/CreateSectionController"})
public class CreateSectionController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy sectionId từ URL
        String sectionIdParam = request.getParameter("sectionId");
        int sectionId = (sectionIdParam != null) ? Integer.parseInt(sectionIdParam) : 0;

        SectionDetailBean section = new SectionDetailBean();
        List<FlashcardDetailBean> flashcards = new ArrayList<>();

        // Nếu sectionId > 0, lấy dữ liệu từ database
        if (sectionId > 0) {
            SectionDao sectionDao = new SectionDao();
            FlashcardDao flashcardDao = new FlashcardDao();

            section = sectionDao.getSectionDetailById(sectionId); // Lấy thông tin section
            flashcards = flashcardDao.getFlashcardsInforBySectionId(sectionId); // Lấy danh sách flashcards
        }

        // Đưa dữ liệu vào request để hiển thị trong JSP
        request.setAttribute("section", section);
        request.setAttribute("flashcards", flashcards);

        // Chuyển tiếp đến create_section.jsp
        RequestDispatcher dispatcher = request.getRequestDispatcher("/page/create-section.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String status = request.getParameter("status");

        String sectionIdParam = request.getParameter("sectionId");
        int sectionId = (sectionIdParam != null && !sectionIdParam.isEmpty()) ? Integer.parseInt(sectionIdParam) : 0;
        // Lấy danh sách flashcards từ request
        String[] terms = request.getParameterValues("term[]");
        String[] definitions = request.getParameterValues("definition[]");

        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("currentUser");

        UserDAO userDao = new UserDAO();
        SectionDao sectionDao = new SectionDao();
        FlashcardDao flashcardDao = new FlashcardDao();

        if (userDao.findByUserID(user.getUserID()).getRole() == 3) {
            request.setAttribute("noAccess", true);
            doGet(request, response); // Trả về trang create-section.jsp kèm cờ "noAccess"
            return;
        }

        try {
            Section section = new Section();
            section.setUserId(user.getUserID());
            section.setTitle(title);
            section.setDescription(description);
            section.setStatus(status);
            section.setCreatedAt(LocalDateTime.now());
            section.setUpdatedAt(LocalDateTime.now());

            boolean isUpdated = false;

            if (sectionId > 0) {
                // Kiểm tra Section có tồn tại và user có quyền cập nhật
                section.setSectionId(sectionId);
                isUpdated = sectionDao.updateSection(section);

                if (isUpdated) {
                    // Xóa Flashcards cũ trước khi thêm mới
                    flashcardDao.deleteFlashcardsBySectionId(sectionId);
                }
            } else {
                // Tạo mới Section
                section.setCreatedAt(LocalDateTime.now());
                sectionId = sectionDao.addSection(section);
                isUpdated = sectionId > 0;
            }

            // Xử lý Flashcards nếu Section được cập nhật/thêm thành công
            if (isUpdated) {

                if (terms != null && definitions != null) {
                    for (int i = 0; i < terms.length; i++) {
                        Flashcard flashcard = new Flashcard();
                        flashcard.setSectionId(sectionId);
                        flashcard.setQuestion(terms[i]);
                        flashcard.setAnswer(definitions[i]);
                        flashcard.setCreatedAt(LocalDateTime.now());
                        flashcard.setUpdatedAt(LocalDateTime.now());
                        flashcardDao.addFlashcard(flashcard);
                    }
                }
            }

            response.sendRedirect(request.getContextPath() + "/MySectionsController");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi hệ thống.");
            doGet(request, response);
        }
    }
}
