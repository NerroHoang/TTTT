<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
<%@ page import="java.util.stream.Collectors" %>
<html lang="vi">

<head>
    <meta charset="utf-8">
    <title>Quản lý người dùng - THI247 Admin</title>
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

        .btn-action {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
            border-radius: 0.2rem;
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
                        else if(user.getRole() == 2) role = "Teacher";
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
            <li class="nav-item"><a class="nav-link bg-primary text-white" href="view-all-user.jsp"><i class="bi bi-people-fill"></i><span>Quản lý người dùng</span></a></li>
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

        <div class="pagetitle d-flex justify-content-between align-items-center mb-4">
            <div>
                <h1 class="fw-bold text-primary">Quản lý người dùng</h1>
                <nav>
                    <ol class="breadcrumb bg-transparent p-0 m-0">
                        <li class="breadcrumb-item"><a href="admin.jsp">Home</a></li>
                        <li class="breadcrumb-item active">Danh sách người dùng</li>
                    </ol>
                </nav>
            </div>
            <button class="btn btn-outline-primary shadow-sm"><i class="bi bi-person-plus-fill me-1"></i> Thêm mới</button>
        </div>

        <div class="card mb-4">
            <div class="card-body py-3">
                <form method="GET" action="view-all-user.jsp" class="row g-3 align-items-end">
                    <div class="col-md-6">
                        <label class="form-label fw-bold text-secondary small">Tìm kiếm người dùng</label>
                        <div class="input-group">
                            <span class="input-group-text bg-light"><i class="bi bi-search"></i></span>
                            <input type="text" name="search" class="form-control" placeholder="Nhập tên người dùng..." 
                                   value="<%= request.getParameter("search") != null && !request.getParameter("search").equals("null") ? request.getParameter("search") : "" %>">
                        </div>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label fw-bold text-secondary small">Trạng thái tài khoản</label>
                        <div class="dropdown w-100">
                            <button class="btn btn-outline-secondary dropdown-toggle w-100 d-flex justify-content-between align-items-center" type="button" data-bs-toggle="dropdown">
                                <% 
                                    String filter = request.getParameter("filter");
                                    if (filter == null) filter = "all";
                                    String displayFilter = "Tất cả người dùng";
                                    if ("ban".equals(filter)) displayFilter = "Đã bị khóa (Banned)";
                                    else if ("unban".equals(filter)) displayFilter = "Đang hoạt động (Active)";
                                %>
                                <%= displayFilter %>
                            </button>
                            <ul class="dropdown-menu w-100">
                                <li><a class="dropdown-item" href="?filter=all&search=<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">Tất cả người dùng</a></li>
                                <li><a class="dropdown-item text-danger" href="?filter=ban&search=<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">Đã bị khóa (Banned)</a></li>
                                <li><a class="dropdown-item text-success" href="?filter=unban&search=<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">Đang hoạt động (Active)</a></li>
                            </ul>
                        </div>
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
                    <table class="table table-hover table-striped align-middle mt-3">
                        <thead>
                            <tr>
                                <th scope="col" style="width: 5%;">ID</th>
                                <th scope="col" style="width: 10%;">Avatar</th>
                                <th scope="col" style="width: 20%;" class="text-start">Tên tài khoản</th>
                                <th scope="col" style="width: 20%;" class="text-start">Họ và tên</th>
                                <th scope="col" style="width: 10%;">Vai trò</th>
                                <th scope="col" style="width: 15%;">Trạng thái</th>
                                <th scope="col" style="width: 20%;">Tác vụ</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                // --- JAVA LOGIC GIỮ NGUYÊN ---
                                List<Users> users = new UserDAO().getAllUsers();
                                String search = request.getParameter("search");

                                if (filter != null) {
                                    if (filter.equals("all")) users = new UserDAO().getAllUsers();
                                    else if(filter.equals("ban")) users = new AdminDAO().getAllStatusUser(true);
                                    else users = new AdminDAO().getAllStatusUser(false);
                                }

                                if (search != null && !search.trim().isEmpty()) {
                                    String searchLower = search.trim().toLowerCase();
                                    users = users.stream()
                                                 .filter(u -> u.getUsername().toLowerCase().contains(searchLower))
                                                 .collect(Collectors.toList());
                                }

                                if(users.size() > 0){
                                    for(Users u: users){
                                        String uRole;
                                        String badgeClass;
                                        if(u.getRole() == 1) { uRole = "Admin"; badgeClass = "bg-danger"; }
                                        else if(u.getRole() == 2) { uRole = "Teacher"; badgeClass = "bg-primary"; }
                                        else { uRole = "User"; badgeClass = "bg-secondary"; }
                            %>
                            <tr>
                                <td class="text-center fw-bold text-muted">#<%=u.getUserID()%></td>
                                <td class="text-center">
                                    <img src="<%=u.getAvatarURL()%>" alt="Avatar" class="rounded-circle avatar-img shadow-sm">
                                </td>
                                <td>
                                    <span class="fw-bold text-dark"><%=u.getUsername()%></span>
                                </td>
                                <td>
                                    <% if (u.getFullname() != null){ %><%=u.getFullname()%><% } else { %><span class="text-muted fst-italic">Chưa cập nhật</span><% } %>
                                </td>
                                <td class="text-center">
                                    <span class="badge <%=badgeClass%> rounded-pill"><%=uRole%></span>
                                </td>
                                <td class="text-center">
                                    <% if(u.isBan()){ %>
                                        <span class="badge bg-danger-light text-danger border border-danger"><i class="bi bi-slash-circle me-1"></i>Banned</span>
                                    <% } else { %>
                                        <span class="badge bg-success-light text-success border border-success"><i class="bi bi-check-circle me-1"></i>Active</span>
                                    <% } %>
                                </td>
                                <td class="text-center">
                                    <a href="UserProfile?userID=<%=u.getUserID()%>" class="btn btn-sm btn-outline-info btn-action me-1" title="Xem chi tiết">
                                        <i class="bi bi-eye"></i>
                                    </a>
                                    
                                    <% if(u.isBan()){ %>
                                        <a href="BanUnbanUser?userID=<%=u.getUserID()%>&isBan=false" class="btn btn-sm btn-success btn-action" title="Mở khóa tài khoản">
                                            <i class="bi bi-unlock-fill me-1"></i> Unban
                                        </a>
                                    <% } else { %>
                                        <a href="BanUnbanUser?userID=<%=u.getUserID()%>&isBan=true" class="btn btn-sm btn-danger btn-action" title="Khóa tài khoản" onclick="return confirm('Bạn có chắc chắn muốn khóa tài khoản này?')">
                                            <i class="bi bi-lock-fill me-1"></i> Ban
                                        </a>
                                    <% } %>
                                </td>
                            </tr>
                            <% 
                                    }
                                } else {
                            %>
                                <tr>
                                    <td colspan="7" class="text-center py-5">
                                        <i class="bi bi-search text-muted" style="font-size: 3rem;"></i>
                                        <p class="text-muted mt-2">Không tìm thấy người dùng nào.</p>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
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