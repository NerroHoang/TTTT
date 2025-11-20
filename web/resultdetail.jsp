<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
<%@ page import="model.QuestionBank" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collections" %>

<jsp:include page="header.jsp"></jsp:include>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        var container = document.getElementById("tagID");
        if (container) {
            var current = container.getElementsByClassName("active");
            if (current.length > 0) {
                current[0].className = current[0].className.replace(" active", "");
            }
            var tag = container.getElementsByClassName("tag");
            if (tag.length > 2) tag[2].className += " active";
        }
    });
</script>

<style>
    /* 1. Cấu trúc chung */
    body {
        background-color: #f4f6f9;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        color: #333;
    }

    .review-container {
        max-width: 900px;
        margin: 0 auto;
        padding-bottom: 50px;
    }

    /* 2. Card câu hỏi */
    .review-card {
        background: #fff;
        border-radius: 12px;
        border: 1px solid #e0e0e0;
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        margin-bottom: 30px;
        overflow: hidden;
        transition: transform 0.2s;
    }

    .review-card.correct {
        border-left: 5px solid #28a745; /* Vạch xanh bên trái nếu đúng */
    }

    .review-card.wrong {
        border-left: 5px solid #dc3545; /* Vạch đỏ bên trái nếu sai */
    }

    /* 3. Header câu hỏi */
    .review-header {
        padding: 15px 20px;
        background-color: #fff;
        border-bottom: 1px solid #f0f0f0;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .question-status {
        font-weight: 700;
        font-size: 0.9rem;
        text-transform: uppercase;
        padding: 5px 12px;
        border-radius: 20px;
    }

    .status-correct {
        color: #155724;
        background-color: #d4edda;
    }

    .status-wrong {
        color: #721c24;
        background-color: #f8d7da;
    }

    /* 4. Nội dung câu hỏi */
    .review-body {
        padding: 20px;
    }

    .question-text {
        font-size: 1.1rem;
        font-weight: 600;
        margin-bottom: 20px;
        color: #2c3e50;
    }

    .question-img {
        max-width: 100%;
        height: auto;
        border-radius: 8px;
        border: 1px solid #eee;
        margin-bottom: 20px;
        display: block;
    }

    /* 5. Đáp án (Options) */
    .option-item {
        display: flex;
        align-items: center;
        padding: 12px 15px;
        margin-bottom: 10px;
        border: 1px solid #e9ecef;
        border-radius: 8px;
        position: relative;
    }

    .option-letter {
        width: 30px;
        height: 30px;
        border-radius: 50%;
        background-color: #f1f3f5;
        color: #495057;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 15px;
        font-weight: bold;
        flex-shrink: 0;
    }

    /* Styles cho các trạng thái đáp án */
    /* Đáp án ĐÚNG (Của hệ thống) */
    .option-item.is-correct-answer {
        border-color: #28a745;
        background-color: #f0fff4;
        color: #155724;
    }
    .option-item.is-correct-answer .option-letter {
        background-color: #28a745;
        color: white;
    }
    
    /* Đáp án SAI (Người dùng chọn nhầm) */
    .option-item.user-selected-wrong {
        border-color: #dc3545;
        background-color: #fff5f5;
        color: #721c24;
    }
    .option-item.user-selected-wrong .option-letter {
        background-color: #dc3545;
        color: white;
    }

    /* Icon trạng thái ở cuối dòng option */
    .status-icon {
        margin-left: auto;
        font-size: 1.2rem;
    }

    /* 6. Giải thích */
    .explain-box {
        margin-top: 20px;
        padding: 15px;
        background-color: #fff3cd;
        border: 1px solid #ffeeba;
        border-radius: 8px;
        color: #856404;
    }
    
    .explain-title {
        font-weight: 700;
        margin-bottom: 5px;
        display: flex;
        align-items: center;
    }

    .btn-back-custom {
        background-color: #6c757d;
        color: white;
        border-radius: 25px;
        padding: 10px 25px;
        font-weight: 600;
        transition: 0.3s;
        text-decoration: none;
        display: inline-block;
    }
    .btn-back-custom:hover {
        background-color: #5a6268;
        color: white;
        transform: translateY(-2px);
    }
</style>

<%
    if(session.getAttribute("test") != null){
        Tests test = (Tests)session.getAttribute("test");
        List<StudentChoice> studentChoices = new StudentExamDAO().getAllSelectedChoice(test.getTestID());
        List<QuestionBank> qbs = new ExamDAO().getAllQuestionByExamID(test.getExamID());
        long seed = test.getSeed();

        HashMap<Integer, String> selectedChoicesMap = new HashMap<>();
        for (StudentChoice studentChoice : studentChoices) {
            selectedChoicesMap.put(studentChoice.getQuestionID(), studentChoice.getSelectedChoice());
        }
%>

<div class="container review-container">
    <br>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0 fw-bold text-primary">Kết quả bài thi</h2>
        <a href="testhistory.jsp" class="btn-back-custom">
            <i class="bi bi-arrow-left me-2"></i> Quay lại lịch sử
        </a>
    </div>

    <%
        int number = -1;
        for(int i = 0; i < qbs.size(); i++){
            QuestionBank qb = qbs.get(i);
            String selectedChoice = selectedChoicesMap.get(qb.getQuestionId());
            
            List<Choice> choices = new ArrayList<>();
            choices.add(new Choice(qb.getChoice1()));
            choices.add(new Choice(qb.getChoice2()));
            choices.add(new Choice(qb.getChoice3()));
            choices.add(new Choice(qb.getChoiceCorrect()));
            Collections.shuffle(choices, new Random(seed + i));
            
            number++;
            
            // Logic kiểm tra đúng sai
            boolean isSkipped = (selectedChoice == null);
            boolean isWrong = isSkipped || !selectedChoice.equals(qb.getChoiceCorrect());
    %>

    <div class="review-card <%= isWrong ? "wrong" : "correct" %>">
        
        <div class="review-header">
            <span class="fw-bold fs-5 text-secondary">Câu hỏi <%=number + 1%></span>
            <% if(isWrong) { %>
                <span class="question-status status-wrong"><i class="bi bi-x-circle me-1"></i> Sai / Chưa làm</span>
            <% } else { %>
                <span class="question-status status-correct"><i class="bi bi-check-circle me-1"></i> Chính xác</span>
            <% } %>
        </div>

        <div class="review-body">
            <p class="question-text"><%=qb.getQuestionContext()%></p>
            
            <% if(qb.getQuestionImg() != null){ %>
                <div class="text-center">
                    <img src="<%=qb.getQuestionImg()%>" class="question-img" alt="Question Image"/>
                </div>
            <% } %>

            <div class="option-list">
                <%
                    for (int j = 0; j < choices.size(); j++) {
                        Choice choice = choices.get(j);
                        char letter = (char)('A' + j);
                        
                        boolean isUserSelected = (selectedChoice != null && selectedChoice.equals(choice.getChoice()));
                        boolean isCorrectAnswer = choice.getChoice().equals(qb.getChoiceCorrect());
                        
                        // Xác định class CSS cho option này
                        String optionClass = "";
                        String iconHtml = "";

                        if (isCorrectAnswer) {
                            // Đây là đáp án đúng của đề -> Luôn tô xanh
                            optionClass = "is-correct-answer";
                            iconHtml = "<i class='bi bi-check-lg text-success status-icon'></i>";
                        } else if (isUserSelected && !isCorrectAnswer) {
                            // Đây là đáp án user chọn sai -> Tô đỏ
                            optionClass = "user-selected-wrong";
                            iconHtml = "<i class='bi bi-x-lg text-danger status-icon'></i>";
                        }
                %>
                    <div class="option-item <%= optionClass %>">
                        <span class="option-letter"><%=letter%></span>
                        
                        <div class="flex-grow-1">
                            <% if(choice.getChoice().startsWith("uploads/docreader")){ %>
                                <img src="<%=choice.getChoice()%>" style="max-height: 80px; border-radius: 4px;" alt="Option Image"/>
                            <% } else { %>
                                <span><%=choice.getChoice()%></span>
                            <% } %>
                            
                            <% if(isUserSelected) { %>
                                <span class="badge bg-secondary ms-2" style="font-size: 0.7rem;">Bạn chọn</span>
                            <% } %>
                        </div>
                        
                        <%= iconHtml %>
                    </div>
                <% } %>
            </div>

            <div class="explain-box">
                <div class="explain-title">
                    <i class="bi bi-lightbulb-fill me-2"></i> Giải thích:
                </div>
                <div><%=qb.getExplain()%></div>
                <% if(qb.getExplainImg() != null){ %>
                    <div class="mt-2">
                        <img src="<%=qb.getExplainImg()%>" class="img-fluid rounded border" style="max-height: 200px;" alt="Explain Image"/>
                    </div>
                <% } %>
            </div>

        </div>
    </div>
    <%
        }
    %>
    
    <div class="text-center mt-4">
        <a href="testhistory.jsp" class="btn btn-primary btn-lg px-5 rounded-pill shadow">
            Hoàn tất xem lại
        </a>
    </div>
</div>

<%
    }
%>

<jsp:include page="footer.jsp"></jsp:include>
<a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>