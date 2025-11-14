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

                        List<QuestionBank> qbs = new ExamDAO().getAllSystemQuestion();    
                        int size = qbs.size();
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

                </li><!-- End Forms Nav -->

                <li class="nav-item">
                    <a class="nav-link collapsed" href="view-all-payment.jsp">
                        <i class="bi bi-gem"></i><span>Giao dịch trong hệ thống</span>
                    </a>
                </li><!-- End Tables Nav -->
                <li class="nav-item">
                    <a class="nav-link collapsed" href="view-all-exam.jsp">
                        <i class="bi bi-journal-check"></i><span>Quản lí kiểm tra</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="view-all-question.jsp">
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
            <h2 class="text-primary">Tất cả câu hỏi của hệ thống</h2>
            <a href="addquestionbank.jsp"><button class="btn btn-primary" style="color: white">Thêm câu hỏi vào hệ thống</button></a>
            <br><br>

            <!-- Search -->
            <form method="GET" action="view-all-question.jsp">
                <div class="form-group">
                    <!-- Trường nhập cho tìm kiếm -->
                    <input type="text" id="search" name="search" class="form-control" placeholder="Nhập tên câu hỏi bạn muốn tìm"
                           value="<%= request.getParameter("search") != null && !request.getParameter("search").equals("null") ? request.getParameter("search") : "" %>">

                    <!-- Trường ẩn giữ giá trị filter -->
                    <input type="hidden" name="filter" value="<%= request.getParameter("filter") != null ? request.getParameter("filter") : "all" %>">
                    <input type="hidden" name="pageSize" value="<%= request.getParameter("pageSize") != null ? request.getParameter("pageSize") : "10" %>">
                </div>
                <button type="submit" class="btn btn-primary text-white">Tìm kiếm</button>
            </form>

            <br><br>
            <div class="d-flex justify-content-between">
                <div class="dropdown">
                    <button onclick="dropdown()" class="dropbtn btn btn-primary dropdown-toggle" style="color: white">
                        <!-- Kiểm tra xem có môn học nào được chọn không, nếu có thì hiển thị tên môn học -->
                        <%
                            String filter = request.getParameter("filter");
                            if (filter == null) filter = "all";
                            String displayText = "Lọc theo môn học"; // Mặc định là "Sắp xếp"
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
                    <div id="myDropdown" class="dropdown-content">
                        <a class="dropdown-item" href="?filter=all&search=<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>&pageSize=<%= request.getParameter("pageSize") != null ? request.getParameter("pageSize") : "10" %>">
                            Tất cả môn học
                        </a>
                        <%
                        List<Subjects> subjects = new ExamDAO().getAllSubject();
                        for (Subjects subject : subjects) {
                        %>
                        <a class="dropdown-item" href="?filter=<%= subject.getSubjectID() %>&search=<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>&pageSize=<%= request.getParameter("pageSize") != null ? request.getParameter("pageSize") : "10" %>">
                            <%= subject.getSubjectName() %>
                        </a>
                        <%
                                    }
                        %>
                    </div>
                </div>
                <br><br>


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

                <form method="GET" action="view-all-question.jsp">
                    <label for="pageSize" class="mr-2 ">Số câu hỏi mỗi trang:</label>
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

            <div class="container">
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th class="text-primary" scope="col">Câu hỏi</th>
                            <th class="text-primary" scope="col">Môn học</th>
                            <th class="text-primary" scope="col">Đáp án</th>
                            <th class="text-primary" scope="col">Tác vụ</th>
                        </tr>
                    </thead>
                    <tbody>


                        <!--            list all user    -->
                        <%
                        if (qbs == null || qbs.isEmpty()) {
                            qbs = new ExamDAO().getAllSystemQuestion(); // Đảm bảo không bị null hoặc rỗng
                        }


                        String search = request.getParameter("search");          
                        if ("null".equals(search)) {
                            search = ""; // Chuyển đổi chuỗi "null" thành giá trị null thực sự
                        }


                        // Nếu filter (môn học) có giá trị
                        if (filter == null || filter.equals("all")) {
                            qbs = new ExamDAO().getAllSystemQuestion();
                        } else {
                            int subjectID = Integer.parseInt(filter);
                            qbs = new ExamDAO().getAllSystemQuestionByID(subjectID);
                        }

                        // Nếu người dùng nhập từ khóa tìm kiếm
                        if (search != null && !search.isEmpty()) {
                            if (filter != null && !filter.equals("all")) {
                                int subjectId = Integer.parseInt(filter);
                                qbs = new ExamDAO().searchQuestionByNameAndSubjectID(search, subjectId);  // Tìm kiếm theo tên và môn học
                            } else {
                                qbs = new ExamDAO().searchQuestionByName(search);  // Tìm kiếm chỉ theo tên
                            }
                        }                     


                        // Nhận pageSize từ request (hoặc gán giá trị mặc định)
                        pageSizeParam = request.getParameter("pageSize");
                        if ("all".equals(pageSizeParam)) {
                            pageSize = qbs.size(); // Lấy tất cả
                        } else {
                            pageSize = (pageSizeParam != null && !pageSizeParam.isEmpty()) ? Integer.parseInt(pageSizeParam) : 10;
                        }

                        int totalPages = (int) Math.ceil((double) qbs.size() / pageSize);
                        // Nhận pageNumber từ request (hoặc gán giá trị mặc định là trang 1)
                        String pageNumberParam = request.getParameter("pageNumber");
                        int pageNumber = (pageNumberParam != null && !pageNumberParam.isEmpty()) ? Integer.parseInt(pageNumberParam) : 1;

                        // Tính toán chỉ số bắt đầu và kết thúc của câu hỏi trên trang hiện tại

                        int startIndex = qbs.size() - (pageNumber * pageSize);
                        int endIndex = qbs.size() - ((pageNumber - 1) * pageSize);

                        // Điều chỉnh nếu startIndex bị âm
                        if (startIndex < 0) {
                            startIndex = 0;
                        }

                        // Lấy danh sách câu hỏi cần hiển thị cho trang hiện tại
                        List<QuestionBank> questionsOnPage = qbs.subList(startIndex, endIndex);

                        String context;
                        String answer;
                        for(int i = questionsOnPage.size() - 1; i >= 0; i--){
                            QuestionBank qb = questionsOnPage.get(i);
                            Subjects subject = new ExamDAO().getSubjectByID(qb.getSubjectId());
                            if(qb.getQuestionContext().length() > 40){ 
                                context = qb.getQuestionContext().substring(0, 40) + "...";
                            }
                            else if(qb.getQuestionContext().length() == 0){
                                context = qb.getQuestionImg();
                            }
                            else context = qb.getQuestionContext();

                            if(qb.getChoiceCorrect().startsWith("uploads/docreader")){
                                answer = qb.getChoiceCorrect();
                            }
                            else{
                                if(qb.getChoiceCorrect().length() > 40) 
                                    answer = qb.getChoiceCorrect().substring(0, 40) + "...";
                                else answer = qb.getChoiceCorrect();
                            }
                            String modalId = "threadModal" + i;
                            String modalDetailId = "threadModalDetail" + i;
                        %>
                        <tr>
                            <%
                            if(context.startsWith("uploads/docreader")){
                            %>
                            <td><img src="<%=context%>" width="30%" height="30%" alt="alt"/></td>
                                <%
                                    }
                                else{
                                %>
                            <td><p><%=context%></p></td>
                            <%
                                }
                            %>
                            <td><%=subject.getSubjectName()%></td>
                            <%
                            if(answer.startsWith("uploads/docreader")){
                            %>
                            <td><img src="<%=answer%>" width="50%" height="50%" alt="alt"/></td>
                                <%
                                    }
                                else{
                                %>
                            <td><%=answer%></td>
                            <%
                                }
                            %>
                            <td style="display: flex; flex-direction: row; text-align: center;">
                                <button
                                    class="btn btn-primary"
                                    type="button"
                                    style="color: white"
                                    data-toggle="modal"
                                    data-target="#<%= modalDetailId %>"  
                                    >
                                    Xem chi tiết
                                </button>
                                <div class="modal fade" id="<%=modalDetailId%>" tabindex="-1" role="dialog" aria-labelledby="threadModalLabel" aria-hidden="true">
                                    <div class="modal-dialog modal-lg" role="document">
                                        <div class="modal-content" style="width: 80%; margin: auto">
                                            <div class="modal-header d-flex align-items-center bg-primary text-white">
                                                <h6 class="modal-title mb-0" id="threadModalLabel">Chi tiết câu hỏi</h6>
                                            </div>
                                            <div class="modal-body" style="text-align: left;"> 
                                                <p style="font-weight: bold">Câu hỏi</p>
                                                <p style="overflow-wrap:break-word;"><%=qb.getQuestionContext()%></p>
                                                <%
                                                if(qb.getQuestionImg() != null){
                                                %>
                                                <img src="<%=qb.getQuestionImg()%>" width="70%"/>
                                                <%
                                                    }
                                                %>
                                                <p style="font-weight: bold">Câu trả lời</p>
                                                <%
                                                if(qb.getChoice1().startsWith("uploads/docreader")){
                                                %>
                                                <br><span style="font-weight: bold">A. </span><img src="<%=qb.getChoice1()%>" height="30" alt="alt"/>
                                                <%
                                                    }
                                                else{
                                                %>
                                                <p style="overflow-wrap:break-word;"><label style="font-weight: bold">A:</label> <%=qb.getChoice1()%></p>
                                                <%
                                                    }
                                                %>
                                                <%
                                                if(qb.getChoice2().startsWith("uploads/docreader")){
                                                %>
                                                <br><span style="font-weight: bold">B. </span><img src="<%=qb.getChoice2()%>" height="30" alt="alt"/>
                                                <%
                                                    }
                                                else{
                                                %>
                                                <p style="overflow-wrap:break-word;"><label style="font-weight: bold">B:</label> <%=qb.getChoice2()%></p>
                                                <%
                                                    }
                                                %>
                                                <%
                                                if(qb.getChoice3().startsWith("uploads/docreader")){
                                                %>
                                                <br><span style="font-weight: bold">D. </span><img src="<%=qb.getChoice3()%>" height="30" alt="alt"/>
                                                <%
                                                    }
                                                else{
                                                %>
                                                <p style="overflow-wrap:break-word;"><label style="font-weight: bold">C:</label> <%=qb.getChoice3()%></p>
                                                <%
                                                    }
                                                %>
                                                <%
                                                if(qb.getChoiceCorrect().startsWith("uploads/docreader")){
                                                %>
                                                <br><span style="font-weight: bold">D. </span><img src="<%=qb.getChoiceCorrect()%>" height="30" alt="alt"/>
                                                <%
                                                    }
                                                else{
                                                %>
                                                <p style="overflow-wrap:break-word;"><label style="font-weight: bold">D:</label> <%=qb.getChoiceCorrect()%></p>
                                                <%
                                                    }
                                                %>
                                                <%
                                                if(qb.getChoiceCorrect().startsWith("uploads/docreader")){
                                                %>
                                                <br><span style="font-weight: bold">Đáp án: </span><img src="<%=qb.getChoiceCorrect()%>" height="30" alt="alt"/>
                                                <%
                                                    }
                                                else{
                                                %>
                                                <p style="overflow-wrap:break-word;"><label style="font-weight: bold">Đáp án:</label> <%=qb.getChoiceCorrect()%></p>
                                                <%
                                                    }
                                                %>
                                                <p style="overflow-wrap:break-word;"><label style="font-weight: bold">Giải thích:</label> <%=qb.getExplain()%></p>
                                                <%
                                                if(qb.getExplainImg() != null){
                                                %>
                                                <img src="<%=qb.getExplainImg()%>" width="70%"/>
                                                <%
                                                    }
                                                %>
                                            </div>
                                            <div class="modal-footer">
                                                <input type="button" class="btn btn-primary" data-dismiss="modal"value="Thoát">
                                            </div>
                                        </div> 
                                    </div>                        
                                </div>
                                <div class="inner-sidebar-header justify-content-center">
                                    <button
                                        class="btn btn-primary"
                                        style="background-color: red; color: white"
                                        type="button"
                                        data-toggle="modal"
                                        data-target="#<%= modalId %>"  
                                        >
                                        Xoá Câu hỏi
                                    </button>
                                </div>

                                <div class="modal fade" id="<%= modalId %>" tabindex="-1" role="dialog" aria-labelledby="threadModalLabel" aria-hidden="true">
                                    <div class="modal-dialog modal-lg" role="document">
                                        <div class="modal-content" style="width: 500px; margin: auto">
                                            <form action="DeleteQuestionInBank" method="POST">
                                                <input type="hidden" name="questionID" value="<%=qb.getQuestionId()%>">
                                                <input type="hidden" name="subjectID" value="<%=subject.getSubjectID()%>">
                                                <div class="modal-header d-flex align-items-center bg-primary text-white">
                                                    <h6 class="modal-title mb-0" id="threadModalLabel">Xác nhận xóa câu hỏi?</h6>
                                                </div>
                                                <div class="modal-body">
                                                    <div class="form-group">                       
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-light" data-dismiss="modal" >Hủy</button>
                                                            <input type="submit" class="btn btn-primary" style="background-color: red" value="Xóa câu hỏi"/>
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
                    if (qbs.size() == 0) {
                %>
                <div class="text-center" style="color: red; margin-top: 5%;">
                    <h3>Không tìm thấy câu hỏi nào</h3>
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
                            <a class="page-link" href="view-all-question.jsp?pageSize=<%= pageSize %>&pageNumber=1&filter=<%= filter %>&search=<%= search %>">Trang đầu tiên</a>
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
                            <a class="page-link" href="view-all-question.jsp?pageSize=<%= pageSize %>&pageNumber=<%= pageNumber - 1 %>&filter=<%= filter %>&search=<%= search %>"><%= pageNumber - 1 %></a>
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
                            <a class="page-link" href="view-all-question.jsp?pageSize=<%= pageSize %>&pageNumber=<%= pageNumber + 1 %>&filter=<%= filter %>&search=<%= search %>"><%= pageNumber + 1 %></a>
                        </li>
                        <% } %>

                        <% 
                            // Hiển thị trang cuối cùng nếu không phải là trang cuối
                            if (pageNumber < totalPages) { 
                        %>
                        <li class="page-item">
                            <a class="page-link" href="view-all-question.jsp?pageSize=<%= pageSize %>&pageNumber=<%= totalPages %>&filter=<%= filter %>&search=<%= search %>">Trang cuối cùng</a>
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
            function dropdown() {
                document.getElementById("myDropdown").classList.toggle("show");
            }

            // Close the dropdown if the user clicks outside of it
            window.onclick = function (event) {
                if (!event.target.matches('.dropbtn')) {
                    var dropdowns = document.getElementsByClassName("dropdown-content");
                    var i;
                    for (i = 0; i < dropdowns.length; i++) {
                        var openDropdown = dropdowns[i];
                        if (openDropdown.classList.contains('show')) {
                            openDropdown.classList.remove('show');
                        }
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
