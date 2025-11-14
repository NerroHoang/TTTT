<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <title>HCV</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <meta content="" name="keywords">
        <meta content="" name="description">

        <!-- Favicon -->
        <link href="img/THI247.png" rel="icon">

        <!-- Google Web Fonts -->
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Heebo:wght@400;500;600&family=Nunito:wght@600;700;800&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v6.1.1/css/all.css">

        <!-- Icon Font Stylesheet -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">
        <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css"
            rel="stylesheet"
            />

        <!-- Libraries Stylesheet -->
        <link href="lib/animate/animate.min.css" rel="stylesheet">
        <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

        <!-- Customized Bootstrap Stylesheet -->
        <link href="css/bootstrap.min.css" rel="stylesheet">

        <!-- Template Stylesheet -->
        <link href="assets/css/admin-css.css" rel="stylesheet">
    </head>
    <body>
        <link
            rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.12.0-2/css/all.min.css"
            integrity="sha256-46r060N2LrChLLb5zowXQ72/iKKNiw/lAmygmHExk/o="
            crossorigin="anonymous"
            />
        <nav class="navbar navbar-expand-lg bg-white navbar-light shadow sticky-top p-0">
            <a href="Home" class="navbar-brand d-flex align-items-center px-4 px-lg-5">
                <h2 class="m-0 text-primary"><i class="fa fa-book me-3"></i>HCV</h2>
            </a>
            <button type="button" class="navbar-toggler me-4" data-bs-toggle="collapse" data-bs-target="#navbarCollapse">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarCollapse">
                <div class="navbar-nav ms-auto p-4 p-lg-0" id="tagID">
                    <a href="Home" class="nav-item nav-link tag active">Trang Chủ</a>
                    <a href="forum.jsp" class="nav-item nav-link tag">Diễn Đàn</a>
                    <a href="teacher.jsp" class="nav-item nav-link tag">Kiểm Tra</a>
                    <a href="schedule.jsp" class="nav-item nav-link tag">Thời gian biểu</a>
                    <%
                        if(session.getAttribute("currentUser") == null){
                    %>
                    <a href="login.jsp" class="btn btn-primary py-4 px-lg-5 d-none d-lg-block">Tham gia ngay<i class="fa fa-arrow-right ms-3"></i></a> 
                        <%
                            }
                            else{
                            Users user = (Users)session.getAttribute("currentUser");
                            TeacherRequest requests = new AdminDAO().getRequestByUserID(user.getUserID());
                            Subjects subject = new Subjects();
                            if(requests != null)
                                subject = new ExamDAO().getSubjectByID(requests.getSubjectID());
                            String role;
                            if(user.getRole() == 1) role = "Admin";
                            else if(user.getRole() == 2) role = "Giáo viên";
                            else role = "Học sinh";
                        %>
                    <a href="recharge.jsp" class="nav-item nav-link tag">
                        <i class="fas fa-coins"></i>
                        <span id="user-balance"><%=user.getBalance()%></span> 
                        <i class="fas fa-plus-circle"></i> 
                    </a>
                </div>
                <li class="nav-item dropdown pe-3 no">
                    <style>
                        .no{
                            display: block;
                        }
                    </style>
                    <a class="nav-link nav-profile d-flex align-items-center pe-0" href="#" data-bs-toggle="dropdown">
                        <img src="<%=user.getAvatarURL()%>" alt="Profile" width="50" height="50" class="rounded-circle">
                        <span class="d-none d-md-block dropdown-toggle ps-2"><%=user.getUsername()%></span>
                    </a><!-- End Profile Iamge Icon -->

                    <ul class="dropdown-menu dropdown-menu-end dropdown-menu-arrow profile">
                        <li class="dropdown-header">
                            <h6><%=user.getUsername()%></h6>
                            <span><%=role%> <%if(user.getRole() == 2){%>môn <%=subject.getSubjectName()%><% }%></span>
                        </li>
                        <li>
                            <hr class="dropdown-divider">
                        </li>
                        <%
                        if(user.getRole() == 1){
                        %>
                        <li>
                            <a class="dropdown-item d-flex align-items-center" href="admin.jsp">
                                <i class="bi bi-person"></i>
                                <span>Quản lý</span>
                            </a>
                        </li>
                        <%
                            }
                        %>

                        <li>
                            <a class="dropdown-item d-flex align-items-center" href="profile.jsp">
                                <i class="bi bi-person"></i>
                                <span>Thông tin</span>
                            </a>
                        </li>
                        <li>
                            <a class="dropdown-item d-flex align-items-center" href="logout">
                                <i class="bi bi-box-arrow-right"></i>
                                <span>Đăng xuất</span>
                            </a>
                        </li>

                    </ul><!-- End Profile Dropdown Items -->
                </li>
                <%
                    }
                %>
            </div>
        </nav>
        <!-- Navbar End -->

        <aside id="sidebar" class="sidebar">
            <ul class="sidebar-nav" id="sidebar-nav">
                <li class="nav-item">
                    <a class="nav-link collapsed"  href="admin.jsp">
                        <i class="bi bi-grid"></i>
                        <span>Dashboard</span>
                    </a>
                </li><!-- End Dashboard Nav -->

                <li class="nav-item">
                    <a class="nav-link collapsed" href="view-all-user.jsp">
                        <i class="bi bi-person"></i>
                        <span>Tất cả người dùng</span>
                    </a>
                </li>

                <li class="nav-item">
                    <a class="nav-link collapsed" href="view-all-payment.jsp">
                        <i class="bi bi-cash-stack"></i><span>Giao dịch trong hệ thống</span>
                    </a>
                </li><!-- End Tables Nav -->
                <li class="nav-item">
                    <a class="nav-link collapsed" href="view-all-exam.jsp">
                        <i class="bi bi-journal-check"></i><span>Quản lí kiểm tra</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link collapsed" href="view-all-question.jsp">
                        <i class="bi bi-question-square"></i><span>Quản lí câu hỏi</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link collapsed" href="notification.jsp">
                        <i class="bi bi-bell"></i><span>Thông báo hệ thống</span>
                    </a>
                </li>
                <!-- End Icons Nav -->
            </ul>
        </aside><!-- End Sidebar-->
        <br><br><br><br>
        
        <button class="btn btn-primary" style="margin-left: 350px">
            <a style="color: white" href="ListAllNotification.jsp">Xem danh sách thông báo</a>
        </button>
        
        <div class="row">
            <div class="col-lg-12" style="width: 1000px; margin: auto; margin-top: 20px; margin-left: 350px">
                <div class="card">
                    <div class="card-body">
                        <h4 class="text-primary">Thông báo hệ thống</h4>
                        <!-- Browser Default Validation -->
                        <form action="AddNotification" method="POST" class="row g-3">     
                            <div class="col-md-12">
                                <label class="form-label">Nhập thông báo</label>
                                <input type="text" class="form-control" name="notificationName" id="validationDefault03" required>
                            </div>
<!--                            <div class="col-md-12">
                                <label class="form-label">Thời gian</label>
                                <input type="date" class="form-control" id="validationDefault03" required>
                            </div>-->
                            <div class="col-12">
                                <button style="margin: auto" class="btn btn-primary" type="submit">Xác nhận</button>
                            </div>
                        </form>
                    </div>
                </div>

            </div>
        </div>    
    </div>    

    <a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>
    <style>
        
        
        
    </style>
    <!-- Vendor JS Files -->
    <script src="assets/vendor/apexcharts/apexcharts.min.js"></script>
    <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="assets/vendor/chart.js/chart.umd.js"></script>
    <script src="assets/vendor/echarts/echarts.min.js"></script>
    <script src="assets/vendor/quill/quill.js"></script>
    <script src="assets/vendor/simple-datatables/simple-datatables.js"></script>
    <script src="assets/vendor/tinymce/tinymce.min.js"></script>
    <script src="assets/vendor/php-email-form/validate.js"></script>

    <!-- Template Main JS File -->
    <script src="assets/js/main.js"></script>









