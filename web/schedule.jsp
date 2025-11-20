<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*, Schedule.*"%>
<jsp:include page="header.jsp"></jsp:include>
    <style>
        /* 1. Đồng bộ màu nền */
        body {
            background-color: #e0f2f7; /* Màu xanh nhạt đồng bộ */
        }
        
        /* 2. Cải thiện giao diện chính */
        .card {
            border-radius: 10px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
            border: none;
            margin-top: 20px;
        }

        .pagetitle h1 {
            color: var(--bs-primary); /* Màu xanh chủ đạo cho tiêu đề chính */
            font-weight: 700;
        }
        
        /* Căn chỉnh bảng */
        .table th, .table td {
            vertical-align: middle;
            text-align: center;
        }
        
        /* 3. Modal Styling */
        .modal-content {
             border-radius: 10px;
        }
        .modal-header.bg-primary {
            background-color: var(--bs-primary) !important;
            border-radius: 10px 10px 0 0;
        }
        .modal-body .form-group {
            display: flex;
            flex-direction: column;
            gap: 15px; /* Khoảng cách giữa các input */
        }
        .modal-body label {
            font-weight: 600;
            margin-bottom: 5px;
        }
        .modal-body input[type="text"],
        .modal-body input[type="date"],
        .modal-body input[type="time"] {
            padding: 10px;
            border: 1px solid #ced4da;
            border-radius: 5px;
            width: 100%;
        }

        /* Nút Tác vụ */
        .btn-danger {
            background-color: #dc3545;
            border-color: #dc3545;
            padding: 5px 15px;
            border-radius: 20px;
        }
        
        /* Nút Thêm Task (bottom) */
        .btn-block {
            padding: 10px 0;
            font-weight: 600;
        }
        
        /* Nút Xóa trong Modal xác nhận */
        .modal-content input[type="submit"][value="Xóa câu hỏi"] {
             background-color: #dc3545 !important;
             border-color: #dc3545 !important;
        }
    </style>
    <script>
        var container = document.getElementById("tagID");
        var tag = container.getElementsByClassName("tag");
        var current = container.getElementsByClassName("active");
        current[0].className = current[0].className.replace(" active", "");
        tag[3].className += " active";
    </script>
<%
if(session.getAttribute("currentUser") != null){
    Users user = (Users)session.getAttribute("currentUser");
    List<Task> listTask = new TaskDAO().getTasksByUser(user.getUserID());
%>
<body>
    <div class="container">        
        <main id="main" class="main">
            <div class="pagetitle" style="margin-top: 50px">
                <h1>To-do List</h1>   
            </div>
            
            <section class="section">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="card">
                            <div class="card-body">
                                <h4 class="card-title text-center text-secondary">Hãy lên một lịch trình học tập và làm việc thật khoa học nhé!</h4>
                                
                                <div class="table-responsive">
                                    <table class="table datatable table-hover table-striped">
                                        <thead>
                                            <tr>
                                                <th style="width: 5%">ID</th>
                                                <th style="width: 50%">Nhiệm vụ</th>
                                                <th style="width: 25%">Thời gian</th>
                                                <th style="width: 20%">Tác vụ</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <%
                                            if(listTask.size() > 0){
                                            for(int i = listTask.size() - 1; i >= 0; i--){
                                                Task task = listTask.get(i);
                                                String modalId = "threadModal" + task.getTaskId(); // Dùng Task ID để đảm bảo ID modal duy nhất
                                            %>
                                            <tr>
                                                <td><%=task.getTaskId()%></td>
                                                <td style="text-align: left;"><%=task.getTaskContext()%></td>
                                                <td><%=task.getTaskDeadline()%></td>
                                                <td>
                                                    <button
                                                        class="btn btn-danger btn-sm"
                                                        type="button"
                                                        data-toggle="modal"
                                                        data-target="#<%= modalId %>"  
                                                        >
                                                        Xoá Lịch
                                                    </button>
                                                    
                                                    <div class="modal fade" id="<%= modalId %>" tabindex="-1" role="dialog" aria-labelledby="threadModalLabel" aria-hidden="true">
                                                        <div class="modal-dialog" role="document">
                                                            <div class="modal-content" style="width: 500px; margin: auto">
                                                                <form action="deleteTask" method="POST">
                                                                    <input type="hidden" name="taskId" value="<%=task.getTaskId()%>">
                                                                    <div class="modal-header d-flex align-items-center bg-primary text-white">
                                                                        <h6 class="modal-title mb-0" id="threadModalLabel">Xác nhận xóa lịch trình?</h6>
                                                                        <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                                                                    </div>
                                                                    <div class="modal-body text-center">
                                                                        <p>Bạn có chắc chắn muốn xóa nhiệm vụ **<%=task.getTaskContext()%>**?</p>
                                                                        <div class="form-group row justify-content-center mt-4" style="gap: 15px;">
                                                                            <button type="button" class="btn btn-light col-5" data-dismiss="modal" >Hủy</button>
                                                                            <input type="submit" class="btn btn-primary col-5" value="Xóa Lịch" style="background-color: red"/>
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
                                            }else{
                                            %>
                                            <tr>
                                                <td colspan="4" class="text-center">Bạn chưa có lịch trình nào!</td>
                                            </tr>
                                            <%
                                                }
                                            %>
                                        </tbody>
                                    </table>
                                </div>
                                

                                <div>
                                    <div class="inner-sidebar-header justify-content-center mt-4">
                                        <button class="btn btn-primary has-icon btn-block" type="button" data-toggle="modal" data-target="#threadModal">Thêm Task Mới</button>
                                    </div>
                                    
                                    <div
                                        class="modal fade"
                                        id="threadModal"
                                        tabindex="-1"
                                        role="dialog"
                                        aria-labelledby="threadModalLabel"
                                        aria-hidden="true"
                                        >
                                        <div class="modal-dialog" role="document">
                                            <div class="modal-content">
                                                <form action="createTask" method="post">
                                                    <div class="modal-header d-flex align-items-center bg-primary text-white">
                                                        <h6 class="modal-title mb-0" id="threadModalLabel">
                                                            Thêm Task Mới
                                                        </h6>
                                                        <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                                                    </div>
                                                    <div class="modal-body">
                                                        <div class="form-group">
                                                            <label for="taskContext">Nội dung nhiệm vụ:</label>
                                                            <input type="text" id="taskContext" name="taskContext" class="form-control" placeholder="Ví dụ: Học bài Địa lý chương 3" required /><br/>

                                                            <label for="taskDate">Ngày hết hạn (YYYY-MM-DD):</label>
                                                            <input type="date" id="taskDate" name="taskDate" class="form-control" required min="<%= java.time.LocalDate.now() %>" /><br/>


                                                            <label for="taskTime">Giờ hết hạn (HH:MM):</label>
                                                            <input type="time" id="taskTime" name="taskTime" class="form-control" required /><br/>
                                                            
                                                        </div>
                                                        <div class="modal-footer justify-content-center">
                                                            <button type="button" class="btn btn-light" data-dismiss="modal" >Hủy</button>
                                                            <input class="btn btn-primary" type="submit" value="Thêm Task" />
                                                        </div>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </main></div>
    <a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>

    <script src="assets/vendor/apexcharts/apexcharts.min.js"></script>
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
</body>
<%
    }
%>
<jsp:include page="footer.jsp"></jsp:include>
<script type="text/javascript"></script>