<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<html lang="vi">

<head>
    <meta charset="utf-8">
    <title>THI247 - Quản lý thông báo</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">

    <link href="img/THI247.png" rel="icon">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Heebo:wght@400;500;600&family=Nunito:wght@600;700;800&display=swap" rel="stylesheet">

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

    <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <link href="assets/css/admin-css.css" rel="stylesheet">
    
    <style>
        body {
            background-color: #f6f9ff;
            font-family: 'Nunito', sans-serif;
        }
        
        /* Xử lý layout main content để không bị sidebar che */
        #main {
            margin-top: 60px; /* Chiều cao header */
            padding: 20px 30px;
            transition: all 0.3s;
        }

        @media (min-width: 1200px) {
            #main {
                margin-left: 300px; /* Chiều rộng sidebar */
            }
        }

        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0px 0 30px rgba(1, 41, 112, 0.1);
        }

        .card-header {
            background: white;
            border-bottom: 1px solid #ebeef4;
            padding: 20px;
            border-radius: 10px 10px 0 0;
        }

        .form-control:focus {
            box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.15);
            border-color: #4154f1;
        }

        /* Animation cho nút */
        .btn-custom {
            transition: all 0.3s ease;
        }
        .btn-custom:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
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
                    // Logic xử lý role giữ nguyên
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
                            <h6 class="mb-1"><%=user.getUsername()%></h6>
                            <span class="badge bg-primary"><%=role%> <%if(user.getRole() == 2){%> - <%=subject.getSubjectName()%><% }%></span>
                        </li>
                        <li><hr class="dropdown-divider"></li>
                        
                        <% if(user.getRole() == 1){ %>
                        <li>
                            <a class="dropdown-item d-flex align-items-center" href="admin.jsp">
                                <i class="bi bi-grid me-2"></i> <span>Quản trị</span>
                            </a>
                        </li>
                        <% } %>

                        <li>
                            <a class="dropdown-item d-flex align-items-center" href="profile.jsp">
                                <i class="bi bi-person me-2"></i> <span>Hồ sơ</span>
                            </a>
                        </li>
                        <li><hr class="dropdown-divider"></li>
                        <li>
                            <a class="dropdown-item d-flex align-items-center text-danger" href="logout">
                                <i class="bi bi-box-arrow-right me-2"></i> <span>Đăng xuất</span>
                            </a>
                        </li>
                    </ul>
                </li>
                <% } else { %>
                    <li class="nav-item pe-3">
                        <a href="login.jsp" class="btn btn-sm btn-primary">Đăng nhập</a>
                    </li>
                <% } %>
            </ul>
        </nav>
    </header>

    <aside id="sidebar" class="sidebar bg-white" style="position: fixed; top: 60px; left: 0; bottom: 0; width: 300px; z-index: 996; transition: all 0.3s; padding: 20px; box-shadow: 0px 0px 20px rgba(1, 41, 112, 0.1); overflow-y: auto;">
        <ul class="sidebar-nav list-unstyled" id="sidebar-nav">
            <li class="nav-item mb-2">
                <a class="nav-link collapsed rounded" href="admin.jsp">
                    <i class="bi bi-grid"></i> <span>Dashboard</span>
                </a>
            </li>
            <li class="nav-item mb-2">
                <a class="nav-link collapsed rounded" href="view-all-user.jsp">
                    <i class="bi bi-people"></i> <span>Quản lý người dùng</span>
                </a>
            </li>
            <li class="nav-item mb-2">
                <a class="nav-link collapsed rounded" href="view-all-payment.jsp">
                    <i class="bi bi-cash-stack"></i> <span>Giao dịch hệ thống</span>
                </a>
            </li>
            <li class="nav-item mb-2">
                <a class="nav-link collapsed rounded" href="view-all-exam.jsp">
                    <i class="bi bi-journal-check"></i> <span>Quản lý bài kiểm tra</span>
                </a>
            </li>
            <li class="nav-item mb-2">
                <a class="nav-link collapsed rounded" href="view-all-question.jsp">
                    <i class="bi bi-question-square"></i> <span>Ngân hàng câu hỏi</span>
                </a>
            </li>
            <li class="nav-item mb-2">
                <a class="nav-link rounded bg-primary text-white" href="notification.jsp">
                    <i class="bi bi-bell-fill"></i> <span>Thông báo hệ thống</span>
                </a>
            </li>
             <li class="nav-item mt-4">
                <a class="nav-link collapsed rounded text-secondary" href="Home">
                    <i class="bi bi-arrow-left-circle"></i> <span>Về trang chủ</span>
                </a>
            </li>
        </ul>
    </aside>

    <main id="main" class="main">
        
        <div class="pagetitle mb-4 d-flex justify-content-between align-items-center">
            <div>
                <h1 class="text-primary fw-bold">Tạo Thông Báo Mới</h1>
                <nav>
                    <ol class="breadcrumb bg-transparent p-0 m-0">
                        <li class="breadcrumb-item"><a href="admin.jsp">Admin</a></li>
                        <li class="breadcrumb-item active">Thông báo</li>
                    </ol>
                </nav>
            </div>
            
            <a href="ListAllNotification.jsp" class="btn btn-outline-primary btn-custom">
                <i class="bi bi-list-ul me-1"></i> Xem danh sách thông báo
            </a>
        </div>

        <section class="section">
            <div class="row justify-content-center">
                <div class="col-lg-8 col-md-10">
                    
                    <div class="card">
                        <div class="card-header d-flex align-items-center">
                            <i class="bi bi-pencil-square text-primary fs-4 me-2"></i>
                            <h5 class="card-title m-0 fw-bold text-dark">Nội dung thông báo</h5>
                        </div>
                        
                        <div class="card-body pt-4">
                            <form action="AddNotification" method="POST" class="needs-validation" novalidate>
                                
                                <div class="mb-4">
                                    <div class="form-floating">
                                        <textarea 
                                            class="form-control" 
                                            placeholder="Nhập nội dung thông báo tại đây" 
                                            id="notificationContent" 
                                            name="notificationName" 
                                            style="height: 150px" 
                                            required></textarea>
                                        <label for="notificationContent">Nội dung chi tiết</label>
                                    </div>
                                    <div class="form-text text-muted">
                                        Thông báo này sẽ được gửi đến toàn bộ người dùng trong hệ thống.
                                    </div>
                                </div>

                                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                    <button type="reset" class="btn btn-light btn-lg px-4 me-md-2">Làm mới</button>
                                    <button type="submit" class="btn btn-primary btn-lg px-5 btn-custom">
                                        <i class="bi bi-send-fill me-2"></i> Gửi thông báo
                                    </button>
                                </div>
                                
                            </form>
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
    <script src="assets/vendor/apexcharts/apexcharts.min.js"></script>
    <script src="assets/vendor/chart.js/chart.umd.js"></script>
    <script src="assets/vendor/echarts/echarts.min.js"></script>
    <script src="assets/vendor/quill/quill.js"></script>
    <script src="assets/vendor/simple-datatables/simple-datatables.js"></script>
    <script src="assets/vendor/tinymce/tinymce.min.js"></script>
    <script src="assets/vendor/php-email-form/validate.js"></script>

    <script src="assets/js/main.js"></script>

    <script>
        document.addEventListener("DOMContentLoaded", () => {
            const toggleBtn = document.querySelector('.toggle-sidebar-btn');
            const sidebar = document.querySelector('#sidebar');
            const main = document.querySelector('#main');
            
            if(toggleBtn) {
                toggleBtn.addEventListener('click', () => {
                    document.body.classList.toggle('toggle-sidebar');
                    // Nếu bạn cần xử lý CSS thủ công (thường main.js của template NiceAdmin đã làm việc này)
                });
            }
        });
    </script>
</body>
</html>