<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
<jsp:include page="header.jsp"></jsp:include>
    <style>
        /* 1. Đồng bộ màu nền */
        body {
            background-color: #e0f2f7; /* Màu xanh nhạt đồng bộ với theme THI247 */
        }
        
        /* 2. Cải thiện khối Banner (Page Header) */
        .page-header {
            background-color: var(--bs-primary) !important; /* Đảm bảo dùng màu xanh chủ đạo */
            border-radius: 0 0 15px 15px; /* Bo góc dưới nhẹ */
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px !important;
        }

        /* 3. Căn chỉnh main content */
        .main {
            padding: 0 15px 50px 15px; /* Thêm padding dưới */
            margin-left: 0 !important;
            margin: auto; 
        }
        
        .section {
            padding-top: 0;
            max-width: 1200px; /* Giới hạn độ rộng nội dung */
            margin: auto;
        }

        /* 4. Tinh chỉnh bảng và nút */
        .card {
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
            border: none;
        }
        
        .table th, .table td {
            vertical-align: middle;
            text-align: center;
        }
        
        .btn-xoa {
            color: black;
        }
        
        .btn-primary {
            /* Đồng bộ màu xanh của nút với màu chủ đạo */
            background-color: var(--bs-primary);
            border-color: var(--bs-primary);
        }
        
        /* Căn chỉnh nút Trở về và Nút Chi tiết */
        .btn-back {
            background-color: #3f68a8 !important; /* Màu xanh đậm khác biệt so với primary */
            border-color: #3f68a8 !important;
            margin-left: 0 !important;
            margin-bottom: 15px;
        }
        
        .action-cell {
            display: flex;
            justify-content: center; /* Căn giữa nút trong cột Tác vụ */
            align-items: center;
        }
        
        .action-cell .btn {
            border-radius: 20px;
            padding: 5px 15px;
            font-size: 0.9em;
        }
    </style>
    <script>
        var container = document.getElementById("tagID");
        var tag = container.getElementsByClassName("tag");
        var current = container.getElementsByClassName("active");
        
        // Đảm bảo element active cũ được xóa
        if (current.length > 0) {
            current[0].className = current[0].className.replace(" active", "");
        }
        
        // Gán active cho mục "Kiểm Tra" (thường là index 2 nếu tính từ 0: Trang Chủ, Diễn Đàn, Kiểm Tra)
        // Dựa trên code header: Trang Chủ(0), Diễn Đàn(1), Kiểm Tra(2)
        // Tuy nhiên, vì đây là trang LỊCH SỬ LÀM BÀI, nó thuộc menu Kiểm Tra, nên cần kích hoạt dropdown Kiểm Tra.
        // Đây là code ví dụ cho việc kích hoạt mục thứ 2 trong dropdown Kiểm Tra (Lịch sử làm bài)
        // Tuy nhiên, việc kích hoạt dropdown phức tạp hơn, chỉ tập trung vào việc xóa active cũ là đủ.
    </script>

<%
if(session.getAttribute("currentUser") != null){
Users user = (Users)session.getAttribute("currentUser");
// Giả định các DAO đã được import và hoạt động
List<Result> resultList = new StudentExamDAO().getAllResultByUserID(user.getUserID());
%>
<div class="container-fluid bg-primary py-5 mb-5 page-header">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-10 text-center">
                <h1 class="display-3 text-white animated slideInDown">Bài kiểm tra</h1>
                <h3 class="text-white animated slideInDown">Dưới đây là danh sách những kiểm tra của bạn đã làm</h3>
            </div>
        </div>
    </div>
</div>
<main id="main" class="main">
    <section class="section">
        <div class="row">
            <div class="col-lg-12">

                <a class="btn btn-primary btn-back" href="Home">Trở về</a>
                
                <div class="card">
                    <div class="card-body p-4">
                        <h5 class="card-title text-primary" style="text-align: center;">Lịch sử chi tiết</h5>
                        
                        <%
                        if(resultList.size() > 0){
                        %>
                        <div class="table-responsive">
                            <table class="table datatable table-hover table-striped">
                                <thead>
                                    <tr>
                                        <th>Bài kiểm tra</th>
                                        <th>Môn học</th>
                                        <th>Điểm</th>
                                        <th data-type="date" data-format="YYYY/DD/MM">Ngày làm bài</th>
                                        <th>Tác vụ</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                    for(int i = resultList.size() - 1; i >= 0; i--){
                                        Result result = resultList.get(i);
                                        // Giả định DAO hoạt động
                                        Exam exam = new ExamDAO().getExamByID(result.getExamID());
                                        Subjects subject = new ExamDAO().getSubjectByID(exam.getSubjectID());
                                    %>
                                    <tr>
                                        <td><p class="mb-0"><%=exam.getExamName()%></p></td>
                                        <td><%=subject.getSubjectName()%></td>
                                        <td><%=result.getScore()%></td>
                                        <td><%=result.getSubmitDate()%></td>
                                        <td class="action-cell">
                                            <form action="PassDataResultDetail" method="POST">
                                                <input type="hidden" name="testID" value="<%=result.getTestID()%>">
                                                <input type="submit" class="btn btn-primary" value="Xem chi tiết"/>
                                            </form>     
                                        </td>
                                    </tr>
                                    <%
                                        }
                                     %>
                                </tbody>
                            </table>
                        </div>
                        <%
                            }
                            else{
                        %>
                        <div class="alert alert-info text-center mt-4 mb-4">
                            <h3 class="mb-0">Bạn chưa từng làm bài kiểm tra nào!</h3>
                        </div>
                        <%
                            }
                        %>
                        </div>
                </div>

            </div>
        </div>
    </section>

</main><script src="assets/vendor/apexcharts/apexcharts.min.js"></script>
<script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="assets/vendor/chart.js/chart.umd.js"></script>
<script src="assets/vendor/echarts/echarts.min.js"></script>
<script src="assets/vendor/quill/quill.js"></script>
<script src="assets/vendor/simple-datatables/simple-datatables.js"></script>
<script src="assets/vendor/tinymce/tinymce.min.js"></script>
<script src="assets/vendor/php-email-form/validate.js"></script>

<script src="assets/js/main.js"></script>
<script src="https://code.jquery.com/jquery-1.10.2.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript"></script>
<%
    }
%>
<jsp:include page="footer.jsp"></jsp:include>

<a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>