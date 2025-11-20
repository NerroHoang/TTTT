/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package examController;

import DAO.QuestionBankDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.QuestionBank;


@WebServlet(name="QuestionList", urlPatterns={"/QuestionList"})
public class QuestionList extends HttpServlet {
   
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
        int page = 1;
        int pageSize = 30;
        
        // Lấy tham số trang và pageSize từ request
        String pageStr = request.getParameter("page");
        String pageSizeStr = request.getParameter("pageSize");
                
        if (pageStr != null) {
            page = Integer.parseInt(pageStr);
        }
        
        if (pageSizeStr != null) {
            pageSize = Integer.parseInt(pageSizeStr);
        }
        
        // Tính toán bắt đầu và kết thúc câu hỏi cho trang hiện tại
        int start = (page - 1)* pageSize;
        
        // Lấy danh sách câu hỏi từ cơ sở dữ liệu (bạn cần có phương thức để lấy câu hỏi)
        QuestionBankDAO questionBankDAO = new QuestionBankDAO();
        List<QuestionBank> questionLists = questionBankDAO.getQuestionsPageSize(start, pageSize);
        
        // Lấy tổng số câu hỏi trong cơ sở dữ liệu
        int totalQuetions = questionBankDAO.getTotalQuestions();
        
        // Tính toán số trang
        int totalPages = (int) Math.ceil((double) totalQuetions / pageSize);
        
        // Đặt các thuộc tính vào request để truyền vào JSP
        request.setAttribute("questionList", questionLists);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        
        // Chuyển hướng đến trang JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("view-all-question.jsp");
        dispatcher.forward(request, response);
    } 
    

    /** 
     * Handles the HTTP <code>POST</code> method.
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
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
