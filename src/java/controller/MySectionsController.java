package controller;

import DAO.SectionDao;
import bean.SectionInforBean;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.Users;

@WebServlet(name = "MySectionsController", urlPatterns = {"/MySectionsController"})
public class MySectionsController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        SectionDao sectionDAO = new SectionDao();

        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("currentUser");

        if (user == null) {
            // Redirect về trang đăng nhập nếu user chưa đăng nhập
            response.sendRedirect("login.jsp");
            return;
        }

        List<SectionInforBean> sections = sectionDAO.getAllSectionsOfUser(user.getUserID());
        System.out.println(sections);
        request.setAttribute("my_sections", sections);
        request.getRequestDispatcher("/page/my_sections.jsp").forward(request, response);
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
