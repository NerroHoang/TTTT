<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
<%@ page import="java.util.stream.Collectors" %>
<html lang="vi">

<head>
    <meta charset="utf-8">
    <title>Dashboard - THI247 Admin</title>
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

        /* Dashboard Cards */
        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0px 0 30px rgba(1, 41, 112, 0.1);
            margin-bottom: 30px;
            transition: all 0.3s;
        }
        
        .card:hover {
            transform: translateY(-5px);
        }

        .card-title {
            padding: 20px 0 15px 0;
            font-size: 18px;
            font-weight: 500;
            color: #012970;
            font-family: "Poppins", sans-serif;
        }

        .card-title span {
            color: #899bbd;
            font-size: 14px;
            font-weight: 400;
        }

        .dashboard .info-card h6 {
            font-size: 28px;
            color: #012970;
            font-weight: 700;
            margin: 0;
            padding: 0;
        }

        .card-icon {
            font-size: 32px;
            line-height: 0;
            width: 64px;
            height: 64px;
            flex-shrink: 0;
            flex-grow: 0;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* Colors for cards */
        .sales-card .card-icon {
            color: #4154f1;
            background: #f6f6fe;
        }
        .revenue-card .card-icon {
            color: #2eca6a;
            background: #e0f8e9;
        }
        .customers-card .card-icon {
            color: #ff771d;
            background: #ffecdf;
        }

        /* Table Styles */
        .table thead th {
            background-color: #f6f9ff;
            color: #444;
            border-bottom: 2px solid #e0e5f2;
        }
        .table td {
            vertical-align: middle;
        }
        
        /* Modal Styles */
        .modal-header {
            background-color: #4154f1;
            color: white;
        }
        .modal-title {
            font-weight: 600;
        }
        .report-reason-list {
            list-style: none;
            padding-left: 0;
        }
        .report-reason-list li {
            padding: 5px 0;
            border-bottom: 1px dashed #eee;
        }
        .report-reason-list li:last-child {
            border-bottom: none;
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
                <li class="nav-item dropdown">
                    <a class="nav-link nav-icon" href="#" data-bs-toggle="dropdown">
                        <i class="bi bi-bell"></i>
                        <span class="badge bg-primary badge-number">3</span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end dropdown-menu-arrow notifications">
                        <li class="dropdown-header">
                            Bạn có thông báo mới
                            <a href="ListAllNotification.jsp"><span class="badge rounded-pill bg-primary p-2 ms-2">Xem tất cả</span></a>
                        </li>
                        <li><hr class="dropdown-divider"></li>
                        <%
                            List<Notification> notis = new NotificationDAO().getTop3Notifications();
                            for(Notification noti : notis){
                        %>
                        <li class="notification-item">
                            <i class="bi bi-info-circle text-primary"></i>
                            <div>
                                <p><%=noti.getNotiName()%></p>
                            </div>
                        </li>
                        <li><hr class="dropdown-divider"></li>
                        <% } %>
                    </ul>
                </li>

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
            <li class="nav-item"><a class="nav-link bg-primary text-white" href="admin.jsp"><i class="bi bi-grid-fill"></i><span>Dashboard</span></a></li>
            <li class="nav-item"><a class="nav-link collapsed" href="view-all-user.jsp"><i class="bi bi-people"></i><span>Quản lý người dùng</span></a></li>
            <li class="nav-item"><a class="nav-link collapsed" href="view-all-payment.jsp"><i class="bi bi-cash-stack"></i><span>Giao dịch hệ thống</span></a></li>
            <li class="nav-item"><a class="nav-link collapsed" href="view-all-exam.jsp"><i class="bi bi-journal-check"></i><span>Quản lí kiểm tra</span></a></li>
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

        <div class="pagetitle mb-4">
            <h1 class="fw-bold text-primary">Tổng quan hệ thống</h1>
            <nav>
                <ol class="breadcrumb bg-transparent p-0 m-0">
                    <li class="breadcrumb-item"><a href="Home">Home</a></li>
                    <li class="breadcrumb-item active">Dashboard</li>
                </ol>
            </nav>
        </div>

        <%
            List<Users> users = new UserDAO().getAllUsers();
            List<Users> teachers = new UserDAO().getAllUsersType(2);
            List<Users> students = new UserDAO().getAllUsersType(3);
        %>

        <section class="section dashboard">
            <div class="row">

                <div class="col-xxl-4 col-md-4">
                    <div class="card info-card sales-card">
                        <div class="card-body">
                            <h5 class="card-title">Tổng Người Dùng <span>| All</span></h5>
                            <div class="d-flex align-items-center">
                                <div class="card-icon rounded-circle d-flex align-items-center justify-content-center">
                                    <i class="bi bi-people"></i>
                                </div>
                                <div class="ps-3">
                                    <h6><%=users.size()%></h6>
                                    <span class="text-success small pt-1 fw-bold">12%</span> <span class="text-muted small pt-2 ps-1">tăng</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xxl-4 col-md-4">
                    <div class="card info-card revenue-card">
                        <div class="card-body">
                            <h5 class="card-title">Học Sinh <span>| Users</span></h5>
                            <div class="d-flex align-items-center">
                                <div class="card-icon rounded-circle d-flex align-items-center justify-content-center">
                                    <i class="bi bi-emoji-smile"></i>
                                </div>
                                <div class="ps-3">
                                    <h6><%=students.size()%></h6>
                                    <span class="text-success small pt-1 fw-bold">8%</span> <span class="text-muted small pt-2 ps-1">tăng</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-xxl-4 col-md-4">
                    <div class="card info-card customers-card">
                        <div class="card-body">
                            <h5 class="card-title">Giáo Viên/VIP <span>| Teachers</span></h5>
                            <div class="d-flex align-items-center">
                                <div class="card-icon rounded-circle d-flex align-items-center justify-content-center">
                                    <i class="bi bi-person-badge"></i>
                                </div>
                                <div class="ps-3">
                                    <h6><%=teachers.size()%></h6>
                                    <span class="text-danger small pt-1 fw-bold">1%</span> <span class="text-muted small pt-2 ps-1">giảm</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-12">
                    <div class="card recent-sales overflow-auto">
                        <div class="card-body">
                            <h5 class="card-title">Danh sách tố cáo vi phạm <span>| Mới nhất</span></h5>

                            <table class="table table-hover datatable align-middle">
                                <thead>
                                    <tr>
                                        <th scope="col">Người tố cáo</th>
                                        <th scope="col">Người bị tố cáo</th>
                                        <th scope="col">Ngày tố cáo</th>
                                        <th scope="col" class="text-center">Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                    List<Report> reports = new ReportDAO().getAllReports();
                                    if (reports.isEmpty()) {
                                    %>
                                        <tr><td colspan="4" class="text-center text-muted py-4">Không có tố cáo nào cần xử lý.</td></tr>
                                    <% } else { 
                                        for(int i = reports.size() - 1; i >= 0; i--){
                                            Report report = reports.get(i);
                                            Users reportedUser = new UserDAO().findByUserID(report.getUserId()); // Người bị tố cáo
                                            Users userReport = new UserDAO().findByUserID(report.getUserReportedId()); // Người đi tố cáo
                                            String modalDetailId = "reportModal" + i;
                                    %>
                                    <tr>
                                        <td>
                                            <a href="UserProfile?userID=<%=report.getUserReportedId()%>" class="fw-bold text-dark">
                                                <%=userReport.getUsername()%>
                                            </a>
                                        </td>
                                        <td>
                                            <a href="UserProfile?userID=<%=report.getUserId()%>" class="text-primary">
                                                <%=reportedUser.getUsername()%>
                                            </a>
                                        </td>
                                        <td><span class="badge bg-light text-dark border"><%=report.getReportDate()%></span></td>
                                        <td class="text-center">
                                            <button type="button" class="btn btn-sm btn-primary rounded-pill px-3" data-bs-toggle="modal" data-bs-target="#<%=modalDetailId%>">
                                                <i class="bi bi-eye-fill me-1"></i> Xem chi tiết
                                            </button>

                                            <div class="modal fade" id="<%=modalDetailId%>" tabindex="-1" aria-hidden="true">
                                                <div class="modal-dialog modal-dialog-centered modal-lg">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title"><i class="bi bi-exclamation-octagon-fill me-2"></i>Chi tiết tố cáo</h5>
                                                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div class="modal-body text-start p-4">
                                                            <div class="row mb-3">
                                                                <div class="col-md-6">
                                                                    <strong>Người tố cáo:</strong> <%=userReport.getUsername()%>
                                                                </div>
                                                                <div class="col-md-6">
                                                                    <strong>Đối tượng:</strong> <%=reportedUser.getUsername()%>
                                                                </div>
                                                            </div>
                                                            
                                                            <h6 class="fw-bold text-secondary mt-3">Lý do vi phạm:</h6>
                                                            <ul class="report-reason-list">
                                                                <%
                                                                boolean checkOtherReason = false;
                                                                for(ReportReason reason: report.getReasons()){
                                                                    if (reason.getReasonId() == 7){
                                                                        checkOtherReason = true;
                                                                        continue;
                                                                    }
                                                                %>
                                                                <li><i class="bi bi-check2-square text-danger me-2"></i> <%=reason.getReasonName()%></li>
                                                                <% } %>
                                                                
                                                                <% if(checkOtherReason){ %>
                                                                <li>
                                                                    <i class="bi bi-pencil-square text-warning me-2"></i> 
                                                                    <strong>Lý do khác:</strong> <span class="fst-italic"><%=report.getReportContext()%></span>
                                                                </li>
                                                                <% } %>
                                                            </ul>

                                                            <% if(report.getReportImg() != null && !report.getReportImg().isEmpty()){ %>
                                                            <div class="mt-4">
                                                                <h6 class="fw-bold text-secondary">Bằng chứng hình ảnh:</h6>
                                                                <img src="<%=report.getReportImg()%>" class="img-fluid rounded border shadow-sm" style="max-height: 300px;" alt="Evidence Image"/>
                                                            </div>
                                                            <% } %>
                                                        </div>
                                                        <div class="modal-footer bg-light">
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                                            <form action="DeleteReport" method="GET" class="d-inline">
                                                                <input type="hidden" name="reportID" value="<%=report.getReportId()%>">
                                                                <button type="submit" class="btn btn-success">
                                                                    <i class="bi bi-check-circle me-1"></i> Xác nhận đã xử lý
                                                                </button>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            </td>
                                    </tr>
                                    <% 
                                        } 
                                    } 
                                    %>
                                </tbody>
                            </table>

                        </div>
                    </div>
                </div>
                </div>
        </section>

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