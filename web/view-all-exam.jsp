<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<html lang="vi">

<head>
    <meta charset="utf-8">
    <title>Quản lý bài kiểm tra - HCV Admin</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <link href="img/HCV.png" rel="icon">

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

        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0px 0 30px rgba(1, 41, 112, 0.1);
            margin-bottom: 30px;
        }

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
            color: #444;
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
            transition: all 0.3s;
        }
        
        .btn-action:hover {
            transform: translateY(-2px);
        }

        /* Pagination */
        .pagination .page-link {
            border: none;
            color: #012970;
            margin: 0 5px;
            border-radius: 5px;
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
                <span class="d-none d-lg-block text-primary fw-bold fs-4"><i class="fa fa-book me-2"></i>HCV Admin</span>
            </a>
            <i class="bi bi-list toggle-sidebar-btn d-block d-lg-none fs-3 text-primary" style="cursor: pointer; margin-left: 10px;"></i>
        </div>

        <nav class="header-nav ms-auto">
            <ul class="d-flex align-items-center m-0 p-0">
                <%
                    if(session.getAttribute("currentUser") != null){
                        Users user = (Users)session.getAttribute("currentUser");
                        TeacherRequest requests = new AdminDAO().getRequestByUserID(user.getUserID());
                        Subjects subject = new Subjects();
                        if(requests != null) subject = new ExamDAO().getSubjectByID(requests.getSubjectID());
                        String role;
                        if(user.getRole() == 1) role = "Admin";
                        else if(user.getRole() == 2) role = "User VIP";
                        else role = "User";
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
            <li class="nav-item"><a class="nav-link bg-primary text-white" href="view-all-exam.jsp"><i class="bi bi-journal-check"></i><span>Quản lí kiểm tra</span></a></li>
            <li class="nav-item"><a class="nav-link collapsed" href="view-all-question.jsp"><i class="bi bi-question-square"></i><span>Quản lí câu hỏi</span></a></li>
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
                <h1 class="fw-bold text-primary">Quản lý bài kiểm tra</h1>
                <nav>
                    <ol class="breadcrumb bg-transparent p-0 m-0">
                        <li class="breadcrumb-item"><a href="admin.jsp">Home</a></li>
                        <li class="breadcrumb-item active">Danh sách bài kiểm tra</li>
                    </ol>
                </nav>
            </div>
            <a href="choosesubject.jsp" class="btn btn-success shadow-sm">
                <i class="bi bi-plus-lg me-1"></i> Tạo đề kiểm tra
            </a>
        </div>

        <div class="card mb-4">
            <div class="card-body py-3">
                <form method="GET" action="view-all-exam.jsp" class="row g-3 align-items-end">
                    <div class="col-md-4">
                        <label class="form-label fw-bold text-secondary small">Tìm kiếm</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-search"></i></span>
                            <input type="text" name="search" class="form-control" placeholder="Nhập tên bài kiểm tra..." 
                                   value="<%= request.getParameter("search") != null && !request.getParameter("search").equals("null") ? request.getParameter("search") : "" %>">
                        </div>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label fw-bold text-secondary small">Môn học</label>
                        <div class="dropdown w-100">
                            <button class="btn btn-outline-secondary dropdown-toggle w-100 d-flex justify-content-between align-items-center" type="button" data-bs-toggle="dropdown">
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
                            <ul class="dropdown-menu w-100">
                                <li><a class="dropdown-item" href="?filter=all&search=<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>&status=<%= request.getParameter("status") != null ? request.getParameter("status") : "all" %>&pageSize=<%= request.getParameter("pageSize") != null ? request.getParameter("pageSize") : "10" %>">Tất cả môn học</a></li>
                                <%
                                List<Subjects> subjects = new ExamDAO().getAllSubject();
                                for (Subjects subject : subjects) {
                                %>
                                <li><a class="dropdown-item" href="?filter=<%= subject.getSubjectID() %>&search=<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>&status=<%= request.getParameter("status") != null ? request.getParameter("status") : "all" %>&pageSize=<%= request.getParameter("pageSize") != null ? request.getParameter("pageSize") : "10" %>"><%= subject.getSubjectName() %></a></li>
                                <% } %>
                            </ul>
                        </div>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label fw-bold text-secondary small">Trạng thái</label>
                        <div class="dropdown w-100">
                            <button class="btn btn-outline-secondary dropdown-toggle w-100 d-flex justify-content-between align-items-center" type="button" data-bs-toggle="dropdown">
                                <% 
                                    String status = request.getParameter("status");
                                    String displayStatus = "Tất cả";
                                    if ("approved".equals(status)) displayStatus = "Đã duyệt";
                                    else if ("notApproved".equals(status)) displayStatus = "Chưa duyệt";
                                %>
                                <%= displayStatus %>
                            </button>
                            <ul class="dropdown-menu w-100">
                                <li><a class="dropdown-item" href="?status=all&filter=<%= filter %>&search=<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>&pageSize=<%= request.getParameter("pageSize") != null ? request.getParameter("pageSize") : "10" %>">Tất cả</a></li>
                                <li><a class="dropdown-item" href="?status=approved&filter=<%= filter %>&search=<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>&pageSize=<%= request.getParameter("pageSize") != null ? request.getParameter("pageSize") : "10" %>">Đã duyệt</a></li>
                                <li><a class="dropdown-item" href="?status=notApproved&filter=<%= filter %>&search=<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>&pageSize=<%= request.getParameter("pageSize") != null ? request.getParameter("pageSize") : "10" %>">Chưa duyệt</a></li>
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
                        <input type="hidden" name="filter" value="<%= filter %>">
                        <input type="hidden" name="search" value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                        <input type="hidden" name="status" value="<%= request.getParameter("status") != null ? request.getParameter("status") : "all" %>">
                    </div>

                    <div class="col-md-1">
                        <button type="submit" class="btn btn-primary w-100"><i class="bi bi-funnel"></i></button>
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
                                <th style="width: 20%">Tên bài kiểm tra</th>
                                <th style="width: 10%">Môn học</th>
                                <th style="width: 8%">Số câu</th>
                                <th style="width: 10%">Giá tiền</th>
                                <th style="width: 10%">Thời gian</th>
                                <th style="width: 10%">Người tạo</th>
                                <th style="width: 10%">Trạng thái</th> 
                                <th style="width: 12%">Ngày đăng</th>
                                <th style="width: 10%">Tác vụ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                // --- JAVA LOGIC GIỮ NGUYÊN ---
                                List<Exam> exams = new ArrayList<>();
                                String search = request.getParameter("search");
                                if (search == null || search.equals("null")) search = "";

                                if (filter != null && !filter.equals("all")) {
                                    int subjectID = Integer.parseInt(filter);
                                    if (status != null) {
                                        if (status.equals("approved")) exams = new ExamDAO().searchExamsBySubjectStatusAndKeyword(subjectID, true, search);
                                        else if (status.equals("notApproved")) exams = new ExamDAO().searchExamsBySubjectStatusAndKeyword(subjectID, false, search);
                                        else exams = new ExamDAO().searchExamsBySubjectAndKeyword(subjectID, search);
                                    } else {
                                        exams = new ExamDAO().searchExamsBySubjectAndKeyword(subjectID, search);
                                    }
                                } else if (filter != null && filter.equals("all")) {
                                    if (status != null) {
                                        if (status.equals("approved")) exams = new ExamDAO().searchExamsByStatusAndKeyword(true, search);
                                        else if (status.equals("notApproved")) exams = new ExamDAO().searchExamsByStatusAndKeyword(false, search);
                                        else exams = new ExamDAO().searchExamsByKeyword(search);
                                    } else {
                                        exams = new ExamDAO().searchExamsByKeyword(search);
                                    }
                                } else {
                                    exams = new ExamDAO().searchExamsByKeyword(search);
                                }

                                // Paging logic
                                pageSizeParam = request.getParameter("pageSize");
                                if ("all".equals(pageSizeParam)) pageSize = exams.size() > 0 ? exams.size() : 1;
                                else pageSize = (pageSizeParam != null && !pageSizeParam.isEmpty()) ? Integer.parseInt(pageSizeParam) : 10;

                                int totalPages = (int) Math.ceil((double) exams.size() / pageSize);
                                String pageNumberParam = request.getParameter("pageNumber");
                                int pageNumber = (pageNumberParam != null && !pageNumberParam.isEmpty()) ? Integer.parseInt(pageNumberParam) : 1;
                                
                                int startIndex = exams.size() - (pageNumber * pageSize);
                                int endIndex = exams.size() - ((pageNumber - 1) * pageSize);
                                if (startIndex < 0) startIndex = 0;
                                if (endIndex > exams.size()) endIndex = exams.size();

                                List<Exam> examOnPage = new ArrayList<>();
                                if (exams.size() > 0 && startIndex < endIndex) {
                                    examOnPage = exams.subList(startIndex, endIndex);
                                }
                                
                                UserDAO userDao = new UserDAO();
                                Users creatorUser = new Users();
                                
                                for(int i = examOnPage.size() - 1; i >= 0; i--){
                                    Exam exam = examOnPage.get(i);
                                    String subjectName = new ExamDAO().getSubjectByID(exam.getSubjectID()).getSubjectName();
                                    int examAmount = new ExamDAO().getQuestionAmount(exam.getExamID());
                                    int hour = exam.getTimer() / 3600;
                                    int minute = (exam.getTimer() % 3600) / 60;
                                    creatorUser = userDao.findByUserID(exam.getUserID());
                                    
                                    String modalDeleteId = "deleteModal" + i;
                                    String modalApproveId = "approveModal" + i;
                            %>
                            <tr>
                                <td><span class="fw-bold text-primary"><%=exam.getExamName()%></span></td>
                                <td class="text-center"><span class="badge bg-light text-dark border"><%=subjectName%></span></td>
                                <td class="text-center fw-bold"><%=examAmount%></td>
                                <td class="text-center text-success fw-bold"><%=NumberFormat.getInstance().format(exam.getPrice())%> đ</td>
                                <td class="text-center"><%if(hour != 0){%><%=hour%>h<% } %><%if(minute != 0){%> <%=minute%>p<% } %></td>
                                <td class="text-center"><%=creatorUser.getUsername()%></td>
                                
                                <td class="text-center">
                                    <% if (exam.isIsAprroved()) { %>
                                        <span class="badge bg-success"><i class="bi bi-check-circle me-1"></i>Đã duyệt</span>
                                    <% } else { %>
                                        <span class="badge bg-warning text-dark"><i class="bi bi-clock me-1"></i>Chờ duyệt</span>
                                    <% } %>
                                </td>
                                
                                <td class="text-center"><small><%=exam.getCreateDate()%></small></td>
                                
                                <td class="text-center">
                                    <form action="PassDataExamUpdate" method="POST" class="d-inline">
                                        <input type="hidden" name="examID" value="<%=exam.getExamID()%>">
                                        <button type="submit" class="btn btn-primary btn-action" title="Chỉnh sửa">
                                            <i class="bi bi-pencil-square"></i>
                                        </button>
                                    </form>

                                    <button type="button" class="btn btn-danger btn-action" data-bs-toggle="modal" data-bs-target="#<%= modalDeleteId %>" title="Xóa">
                                        <i class="bi bi-trash"></i>
                                    </button>

                                    <% if (!exam.isIsAprroved()) { %>
                                        <button type="button" class="btn btn-success btn-action" data-bs-toggle="modal" data-bs-target="#<%= modalApproveId %>" title="Phê duyệt">
                                            <i class="bi bi-check-lg"></i>
                                        </button>
                                    <% } %>

                                    <div class="modal fade" id="<%= modalDeleteId %>" tabindex="-1" aria-hidden="true">
                                        <div class="modal-dialog modal-dialog-centered">
                                            <div class="modal-content">
                                                <form action="DeleteExam" method="POST">
                                                    <div class="modal-header bg-danger text-white">
                                                        <h5 class="modal-title"><i class="bi bi-exclamation-triangle-fill me-2"></i>Xác nhận xóa</h5>
                                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <div class="modal-body py-4">
                                                        <p class="mb-0 fs-5">Bạn có chắc chắn muốn xóa bài kiểm tra <strong><%=exam.getExamName()%></strong>?</p>
                                                        <input type="hidden" name="examID" value="<%=exam.getExamID()%>">
                                                    </div>
                                                    <div class="modal-footer justify-content-center">
                                                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                                                        <button type="submit" class="btn btn-danger">Xóa ngay</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>

                                    <% if (!exam.isIsAprroved()) { %>
                                    <div class="modal fade" id="<%= modalApproveId %>" tabindex="-1" aria-hidden="true">
                                        <div class="modal-dialog modal-dialog-centered">
                                            <div class="modal-content">
                                                <form action="ApproveExamController" method="POST">
                                                    <div class="modal-header bg-success text-white">
                                                        <h5 class="modal-title"><i class="bi bi-check-circle-fill me-2"></i>Xác nhận phê duyệt</h5>
                                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                                    </div>
                                                    <div class="modal-body py-4">
                                                        <p class="mb-0 fs-5">Cho phép hiển thị bài kiểm tra <strong><%=exam.getExamName()%></strong> lên hệ thống?</p>
                                                        <input type="hidden" name="examID" value="<%=exam.getExamID()%>">
                                                    </div>
                                                    <div class="modal-footer justify-content-center">
                                                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                                                        <button type="submit" class="btn btn-success">Phê duyệt</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                    <% } %>
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>

                    <% if (exams.isEmpty()) { %>
                        <div class="text-center py-5">
                            <i class="bi bi-journal-x text-muted" style="font-size: 3rem;"></i>
                            <p class="text-muted mt-2">Không tìm thấy bài kiểm tra nào.</p>
                        </div>
                    <% } %>
                </div>

                <% if (!exams.isEmpty()) { %>
                <nav aria-label="Page navigation" class="mt-4">
                    <ul class="pagination justify-content-center">
                        <li class="page-item <%= (pageNumber <= 1) ? "disabled" : "" %>">
                            <a class="page-link" href="?pageSize=<%= pageSize %>&pageNumber=1&filter=<%= filter %>&search=<%= search %>&status=<%= status %>"><i class="bi bi-chevron-double-left"></i></a>
                        </li>
                        <li class="page-item <%= (pageNumber <= 1) ? "disabled" : "" %>">
                            <a class="page-link" href="?pageSize=<%= pageSize %>&pageNumber=<%= pageNumber - 1 %>&filter=<%= filter %>&search=<%= search %>&status=<%= status %>"><i class="bi bi-chevron-left"></i></a>
                        </li>
                        <li class="page-item active">
                            <span class="page-link"><%= pageNumber %> / <%= totalPages %></span>
                        </li>
                        <li class="page-item <%= (pageNumber >= totalPages) ? "disabled" : "" %>">
                            <a class="page-link" href="?pageSize=<%= pageSize %>&pageNumber=<%= pageNumber + 1 %>&filter=<%= filter %>&search=<%= search %>&status=<%= status %>"><i class="bi bi-chevron-right"></i></a>
                        </li>
                         <li class="page-item <%= (pageNumber >= totalPages) ? "disabled" : "" %>">
                            <a class="page-link" href="?pageSize=<%= pageSize %>&pageNumber=<%= totalPages %>&filter=<%= filter %>&search=<%= search %>&status=<%= status %>"><i class="bi bi-chevron-double-right"></i></a>
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