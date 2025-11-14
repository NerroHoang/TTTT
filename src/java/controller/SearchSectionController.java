/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import bean.SectionInforBean;
import DAO.SectionDao;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Section;

/**
 *
 * @author phuck
 */
@WebServlet(name = "SearchSectionController", urlPatterns = {"/SearchSectionController"})
public class SearchSectionController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy dữ liệu từ thanh tìm kiếm
        String sectionName = request.getParameter("section_name");

        // Kiểm tra nếu không có giá trị hoặc giá trị trống
        if (sectionName == null || sectionName.trim().isEmpty()) {
            sectionName = ""; // Gán giá trị mặc định
        }
        SectionDao sectionDAO = new SectionDao();
        // Gọi DAO để tìm kiếm
        List<SectionInforBean> searchResults = sectionDAO.searchSectionsByName(sectionName);

        // Đặt kết quả tìm kiếm vào request attribute
        request.setAttribute("searchResults", searchResults);
        request.setAttribute("sectionName", sectionName);

        // Chuyển tiếp đến trang hiển thị kết quả
        request.getRequestDispatcher("/page/search_sections.jsp").forward(request, response);
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
