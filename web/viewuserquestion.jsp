<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
<jsp:include page="header.jsp"></jsp:include>

<style>
    /* Nền chung */
    body {
        background-color: #f0f2f5;
    }

    /* Tiêu đề trang */
    .page-header-custom {
        background: linear-gradient(135deg, #0d6efd 0%, #0a58ca 100%);
        padding: 60px 0;
        margin-bottom: 30px;
        border-radius: 0 0 20px 20px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    }

    /* Card chứa bảng */
    .card-table {
        border: none;
        border-radius: 15px;
        box-shadow: 0 0 20px rgba(0,0,0,0.05);
        overflow: hidden;
    }

    /* Bảng dữ liệu */
    .table thead th {
        background-color: #f8f9fa;
        border-bottom: 2px solid #dee2e6;
        color: #495057;
        font-weight: 600;
        text-transform: uppercase;
        font-size: 0.85rem;
        padding: 15px;
        vertical-align: middle;
    }

    .table tbody td {
        padding: 15px;
        vertical-align: middle;
        color: #333;
        font-size: 0.95rem;
    }

    /* Hình ảnh trong bảng */
    .img-preview {
        max-width: 100px;
        max-height: 80px;
        border-radius: 8px;
        border: 1px solid #eee;
        object-fit: cover;
        transition: transform 0.2s;
    }
    .img-preview:hover {
        transform: scale(1.5);
        z-index: 10;
        position: relative;
        box-shadow: 0 4px 10px rgba(0,0,0,0.15);
    }

    /* Nút bấm */
    .btn-action {
        border-radius: 50px;
        padding: 6px 15px;
        font-size: 0.85rem;
        font-weight: 600;
        transition: all 0.3s;
        margin: 0 3px;
    }
    
    .btn-view {
        background-color: #e7f1ff;
        color: #0d6efd;
        border: none;
    }
    .btn-view:hover {
        background-color: #0d6efd;
        color: white;
    }

    .btn-delete {
        background-color: #f8d7da;
        color: #dc3545;
        border: none;
    }
    .btn-delete:hover {
        background-color: #dc3545;
        color: white;
    }

    /* Modal */
    .modal-header-custom {
        background-color: #0d6efd;
        color: white;
    }
    .modal-content {
        border-radius: 12px;
        border: none;
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
    Users user = (Users)session.getAttribute("currentUser");
    List<QuestionBank> qbs = new ExamDAO().getAllUserQuestionsByID(user.getUserID());
    session.setAttribute("backlink", "viewuserquestion.jsp");
%>

<div class="container-fluid page-header-custom text-center text-white">
    <h1 class="display-4 fw-bold mb-2">Ngân hàng câu hỏi</h1>
    <p class="lead opacity-75">Quản lý danh sách câu hỏi bạn đã đóng góp</p>
</div>

<main id="main" class="container pb-5">
    <section class="section">
        <div class="row justify-content-center">
            <div class="col-lg-12">
                
                <div class="card card-table">
                    <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center border-bottom-0">
                        <h5 class="m-0 fw-bold text-primary"><i class="bi bi-list-ul me-2"></i>Danh sách câu hỏi (<%=qbs.size()%>)</h5>
                        
                        <div class="d-flex gap-2">
                            <a href="questionbank.jsp" class="btn btn-outline-secondary btn-sm rounded-pill px-3">
                                <i class="bi bi-arrow-left me-1"></i> Trở về
                            </a>
                            <form action="PassDataQuestionAdd" method="POST" class="d-inline">
                                <input type="hidden" name="subjectID" value="subjectID"/>
                                <button type="submit" class="btn btn-primary btn-sm rounded-pill px-3 shadow-sm">
                                    <i class="bi bi-plus-lg me-1"></i> Thêm câu hỏi mới
                                </button>
                            </form>
                        </div>
                    </div>

                    <div class="card-body p-0">
                        <% if(qbs.size() > 0){ %>
                        <div class="table-responsive">
                            <table class="table table-hover mb-0 datatable">
                                <thead>
                                    <tr>
                                        <th style="width: 40%;">Câu hỏi</th>
                                        <th style="width: 30%;">Đáp án đúng</th>
                                        <th style="width: 15%;" class="text-center">Môn học</th>
                                        <th style="width: 15%;" class="text-center">Tác vụ</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                    String context;
                                    String answer;
                                    String subjectName;
                                    for(int i = qbs.size() - 1; i >= 0; i--){
                                        QuestionBank qb = qbs.get(i);
                                        
                                        // Xử lý hiển thị Context
                                        if(qb.getQuestionContext().length() > 60){ 
                                            context = qb.getQuestionContext().substring(0, 60) + "...";
                                        } else if(qb.getQuestionContext().length() == 0){
                                            context = qb.getQuestionImg(); // Nếu ko có text thì lấy ảnh
                                        } else {
                                            context = qb.getQuestionContext();
                                        }

                                        // Xử lý hiển thị Answer
                                        if(qb.getChoiceCorrect().startsWith("uploads/docreader")){
                                            answer = qb.getChoiceCorrect();
                                        } else {
                                            if(qb.getChoiceCorrect().length() > 40) 
                                                answer = qb.getChoiceCorrect().substring(0, 40) + "...";
                                            else answer = qb.getChoiceCorrect();
                                        }
                                        
                                        String modalId = "deleteModal" + i;
                                        String modalDetailId = "detailModal" + i; // ID riêng cho modal detail
                                        subjectName = new SubjectDAO().getSubjectNameById(qb.getSubjectId());
                                    %>
                                    <tr>
                                        <td>
                                            <% if(context.startsWith("uploads/docreader")){ %>
                                                <img src="<%=context%>" class="img-preview" alt="Question Image"/>
                                            <% } else { %>
                                                <span class="fw-medium text-dark"><%=context%></span>
                                            <% } %>
                                        </td>

                                        <td>
                                            <% if(answer.startsWith("uploads/docreader")){ %>
                                                <img src="<%=answer%>" class="img-preview" alt="Answer Image" style="max-height: 50px;"/>
                                            <% } else { %>
                                                <span class="text-success fw-bold"><i class="bi bi-check-circle me-1"></i><%=answer%></span>
                                            <% } %>
                                        </td>

                                        <td class="text-center">
                                            <span class="badge bg-light text-dark border"><%= subjectName %></span>
                                        </td>

                                        <td class="text-center">
                                            <div class="d-flex justify-content-center">
                                                <form action="ViewQuestionDetail" method="POST" class="d-inline">
                                                    <input type="hidden" name="questionID" value="<%=qb.getQuestionId()%>">
                                                    <button type="submit" class="btn-action btn-view" title="Xem chi tiết">
                                                        <i class="bi bi-eye"></i>
                                                    </button>
                                                </form>

                                                <button type="button" class="btn-action btn-delete" data-bs-toggle="modal" data-bs-target="#<%= modalId %>" title="Xóa câu hỏi">
                                                    <i class="bi bi-trash"></i>
                                                </button>
                                            </div>

                                            <div class="modal fade" id="<%= modalId %>" tabindex="-1" aria-hidden="true">
                                                <div class="modal-dialog modal-dialog-centered">
                                                    <div class="modal-content">
                                                        <div class="modal-header bg-danger text-white">
                                                            <h5 class="modal-title"><i class="bi bi-exclamation-triangle-fill me-2"></i>Xác nhận xóa</h5>
                                                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div class="modal-body text-start">
                                                            <p class="mb-0">Bạn có chắc chắn muốn xóa câu hỏi này khỏi ngân hàng câu hỏi không?</p>
                                                            <p class="text-muted small mt-2 mb-0">Hành động này không thể hoàn tác.</p>
                                                        </div>
                                                        <div class="modal-footer bg-light">
                                                            <form action="DeleteQuestionInBank" method="POST">
                                                                <input type="hidden" name="questionID" value="<%=qb.getQuestionId()%>">
                                                                <input type="hidden" name="subjectID" value="<%=qb.getSubjectId()%>">
                                                                <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy bỏ</button>
                                                                <button type="submit" class="btn btn-danger fw-bold">Xóa ngay</button>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } else { %>
                            <div class="text-center py-5">
                                <i class="bi bi-folder2-open display-1 text-muted opacity-25"></i>
                                <h4 class="mt-3 text-secondary">Bạn chưa có câu hỏi nào</h4>
                                <p class="text-muted">Hãy bắt đầu đóng góp câu hỏi cho cộng đồng ngay hôm nay!</p>
                            </div>
                        <% } %>
                    </div>
                </div>
                </div>
        </div>
    </section>
</main>

<script>
    document.addEventListener("DOMContentLoaded", function (event) {
        var scrollpos = localStorage.getItem('scrollpos');
        if (scrollpos) window.scrollTo(0, scrollpos);
    });

    window.onbeforeunload = function (e) {
        localStorage.setItem('scrollpos', window.scrollY);
    };
</script>

<script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="assets/vendor/simple-datatables/simple-datatables.js"></script>
<script src="assets/js/main.js"></script>

<jsp:include page="footer.jsp"></jsp:include>
<a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>