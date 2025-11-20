<!DOCTYPE html>
<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <title>THI247</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <meta content="" name="keywords">
        <meta content="" name="description">

        <link href="img/THI247.png" rel="icon">

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Heebo:wght@400;500;600&family=Nunito:wght@600;700;800&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="https://use.fontawesome.com/releases/v6.1.1/css/all.css">

        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">
        <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/css/bootstrap.min.css"
            rel="stylesheet"
            />
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">


        <link href="lib/animate/animate.min.css" rel="stylesheet">
        <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

        <link href="css/bootstrap.min.css" rel="stylesheet">

        <link href="css/style.css" rel="stylesheet">
        
        <style>
            /* Cải thiện chung cho Dropdown */
            .navbar .dropdown-menu {
                border-radius: 0.5rem; 
                box-shadow: 0 4px 12px rgba(0,0,0,0.15); 
                border: none;
                padding: 10px 0; 
            }
            .navbar .dropdown-item {
                padding: 10px 15px;
                transition: background-color 0.2s;
            }
            .navbar .dropdown-item:hover {
                background-color: #f8f9fa; 
                color: var(--bs-primary); 
            }
            .dropdown-header {
                font-weight: 600;
                color: #6c757d;
                padding: 5px 15px;
            }
            
            /* ======== PHẦN CĂN CHỈNH QUAN TRỌNG ======== */
            
            /* Tối ưu khối chứa menu (navbar-nav) để dùng flexbox căn giữa dọc */
            .navbar-nav {
                display: flex;
                align-items: center; /* Đảm bảo tất cả các mục (menu và nút) được căn giữa theo chiều dọc */
            }

            /* Đảm bảo chiều cao nav-link nhất quán */
            .navbar-nav .nav-link {
                /* Dùng padding tương đương với nút để căn chỉnh dễ hơn */
                padding-top: 0.5rem !important; 
                padding-bottom: 0.5rem !important;
            }

            /* Điều chỉnh kích thước và padding của nút "Tham gia ngay" */
            .navbar-nav .btn.btn-primary {
                font-weight: 700;
                /* Padding phải khớp với nav-link để nằm ngang hàng */
                padding-top: 0.5rem !important;
                padding-bottom: 0.5rem !important;
                padding-left: 1rem !important;
                padding-right: 1rem !important;
                
                height: fit-content;
                margin-left: 15px; /* Khoảng cách với mục menu cuối cùng */
                white-space: nowrap; 
            }
            /* =========================================== */

            /* Cân xứng hóa khu vực người dùng */
            .profile-avatar {
                width: 25px !important;
                height: 25px !important;
                border: 2px solid var(--bs-primary); 
                object-fit: cover;
            }
            
            .user-area {
                display: flex;
                align-items: center;
                gap: 5px; 
            }
            
            .user-info-group {
                display: flex;
                align-items: center;
                gap: 15px; 
            }
            
            .user-info-group .nav-link, 
            .profile-dropdown-container .nav-link {
                padding: 0; 
            }
            
            /* Căn chỉnh số dư */
            #user-balance-link {
                font-weight: 700;
                color: #28a745; 
                margin-right: 5px; 
            }

            /* Căn chỉnh Profile Dropdown */
            .profile-dropdown-container {
                list-style: none; 
                margin: 0 20px 0 10px; 
            }
            
            .nav-profile .dropdown-toggle {
                font-weight: 600;
                color: #000; 
            }
            .nav-profile .dropdown-toggle::after {
                margin-left: 0.25em; 
            }
            
        </style>
        
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
                <h2 class="m-0 text-primary"><i class="fa fa-book me-3"></i>THI247</h2>
            </a>
            <button type="button" class="navbar-toggler me-4" data-bs-toggle="collapse" data-bs-target="#navbarCollapse">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarCollapse">
                <div class="navbar-nav ms-auto p-4 p-lg-0" id="tagID">
                    <a href="Home" class="nav-item nav-link tag active">Trang Chủ</a>
                    <a href="forum.jsp" class="nav-item nav-link tag">Diễn Đàn</a>
                    
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle tag" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            Kiểm Tra
                        </a>
                        <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <%
                            if(session.getAttribute("currentUser") != null) {
                                Users user = (Users) session.getAttribute("currentUser");
                                
                                if (user.getRole() == 3) {
                            %>
                            <li class="dropdown-header">Học Sinh</li>
                            <li><a class="dropdown-item" href="choosesubjectstudent.jsp">Chọn môn kiểm tra</a></li>
                            <li><a class="dropdown-item" href="testhistory.jsp">Lịch sử làm bài</a></li>
                                <%
                                    } else  {
                                %>
                            <li class="dropdown-header">Giáo Viên/Admin</li>
                            <li><a class="dropdown-item" href="choosesubject.jsp">Tạo bài kiểm tra</a></li>
                            <li><a class="dropdown-item" href="questionbank.jsp">Ngân hàng câu hỏi</a></li>
                            <li><a class="dropdown-item" href="ViewAllExamTeacher.jsp">Các bài kiểm tra đã tạo</a></li>
<!--                            <li><hr class="dropdown-divider"></li>-->
<!--                            <li class="dropdown-header">Học Sinh</li>
                            <li><a class="dropdown-item" href="choosesubjectstudent.jsp">Chọn môn kiểm tra</a></li>
                            <li><a class="dropdown-item" href="testhistory.jsp">Lịch sử làm bài</a></li>-->
                                <%
                                    }
                                } else {
                                %>
                                <li class="dropdown-header">Vui lòng Đăng nhập</li>
                                <li><a class="dropdown-item" href="login.jsp">Đăng nhập để xem tùy chọn</a></li>
                                <%
                                }
                                %>
                        </ul>
                    </li>
                    <a href="${pageContext.request.contextPath}/SectionsController?action=get" class="nav-item nav-link tag">Học phần</a>
                    <a href="schedule.jsp" class="nav-item nav-link tag">Thời gian biểu</a>
                    
                    <%
                        if(session.getAttribute("currentUser") == null){
                    %>
                    <a href="login.jsp" class="btn btn-primary d-none d-lg-block">Tham gia ngay<i class="fa fa-arrow-right ms-3"></i></a> 
                        <%
                            }
                            else{
                            Users user = (Users)session.getAttribute("currentUser");
                            // Khởi tạo các đối tượng DAO và model cần thiết
                            TeacherRequest requests = null;
                            List<Notification> notis = Collections.emptyList();
                            Subjects subject = null;
                            
                            try {
                                requests = new AdminDAO().getRequestByUserID(user.getUserID());
                                notis = new NotificationDAO().getTop3Notifications();
                                if(requests != null)
                                    subject = new ExamDAO().getSubjectByID(requests.getSubjectID());
                            } catch (Exception e) {
                                // Xử lý lỗi nếu cần
                            }
                            
                            String role;
                            if(user.getRole() == 1) role = "Admin";
                            else if(user.getRole() == 2) role = "Giáo Viên/VIP";
                            else role = "Học Sinh";
                        %>
                    
                    <div class="user-area">
                        <div class="user-info-group">
                            <a href="recharge.jsp" class="nav-item nav-link d-flex align-items-center" style="color: black;">
                                <span id="user-balance-link"><%=user.getBalance()%></span> 
                                <i class="fas fa-coins text-warning" style="font-size: 1.1em;"></i>
                                <i class="fas fa-plus-circle text-primary ms-1" style="font-size: 0.8em;"></i> 
                            </a>
                            
                            <div class="nav-item dropdown">
                                <a href="#" class="nav-link" id="notificationDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                    <i class="bi bi-bell-fill text-dark" style="font-size: 1.1em;"></i>
                                </a>
                                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="notificationDropdown">
                                    <li class="dropdown-header">Thông báo mới nhất</li>
                                    <li><hr class="dropdown-divider"></li>
                                    <%
                                        if (notis != null) {
                                            for(int i = 0; i < notis.size(); i++){
                                                Notification noti = notis.get(i);
                                                String notiName = noti.getNotiName();
                                                if (notiName.length() > 30) {
                                                    notiName = notiName.substring(0, 30) + "...";
                                                }
                                    %>
                                    <li><a class="dropdown-item" href="#"><%=notiName%></a></li>
                                    <%
                                            }
                                        }
                                    %>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item text-center text-primary" href="ListAllNotification.jsp" style="font-weight: 500;">Xem tất cả</a></li>
                                </ul>
                            </div>
                        </div>

                        <li class="nav-item dropdown profile-dropdown-container">
                            <a class="nav-link nav-profile d-flex align-items-center pe-0" href="#" data-bs-toggle="dropdown">
                                <img src="<%=user.getAvatarURL()%>" alt="Profile" width="25" height="25" class="rounded-circle profile-avatar">
                                <span class="d-none d-md-block dropdown-toggle ps-2"><%=user.getUsername()%></span>
                            </a>

                            <ul class="dropdown-menu dropdown-menu-end dropdown-menu-arrow profile">
                                <li class="dropdown-header text-center">
                                    <h6><%=user.getUsername()%></h6>
                                    <span class="badge bg-primary"><%=role%></span>
                                </li>
                                <li>
                                    <hr class="dropdown-divider">
                                </li>
                                <%
                                if(user.getRole() == 1){
                                %>
                                <li>
                                    <a class="dropdown-item d-flex align-items-center" href="admin.jsp">
                                        <i class="bi bi-gear me-2"></i>
                                        <span>Quản lý (Admin)</span>
                                    </a>
                                </li>
                                <li>
                                    <hr class="dropdown-divider">
                                </li>
                                <%
                                    }
                                %>

                                <li>
                                    <a class="dropdown-item d-flex align-items-center" href="profile.jsp">
                                        <i class="bi bi-person me-2"></i>
                                        <span>Thông tin cá nhân</span>
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item d-flex align-items-center" href="recharge.jsp">
                                        <i class="fas fa-wallet me-2"></i>
                                        <span>Nạp tiền</span>
                                    </a>
                                </li>
                                <li>
                                    <hr class="dropdown-divider">
                                </li>
                                <li>
                                    <a class="dropdown-item d-flex align-items-center" href="logout">
                                        <i class="bi bi-box-arrow-right me-2"></i>
                                        <span>Đăng xuất</span>
                                    </a>
                                </li>

                            </ul>
                        </li>
                        <%
                            }
                        %>
                    </div>
                </div>
            </div>
        </nav>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>