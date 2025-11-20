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
    /* 1. Tổng quan */
    body {
        background-color: #f0f2f5; /* Màu nền xám xanh hiện đại */
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }

    /* 2. Câu hỏi (Cột trái) */
    .question-card {
        border: none;
        border-radius: 12px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        margin-bottom: 25px;
        background: white;
        overflow: hidden;
        transition: transform 0.2s;
    }
    
    .question-header {
        background-color: #fff;
        border-bottom: 1px solid #eee;
        padding: 15px 20px;
        font-weight: 700;
        color: #06BBCC; /* Màu chủ đạo */
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .question-body {
        padding: 20px;
    }

    .question-text {
        font-size: 1.1rem;
        font-weight: 500;
        margin-bottom: 20px;
        color: #333;
    }

    .question-image {
        max-width: 100%;
        height: auto;
        border-radius: 8px;
        border: 1px solid #ddd;
        margin-bottom: 20px;
        display: block;
    }

    /* 3. Các lựa chọn (Options) */
    .option-group {
        display: flex;
        flex-direction: column;
        gap: 10px;
    }

    /* Ẩn radio button mặc định */
    .option-input {
        display: none;
    }

    /* Label đóng vai trò là nút bấm */
    .option-label {
        display: flex;
        align-items: center;
        padding: 12px 15px;
        border: 2px solid #e9ecef;
        border-radius: 8px;
        cursor: pointer;
        transition: all 0.2s ease;
        background: #fff;
    }

    .option-label:hover {
        background-color: #f8f9fa;
        border-color: #ced4da;
    }

    /* Trạng thái khi được chọn */
    .option-input:checked + .option-label {
        border-color: #06BBCC;
        background-color: #e0f2f7;
        color: #007bb5;
        font-weight: 600;
    }

    .option-letter {
        width: 30px;
        height: 30px;
        border-radius: 50%;
        background-color: #eee;
        color: #555;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-right: 15px;
        font-weight: bold;
        font-size: 0.9rem;
    }

    .option-input:checked + .option-label .option-letter {
        background-color: #06BBCC;
        color: white;
    }

    /* 4. Sidebar (Cột phải) */
    .sidebar-sticky {
        position: sticky;
        top: 90px; /* Cách top header một khoảng */
        z-index: 100;
    }

    .timer-card {
        background: #06BBCC;
        color: white;
        border-radius: 12px;
        padding: 15px;
        text-align: center;
        margin-bottom: 20px;
        box-shadow: 0 4px 15px rgba(6, 187, 204, 0.3);
    }

    .timer-display {
        font-size: 2rem;
        font-weight: 800;
        font-family: 'Courier New', Courier, monospace;
    }

    .nav-card {
        background: white;
        border-radius: 12px;
        padding: 15px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }

    .question-palette {
        display: grid;
        grid-template-columns: repeat(5, 1fr);
        gap: 8px;
        margin-top: 15px;
    }

    .palette-item {
        display: flex;
        align-items: center;
        justify-content: center;
        height: 35px;
        border-radius: 5px;
        background-color: #fff;
        border: 1px solid #ddd;
        color: #666;
        text-decoration: none;
        font-size: 0.9rem;
        transition: all 0.2s;
    }

    .palette-item:hover {
        border-color: #06BBCC;
        color: #06BBCC;
    }

    .palette-item.answered {
        background-color: #06BBCC;
        color: white;
        border-color: #06BBCC;
    }

    .btn-submit {
        width: 100%;
        padding: 12px;
        font-size: 1.1rem;
        font-weight: bold;
        border-radius: 30px;
        margin-top: 20px;
        box-shadow: 0 4px 10px rgba(0,0,0,0.1);
    }

    /* Responsive ảnh trong option */
    .option-img {
        max-height: 100px;
        border-radius: 5px;
        border: 1px solid #ddd;
    }
</style>

<%
    if(session.getAttribute("examID") != null){
        int examID = (Integer)session.getAttribute("examID");
        Users user = (Users)session.getAttribute("currentUser");
        Tests test = (Tests)session.getAttribute("test");
        List<StudentChoice> studentChoices = new StudentExamDAO().getAllSelectedChoice(test.getTestID());
        Exam currentExam = new ExamDAO().getExamByID(examID);
        List<QuestionBank> qbs = new ExamDAO().getAllQuestionByExamID(examID);
        long seed = (Long)session.getAttribute("seed");

        HashMap<Integer, String> selectedChoicesMap = new HashMap<>();
        for (StudentChoice studentChoice : studentChoices) {
            selectedChoicesMap.put(studentChoice.getQuestionID(), studentChoice.getSelectedChoice());
        }
%>

<div class="container-xxl py-4">
    <form id="examForm" action="SubmitTest" method="post">
        <input type="hidden" name="numberOfQuestion" value="<%=qbs.size()%>"/>
        <input type="hidden" name="testID" value="<%=test.getTestID()%>"/>
        <input type="hidden" name="examID" value="<%=examID%>"/>
        <input id="timeLeft" type="hidden" name="timeLeft" value="<%=test.getTimeLeft()%>"/>

        <div class="row">
            <div class="col-lg-9 col-md-12">
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
                %>
                
                <div class="question-card" id="q-card-<%=number%>">
                    <div class="question-header">
                        <span><i class="bi bi-question-circle-fill me-2"></i>Câu hỏi <%=number + 1%></span>
                        </div>
                    
                    <div class="question-body">
                        <p class="question-text"><%=qb.getQuestionContext()%></p>
                        <input type="hidden" name="question<%=number%>" value="<%=qb.getQuestionId()%>"/>

                        <% if(qb.getQuestionImg() != null){ %>
                            <div class="text-center">
                                <img src="<%=qb.getQuestionImg()%>" class="question-image" alt="Question Image"/>
                            </div>
                        <% } %>

                        <div class="option-group">
                            <%
                                for (int j = 0; j < choices.size(); j++) {
                                    Choice choice = choices.get(j);
                                    char letter = (char)('A' + j);
                                    boolean isSelected = selectedChoice != null && selectedChoice.equals(choice.getChoice());
                            %>
                                <div>
                                    <input class="option-input" 
                                           onclick="onOptionClick(<%=number%>)" 
                                           type="radio" 
                                           name="answer<%=number%>" 
                                           id="opt-<%=number%>-<%=j%>" 
                                           value="<%=choice.getChoice()%>" 
                                           <%if(isSelected){%>checked<%}%>
                                    />
                                    <label class="option-label" for="opt-<%=number%>-<%=j%>">
                                        <span class="option-letter"><%=letter%></span>
                                        
                                        <% if(choice.getChoice().startsWith("uploads/docreader")){ %>
                                            <img src="<%=choice.getChoice()%>" class="option-img" alt="Option Image"/>
                                        <% } else { %>
                                            <span class="option-content"><%=choice.getChoice()%></span>
                                        <% } %>
                                    </label>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>

            <div class="col-lg-3 col-md-12">
                <div class="sidebar-sticky">
                    <div class="timer-card">
                        <div class="small text-uppercase opacity-75 mb-1">Thời gian còn lại</div>
                        <div id="timer" class="timer-display">00:00</div>
                    </div>

                    <div class="nav-card">
                        <h6 class="fw-bold text-center mb-0">Danh sách câu hỏi</h6>
                        <hr class="my-2">
                        <div class="question-palette">
                            <% for(int k = 0; k <= number; k++) { 
                                // Kiểm tra xem câu hỏi đã được trả lời chưa để add class 'answered'
                                boolean isAnswered = false;
                                // Logic đơn giản kiểm tra từ map (cho lần load đầu tiên)
                                // Logic JS sẽ xử lý cập nhật real-time
                                if(qbs.size() > k) {
                                    int qId = qbs.get(k).getQuestionId();
                                    if(selectedChoicesMap.containsKey(qId)) isAnswered = true;
                                }
                            %>
                                <a href="#q-card-<%=k%>" id="nav-item-<%=k%>" class="palette-item <%= isAnswered ? "answered" : "" %>">
                                    <%=k + 1%>
                                </a>
                            <% } %>
                        </div>
                        
                        <div class="mt-3 small text-muted d-flex justify-content-between">
                            <span><span class="badge bg-secondary me-1">&nbsp;</span> Chưa làm</span>
                            <span><span class="badge bg-info me-1">&nbsp;</span> Đã làm</span>
                        </div>

                        <input type="submit" class="btn btn-primary btn-submit" value="Nộp bài thi" onclick="return confirm('Bạn có chắc chắn muốn nộp bài không?');"/>
                    </div>
                </div>
            </div>
        </div>
    </form>
</div>

<script>
    // --- TIMER LOGIC ---
    var countdownTime = <%=test.getTimeLeft()%>; 
    let timeLeftInput = document.getElementById("timeLeft");
    var timerElement = document.getElementById('timer');

    function updateTimer() {
        var minutes = Math.floor(countdownTime / 60);
        var seconds = countdownTime % 60;
        
        // Cập nhật giao diện
        timerElement.innerHTML = ('0' + minutes).slice(-2) + ':' + ('0' + seconds).slice(-2);
        
        // Đổi màu timer khi sắp hết giờ (dưới 1 phút)
        if(countdownTime < 60) {
            document.querySelector('.timer-card').style.backgroundColor = '#dc3545'; // Màu đỏ
        }

        countdownTime--;
        timeLeftInput.value = countdownTime;

        if (countdownTime < 0) {
            clearInterval(timerInterval);
            timeLeftInput.value = 0;
            document.getElementById('examForm').submit();
        }
    }
    var timerInterval = setInterval(updateTimer, 1000);

    // --- UI INTERACTION LOGIC ---

    // Hàm gọi khi click chọn đáp án
    function onOptionClick(questionIndex) {
        // 1. Cập nhật màu sắc trên Question Palette
        var navItem = document.getElementById('nav-item-' + questionIndex);
        if(navItem) {
            navItem.classList.add('answered');
        }
        // 2. Gọi Auto Save
        autoSave();
    }

    // --- AUTO SAVE LOGIC ---
    window.onbeforeunload = function (event) {
        var formData = new FormData(document.getElementById('examForm'));
        var params = new URLSearchParams(formData);
        var url = 'AutoSaveServlet';
        navigator.sendBeacon(url, params); 
    };

    function autoSave() {
        var formData = new FormData(document.getElementById('examForm'));
        fetch('AutoSaveServlet', {
            method: 'POST',
            body: formData
        })
        .then(response => {
            if (!response.ok) throw new Error('Network response was not ok');
            console.log('Autosave successful!');
        })
        .catch(error => console.error('Error during autosave:', error));
    }
    
    // Autosave định kỳ 10s để đảm bảo an toàn
    setInterval(autoSave, 10000); 
</script>

<%
    }
%>

<jsp:include page="footer.jsp"></jsp:include>
<a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>