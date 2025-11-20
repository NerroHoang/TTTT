<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<html lang="vi">

<head>
    <meta charset="utf-8">
    <title>Ngân hàng câu hỏi - THI247 Admin</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <link href="img/THI247.png" rel="icon">

    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700&display=swap" rel="stylesheet">

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

    <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <link href="assets/css/admin-css.css" rel="stylesheet">

    <style>
        body {
            background-color: #f6f9ff;
            font-family: 'Nunito', sans-serif;
        }
        
        /* Card Styling */
        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0px 0 30px rgba(1, 41, 112, 0.1);
            margin-bottom: 30px;
        }
        
        .card-body {
            padding: 20px;
        }

        /* Table Styling */
        .table thead th {
            background-color: #f6f9ff;
            color: #012970;
            border-bottom: 2px solid #e0e5f2;
            font-weight: 600;
            text-align: center;
            white-space: nowrap;
        }
        
        .table td {
            vertical-align: middle;
        }

        /* Search & Filter Bar */
        .search-bar {
            background: #fff;
            border-radius: 5px;
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid #dee2e6;
        }

        /* Image Thumbnail in Table */
        .img-thumb-question {
            max-height: 50px;
            border-radius: 5px;
            border: 1px solid #dee2e6;
            padding: 2px;
        }

        /* Action Buttons */
        .btn-action {
            width: 35px;
            height: 35px;
            padding: 0;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            margin: 0 3px;
        }

        /* Pagination */
        .pagination .page-link {
            border: none;
            color: #012970;
            margin: 0 5px;
            border-radius: 5px;
        }
        .pagination .page-item.disabled .page-link {
            background-color: #f6f6f6;
        }
        .pagination .page-item.active .page-link {
            background-color: #4154f1;
            color: white;
        }
    </style>
</head>

<body>

    <header id="header" class="header fixed-top d-flex align-items-center bg-white shadow-sm" style="height: 60px; z-index: 997;">
        <div class="d-flex align-items-center justify-content-between">
            <a href="Home" class="logo d-flex align-items-center text-decoration-none px-4">
                <span class="d-none d-lg-block text-primary fw-bold fs-4"><i class="fa fa-book me-2"></i>THI247 Admin</span>
            </a>
            <i class="bi bi-list toggle-sidebar-btn d-block d-lg-none fs-3 text-primary" style="cursor: pointer; margin-left: 10px;"></i>
        </div>

        <nav class="header-nav ms-auto">
            <ul class="d-flex align-items-center m-0 p-0">
                <%
                    if(session.getAttribute("currentUser") != null){
                        Users user = (Users)session.getAttribute("currentUser");
                        // Logic role giữ nguyên
                        TeacherRequest requests = new AdminDAO().getRequestByUserID(user.getUserID());
                        Subjects subject = new Subjects();
                        if(requests != null) subject = new ExamDAO().getSubjectByID(requests.getSubjectID());
                        String role;
                        if(user.getRole() == 1) role = "Admin";
                        else if(user.getRole() == 2) role = "Giáo viên";
                        else role = "Học sinh";
                %>
                <li class="nav-item dropdown pe-3">
                    <a class="nav-link nav-profile d-flex align-items-center pe-0" href="#" data-bs-toggle="dropdown">
                        <img src="<%=user.getAvatarURL()%>" alt="Profile" class="rounded-circle" style="width: 36px; height: 36px; object-fit: cover;">
                        <span class="d-none d-md-block dropdown-toggle ps-2 text-dark"><%=user.getUsername()%></span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end dropdown-menu-arrow profile shadow">
                        <li class="dropdown-header text-center">
                            <h6><%=user.getUsername()%></h6>
                            <span><%=role%></span>
                        </li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item d-flex align-items-center" href="profile.jsp"><i class="bi bi-person"></i> <span>Thông tin</span></a></li>
                        <li><a class="dropdown-item d-flex align-items-center" href="logout"><i class="bi bi-box-arrow-right"></i> <span>Đăng xuất</span></a></li>
                    </ul>
                </li>
                <% } %>
            </ul>
        </nav>
    </header>

    <aside id="sidebar" class="sidebar bg-white" style="position: fixed; top: 60px; left: 0; bottom: 0; width: 300px; z-index: 996; padding: 20px; box-shadow: 0px 0px 20px rgba(1, 41, 112, 0.1); overflow-y: auto;">
        <ul class="sidebar-nav" id="sidebar-nav">
            <li class="nav-item"><a class="nav-link collapsed" href="admin.jsp"><i class="bi bi-grid"></i><span>Dashboard</span></a></li>
            <li class="nav-item"><a class="nav-link collapsed" href="view-all-user.jsp"><i class="bi bi-people"></i><span>Quản lý người dùng</span></a></li>
            <li class="nav-item"><a class="nav-link collapsed" href="view-all-payment.jsp"><i class="bi bi-cash-stack"></i><span>Giao dịch hệ thống</span></a></li>
            <li class="nav-item"><a class="nav-link collapsed" href="view-all-exam.jsp"><i class="bi bi-journal-check"></i><span>Quản lí kiểm tra</span></a></li>
            <li class="nav-item"><a class="nav-link bg-primary text-white" href="view-all-question.jsp"><i class="bi bi-question-square-fill"></i><span>Quản lí câu hỏi</span></a></li>
            <li class="nav-item"><a class="nav-link collapsed" href="notification.jsp"><i class="bi bi-bell"></i><span>Thông báo hệ thống</span></a></li>
             <li class="nav-item mt-4">
                <a class="nav-link collapsed rounded text-secondary" href="Home">
                    <i class="bi bi-arrow-left-circle"></i> <span>Về trang chủ</span>
                </a>
            </li>
        </ul>
    </aside>

    <main id="main" class="main" style="margin-top: 60px; margin-left: 300px; padding: 20px 30px; transition: all 0.3s;">
        
        <div class="pagetitle d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1 class="fw-bold text-primary">Ngân hàng câu hỏi</h1>
                <nav>
                    <ol class="breadcrumb bg-transparent p-0 m-0">
                        <li class="breadcrumb-item"><a href="admin.jsp">Home</a></li>
                        <li class="breadcrumb-item active">Tất cả câu hỏi</li>
                    </ol>
                </nav>
            </div>
            <a href="addquestionbank.jsp" class="btn btn-success shadow-sm">
                <i class="bi bi-plus-circle me-1"></i> Thêm câu hỏi mới
            </a>
        </div>

        <div class="card mb-4">
            <div class="card-body py-3">
                <form method="GET" action="view-all-question.jsp" class="row g-3 align-items-end">
                    
                    <div class="col-md-5">
                        <label class="form-label fw-bold text-secondary small">Tìm kiếm câu hỏi</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-search"></i></span>
                            <input type="text" name="search" class="form-control" placeholder="Nhập nội dung câu hỏi..." 
                                   value="<%= request.getParameter("search") != null && !request.getParameter("search").equals("null") ? request.getParameter("search") : "" %>">
                        </div>
                    </div>

                    <div class="col-md-3">
                         <label class="form-label fw-bold text-secondary small">Lọc theo môn học</label>
                         <div class="dropdown w-100">
                            <button class="btn btn-outline-primary dropdown-toggle w-100 d-flex justify-content-between align-items-center" type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" aria-expanded="false">
                                <%
                                    String filter = request.getParameter("filter");
                                    if (filter == null) filter = "all";
                                    String displayText = "Tất cả môn học";
                                    if (filter != null && !filter.equals("all")) {
                                        List<Subjects> subjectsList = new ExamDAO().getAllSubject();
                                        for (Subjects s : subjectsList) {
                                            if (String.valueOf(s.getSubjectID()).equals(filter)) {
                                                displayText = s.getSubjectName();
                                                break;
                                            }
                                        }
                                    }
                                %>
                                <%= displayText %>
                            </button>
                            <ul class="dropdown-menu w-100" aria-labelledby="dropdownMenuButton1">
                                <li><a class="dropdown-item" href="?filter=all&search=<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>&pageSize=<%= request.getParameter("pageSize") != null ? request.getParameter("pageSize") : "10" %>">Tất cả môn học</a></li>
                                <%
                                List<Subjects> subjects = new ExamDAO().getAllSubject();
                                for (Subjects subject : subjects) {
                                %>
                                <li><a class="dropdown-item" href="?filter=<%= subject.getSubjectID() %>&search=<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>&pageSize=<%= request.getParameter("pageSize") != null ? request.getParameter("pageSize") : "10" %>"><%= subject.getSubjectName() %></a></li>
                                <% } %>
                            </ul>
                        </div>
                    </div>

                    <div class="col-md-2">
                        <%
                            String pageSizeParam = request.getParameter("pageSize");
                            int pageSize = 10;
                            if (pageSizeParam != null && !pageSizeParam.isEmpty() && !pageSizeParam.equals("all")) {
                                try { pageSize = Integer.parseInt(pageSizeParam); } catch (NumberFormatException e) { pageSize = 10; }
                            }
                        %>
                        <label class="form-label fw-bold text-secondary small">Hiển thị</label>
                        <select name="pageSize" class="form-select" onchange="this.form.submit()">
                            <option value="10" <%= pageSize == 10 ? "selected" : "" %>>10 dòng</option>
                            <option value="20" <%= pageSize == 20 ? "selected" : "" %>>20 dòng</option>
                            <option value="30" <%= pageSize == 30 ? "selected" : "" %>>30 dòng</option>
                            <option value="50" <%= pageSize == 50 ? "selected" : "" %>>50 dòng</option>
                            <option value="all" <%= "all".equals(pageSizeParam) ? "selected" : "" %>>Tất cả</option>
                        </select>
                         <input type="hidden" name="filter" value="<%= request.getParameter("filter") != null ? request.getParameter("filter") : "all" %>">
                    </div>

                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary w-100"><i class="bi bi-funnel"></i> Lọc</button>
                    </div>
                </form>
            </div>
        </div>

        <div class="card">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover table-bordered align-middle mt-3">
                        <thead class="table-light">
                            <tr>
                                <th scope="col" style="width: 45%;">Nội dung câu hỏi</th>
                                <th scope="col" style="width: 15%;">Môn học</th>
                                <th scope="col" style="width: 25%;">Đáp án đúng</th>
                                <th scope="col" style="width: 15%;">Tác vụ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                // --- LOGIC JAVA XỬ LÝ DỮ LIỆU ---
                                List<QuestionBank> qbs = new ExamDAO().getAllSystemQuestion();
                                // (Logic tìm kiếm và filter y hệt code gốc)
                                String search = request.getParameter("search");
                                if ("null".equals(search)) search = "";
                                
                                if (filter == null || filter.equals("all")) {
                                    qbs = new ExamDAO().getAllSystemQuestion();
                                } else {
                                    int subjectID = Integer.parseInt(filter);
                                    qbs = new ExamDAO().getAllSystemQuestionByID(subjectID);
                                }

                                if (search != null && !search.isEmpty()) {
                                    if (filter != null && !filter.equals("all")) {
                                        int subjectId = Integer.parseInt(filter);
                                        qbs = new ExamDAO().searchQuestionByNameAndSubjectID(search, subjectId);
                                    } else {
                                        qbs = new ExamDAO().searchQuestionByName(search);
                                    }
                                }

                                // Paging Logic
                                pageSizeParam = request.getParameter("pageSize");
                                if ("all".equals(pageSizeParam)) pageSize = qbs.size() > 0 ? qbs.size() : 1;
                                else pageSize = (pageSizeParam != null && !pageSizeParam.isEmpty()) ? Integer.parseInt(pageSizeParam) : 10;

                                int totalPages = (int) Math.ceil((double) qbs.size() / pageSize);
                                String pageNumberParam = request.getParameter("pageNumber");
                                int pageNumber = (pageNumberParam != null && !pageNumberParam.isEmpty()) ? Integer.parseInt(pageNumberParam) : 1;

                                int startIndex = qbs.size() - (pageNumber * pageSize);
                                int endIndex = qbs.size() - ((pageNumber - 1) * pageSize);
                                if (startIndex < 0) startIndex = 0;
                                if (endIndex > qbs.size()) endIndex = qbs.size(); // Safe check

                                List<QuestionBank> questionsOnPage = new ArrayList<>();
                                if (qbs.size() > 0 && startIndex < endIndex) {
                                     questionsOnPage = qbs.subList(startIndex, endIndex);
                                }
                                
                                // Rendering Loop
                                String context;
                                String answer;
                                for(int i = questionsOnPage.size() - 1; i >= 0; i--){
                                    QuestionBank qb = questionsOnPage.get(i);
                                    Subjects subjectObj = new ExamDAO().getSubjectByID(qb.getSubjectId());
                                    
                                    // Xử lý text ngắn gọn
                                    if(qb.getQuestionContext().length() > 60) context = qb.getQuestionContext().substring(0, 60) + "...";
                                    else if(qb.getQuestionContext().length() == 0) context = qb.getQuestionImg();
                                    else context = qb.getQuestionContext();

                                    if(qb.getChoiceCorrect().startsWith("uploads/docreader")) answer = qb.getChoiceCorrect();
                                    else {
                                        if(qb.getChoiceCorrect().length() > 40) answer = qb.getChoiceCorrect().substring(0, 40) + "...";
                                        else answer = qb.getChoiceCorrect();
                                    }
                                    
                                    String modalDetailId = "detailModal" + i;
                                    String modalDeleteId = "deleteModal" + i;
                            %>
                            <tr>
                                <td>
                                    <% if(context.startsWith("uploads/docreader")){ %>
                                        <img src="<%=context%>" class="img-thumb-question" alt="Question Image"/>
                                    <% } else { %>
                                        <span class="fw-bold text-dark"><%=context%></span>
                                    <% } %>
                                </td>
                                
                                <td class="text-center"><span class="badge bg-light text-dark border"><%=subjectObj.getSubjectName()%></span></td>
                                
                                <td>
                                    <% if(answer.startsWith("uploads/docreader")){ %>
                                        <img src="<%=answer%>" class="img-thumb-question" alt="Answer Image"/>
                                    <% } else { %>
                                        <span class="text-success fw-bold"><%=answer%></span>
                                    <% } %>
                                </td>
                                
                                <td class="text-center">
                                    <button type="button" class="btn btn-primary btn-action" data-bs-toggle="modal" data-bs-target="#<%= modalDetailId %>" title="Xem chi tiết">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                    <button type="button" class="btn btn-danger btn-action" data-bs-toggle="modal" data-bs-target="#<%= modalDeleteId %>" title="Xóa">
                                        <i class="bi bi-trash"></i>
                                    </button>

                                    <div class="modal fade" id="<%=modalDetailId%>" tabindex="-1" aria-hidden="true">
                                        <div class="modal-dialog modal-lg modal-dialog-scrollable">
                                            <div class="modal-content">
                                                <div class="modal-header bg-primary text-white">
                                                    <h5 class="modal-title"><i class="bi bi-info-circle me-2"></i>Chi tiết câu hỏi</h5>
                                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                                </div>
                                                <div class="modal-body text-start p-4">
                                                    <h6 class="fw-bold text-primary">Câu hỏi:</h6>
                                                    <p class="mb-2"><%=qb.getQuestionContext()%></p>
                                                    <% if(qb.getQuestionImg() != null){ %>
                                                        <div class="mb-3"><img src="<%=qb.getQuestionImg()%>" class="img-fluid rounded border" style="max-height: 200px;"></div>
                                                    <% } %>
                                                    
                                                    <hr>
                                                    <h6 class="fw-bold text-primary">Các lựa chọn:</h6>
                                                    <div class="row g-2">
                                                        <div class="col-md-6">
                                                            <div class="p-2 border rounded bg-light">
                                                                <span class="fw-bold text-secondary">A.</span> 
                                                                <% if(qb.getChoice1().startsWith("uploads")){ %> <img src="<%=qb.getChoice1()%>" height="30"> <% } else { %> <%=qb.getChoice1()%> <% } %>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="p-2 border rounded bg-light">
                                                                <span class="fw-bold text-secondary">B.</span> 
                                                                <% if(qb.getChoice2().startsWith("uploads")){ %> <img src="<%=qb.getChoice2()%>" height="30"> <% } else { %> <%=qb.getChoice2()%> <% } %>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="p-2 border rounded bg-light">
                                                                <span class="fw-bold text-secondary">C.</span> 
                                                                <% if(qb.getChoice3().startsWith("uploads")){ %> <img src="<%=qb.getChoice3()%>" height="30"> <% } else { %> <%=qb.getChoice3()%> <% } %>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6">
                                                            <div class="p-2 border rounded bg-light">
                                                                <span class="fw-bold text-secondary">D.</span> 
                                                                <% if(qb.getChoiceCorrect().startsWith("uploads")){ %> <img src="<%=qb.getChoiceCorrect()%>" height="30"> <% } else { %> <%=qb.getChoiceCorrect()%> <% } %>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="alert alert-success mt-3 mb-0">
                                                        <strong><i class="bi bi-check-circle-fill"></i> Đáp án đúng:</strong> 
                                                        <% if(qb.getChoiceCorrect().startsWith("uploads")){ %> <img src="<%=qb.getChoiceCorrect()%>" height="30"> <% } else { %> <%=qb.getChoiceCorrect()%> <% } %>
                                                        <br>
                                                        <strong>Giải thích:</strong> <%=qb.getExplain()%>
                                                        <% if(qb.getExplainImg() != null){ %> <br><img src="<%=qb.getExplainImg()%>" height="100" class="mt-2 rounded"> <% } %>
                                                    </div>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="modal fade" id="<%= modalDeleteId %>" tabindex="-1" aria-hidden="true">
                                        <div class="modal-dialog modal-dialog-centered">
                                            <div class="modal-content">
                                                <form action="DeleteQuestionInBank" method="POST">
                                                    <div class="modal-header bg-danger text-white">
                                                        <h5 class="modal-title"><i class="bi bi-exclamation-triangle-fill me-2"></i>Xác nhận xóa</h5>
                                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                                    </div>
                                                    <div class="modal-body text-center py-4">
                                                        <p class="mb-0 fs-5">Bạn có chắc chắn muốn xóa câu hỏi này không?</p>
                                                        <small class="text-muted">Hành động này không thể hoàn tác.</small>
                                                        <input type="hidden" name="questionID" value="<%=qb.getQuestionId()%>">
                                                        <input type="hidden" name="subjectID" value="<%=subjectObj.getSubjectID()%>">
                                                    </div>
                                                    <div class="modal-footer justify-content-center">
                                                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy bỏ</button>
                                                        <button type="submit" class="btn btn-danger">Xóa ngay</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>

                    <% if (qbs.isEmpty()) { %>
                        <div class="text-center py-5">
                            <i class="bi bi-inbox text-muted" style="font-size: 3rem;"></i>
                            <p class="text-muted mt-2">Không tìm thấy dữ liệu câu hỏi nào.</p>
                        </div>
                    <% } %>
                </div>

                <% if (!qbs.isEmpty()) { %>
                <nav aria-label="Page navigation" class="mt-4">
                    <ul class="pagination justify-content-center">
                        <li class="page-item <%= (pageNumber <= 1) ? "disabled" : "" %>">
                            <a class="page-link" href="?pageSize=<%= pageSize %>&pageNumber=1&filter=<%= filter %>&search=<%= search %>">
                                <i class="bi bi-chevron-double-left"></i>
                            </a>
                        </li>
                        <li class="page-item <%= (pageNumber <= 1) ? "disabled" : "" %>">
                            <a class="page-link" href="?pageSize=<%= pageSize %>&pageNumber=<%= pageNumber - 1 %>&filter=<%= filter %>&search=<%= search %>">
                                <i class="bi bi-chevron-left"></i>
                            </a>
                        </li>
                        
                        <li class="page-item active">
                            <span class="page-link"><%= pageNumber %> / <%= totalPages %></span>
                        </li>

                        <li class="page-item <%= (pageNumber >= totalPages) ? "disabled" : "" %>">
                            <a class="page-link" href="?pageSize=<%= pageSize %>&pageNumber=<%= pageNumber + 1 %>&filter=<%= filter %>&search=<%= search %>">
                                <i class="bi bi-chevron-right"></i>
                            </a>
                        </li>
                         <li class="page-item <%= (pageNumber >= totalPages) ? "disabled" : "" %>">
                            <a class="page-link" href="?pageSize=<%= pageSize %>&pageNumber=<%= totalPages %>&filter=<%= filter %>&search=<%= search %>">
                                <i class="bi bi-chevron-double-right"></i>
                            </a>
                        </li>
                    </ul>
                </nav>
                <% } %>

            </div>
        </div>

    </main>

    <a href="#" class="back-to-top d-flex align-items-center justify-content-center bg-primary text-white rounded-circle" style="position: fixed; width: 40px; height: 40px; bottom: 15px; right: 15px; z-index: 99999;">
        <i class="bi bi-arrow-up-short fs-4"></i>
    </a>

    <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="assets/vendor/apexcharts/apexcharts.min.js"></script>
    <script src="assets/vendor/chart.js/chart.umd.js"></script>
    <script src="assets/vendor/echarts/echarts.min.js"></script>
    <script src="assets/vendor/quill/quill.js"></script>
    <script src="assets/vendor/simple-datatables/simple-datatables.js"></script>
    <script src="assets/vendor/tinymce/tinymce.min.js"></script>
    <script src="assets/vendor/php-email-form/validate.js"></script>

    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const toggleBtn = document.querySelector('.toggle-sidebar-btn');
            if(toggleBtn) {
                toggleBtn.addEventListener('click', () => {
                    document.body.classList.toggle('toggle-sidebar');
                    const main = document.querySelector('#main');
                    const sidebar = document.querySelector('#sidebar');
                    
                    if(document.body.classList.contains('toggle-sidebar')){
                        sidebar.style.left = '-300px';
                        main.style.marginLeft = '0';
                    } else {
                        sidebar.style.left = '0';
                         if(window.innerWidth >= 1200) {
                             main.style.marginLeft = '300px';
                         }
                    }
                });
            }
        });
    </script>
</body>
</html>