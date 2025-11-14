
<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
<%@page import="java.util.concurrent.TimeUnit" %>
<jsp:include page="header.jsp"></jsp:include>
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
    <script>
        var container = document.getElementById("tagID");
        var tag = container.getElementsByClassName("tag");
        var current = container.getElementsByClassName("active");
        current[0].className = current[0].className.replace(" active", "");
        tag[2].className += " active";
    </script>

    <style>
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
<%
if(session.getAttribute("subjectID") != null){
Users user = (Users)session.getAttribute("currentUser");
int subjectID = (Integer)session.getAttribute("subjectID");
Subjects subject = new ExamDAO().getSubjectByID(subjectID);

%>

<!-- Courses Start -->
<div class="container-xxl py-5">
    <div class="container">
        <a class="btn btn-primary" style="background-color:blue ; margin-top: 20px;" href="choosesubjectstudent.jsp">Trở về</a>
        <div class="text-center wow fadeInUp" data-wow-delay="0.1s">
            <h6 class="section-title bg-white text-center text-primary px-3">Môn <%=subject.getSubjectName()%></h6>
            <h1 class="mb-5">Danh sách các bài kiểm tra của môn <%=subject.getSubjectName()%></h1>
        </div>
        <div class="d-flex align-items-center justify-content-between ">

            <div class="dropdown">
                <button class="dropbtn btn btn-primary dropdown-toggle" type="button" onclick="toggleDropdown('dropdownFilter')">
                    <% 
                        String displayFilter = "Tất cả các bài kiểm tra"; // Mặc định là "Tất cả các bài kiểm tra"
                        String filter = request.getParameter("filter") != null ? request.getParameter("filter") : "all"; // Lấy filter từ request
                        if (filter.equals("free")) displayFilter = "Bài kiểm tra miễn phí";
                        else if (filter.equals("paid")) displayFilter = "Bài kiểm tra trả phí";
                        else if (filter.equals("purchased")) displayFilter = "Bài kiểm tra đã mua";
                    %>
                    <%= displayFilter %>
                </button>
                <div id="dropdownFilter" class="dropdown-content">
                    <a class="dropdown-item" href="?filter=all&search=<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                        Tất cả các bài kiểm tra
                    </a>
                    <a class="dropdown-item" href="?filter=free&search=<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                        Bài kiểm tra miễn phí
                    </a>
                    <a class="dropdown-item" href="?filter=paid&search=<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                        Bài kiểm tra trả phí
                    </a>
                    <a class="dropdown-item" href="?filter=purchased&search=<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                        Bài kiểm tra đã mua
                    </a>
                </div>

            </div>

            <!-- Search -->
            <form method="GET" action="examlist.jsp">
                <div class="form-group">
                    <!-- Trường nhập cho tìm kiếm -->
                    <input type="text" id="search" name="search" class="form-control" 
                           placeholder="Nhập tên bài kiểm tra bạn muốn tìm"
                           value="<%= request.getParameter("search") != null && !request.getParameter("search").equals("null") ? request.getParameter("search") : "" %>"
                           onkeydown="if (event.key === 'Enter')
                                       this.form.submit();" style="width: 200%;">

                    <!-- Trường ẩn giữ giá trị filter, pageSize -->
                    <input type="hidden" name="filter" value="<%= request.getParameter("filter") != null ? request.getParameter("filter") : "all" %>">
                    <input type="hidden" name="pageSize" value="<%= request.getParameter("pageSize") != null ? request.getParameter("pageSize") : "12" %>">
                </div>
            </form>



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

            <div>
                <form method="GET" action="examlist.jsp">
                    <label for="pageSize" class="mr-2 ">Số bài kiểm tra mỗi trang:</label>
                    <select name="pageSize" id="pageSize">
                        <option value="12" <%= pageSize == 12 ? "selected" : "" %>>12</option>
                        <option value="24" <%= pageSize == 24 ? "selected" : "" %>>24</option>
                        <option value="36" <%= pageSize == 36 ? "selected" : "" %>>36</option>
                        <option value="all" <%= "all".equals(pageSizeParam) ? "selected" : "" %>>Tất cả</option>
                    </select>
                    <input type="hidden" name="filter" value="<%= request.getParameter("filter") != null ? request.getParameter("filter") : "all" %>">
                    <input type="hidden" name="search" value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
                    <button type="submit" class="btn btn-primary text-white">Cập nhật</button>
                </form>
            </div>
        </div>
        <div class="row g-4 justify-content-center">
            <!--                bai kiem tra-->
            <%
            
            List<Exam> exams = new StudentExamDAO().getAllExamIsAprrovedBySubjectID(subjectID);
            String search = request.getParameter("search");

if (filter != null) {
    if (filter.equals("free")) {
        exams.removeIf(exam -> exam.getPrice() > 0);
    } else if (filter.equals("paid")) {
        exams.removeIf(exam -> exam.getPrice() == 0);
    } else if (filter.equals("purchased")) {
        exams.removeIf(exam -> !new StudentExamDAO().checkExamPay(user.getUserID(), exam.getExamID()));
    }
}
            
// Kết hợp search
if (search != null && !search.trim().isEmpty()) {
    String searchLower = search.trim().toLowerCase();
    exams.removeIf(exam -> !exam.getExamName().toLowerCase().contains(searchLower)); // Lọc theo tên bài kiểm tra
}

pageSizeParam = request.getParameter("pageSize");
                        if ("all".equals(pageSizeParam)) {
                         // Nhận pageSize từ request (hoặc gán giá trị mặc định)
                            pageSize = exams.size(); // Lấy tất cả
                        } else {
                            pageSize = (pageSizeParam != null && !pageSizeParam.isEmpty()) ? Integer.parseInt(pageSizeParam) : 12;
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
                        
                        
            for(int i = examOnPage.size() - 1; i >= 0; i--){
            Exam exam = examOnPage.get(i);
            int price = exam.getPrice();
            int attempt = new ExamDAO().countAttemptExam(exam.getExamID());

            String modalID = "threadModal" + i;
            String modalNoID = "threadModalNo" + i;
    
    // Lấy thông tin người tạo bài kiểm tra từ userId
    UserDAO userDAO = new UserDAO();
    Users creator = userDAO.findByUserID(exam.getUserID());  // Giả sử phương thức này truy vấn CSDL và trả về đối tượng User

    // Giả sử exam.getDuration() trả về thời gian làm bài tính bằng giây
    int durationInSeconds = exam.getTimer(); 

    // Chuyển đổi giây sang giờ, phút, giây
    long hours = TimeUnit.SECONDS.toHours(durationInSeconds);
    long minutes = TimeUnit.SECONDS.toMinutes(durationInSeconds) - TimeUnit.HOURS.toMinutes(hours);
    long seconds = durationInSeconds - TimeUnit.MINUTES.toSeconds(minutes) - TimeUnit.HOURS.toSeconds(hours);
            

            %>

            <div class="col-lg-4 col-md-6 wow fadeInUp" data-wow-delay="0.1s">
                <div class="course-item bg-light">
                    <div class="position-relative overflow-hidden">
                        <img class="img-fluid" src="img/course-1.jpg" alt="">
                        <div class="w-100 d-flex justify-content-center position-absolute bottom-0 start-0 mb-4">
                            <%
                            if (price == 0 || new StudentExamDAO().checkExamPay(user.getUserID(), exam.getExamID())) {
                            %>
                            <button
                                class="flex-shrink-0 btn btn-sm btn-primary px-3"
                                style="border-radius:30px"
                                type="button"
                                data-toggle="modal"
                                data-target="#<%= modalID %>"                             
                                >
                                <%
    new ExamDAO().incrementViewCount(exam.getExamID());
                                %>
                                Xem chi tiết bài thi
                            </button>

                            <div class="modal fade" id="<%= modalID %>" tabindex="-1" role="dialog" aria-labelledby="examModalLabel" aria-hidden="true">
                                <div class="modal-dialog modal-lg" role="document">
                                    <div class="modal-content" style="width: 500px; margin: auto">
                                        <div class="modal-header d-flex align-items-center bg-primary text-white">
                                            <h6 class="modal-title mb-0" id="examModalLabel" style="color: white">Chi tiết bài kiểm tra</h6>
                                        </div>
                                        <div class="modal-body">
                                            <h5><%= exam.getExamName() %></h5>
                                            <p><strong>Giá:</strong> <%= price == 0 ? "Free" : price + " coin" %></p>
                                            <!-- Hiển thị thông tin người tạo -->
                                            <p><strong>Người tạo:</strong> <%= creator != null ? creator.getUsername() : "Không xác định" %></p>
                                            <p><strong>Ngày tạo:</strong> <%= exam.getCreateDate() %></p>
                                            <p><strong>Thời gian làm bài:</strong> <%= String.format("%02d:%02d:%02d", hours, minutes, seconds) %></p>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-light" data-dismiss="modal">Hủy</button>
                                            <a href="ExamDetail?examID=<%= exam.getExamID() %>">
                                                <button class="btn btn-primary">Vào thi</button>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <%
                            } else if (price > 0 && user.getBalance() >= price) {
                            %>
                            <button
                                class="flex-shrink-0 btn btn-sm btn-primary px-3"
                                style="border-radius:30px"
                                type="button"
                                data-toggle="modal"
                                data-target="#<%= modalID %>"
                                >
                                Vào thi
                            </button>

                            <div class="modal fade" id="<%= modalID %>" tabindex="-1" role="dialog" aria-labelledby="examModalLabel" aria-hidden="true">
                                <div class="modal-dialog modal-lg" role="document">
                                    <div class="modal-content" style="width: 500px; margin: auto">
                                        <div class="modal-header d-flex align-items-center bg-primary text-white">
                                            <h6 class="modal-title mb-0" id="examModalLabel" style="color: white">Xác nhận mua bài kiểm tra</h6>
                                        </div>
                                        <div class="modal-body">
                                            <h5><%= exam.getExamName() %></h5>
                                            <p><strong>Giá:</strong> <%= price + " coin" %></p>
                                            <p><strong>Người tạo:</strong> <%= creator != null ? creator.getUsername() : "Không xác định" %></p>
                                            <p><strong>Ngày tạo:</strong> <%= exam.getCreateDate() %></p>
                                            <p><strong>Thời gian làm bài:</strong> <%= String.format("%02d:%02d:%02d", hours, minutes, seconds) %></p>
                                        </div>
                                        <form action="PurchaseExam" method="POST">
                                            <input type="hidden" name="price" value="<%= price %>"/>
                                            <input type="hidden" name="examID" value="<%= exam.getExamID() %>">
                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-light" data-dismiss="modal">Hủy</button>
                                                <input type="submit" class="btn btn-primary" value="Xác nhận"/>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>

                            <%
                            } else {
                            %>
                            <button
                                class="flex-shrink-0 btn btn-sm btn-primary px-3"
                                style="border-radius:30px"
                                type="button"
                                data-toggle="modal"
                                data-target="#<%= modalNoID %>"
                                >
                                Vào thi
                            </button>

                            <div class="modal fade" id="<%= modalNoID %>" tabindex="-1" role="dialog" aria-labelledby="threadModalLabel" aria-hidden="true">
                                <div class="modal-dialog modal-lg" role="document">
                                    <div class="modal-content" style="width: 500px; margin: auto">
                                        <div class="modal-header d-flex align-items-center bg-primary text-white">
                                            <h6 class="modal-title mb-0" id="threadModalLabel" style="color: white">Bạn không đủ tiền để thanh toán! Nạp thêm tiền?</h6>
                                        </div>
                                        <div class="modal-body">
                                            <div class="form-group">
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-light" data-dismiss="modal">Hủy</button>
                                                    <a href="recharge.jsp"><button class="btn btn-primary">Xác nhận</button></a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <%
                            }
                            %>
                        </div>
                    </div>
                    <div class="text-center p-4 pb-0">
                        <h3 class="mb-0"><%=exam.getExamName()%></h3>
                        <%
                        if(price == 0){
                        %>
                        <h5>Free</h5>
                        <%
                            }else if(price > 0 && new StudentExamDAO().checkExamPay(user.getUserID(), exam.getExamID())){
                        %>
                        <h5 style="color: green"><%=price%> coin(Đã thanh toán)</h5>
                        <%
                            }else{
                        %>
                        <h5><%=price%> coin</h5>
                        <%
                            }
                        %>
                        <h5 style="font-style: italic">Số lượt làm: <%=attempt%></h5>
                    </div>
                </div>
            </div>

            <%
                }
            %>
            <!--                bai kiem tra-->
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
                        <a class="page-link" href="view-all-exam.jsp?pageSize=<%= pageSize %>&pageNumber=1&filter=<%= filter %>&search=<%= search %>">Trang đầu tiên</a>
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
                        <a class="page-link" href="view-all-exam.jsp?pageSize=<%= pageSize %>&pageNumber=<%= pageNumber - 1 %>&filter=<%= filter %>&search=<%= search %>"><%= pageNumber - 1 %></a>
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
                        <a class="page-link" href="view-all-exam.jsp?pageSize=<%= pageSize %>&pageNumber=<%= pageNumber + 1 %>&filter=<%= filter %>&search=<%= search %>"><%= pageNumber + 1 %></a>
                    </li>
                    <% } %>

                    <% 
                        // Hiển thị trang cuối cùng nếu không phải là trang cuối
                        if (pageNumber < totalPages) { 
                    %>
                    <li class="page-item">
                        <a class="page-link" href="view-all-exam.jsp?pageSize=<%= pageSize %>&pageNumber=<%= totalPages %>&filter=<%= filter %>&search=<%= search %>">Trang cuối cùng</a>
                    </li>
                    <% } else { %>
                    <li class="page-item disabled">
                        <span class="page-link" style="background-color: #f0f0f0; color: #333;">Trang cuối cùng</span>
                    </li>
                    <% } %>
                </ul>
            </nav>
        </div>
    </div>
</div>

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

<%
    }
%>
<!-- Courses End -->

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
<script src="https://code.jquery.com/jquery-1.10.2.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.bundle.min.js"></script>

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

    document.addEventListener('mouseleave', function (event) {
        var dropdownContent = document.getElementById("myDropdown");
        if (event.target.closest('.dropdown') === null && dropdownContent.classList.contains('show')) {
            dropdownContent.classList.remove('show');
        }
    });
</script>

<jsp:include page="footer.jsp"></jsp:include>
<!-- Back to Top -->
<a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>