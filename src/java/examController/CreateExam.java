package examController;

import DAO.ExamDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;

@WebServlet(name = "CreateExam", urlPatterns = {"/CreateExam"})
public class CreateExam extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 1. Xử lý Tiếng Việt
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("currentUser");

        // 2. Kiểm tra đăng nhập
        if (user == null) {
            response.sendRedirect("login.jsp"); // Hoặc trang login của bạn
            return;
        }

        try {
            // 3. Lấy subjectID an toàn (Ưu tiên lấy từ Session vì form có thể không gửi)
            int subjectID = 0;
            if (session.getAttribute("subjectID") != null) {
                subjectID = (Integer) session.getAttribute("subjectID");
            } else if (request.getParameter("subjectID") != null) {
                // Dự phòng nếu có gửi kèm param
                subjectID = Integer.parseInt(request.getParameter("subjectID"));
            }

            // Nếu không có subjectID thì không thể tạo bài thi -> quay về
            if (subjectID == 0) {
                response.sendRedirect("choosesubject.jsp");
                return;
            }

            // 4. Lấy dữ liệu an toàn (Tránh lỗi NumberFormatException)
            String examName = request.getParameter("examName");
            
            String hoursStr = request.getParameter("examHours");
            int examHours = (hoursStr != null && !hoursStr.isEmpty()) ? Integer.parseInt(hoursStr) : 0;

            String minutesStr = request.getParameter("examMinutes");
            int examMinutes = (minutesStr != null && !minutesStr.isEmpty()) ? Integer.parseInt(minutesStr) : 0;

            String priceStr = request.getParameter("price");
            int price = (priceStr != null && !priceStr.isEmpty()) ? Integer.parseInt(priceStr) : 0;

            // 5. Lấy danh sách câu hỏi đã chọn
            String[] QuestionIDs = request.getParameterValues("selectedQuestions");

            // Validation: Kiểm tra có chọn câu hỏi không
            if (QuestionIDs == null || QuestionIDs.length == 0) {
                request.setAttribute("error", "Vui lòng chọn ít nhất một câu hỏi!");
                request.getRequestDispatcher("create-exam.jsp").forward(request, response);
                return; // Dừng xử lý
            }

            // 6. Tính tổng thời gian (giây)
            int examTime = (examHours * 3600) + (examMinutes * 60);
            
            // Kiểm tra thời gian hợp lệ (ít nhất 1 phút)
            if (examTime <= 0) {
                request.setAttribute("error", "Thời gian làm bài phải lớn hơn 0!");
                request.getRequestDispatcher("create-exam.jsp").forward(request, response);
                return;
            }

            // 7. Lưu vào Database
            ExamDAO dao = new ExamDAO();
            
            // Lưu thông tin bài thi (Exam Header)
            // User ID: Nếu là Admin (role=1) thì set cứng là 1, nếu là Teacher thì lấy ID của teacher
            int creatorID = (user.getRole() == 1) ? 1 : user.getUserID();
            dao.addExam(examName, creatorID, subjectID, examTime, price);

            // Lấy ID bài thi vừa tạo
            int examID = dao.getLastestExam().getExamID();

            // Lưu chi tiết câu hỏi vào bài thi (Exam Details)
            for (String qID : QuestionIDs) {
                dao.addQuestionToExam(Integer.parseInt(qID), examID);
            }

            // 8. Điều hướng sau khi thành công
            if (user.getRole() == 1) {
                response.sendRedirect("view-all-exam.jsp");
            } else {
                response.sendRedirect("ViewAllExamTeacher.jsp"); // Hoặc trang quản lý của GV
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Đã xảy ra lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("create-exam.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Create Exam Servlet";
    }
}