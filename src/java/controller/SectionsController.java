package controller;

import bean.SectionInforBean;
import DAO.SectionDao;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;

@WebServlet(name = "SectionsController", urlPatterns = {"/SectionsController"})
public class SectionsController extends HttpServlet {

    private final int limit = 6;
    private final SectionDao sectionDao = new SectionDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("currentUser");

        if (action.equals("get")) {
            // Reset offset về 0 khi tải danh sách mới
            if (user == null) {
                // Redirect về trang đăng nhập nếu user chưa đăng nhập
                response.sendRedirect("login.jsp");
                return;
            }

            int offset = 0; // Offset bắt đầu

            // Cập nhật session với giá trị offset ban đầu
            request.getSession().setAttribute("offset", String.valueOf(offset));

            // Lấy danh sách sections
            List<SectionInforBean> sections = sectionDao.getPublicSectionsExcludingUser(user.getUserID(), offset, limit);
            System.out.println(sections.size());
            
            // Làm sạch danh sách cũ trong session trước khi lưu mới
            request.getSession().removeAttribute("public_sections");
            request.getSession().setAttribute("public_sections", sections);

            // Kiểm tra nếu còn dữ liệu
            boolean hasMore = sections.size() == limit;

            // Gửi dữ liệu về JSP
            request.setAttribute("offset", offset + limit);
            request.setAttribute("hasMore", hasMore);

            request.getRequestDispatcher("/page/sections.jsp").forward(request, response);

        } else if (action.equals("more")) {
            // Tải thêm danh sách (phân trang)
            int offset = 0; // Offset mặc định

            // Lấy offset từ request
            String offsetParam = request.getParameter("offset");
            if (offsetParam != null) {
                try {
                    offset = Integer.parseInt(offsetParam);
                } catch (NumberFormatException e) {
                    offset = 0;
                }
            }

            // Lấy thêm danh sách mới
            List<SectionInforBean> newSections = sectionDao.getPublicSectionsExcludingUser(user.getUserID(), offset, limit);

            // Lấy danh sách cũ từ session
            List<SectionInforBean> allSections = (List<SectionInforBean>) request.getSession().getAttribute("public_sections");
            if (allSections == null) {
                allSections = new ArrayList<>();
            }

            // Kết hợp danh sách cũ và mới
            allSections.addAll(newSections);
            request.getSession().setAttribute("public_sections", allSections);

            // Kiểm tra nếu còn dữ liệu để hiển thị nút "Xem thêm"
            boolean hasMore = newSections.size() == limit;

            // Gửi dữ liệu về JSP
            request.setAttribute("offset", offset + limit); // Offset cho lần tải tiếp theo
            request.setAttribute("hasMore", hasMore); // Còn dữ liệu hay không

            request.getRequestDispatcher("/page/sections.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Xử lý POST nếu cần (hiện tại chưa sử dụng)
    }

    @Override
    public String getServletInfo() {
        return "SectionsController handles public sections and pagination";
    }
}
