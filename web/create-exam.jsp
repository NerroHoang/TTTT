<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<jsp:include page="header.jsp"></jsp:include>

<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

<style>
    /* 1. Tổng quan */
    body {
        background-color: #f0f2f5;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    .main-container {
        max-width: 1200px;
        margin: 30px auto;
        padding: 0 15px;
    }

    /* 2. Cột trái: Thông tin bài thi (Sticky) */
    .exam-info-card {
        background: white;
        border-radius: 15px;
        padding: 25px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.05);
        position: sticky;
        top: 20px; /* Cố định khi cuộn */
    }

    .form-label {
        font-weight: 600;
        color: #344767;
        margin-bottom: 8px;
    }

    .form-control, .form-select {
        border-radius: 10px;
        padding: 10px 15px;
        border: 1px solid #dee2e6;
    }
    
    .form-control:focus, .form-select:focus {
        border-color: #06BBCC;
        box-shadow: 0 0 0 0.2rem rgba(6, 187, 204, 0.25);
    }

    /* Tùy chỉnh input group (kết hợp input và text 'Coin') */
    .input-group-text {
        border-radius: 0 10px 10px 0;
        background-color: #f8f9fa;
        border: 1px solid #dee2e6;
        color: #6c757d;
    }
    .input-group .form-control {
        border-radius: 10px 0 0 10px;
    }

    /* 3. Cột phải: Danh sách câu hỏi */
    .question-list-container {
        max-height: 80vh;
        overflow-y: auto;
        padding-right: 5px; /* Để thanh cuộn không đè nội dung */
    }

    /* Card câu hỏi nhỏ */
    .question-item-card {
        background: white;
        border-radius: 12px;
        padding: 15px;
        margin-bottom: 15px;
        border: 1px solid #eee;
        transition: all 0.2s;
        cursor: pointer;
        position: relative;
    }

    .question-item-card:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0,0,0,0.05);
    }

    /* Checkbox ẩn, style cả card khi checked */
    .q-checkbox {
        position: absolute;
        top: 15px;
        right: 15px;
        width: 20px;
        height: 20px;
        z-index: 10;
        cursor: pointer;
    }

    .question-item-card.selected {
        border: 2px solid #06BBCC;
        background-color: #f0fbfc;
    }

    .q-content {
        padding-right: 30px; /* Chừa chỗ cho checkbox */
        font-size: 0.95rem;
        font-weight: 500;
        color: #333;
        margin-bottom: 8px;
    }
    
    .q-answer {
        font-size: 0.85rem;
        color: #666;
        background: #f8f9fa;
        padding: 5px 10px;
        border-radius: 6px;
        display: inline-block;
    }

    .q-img-preview {
        max-height: 60px;
        border-radius: 5px;
        border: 1px solid #ddd;
        margin-top: 5px;
    }

    /* 4. Buttons */
    .btn-primary-custom {
        background: linear-gradient(135deg, #06BBCC 0%, #049aa9 100%);
        border: none;
        color: white;
        padding: 12px 20px;
        border-radius: 10px;
        font-weight: 600;
        transition: transform 0.2s;
        width: 100%;
        margin-bottom: 10px;
    }
    
    .btn-primary-custom:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(6, 187, 204, 0.3);
        color: white;
    }

    .btn-outline-custom {
        border: 2px solid #06BBCC;
        color: #06BBCC;
        background: white;
        padding: 10px 20px;
        border-radius: 10px;
        font-weight: 600;
        width: 100%;
        transition: all 0.2s;
    }

    .btn-outline-custom:hover {
        background: #06BBCC;
        color: white;
    }

    /* 5. Modal */
    .modal-content {
        border-radius: 15px;
        border: none;
        overflow: hidden;
    }
    .modal-header {
        background: #06BBCC;
        color: white;
    }
</style>

<%
if(session.getAttribute("subjectID") != null){
    int subjectID = (Integer)session.getAttribute("subjectID");
    Subjects subject = new ExamDAO().getSubjectByID(subjectID);
    List<QuestionBank> qbs = (List<QuestionBank>)session.getAttribute("questionList");
%>

<div class="main-container">
    <a href="choosesubject.jsp" class="text-decoration-none text-secondary mb-3 d-inline-block">
        <i class="bi bi-arrow-left-circle me-1"></i> Quay lại chọn môn
    </a>

    <h3 class="fw-bold text-dark mb-4">
        <span class="text-primary">Tạo bài kiểm tra:</span> <%=subject.getSubjectName()%>
    </h3>

    <c:if test="${not empty error}">
        <div class="alert alert-danger rounded-3 mb-4" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i> ${error}
        </div>
    </c:if>

    <form method="POST" action="CreateExam" id="createExamForm">
        <div class="row g-4">
            <div class="col-lg-4">
                <div class="exam-info-card">
                    <h5 class="fw-bold mb-3 text-secondary"><i class="bi bi-info-circle me-2"></i>Thiết lập chung</h5>
                    
                    <div class="mb-3">
                        <label class="form-label">Tên bài kiểm tra</label>
                        <input type="text" class="form-control" id="examName" name="examName" placeholder="VD: Kiểm tra 15 phút chương 1" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Giá tiền</label>
                        <div class="input-group">
                            <input type="number" class="form-control" name="price" min="0" value="0" required placeholder="Nhập giá tiền">
                            <span class="input-group-text">Coin</span>
                        </div>
                        <div class="form-text text-muted small">Nhập 0 để miễn phí.</div>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Thời gian làm bài</label>
                        <div class="row g-2">
                            <div class="col-6">
                                <div class="input-group">
                                    <input type="number" min="0" class="form-control" name="examHours" placeholder="0" required>
                                    <span class="input-group-text bg-light">Giờ</span>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="input-group">
                                    <input type="number" min="0" class="form-control" name="examMinutes" placeholder="0" required>
                                    <span class="input-group-text bg-light">Phút</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <hr class="my-4">

                    <button type="submit" class="btn-primary-custom mb-3">
                        <i class="bi bi-check-lg me-2"></i> Hoàn tất tạo bài
                    </button>
                    
                    <button type="button" class="btn-outline-custom" data-bs-toggle="modal" data-bs-target="#randomExamModal">
                        <i class="bi bi-shuffle me-2"></i> Tạo đề ngẫu nhiên
                    </button>
                </div>
            </div>

            <div class="col-lg-8">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h5 class="fw-bold text-secondary mb-0">
                        <i class="bi bi-list-check me-2"></i>Ngân hàng câu hỏi (<%=qbs.size()%>)
                    </h5>
                    <small class="text-muted">Chọn các câu hỏi bên dưới</small>
                </div>

                <div class="question-list-container">
                    <%
                        for(int i = qbs.size() - 1; i >= 0; i--){
                            QuestionBank qb = qbs.get(i);
                            String context = qb.getQuestionContext();
                            String answer = qb.getChoiceCorrect();
                            String modalDetailId = "modalDetail" + i;
                            
                            // Xử lý hiển thị text ngắn gọn
                            String displayContext = (context.length() > 100) ? context.substring(0, 100) + "..." : context;
                            if(displayContext.isEmpty()) displayContext = "(Câu hỏi dạng hình ảnh)";
                    %>
                    
                    <div class="question-item-card" onclick="toggleSelect(this)">
                        <input type="checkbox" class="q-checkbox form-check-input" name="selectedQuestions" value="<%=qb.getQuestionId()%>" onclick="event.stopPropagation(); toggleCardStyle(this);">
                        
                        <div class="q-content">
                            <span class="fw-bold text-primary me-1">Câu <%=i+1%>:</span> 
                            <%= displayContext %>
                            <% if(context.startsWith("uploads/docreader") || qb.getQuestionImg() != null) { %>
                                <div><img src="<%= context.startsWith("uploads") ? context : qb.getQuestionImg() %>" class="q-img-preview"></div>
                            <% } %>
                        </div>

                        <div class="d-flex justify-content-between align-items-center mt-2">
                            <div class="q-answer">
                                <i class="bi bi-check-circle-fill text-success me-1"></i>
                                Đáp án: 
                                <% if(answer.startsWith("uploads/docreader")) { %>
                                    <img src="<%=answer%>" style="height: 30px;">
                                <% } else { %>
                                    <%= (answer.length() > 50) ? answer.substring(0, 50) + "..." : answer %>
                                <% } %>
                            </div>
                            
                            <button type="button" class="btn btn-sm btn-link text-decoration-none" data-bs-toggle="modal" data-bs-target="#<%=modalDetailId%>" onclick="event.stopPropagation();">
                                Chi tiết <i class="bi bi-chevron-right"></i>
                            </button>
                        </div>
                    </div>

                    <div class="modal fade" id="<%=modalDetailId%>" tabindex="-1" aria-hidden="true">
                        <div class="modal-dialog modal-lg modal-dialog-centered">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <h5 class="modal-title text-white">Chi tiết câu hỏi #<%=qb.getQuestionId()%></h5>
                                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <p><strong>Câu hỏi:</strong> <%=qb.getQuestionContext()%></p>
                                    <% if(qb.getQuestionImg() != null) { %>
                                        <img src="<%=qb.getQuestionImg()%>" class="img-fluid mb-3 rounded" style="max-height: 200px;">
                                    <% } %>
                                    
                                    <hr>
                                    <div class="row g-3">
                                        <div class="col-md-6"><div class="p-2 border rounded bg-light"><strong>A:</strong> <%=qb.getChoice1()%></div></div>
                                        <div class="col-md-6"><div class="p-2 border rounded bg-light"><strong>B:</strong> <%=qb.getChoice2()%></div></div>
                                        <div class="col-md-6"><div class="p-2 border rounded bg-light"><strong>C:</strong> <%=qb.getChoice3()%></div></div>
                                        <div class="col-md-6"><div class="p-2 border rounded bg-light"><strong>D:</strong> <%=qb.getChoiceCorrect()%></div></div>
                                    </div>
                                    
                                    <div class="mt-3 p-3 alert alert-success">
                                        <strong>Đáp án đúng:</strong> <%=qb.getChoiceCorrect()%>
                                    </div>
                                    <div class="p-3 bg-light border rounded">
                                        <strong>Giải thích:</strong> <%=qb.getExplain()%>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <% } %>
                </div>
            </div>
        </div>
    </form>
</div>

<div class="modal fade" id="randomExamModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <form action="CreateRandomExam" method="POST">
                <div class="modal-header">
                    <h5 class="modal-title text-white"><i class="bi bi-magic me-2"></i>Tạo đề ngẫu nhiên</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <% if(qbs.size() > 0){ int max = qbs.size(); %>
                        
                        <div class="mb-3">
                            <label class="form-label">Tên đề thi</label>
                            <input type="text" class="form-control" name="examName" required placeholder="Nhập tên đề thi...">
                        </div>
                        <input type="hidden" name="subjectID" value="<%=subjectID%>"/>

                        <div class="mb-3">
                            <label class="form-label">Thời gian làm bài</label>
                            <div class="row g-2">
                                <div class="col-6">
                                    <div class="input-group">
                                        <input type="number" name="examHours" min="0" class="form-control" required placeholder="0">
                                        <span class="input-group-text">Giờ</span>
                                    </div>
                                </div>
                                <div class="col-6">
                                    <div class="input-group">
                                        <input type="number" name="examMinutes" min="0" class="form-control" required placeholder="0">
                                        <span class="input-group-text">Phút</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Giá tiền</label>
                            <div class="input-group">
                                <input type="number" class="form-control" name="price" min="0" value="0" required placeholder="Nhập giá tiền">
                                <span class="input-group-text">Coin</span>
                            </div>
                            <div class="form-text text-muted small">Nhập 0 để miễn phí.</div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Số lượng câu hỏi (Max: <%=max%>)</label>
                            <input type="number" class="form-control" name="numQuestions" min="1" max="<%=max%>" value="10" required>
                            <div class="form-text">Hệ thống sẽ chọn ngẫu nhiên các câu hỏi từ ngân hàng.</div>
                        </div>

                    <% } else { %>
                        <div class="text-center py-4">
                            <i class="bi bi-inbox display-4 text-muted"></i>
                            <p class="mt-3">Ngân hàng câu hỏi trống!</p>
                        </div>
                    <% } %>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy bỏ</button>
                    <% if(qbs.size() > 0){ %>
                        <button type="submit" class="btn btn-primary" style="background-color: #06BBCC; border:none;">Xác nhận tạo</button>
                    <% } %>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    // Script để click vào card là chọn checkbox
    function toggleSelect(card) {
        var checkbox = card.querySelector('.q-checkbox');
        checkbox.checked = !checkbox.checked;
        toggleCardStyle(checkbox);
    }

    function toggleCardStyle(checkbox) {
        var card = checkbox.closest('.question-item-card');
        if (checkbox.checked) {
            card.classList.add('selected');
        } else {
            card.classList.remove('selected');
        }
    }
</script>

<%
    }
%>

<jsp:include page="footer.jsp"></jsp:include>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>