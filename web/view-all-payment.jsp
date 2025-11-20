<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<html lang="vi">

<head>
    <meta charset="utf-8">
    <title>Lịch sử giao dịch - THI247 Admin</title>
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

        .card-title {
            padding: 20px 0 15px 0;
            font-size: 18px;
            font-weight: 500;
            color: #012970;
            font-family: "Poppins", sans-serif;
        }

        .table thead th {
            background-color: #f6f9ff;
            color: #012970;
            border-bottom: 2px solid #e0e5f2;
            font-weight: 700;
            text-align: center;
            white-space: nowrap;
        }

        .table td {
            vertical-align: middle;
            color: #444;
        }

        .avatar-img {
            width: 45px;
            height: 45px;
            object-fit: cover;
            border: 2px solid #e0e5f2;
        }
        
        /* Total amount summary box (Optional addition) */
        .summary-card {
            transition: all 0.3s;
        }
        .summary-card:hover {
            transform: translateY(-5px);
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
            <li class="nav-item"><a class="nav-link bg-primary text-white" href="view-all-payment.jsp"><i class="bi bi-cash-stack"></i><span>Giao dịch hệ thống</span></a></li>
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

        <div class="pagetitle d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1 class="fw-bold text-primary">Lịch sử giao dịch</h1>
                <nav>
                    <ol class="breadcrumb bg-transparent p-0 m-0">
                        <li class="breadcrumb-item"><a href="admin.jsp">Home</a></li>
                        <li class="breadcrumb-item active">Giao dịch</li>
                    </ol>
                </nav>
            </div>
            <button class="btn btn-outline-primary shadow-sm"><i class="bi bi-download me-1"></i> Xuất báo cáo</button>
        </div>

        <section class="section">
            <div class="row">
                <div class="col-lg-12">

                    <div class="card">
                        <div class="card-body">
                            <h5 class="card-title">Tất cả giao dịch trong hệ thống</h5>

                            <div class="table-responsive">
                                <table class="table table-hover table-striped align-middle">
                                    <thead>
                                        <tr>
                                            <th scope="col">Avatar</th>
                                            <th scope="col" class="text-start">Người dùng</th>
                                            <th scope="col">Số tiền</th>
                                            <th scope="col">Ngày thanh toán</th>
                                            <th scope="col">Chi tiết</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <%
                                        // --- JAVA LOGIC GIỮ NGUYÊN ---
                                        List<Payment> paymentList = new UserDAO().getAllPayment();
                                        if(paymentList.size() > 0){
                                            for(int i = paymentList.size() - 1; i >= 0; i--){
                                                Payment payment = paymentList.get(i);
                                                Users otherUser = new UserDAO().findByUserID(payment.getUserID());
                                                NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
                                                String money = currencyFormatter.format(payment.getAmount());
                                        %>
                                        <tr>
                                            <td class="text-center">
                                                <img src="<%=otherUser.getAvatarURL()%>" alt="Profile" class="rounded-circle avatar-img shadow-sm">
                                            </td>
                                            <td>
                                                <span class="fw-bold text-dark"><%=otherUser.getUsername()%></span>
                                                <br>
<!--                                                <small class="text-muted">ID: #<%=otherUser.getUserID()%></small>-->
                                            </td>
                                            <td class="text-center">
                                                <span class="fw-bold text-success fs-6">
                                                    + <%=money%>
                                                </span>
                                            </td>
                                            <td class="text-center">
                                                <span class="text-secondary"><%=payment.getPaymentDate()%></span>
                                            </td>
                                            <td class="text-center">
                                                <a href="UserProfile?userID=<%=otherUser.getUserID()%>" class="btn btn-sm btn-light text-primary border shadow-sm" title="Xem hồ sơ">
                                                    <i class="bi bi-person-lines-fill me-1"></i> Xem hồ sơ
                                                </a>
                                            </td>
                                        </tr>
                                        <%
                                            }
                                        } else {
                                        %>
                                            <tr>
                                                <td colspan="5" class="text-center py-5">
                                                    <i class="bi bi-inbox-fill text-muted" style="font-size: 3rem;"></i>
                                                    <p class="text-muted mt-2">Chưa có giao dịch nào trong hệ thống.</p>
                                                </td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
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

    <script src="assets/js/main.js"></script>

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