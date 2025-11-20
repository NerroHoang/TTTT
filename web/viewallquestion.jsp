<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<jsp:include page="header.jsp"></jsp:include>
    
    <style>
        /* Các biến màu chủ đạo của THI247 */
        :root {
            --thi247-primary: #17a2b8; /* Xanh ngọc */
            --thi247-secondary: #007bff; /* Xanh dương */
            --thi247-light-blue: #e0f2f7; /* Nền xanh nhạt */
            --thi247-text-dark: #343a40;
            --thi247-danger: #dc3545;
            --thi247-success: #28a745;
        }
        
        /* 1. Màu nền đồng bộ */
        body {
            background-color: var(--thi247-light-blue) !important;
            padding-bottom: 50px;
        }

        /* 2. Cấu trúc chính */
        #main {
            max-width: 1300px;
            margin: 20px auto;
            padding: 30px;
            background: none;
            box-shadow: none;
        }
        .container-fluid.page-header {
            background-color: var(--thi247-primary) !important;
            border-radius: 0 0 15px 15px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 40px !important;
        }
        
        /* 3. Tiêu đề và Nút Tạo đề */
        h1, h3 {
            font-weight: 700;
        }
        a button.btn-primary {
            background-color: var(--thi247-secondary) !important;
            border-color: var(--thi247-secondary) !important;
            border-radius: 25px;
            padding: 8px 20px;
            font-weight: 600;
            margin-bottom: 20px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        
        /* 4. Khối bộ lọc */
        form.p-3 {
            border-radius: 8px !important;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
            padding: 15px 20px !important;
        }
        form label {
            font-weight: 600;
            color: var(--thi247-text-dark);
            margin-right: 15px;
        }
        
        /* Dropdown */
        .dropdown-content {
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            border: 1px solid #ddd;
            min-width: 150px;
        }
        .dropbtn {
            background-color: var(--thi247-secondary) !important;
            border-color: var(--thi247-secondary) !important;
            border-radius: 8px;
            padding: 10px 15px;
            font-weight: 600;
            margin-right: 10px;
            display: inline-flex;
            align-items: center;
            color: white !important;
        }
        
        /* 5. Bảng Dữ liệu */
        .table-container {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            padding: 20px;
        }
        .table {
            border-radius: 12px;
            overflow: hidden;
        }
        thead th {
            background-color: var(--thi247-primary) !important;
            color: white !important;
            font-weight: 700;
            padding: 12px;
            text-align: center !important;
            border: none;
        }
        tbody td {
            vertical-align: middle;
            color: var(--thi247-text-dark);
            text-align: center;
        }
        
        /* Nút Tác vụ trong bảng */
        .action-buttons-cell {
             display: flex;
             justify-content: center;
             gap: 5px;
        }
        .action-buttons-cell input[type="submit"], 
        .action-buttons-cell button {
            border-radius: 20px;
            padding: 5px 12px;
            font-size: 0.85em;
            font-weight: 600;
            min-width: 60px;
        }
        .btn-edit {
            background-color: var(--thi247-secondary) !important;
            border-color: var(--thi247-secondary) !important;
        }
        .btn-delete {
            background-color: var(--thi247-danger) !important;
            border-color: var(--thi247-danger) !important;
        }
        .btn-approved {
            background-color: var(--thi247-success) !important;
            border-color: var(--thi247-success) !important;
        }
        .status-approved-btn {
            background-color: var(--thi247-success) !important;
            border-color: var(--thi247-success) !important;
            color: white !important;
            cursor: default;
        }
        
        /* 6. Phân trang */
        .pagination .page-current {
            background-color: var(--thi247-secondary) !important;
            color: white !important;
            font-weight: 700;
            border-color: var(--thi247-secondary) !important;
        }

    </style>

    <script>
        var container = document.getElementById("tagID");
        var tag = container.getElementsByClassName("tag");
        var current = container.getElementsByClassName("active");
        current[0].className = current[0].className.replace(" active", "");
        tag[2].className += " active";
    </script>

<%
// ====================================================================
// KHAI BÁO TẤT CẢ BIẾN CẦN THIẾT (SỬA LỖI PHẠM VI BIẾN)
// ====================================================================

// Lấy thông tin người dùng hiện tại
Users currentUser = (Users)session.getAttribute("currentUser");

// Khởi tạo các biến cho logic filtering/paging
List<Exam> exams = new ArrayList<>();
String search = "";
String filter = request.getParameter("filter");
String status = request.getParameter("status");
String pageSizeParam = request.getParameter("pageSize");
int pageSize = 10;
int totalPages = 1;
int pageNumber = 1;
String pageNumberParam = request.getParameter("pageNumber");
UserDAO userDao = new UserDAO();
Users userCreator = new Users();

// Xử lý giá trị filter, search và status
if (filter == null) filter = "all";
if (status == null) status = "all";
if (request.getParameter("search") != null && !request.getParameter("search").equals("null")) {
    search = request.getParameter("search");
}

if(currentUser != null){

// Lấy danh sách bài kiểm tra dựa trên bộ lọc
if ("approved".equals(filter)) {
    exams = new ExamDAO().getAllExamIsApprovedByUserID(currentUser.getUserID());
} else if ("notApproved".equals(filter)) {
    exams = new ExamDAO().getAllExamNotApprovedByUserID(currentUser.getUserID());
} else {
    exams = new ExamDAO().getAllExamByUserID(currentUser.getUserID());
}

// Xử lý phân trang
if ("all".equals(pageSizeParam)) {
    pageSize = exams.size(); 
} else {
    try {
        pageSize = (pageSizeParam != null && !pageSizeParam.isEmpty()) ? Integer.parseInt(pageSizeParam) : 10;
    } catch (NumberFormatException e) {
        pageSize = 10;
    }
}

totalPages = (int) Math.ceil((double) exams.size() / pageSize);

try {
    pageNumber = (pageNumberParam != null && !pageNumberParam.isEmpty()) ? Integer.parseInt(pageNumberParam) : 1;
    if (pageNumber < 1) pageNumber = 1;
    if (totalPages > 0 && pageNumber > totalPages) pageNumber = totalPages;
} catch (NumberFormatException e) {
    pageNumber = 1;
}

// Tính toán chỉ số bắt đầu và kết thúc của câu hỏi trên trang hiện tại
int startIndex = exams.size() - (pageNumber * pageSize);
int endIndex = exams.size() - ((pageNumber - 1) * pageSize);

if (startIndex < 0) {
    startIndex = 0;
}

List<Exam> examOnPage = exams.subList(startIndex, endIndex);

// ====================================================================
%>
<div class="container-fluid bg-primary py-5 mb-5 page-header">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-10 text-center">
                <h1 class="display-3 text-white animated slideInDown">Bài kiểm tra</h1>
                <h3 class="text-white animated slideInDown">Dưới đây là danh sách những kiểm tra của bạn đã tạo</h3>
            </div>
        </div>
    </div>
</div>
<main id="main" class="main" style="margin-left: 0">
    <section class="section" style="margin: auto;justify-content: center">
        <form method="POST" action="ViewAllExamTeacher.jsp" class="p-3 border rounded bg-light">
            <div class="d-flex align-items-center mb-3">
                <label class="mr-2 fw-bold">Lọc bài kiểm tra: </label>
                
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="filter" id="all" value="all" 
                            <% if("all".equals(filter)) { %>checked<% } %>>
                    <label class="form-check-label" for="all">Tất cả</label>
                </div>
                
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="filter" id="approved" value="approved" 
                            <% if("approved".equals(filter)) { %>checked<% } %>>
                    <label class="form-check-label" for="approved">Đã duyệt</label>
                </div>
                
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="filter" id="notApproved" value="notApproved" 
                            <% if("notApproved".equals(filter)) { %>checked<% } %>>
                    <label class="form-check-label" for="notApproved">Chưa duyệt</label>
                </div>
                
                <button type="submit" class="btn btn-primary ml-3">Lọc</button>
            </div>
        </form>
        <div class="row">
            <div class="col-lg-12">

                <div class="table-container">
                    <div class="card-body p-4">
                        <%
                        if(exams.size() > 0){
                        %>
                        <div class="table-responsive">
                            <table class="table table-striped table-hover">
                                <thead>
                                    <tr>
                                        <th style="text-align: center">Bài kiểm tra</th>
                                        <th style="text-align: center">Môn học</th>
                                        <th style="text-align: center">Số câu hỏi</th>
                                        <th style="text-align: center">Giá tiền</th>
                                        <th style="text-align: center">Thời gian làm bài</th>
                                        <th style="text-align: center" data-type="date" data-format="YYYY/DD/MM">Ngày đăng</th>
                                        <th style="padding-left: 33px">Tác vụ</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                    for(int i = examOnPage.size() - 1; i >= 0; i--){
                                        Exam exam = examOnPage.get(i);
                                        String subjectName = new ExamDAO().getSubjectByID(exam.getSubjectID()).getSubjectName();
                                        int examAmount = new ExamDAO().getQuestionAmount(exam.getExamID());
                                        String modalId = "deleteModal" + exam.getExamID();
                                        String modalId1 = "approveModal" + exam.getExamID();
                                        int hour = exam.getTimer() / 3600;
                                        int minute = (exam.getTimer() % 3600) / 60;
                                        userCreator =  userDao.findByUserID(exam.getUserID());
                                    %>
                                    <tr>
                                        <td style="text-align: center"><p><%=exam.getExamName()%></p></td>
                                        <td style="text-align: center"><%=subjectName%></td>
                                        <td style="text-align: center"><%=examAmount%></td>
                                        <td style="text-align: center"><%=exam.getPrice()%></td>
                                        <td style="text-align: center"><%if(hour != 0){%><%=hour%>h<% } %><%if(minute != 0){%> <%=minute%>p<% } %></td>
                                        <td style="text-align: center"><%=exam.getCreateDate()%></td>
                                        <td class="action-buttons-cell">

                                            <form action="PassDataExamUpdate" method="POST" style="margin: 0;">
                                                <input type="hidden" name="examID" value="<%=exam.getExamID()%>">
                                                <input type="submit" class="btn btn-primary btn-edit" value="Sửa"/>
                                            </form>
                                            
                                            <button
                                                class="btn btn-delete btn-danger"
                                                type="button"
                                                data-toggle="modal"
                                                data-target="#<%= modalId %>" 
                                                >
                                                Xoá
                                            </button>
                                            
                                            <% if (!exam.isIsAprroved()) { %>
                                            <button
                                                class="btn btn-primary btn-approved"
                                                type="button"
                                                data-toggle="modal"
                                                data-target="#<%= modalId1 %>"
                                                >
                                                Duyệt
                                            </button>
                                            <% } else { %>
                                            <button
                                                class="btn btn-success status-approved-btn"
                                                type="button"
                                                disabled
                                                >
                                                Đã Duyệt
                                            </button>
                                            <% } %>

                                            <div class="modal fade" id="<%= modalId %>" tabindex="-1" role="dialog" aria-labelledby="deleteModalLabel" aria-hidden="true">
                                                <div class="modal-dialog modal-sm" role="document">
                                                    <div class="modal-content">
                                                        <form action="DeleteExam" method="POST">
                                                            <input type="hidden" name="examID" value="<%=exam.getExamID()%>">
                                                            <div class="modal-header bg-danger text-white">
                                                                <h6 class="modal-title mb-0">Xác nhận xóa?</h6>
                                                                <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                                                            </div>
                                                            <div class="modal-body text-center">
                                                                <p>Bạn có chắc chắn muốn xóa bài kiểm tra **<%=exam.getExamName()%>**?</p>
                                                                <div class="modal-footer justify-content-center" style="border-top: none;">
                                                                    <button type="button" class="btn btn-light" data-dismiss="modal" >Hủy</button>
                                                                    <input type="submit" class="btn btn-primary btn-delete" style="background-color: var(--thi247-danger);" value="Xoá bài kiểm tra"/>
                                                                </div>
                                                            </div> 
                                                        </form>
                                                    </div> 
                                                </div> 
                                            </div>
                                            
                                            <div class="modal fade" id="<%= modalId1 %>" tabindex="-1" role="dialog" aria-labelledby="approveModalLabel" aria-hidden="true">
                                                <div class="modal-dialog modal-sm" role="document">
                                                    <div class="modal-content">
                                                        <form action="ApproveExamController" method="POST">
                                                            <input type="hidden" name="examID" value="<%=exam.getExamID()%>">
                                                            <div class="modal-header bg-primary text-white">
                                                                <h6 class="modal-title mb-0">Xác nhận duyệt?</h6>
                                                                <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                                                            </div>
                                                            <div class="modal-body text-center">
                                                                <p>Bạn có chắc chắn muốn duyệt bài kiểm tra **<%=exam.getExamName()%>**?</p>
                                                                <div class="modal-footer justify-content-center" style="border-top: none;">
                                                                    <button type="button" class="btn btn-light" data-dismiss="modal" >Hủy</button>
                                                                    <input type="submit" class="btn btn-primary btn-approved" value="Duyệt bài kiểm tra"/>
                                                                </div>
                                                            </div>
                                                        </form>
                                                    </div> 
                                                </div> 
                                            </div>

                                        </td>
                                    </tr>

                                    <%
                                        }
                                    }
                                    else{
                                    %>
                                    <tr>
                                        <td colspan="7" class="text-center">
                                            <h3 class="text-center text-muted mt-3">Bạn chưa từng tạo một bài kiểm tra nào!</h3>
                                        </td>
                                    </tr>
                                    <%
                                    }
                                    %>
                                    </tbody>

                                </table>
                        </div>
                        
                        <div class="d-flex justify-content-center my-4">
                            <nav aria-label="Page navigation">
                                <ul class="pagination">
                                    <%  
                                        // Sử dụng biến đã khai báo ở trên
                                        if (pageNumber > 1) { 
                                    %>
                                    <li class="page-item">
                                        <a class="page-link" href="view-all-exam.jsp?pageSize=<%= pageSize %>&pageNumber=1&filter=<%= filter %>&search=<%= search %>&status=<%= status %>">Trang đầu tiên</a>
                                    </li>
                                    <% } else { %>
                                    <li class="page-item disabled">
                                        <span class="page-link" style="background-color: #f0f0f0; color: #333;">Trang đầu tiên</span>
                                    </li>
                                    <% } %>

                                    <%  
                                        if (pageNumber > 1) { 
                                    %>
                                    <li class="page-item">
                                        <a class="page-link" href="view-all-exam.jsp?pageSize=<%= pageSize %>&pageNumber=<%= pageNumber - 1 %>&filter=<%= filter %>&search=<%= search %>&status=<%= status %>"><i class="fas fa-chevron-left"></i></a>
                                    </li>
                                    <% } %>
                                    
                                    <li class="page-item disabled">
                                        <span class="page-link page-current"><%= pageNumber %></span>
                                    </li>
                                    
                                    <%  
                                        if (pageNumber < totalPages) { 
                                    %>
                                    <li class="page-item">
                                        <a class="page-link" href="view-all-exam.jsp?pageSize=<%= pageSize %>&pageNumber=<%= pageNumber + 1 %>&filter=<%= filter %>&search=<%= search %>&status=<%= status %>"><i class="fas fa-chevron-right"></i></a>
                                    </li>
                                    <% } %>

                                    <%  
                                        if (pageNumber < totalPages) { 
                                    %>
                                    <li class="page-item">
                                        <a class="page-link" href="view-all-exam.jsp?pageSize=<%= pageSize %>&pageNumber=<%= totalPages %>&filter=<%= filter %>&search=<%= search %>&status=<%= status %>">Trang cuối cùng</a>
                                    </li>
                                    <% } else { %>
                                    <li class="page-item disabled">
                                        <span class="page-link" style="background-color: #f0f0f0; color: #333;">Trang cuối cùng</span>
                                    </li>
                                    <% } %>
                                </ul>
                            </nav>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </section>

</main><script>
    /* When the user clicks on the button, 
    toggle between hiding and showing the dropdown content */
    function toggleDropdown(dropdownId) {
        // Đóng tất cả các dropdown trước
        var dropdowns = document.getElementsByClassName("dropdown-content");
        for (var i = 0; i < dropdowns.length; i++) {
            if (dropdowns[i].id !== dropdownId) {
                dropdowns[i].classList.remove("show");
            }
        }

        // Bật/tắt dropdown được chọn
        var dropdown = document.getElementById(dropdownId);
        dropdown.classList.toggle("show");
    }

    // Close the dropdown if the user clicks outside of it
    window.onclick = function (event) {
        if (!event.target.matches('.dropbtn')) {
            var dropdowns = document.getElementsByClassName("dropdown-content");
            for (var i = 0; i < dropdowns.length; i++) {
                dropdowns[i].classList.remove("show");
            }
        }
    };
</script>
<%
    }
%>
<jsp:include page="footer.jsp"></jsp:include>

<a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>