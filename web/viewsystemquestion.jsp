<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
<jsp:include page="header.jsp"></jsp:include>

<style>
    /* --- Style đồng bộ UI/UX --- */
    body {
        background-color: #f0f2f5;
    }

    .page-header-custom {
        background: linear-gradient(135deg, #0d6efd 0%, #0a58ca 100%);
        padding: 60px 0;
        margin-bottom: -40px; /* Đẩy nội dung lên đè header 1 chút */
        padding-bottom: 80px;
        border-radius: 0 0 20px 20px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        color: white;
    }

    .card-table {
        border: none;
        border-radius: 15px;
        box-shadow: 0 0 20px rgba(0,0,0,0.05);
        overflow: hidden;
        background: white;
        margin-top: -40px; /* Kéo lên đè header */
    }

    /* Table Styles */
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

    /* Nút hành động */
    .btn-action-icon {
        width: 35px;
        height: 35px;
        border-radius: 50%;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        transition: all 0.2s;
        border: none;
    }
    
    .btn-view {
        background-color: #e7f1ff;
        color: #0d6efd;
    }
    .btn-view:hover {
        background-color: #0d6efd;
        color: white;
        transform: translateY(-2px);
    }

    .btn-back-custom {
        background-color: white;
        color: #333;
        border: 1px solid #ddd;
        border-radius: 50px;
        padding: 8px 20px;
        font-weight: 500;
        text-decoration: none;
        transition: all 0.2s;
        display: inline-flex;
        align-items: center;
    }
    .btn-back-custom:hover {
        background-color: #f8f9fa;
        color: #0d6efd;
        border-color: #0d6efd;
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
    List<QuestionBank> qbs = (List<QuestionBank>)session.getAttribute("questionList");
    session.setAttribute("backlink", "teacher.jsp");
%>

<div class="container-fluid page-header-custom text-center">
    <h1 class="display-5 fw-bold mb-2">Ngân hàng câu hỏi hệ thống</h1>
    <p class="lead opacity-75 mb-0">Danh sách toàn bộ câu hỏi có sẵn để tạo đề thi</p>
</div>

<main id="main" class="container pb-5">
    <section class="section">
        <div class="row justify-content-center">
            <div class="col-lg-12">
                
                <div class="card card-table">
                    <div class="card-header bg-white py-3 border-bottom-0 d-flex justify-content-between align-items-center">
                        <h5 class="m-0 fw-bold text-primary">
                            <i class="bi bi-database me-2"></i>Tổng số câu hỏi: <%= (qbs != null) ? qbs.size() : 0 %>
                        </h5>
                        <a href="questionbank.jsp" class="btn-back-custom">
                            <i class="bi bi-arrow-left me-2"></i> Trở về
                        </a>
                    </div>

                    <div class="card-body p-0">
                        <% if(qbs != null && qbs.size() > 0){ %>
                        <div class="table-responsive">
                            <table class="table table-hover mb-0 datatable">
                                <thead>
                                    <tr>
                                        <th style="width: 40%;">Câu hỏi</th>
                                        <th style="width: 40%;">Đáp án đúng</th>
                                        <th style="width: 20%;" class="text-center">Tác vụ</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                    String context;
                                    String answer;
                                    for(int i = 0; i < qbs.size(); i++){
                                        QuestionBank qb = qbs.get(i);
                                        
                                        // Xử lý hiển thị text ngắn gọn
                                        if(qb.getQuestionContext().length() > 60) 
                                            context = qb.getQuestionContext().substring(0, 60) + "...";
                                        else 
                                            context = qb.getQuestionContext();

                                        if(qb.getChoiceCorrect().length() > 40) 
                                            answer = qb.getChoiceCorrect().substring(0, 40) + "...";
                                        else 
                                            answer = qb.getChoiceCorrect();
                                    %>
                                    <tr>
                                        <td>
                                            <span class="fw-medium text-dark"><%=context%></span>
                                        </td>

                                        <td>
                                            <span class="text-success"><i class="bi bi-check-circle-fill me-1" style="font-size: 0.8rem;"></i><%=answer%></span>
                                        </td>

                                        <td class="text-center">
                                            <form action="ViewQuestionDetail" method="POST" class="d-inline">
                                                <input type="hidden" name="questionID" value="<%=qb.getQuestionId()%>">
                                                <button type="submit" class="btn-action-icon btn-view" title="Xem chi tiết">
                                                    <i class="bi bi-eye"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>
                        <% } else { %>
                            <div class="text-center py-5">
                                <i class="bi bi-inbox display-1 text-muted opacity-25"></i>
                                <h4 class="mt-3 text-secondary">Không có dữ liệu câu hỏi</h4>
                            </div>
                        <% } %>
                    </div>
                </div>

            </div>
        </div>
    </section>
</main>

<script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="assets/vendor/simple-datatables/simple-datatables.js"></script>
<script src="assets/js/main.js"></script>

<script>
    document.addEventListener("DOMContentLoaded", function (event) {
        var scrollpos = localStorage.getItem('scrollpos');
        if (scrollpos) window.scrollTo(0, scrollpos);
    });

    window.onbeforeunload = function (e) {
        localStorage.setItem('scrollpos', window.scrollY);
    };
</script>

<jsp:include page="footer.jsp"></jsp:include>
<a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>