<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>

<jsp:include page="header.jsp"></jsp:include>

<style>
    .table thead th {
        background: #0d6efd;
        color: white;
        text-align: center;
        vertical-align: middle;
    }

    .table tbody td {
        vertical-align: middle;
        text-align: center;
    }

    .card {
        border-radius: 12px;
        overflow: hidden;
        box-shadow: 0 4px 18px rgba(0, 0, 0, 0.1);
    }

    .btn-primary, .btn-danger, .btn-success {
        border-radius: 6px;
    }

    .badge-status {
        padding: 6px 12px;
        border-radius: 8px;
        font-size: 14px;
    }

    .badge-approved {
        background-color: #28a745;
        color: white;
    }

    .section-filter {
        background: white;
        border-radius: 12px;
        padding: 20px;
        margin-bottom: 25px;
        box-shadow: 0 4px 14px rgba(0,0,0,0.08);
    }
</style>

<script>
    var container = document.getElementById("tagID");
    if (container) {
        var current = container.getElementsByClassName("active");
        if (current.length > 0) {
            current[0].className = current[0].className.replace(" active", "");
        }
    }
</script>

<%
    if (session.getAttribute("currentUser") != null) {
        Users user = (Users) session.getAttribute("currentUser");
        String filter = request.getParameter("filter");
        List<Exam> exams;

        if ("approved".equals(filter)) {
            exams = new ExamDAO().getAllExamIsApprovedByUserID(user.getUserID());
        } else if ("notApproved".equals(filter)) {
            exams = new ExamDAO().getAllExamNotApprovedByUserID(user.getUserID());
        } else {
            exams = new ExamDAO().getAllExamByUserID(user.getUserID());
        }
%>

<!-- HEADER -->
<div class="container-fluid bg-primary py-5 mb-5 page-header">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-10 text-center">
                <h1 class="display-3 text-white animated slideInDown">Bài kiểm tra</h1>
                <h3 class="text-white animated slideInDown">Danh sách bài kiểm tra bạn đã tạo</h3>
            </div>
        </div>
    </div>
</div>

<!-- MAIN -->
<main id="main" class="main" style="margin-left: 0">

    <!-- FILTER SECTION -->
    <section class="section section-filter container">
        <form method="POST" action="ViewAllExamTeacher.jsp">
            <h5 class="mb-3 fw-bold">Lọc bài kiểm tra</h5>
            <div class="d-flex align-items-center flex-wrap">

                <div class="form-check form-check-inline mb-2">
                    <input class="form-check-input" type="radio" name="filter" value="all"
                        <% if (filter == null || "all".equals(filter)) { %> checked <% } %>>
                    <label class="form-check-label">Tất cả</label>
                </div>

                <div class="form-check form-check-inline mb-2">
                    <input class="form-check-input" type="radio" name="filter" value="approved"
                        <% if ("approved".equals(filter)) { %> checked <% } %>>
                    <label class="form-check-label">Đã duyệt</label>
                </div>

                <div class="form-check form-check-inline mb-2">
                    <input class="form-check-input" type="radio" name="filter" value="notApproved"
                        <% if ("notApproved".equals(filter)) { %> checked <% } %>>
                    <label class="form-check-label">Chưa duyệt</label>
                </div>

                <button type="submit" class="btn btn-primary ml-3 px-4">Lọc</button>
            </div>
        </form>
    </section>

    <section class="section container">
        <div class="row">
            <div class="col-lg-12">

                <div class="card">
                    <div class="card-body">

                        <% if (exams.size() > 0) { %>

                        <table class="table table-striped table-hover align-middle">
                            <thead>
                                <tr>
                                    <th>Bài kiểm tra</th>
                                    <th>Môn học</th>
                                    <th>Số câu hỏi</th>
                                    <th>Giá tiền</th>
                                    <th>Thời gian</th>
                                    <th>Ngày đăng</th>
                                    <th>Tác vụ</th>
                                </tr>
                            </thead>

                            <tbody>
                                <%  
                                for (int i = exams.size() - 1; i >= 0; i--) {
                                    Exam exam = exams.get(i);
                                    String subjectName = new ExamDAO().getSubjectByID(exam.getSubjectID()).getSubjectName();
                                    int examAmount = new ExamDAO().getQuestionAmount(exam.getExamID());
                                    int hour = exam.getTimer() / 3600;
                                    int minute = (exam.getTimer() % 3600) / 60;
                                    String modalId = "threadModal" + i;
                                %>

                                <tr>
                                    <td><%= exam.getExamName() %></td>
                                    <td><%= subjectName %></td>
                                    <td><%= examAmount %></td>
                                    <td><%= exam.getPrice() %></td>

                                    <td>
                                        <% if(hour != 0){ %> <%= hour %>h <% } %>
                                        <% if(minute != 0){ %> <%= minute %>p <% } %>
                                    </td>

                                    <td><%= exam.getCreateDate() %></td>

                                    <!-- ACTIONS -->
                                    <td>
                                        <!-- EDIT -->
                                        <form action="PassDataExamUpdate" method="POST" class="d-inline-block">
                                            <input type="hidden" name="examID" value="<%=exam.getExamID()%>">
                                            <button type="submit" class="btn btn-primary btn-sm px-3">Sửa</button>
                                        </form>

                                        <!-- DELETE -->
                                        <button class="btn btn-danger btn-sm px-3"
                                                data-toggle="modal" data-target="#<%= modalId %>">Xoá</button>

                                        <!-- STATUS -->
                                        <% if (exam.isIsAprroved()) { %>
                                            <span class="badge badge-approved badge-status ml-2">Đã duyệt</span>
                                        <% } %>
                                    </td>
                                </tr>

                                <!-- DELETE MODAL -->
                                <div class="modal fade" id="<%= modalId %>" tabindex="-1">
                                    <div class="modal-dialog modal-dialog-centered">
                                        <div class="modal-content">
                                            <form action="DeleteExam" method="POST">
                                                <input type="hidden" name="examID" value="<%=exam.getExamID()%>">

                                                <div class="modal-header bg-primary text-white">
                                                    <h5 class="modal-title">Xác nhận xoá bài kiểm tra?</h5>
                                                </div>

                                                <div class="modal-body text-center">
                                                    <p>Bạn có chắc chắn muốn xoá bài: 
                                                        <b><%= exam.getExamName() %></b>?</p>
                                                </div>

                                                <div class="modal-footer">
                                                    <button class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                                                    <button type="submit" class="btn btn-danger">Xóa</button>
                                                </div>

                                            </form>
                                        </div>
                                    </div>
                                </div>

                                <% } %>
                            </tbody>
                        </table>

                        <% } else { %>
                            <h3 class="text-center my-5">Bạn chưa tạo bài kiểm tra nào!</h3>
                        <% } %>

                    </div>
                </div>

            </div>
        </div>
    </section>

</main>

<jsp:include page="footer.jsp"></jsp:include>

<a href="#" class="back-to-top d-flex align-items-center justify-content-center">
    <i class="bi bi-arrow-up-short"></i>
</a>

<script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="assets/vendor/simple-datatables/simple-datatables.js"></script>
<script src="assets/js/main.js"></script>

<%
    }
%>
