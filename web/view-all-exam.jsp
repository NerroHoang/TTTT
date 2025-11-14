<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<style>
    .page-item {
        margin: 0 5px; /* 0px trên dưới, 5px trái phải */
    }
    #pageSize {
        background-color: #fff; /* Nền trắng */
        border: 1px solid #ccc; /* Viền màu xám nhẹ */
        color: #333; /* Màu chữ tối */
        font-size: 16px; /* Cỡ chữ */
        padding: 10px; /* Padding bên trong */
        border-radius: 5px; /* Bo góc nhẹ cho ô select */
    }

    #pageSize:focus {
        border-color: #007bff; /* Màu viền khi ô được chọn */
        box-shadow: 0 0 0 0.2rem rgba(38, 143, 255, 0.25); /* Hiệu ứng shadow khi focus */
    }

    button {
        border-radius: 5px; /* Bo góc cho button */
        transition: background-color 0.3s ease; /* Hiệu ứng chuyển màu nền khi hover */
    }

    button:hover {
        background-color: #0056b3; /* Màu nền khi hover */
    }

    th {
        writing-mode: horizontal-tb; /* Đảm bảo văn bản nằm ngang */
        white-space: nowrap; /* Ngăn ngừa việc cắt chữ hoặc xuống dòng */
        text-align: center; /* Căn giữa chữ nếu cần */
    }

</style>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <title></title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <meta content="" name="keywords">
        <meta content="" name="description">

        <!-- Favicon -->
        <link href="img/HCV.png" rel="icon">

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
                            else if(user.getRole() == 2) role = "User VIP";
                            else role = "User";
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

                </li><!-- End Forms Nav -->

                <li class="nav-item">
                    <a class="nav-link collapsed" href="view-all-payment.jsp">
                        <i class="bi bi-gem"></i><span>Giao dịch trong hệ thống</span>
                    </a>
                </li><!-- End Tables Nav -->
                <li class="nav-item">
                    <a class="nav-link" href="view-all-exam.jsp">
                        <i class="bi bi-journal-check"></i><span>Quản lí kiểm tra</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link collapsed" href="view-all-question.jsp">
                        <i class="bi bi-journal-check"></i><span>Quản lí câu hỏi</span>
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

        <style>
            .dropdown:hover .dropdown-menu {
                display: none;
            }

            .dropdown {
                position: relative;
                display: inline-block;
            }

            .dropdown-content {
                display: none;
                position: absolute;
                background-color: #f1f1f1;
                box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
                z-index: 1;
            }

            .dropdown-content a {
                color: black;
                padding: 12px 16px;
                text-decoration: none;
                display: block;
            }
            .show {
                display: block;
            }

        </style>

        <main id="main" class="main">
            <h2 class="text-primary">Tất cả bài kiểm tra trong hệ thống</h2>
            <a href="choosesubject.jsp"><button class="btn btn-primary" style="color: white">Tạo đề kiểm tra</button></a>
            <br><br>

            <!-- Lấy giá trị filter và status từ request -->
            <%
                String status = request.getParameter("status");
                
            %>
            <%
// Lấy giá trị của pageSize từ request
String pageSizeParam = request.getParameter("pageSize");

// Nếu pageSize là "all", thay thế bằng giá trị mặc định (ví dụ: 10)
int pageSize = 10;  // Mặc định nếu không có giá trị hợp lệ

// Kiểm tra nếu pageSize là "all", bỏ qua
if (pageSizeParam != null && !pageSizeParam.isEmpty() && !pageSizeParam.equals("all")) {
try {
pageSize = Integer.parseInt(pageSizeParam);  // Chuyển đổi thành int nếu không phải "all"
} catch (NumberFormatException e) {
// Nếu không thể chuyển đổi, giữ giá trị mặc định (10)
pageSize = 10;
}
}
            %>

            <!-- Search -->
            <form method="GET" action="view-all-exam.jsp">
                <div class="form-group">
                    <!-- Trường nhập cho tìm kiếm -->
                    <input type="text" id="search" name="search" class="form-control" placeholder="Nhập tên bài kiểm tra bạn muốn tìm"
                           value="<%= request.getParameter("search") != null && !request.getParameter("search").equals("null") ? request.getParameter("search") : "" %>">

                    <!-- Trường ẩn giữ giá trị filter, pageSize, status -->
                    <input type="hidden" name="filter" value="<%= request.getParameter("filter") != null ? request.getParameter("filter") : "all" %>">
                    <input type="hidden" name="pageSize" value="<%= request.getParameter("pageSize") != null ? request.getParameter("pageSize") : "10" %>">
                    <input type="hidden" name="status" value="<%= request.getParameter("status") != null ? request.getParameter("status") : "all" %>">
                </div>
                <button type="submit" class="btn btn-primary text-white">Tìm kiếm</button>
            </form>
                
            <br>
            
            <div class="d-flex justify-content-between">
                <div class="d-flex ">
                    <div class="dropdown">
                        <button onclick="toggleDropdown('dropdownSubjects')" class="dropbtn btn btn-primary dropdown-toggle" style="color: white">
                            <!-- Kiểm tra xem có môn học nào được chọn không, nếu có thì hiển thị tên môn học -->
                            <%
                                String filter = request.getParameter("filter");
                                if (filter == null) filter = "all";
                                String displayText = "Tất cả môn học";
                                if (filter != null && !filter.equals("all")) {
                                    // Tìm môn học đã chọn từ danh sách môn học
                                    List<Subjects> subjects = new ExamDAO().getAllSubject();
                                    for (Subjects subject : subjects) {
                                        if (String.valueOf(subject.getSubjectID()).equals(filter)) {
                                            displayText = subject.getSubjectName(); // Hiển thị tên môn học
                                            break;
                                        }
                                    }
                                }
                            %>
                            <%= displayText %>
                        </button>
                        <div id="dropdownSubjects" class="dropdown-content">
                            <a class="dropdown-item" href="?filter=all&search=<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>&pageSize=<%= request.getParameter("pageSize") != null ? request.getParameter("pageSize") : "10" %>&status=<%= request.getParameter("status") != null ? request.getParameter("status") : "all" %>">
                                Tất cả môn học
                            </a>
                            <%
                            List<Subjects> subjects = new ExamDAO().getAllSubject();
                            for (Subjects subject : subjects) {
                            %>
                            <a class="dropdown-item" href="?filter=<%= subject.getSubjectID() %>&search=<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>&pageSize=<%= request.getParameter("pageSize") != null ? request.getParameter("pageSize") : "10" %>&status=<%= request.getParameter("status") != null ? request.getParameter("status") : "all" %>">
                                <%= subject.getSubjectName() %>
                            </a>
                            <%
                            }
                            %>
                        </div>

                    </div>
                    <br><br>

                    <div class="dropdown">
                        <button class="dropbtn btn btn-primary dropdown-toggle" style="color: white" type="button" onclick="toggleDropdown('dropdownStatus')">
                            <% 
                                String displayStatus = "Tất cả trạng thái"; // Mặc định là "Tất cả trạng thái"
                                if (status != null && status.equals("approved")) displayStatus = "Đã duyệt";
                                else if (status != null && status.equals("notApproved")) displayStatus = "Chưa duyệt";
                            %>
                            <%= displayStatus %>
                        </button>
                        <div id="dropdownStatus" class="dropdown-content">
                            <a class="dropdown-item" href="?status=all&filter=<%= request.getParameter("filter") != null ? request.getParameter("filter") : "all" %>&pageSize=<%= request.getParameter("pageSize") != null ? request.getParameter("pageSize") : "10" %>&search=<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                                Tất cả trạng thái
                            </a>
                            <a class="dropdown-item" href="?status=approved&filter=<%= request.getParameter("filter") != null ? request.getParameter("filter") : "all" %>&pageSize=<%= request.getParameter("pageSize") != null ? request.getParameter("pageSize") : "10" %>&search=<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                                Đã duyệt
                            </a>
                            <a class="dropdown-item" href="?status=notApproved&filter=<%= request.getParameter("filter") != null ? request.getParameter("filter") : "all" %>&pageSize=<%= request.getParameter("pageSize") != null ? request.getParameter("pageSize") : "10" %>&search=<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                                Chưa duyệt
                            </a>
                        </div>
                    </div>
                </div>

                <div>

                    <form method="GET" action="view-all-exam.jsp">
                        <label for="pageSize" class="mr-2 ">Số bài kiểm tra mỗi trang:</label>
                        <select name="pageSize" id="pageSize">
                            <option value="10" <%= pageSize == 10 ? "selected" : "" %>>10</option>
                            <option value="20" <%= pageSize == 20 ? "selected" : "" %>>20</option>
                            <option value="30" <%= pageSize == 30 ? "selected" : "" %>>30</option>
                            <option value="50" <%= pageSize == 50 ? "selected" : "" %>>50</option>
                            <option value="all" <%= "all".equals(pageSizeParam) ? "selected" : "" %>>Tất cả</option>
                        </select>
                        <input type="hidden" name="filter" value="<%= request.getParameter("filter") != null ? request.getParameter("filter") : "all" %>">
                        <input type="hidden" name="search" value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                        <button type="submit" class="btn btn-primary text-white">Cập nhật</button>
                    </form>
                </div>
            </div>



            <br><br>
            <div class="container">
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th class="text-primary" scope="col" style="text-align: center">Tên bài kiểm tra</th>
                            <th class="text-primary" scope="col" style="text-align: center">Môn học</th>
                            <th class="text-primary" scope="col" style="text-align: center">Số câu hỏi</th>
                            <th class="text-primary" scope="col" style="text-align: center">Giá tiền</th>
                            <th class="text-primary" scope="col" style="text-align: center">Thời gian làm bài</th>
                            <th class="text-primary" scope="col" style="text-align: center">Người tạo</th>
                            <th class="text-primary" scope="col" style="text-align: center">Ngày đăng</th>
                            <th class="text-primary" scope="col">Tác vụ</th>
                        </tr>
                    </thead>
                    <tbody>


                        <!--            list all exam    -->
                        <%
                        List<Exam> exams = new ArrayList<>(); 
                        String search = request.getParameter("search");
                  
                        // Nếu không có từ khóa tìm kiếm, đặt mặc định là chuỗi rỗng
                        if (search == null || search.equals("null")) {
                            search = ""; 
                        }
                        
                        // Xử lý lọc bài kiểm tra
                    if (filter != null && !filter.equals("all")) {
                        int subjectID = Integer.parseInt(filter); // Lấy môn học theo ID
                        if (status != null) {
                            if (status.equals("approved")) {
                                exams = new ExamDAO().searchExamsBySubjectStatusAndKeyword(subjectID, true, search);
                            } else if (status.equals("notApproved")) {
                                exams = new ExamDAO().searchExamsBySubjectStatusAndKeyword(subjectID, false, search);
                            } else { // status = all
                                exams = new ExamDAO().searchExamsBySubjectAndKeyword(subjectID, search);
                            }
                        } else {
                            exams = new ExamDAO().searchExamsBySubjectAndKeyword(subjectID, search);
                        }
                    } else if (filter != null && filter.equals("all")) {
                        if (status != null) {
                            if (status.equals("approved")) {
                                exams = new ExamDAO().searchExamsByStatusAndKeyword(true, search);
                            } else if (status.equals("notApproved")) {
                                exams = new ExamDAO().searchExamsByStatusAndKeyword(false, search);
                            } else { // status = all
                                exams = new ExamDAO().searchExamsByKeyword(search);
                            }
                        } else {
                            exams = new ExamDAO().searchExamsByKeyword(search);
                        }
                    } else {
                        exams = new ExamDAO().searchExamsByKeyword(search); // Mặc định lấy tất cả bài kiểm tra
                    }                     
                        
                // Nhận pageSize từ request (hoặc gán giá trị mặc định)
                        pageSizeParam = request.getParameter("pageSize");
                        if ("all".equals(pageSizeParam)) {
                         // Nhận pageSize từ request (hoặc gán giá trị mặc định)
                            pageSize = exams.size(); // Lấy tất cả
                        } else {
                            pageSize = (pageSizeParam != null && !pageSizeParam.isEmpty()) ? Integer.parseInt(pageSizeParam) : 10;
                        }

                        int totalPages = (int) Math.ceil((double) exams.size() / pageSize);
                        // Nhận pageNumber từ request (hoặc gán giá trị mặc định là trang 1)
                        String pageNumberParam = request.getParameter("pageNumber");
                        int pageNumber = (pageNumberParam != null && !pageNumberParam.isEmpty()) ? Integer.parseInt(pageNumberParam) : 1;

                        // Tính toán chỉ số bắt đầu và kết thúc của câu hỏi trên trang hiện tại

                        int startIndex = exams.size() - (pageNumber * pageSize);
                        int endIndex = exams.size() - ((pageNumber - 1) * pageSize);

                        // Điều chỉnh nếu startIndex bị âm
                        if (startIndex < 0) {
                            startIndex = 0;
                        }
                        
                        List<Exam> examOnPage = exams.subList(startIndex, endIndex);               
                
                        UserDAO userDao = new UserDAO();
                        Users user = new Users();
                        if(examOnPage.size() > 0){
                            for(int i = examOnPage.size() - 1; i >= 0; i--){
                                Exam exam = examOnPage.get(i);
                                String subjectName = new ExamDAO().getSubjectByID(exam.getSubjectID()).getSubjectName();
                                int examAmount = new ExamDAO().getQuestionAmount(exam.getExamID());
                                String modalId = "threadModal" + i;
                                String modalId1 = "threadModal1" + i;
                     
                                int hour = exam.getTimer() / 3600;
                                int minute = (exam.getTimer() % 3600) / 60;
                                user =  userDao.findByUserID(exam.getUserID());
                        %>
                        <tr>
                            <td style="text-align: center"><%=exam.getExamName()%></td>
                            <td style="text-align: center"><%=subjectName%></td>
                            <td style="text-align: center"><%=examAmount%></td>
                            <td style="text-align: center"><%=exam.getPrice()%></td>
                            <td style="text-align: center"><%if(hour != 0){%><%=hour%>h<% } %><%if(minute != 0){%> <%=minute%>p<% } %></td>
                            <td style="text-align: center"><%=user.getUsername()%></td>
                            <td style="text-align: center"><%=exam.getCreateDate()%></td>
                            <td style="display: flex; text-align: center; flex-direction: row">


                                <form style="border-radius: 15px" action="PassDataExamUpdate" method="POST">
                                    <input type="hidden" name="examID" value="<%=exam.getExamID()%>">
                                    <div class="inner-sidebar-header justify-content-center"">
                                        <input type="submit" class="btn btn-primary" style="color: white;" value="Sửa"/>
                                    </div>
                                </form>
                                <div class="inner-sidebar-header justify-content-center" style="background-color: red; border-radius: 15px">
                                    <button
                                        class="btn btn-primary"
                                        type="button"
                                        data-toggle="modal"
                                        data-target="#<%= modalId %>"  
                                        style="background-color: red; color: white;"
                                        >
                                        Xoá
                                    </button>
                                </div>

                                <div class="modal fade" id="<%= modalId %>" tabindex="-1" role="dialog" aria-labelledby="threadModalLabel" aria-hidden="true">
                                    <div class="modal-dialog modal-lg" role="document">
                                        <div class="modal-content" style="width: 500px; margin: auto">
                                            <form action="DeleteExam" method="POST">
                                                <input type="hidden" name="examID" value="<%=exam.getExamID()%>">
                                                <div class="modal-header d-flex align-items-center bg-primary text-white">
                                                    <h6 class="modal-title mb-0" id="threadModalLabel">Xác nhận xóa bài kiểm tra?</h6>
                                                </div>
                                                <div class="modal-body">
                                                    <div class="form-group">                       
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-light" data-dismiss="modal" >Hủy</button>
                                                            <input type="submit" class="btn btn-primary" style="background-color: red" value="Xoá bài kiểm tra"/>
                                                        </div>
                                                    </div> 
                                                </div>
                                            </form>
                                        </div> 
                                    </div>                        
                                </div>

                                <!-- Nếu bài kiểm tra chưa duyệt thì hiển thị nút Duyệt -->
                                <% if (!exam.isIsAprroved()) { %>
                                <div class="inner-sidebar-header justify-content-center" style="border-radius: 5px;">
                                    <button style="color: white;"
                                        class="btn btn-primary"
                                        type="button"
                                        data-toggle="modal"
                                        data-target="#<%= modalId1 %>"
                                        >
                                        Duyệt
                                    </button>
                                </div>
                                <% } %>

                                <% if (exam.isIsAprroved()==true) { %>
                                <div class="inner-sidebar-header justify-content-center" style="background-color: green; border-radius: 15px; margin-left: 10px;">
                                    <button
                                        class="btn btn-primary"
                                        type="button"
                                        style="color: white; cursor: not-allowed;"
                                        disabled
                                        >
                                        Đã Duyệt
                                    </button>
                                </div>
                                <% } %>

                                <div class="modal fade" id="<%= modalId1 %>" tabindex="-1" role="dialog" aria-labelledby="threadModal1Label" aria-hidden="true">
                                    <div class="modal-dialog modal-lg" role="document">
                                        <div class="modal-content" style="width: 500px; margin: auto">
                                            <form action="ApproveExamController" method="POST">
                                                <input type="hidden" name="examID" value="<%=exam.getExamID()%>">
                                                <div class="modal-header d-flex align-items-center bg-primary text-white">
                                                    <h6 class="modal-title mb-0" id="threadModal1Label">Xác nhận duyệt bài kiểm tra?</h6>
                                                </div>
                                                <div class="modal-body">
                                                    <div class="form-group">                       
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-light" data-dismiss="modal" >Hủy</button>
                                                            <input type="submit" class="btn btn-primary" value="Duyệt bài kiểm tra"/>
                                                        </div>
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
                        %>
                        <!--                ket thuc list all user-->


                        <!--<tr>
                                        <td>abc</td>
                                        <td>getUserImg</td>
                                        <td>getUsername</td>
                                        <td>getFullname</td>
                                        <td>getRole</td>
                                        <td>redirect to profile</td>
                                        <td><input type="submit" class="btn btn-primary" value="Unban"/></td>
                        
                                    </tr>-->
                    </tbody>

                </table>
                <%
           // Kiểm tra nếu qbs là rỗng
           if (exams.size() == 0) {
                %>
                <div class="text-center" style="color: red; margin-top: 5%;">
                    <h3>Không tìm thấy bài kiểm tra nào</h3>
                </div>
                <%
                    } 
                %>
            </div>

            <!-- Phân trang -->
            <div class="d-flex justify-content-center my-4">
                <nav aria-label="Page navigation">
                    <ul class="pagination">
                        <% 
                            // Hiển thị trang đầu tiên nếu không phải là trang đầu tiên
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
                            // Hiển thị trang trước nếu không phải là trang đầu tiên
                            if (pageNumber > 1) { 
                        %>
                        <li class="page-item">
                            <a class="page-link" href="view-all-exam.jsp?pageSize=<%= pageSize %>&pageNumber=<%= pageNumber - 1 %>&filter=<%= filter %>&search=<%= search %>&status=<%= status %>"><%= pageNumber - 1 %></a>
                        </li>
                        <% } %>

                        <!-- Hiển thị trang hiện tại -->
                        <li class="page-item disabled">
                            <span class="page-link"  style="background-color: #f0f0f0; color: #333;"><%= pageNumber %></span>
                        </li>

                        <% 
                            // Hiển thị trang tiếp theo nếu không phải là trang cuối cùng
                            if (pageNumber < totalPages) { 
                        %>
                        <li class="page-item">
                            <a class="page-link" href="view-all-exam.jsp?pageSize=<%= pageSize %>&pageNumber=<%= pageNumber + 1 %>&filter=<%= filter %>&search=<%= search %>&status=<%= status %>"><%= pageNumber + 1 %></a>
                        </li>
                        <% } %>

                        <% 
                            // Hiển thị trang cuối cùng nếu không phải là trang cuối
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
        </main><!-- End #main -->
        <script>
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


        <a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>

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
        <script src="https://code.jquery.com/jquery-1.10.2.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.bundle.min.js"></script>
        <script type="text/javascript"></script>




