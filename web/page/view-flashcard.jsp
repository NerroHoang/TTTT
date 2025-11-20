<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Flashcards View</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/view_flashcards.css">
        
        <style>
            /* Màu chủ đạo */
            :root {
                --thi247-primary: #17a2b8; /* Xanh ngọc */
                --thi247-secondary: #007bff; /* Xanh dương */
                --thi247-light-blue: #e0f2f7; /* Nền xanh nhạt */
                --thi247-text-dark: #343a40;
                --thi247-text-muted: #6c757d;
            }

            /* 1. Màu nền Body (ĐÃ CHỈNH SỬA) */
            body {
                background-color: var(--thi247-light-blue); /* Áp dụng màu xanh nhạt đồng bộ */
                padding-bottom: 50px;
            }
            .container {
                max-width: 900px;
            }
            
            /* 2. Thiết kế Flashcard */
            #flashcard-container {
                perspective: 1000px; 
                height: 350px; 
                margin: 40px auto;
                max-width: 600px;
            }
            
            .flashcard {
                position: relative;
                width: 100%;
                height: 100%;
                text-align: center;
                transition: transform 0.8s;
                transform-style: preserve-3d;
                cursor: pointer;
                border-radius: 15px;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
            }

            .flashcard.flipped {
                transform: rotateY(180deg);
            }

            .flashcard-content {
                position: absolute;
                width: 100%;
                height: 100%;
                backface-visibility: hidden;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 30px;
                font-size: 1.5rem;
                font-weight: 600;
                border-radius: 15px;
                border: 1px solid #ccc;
                box-sizing: border-box;
            }

            .front {
                background-color: #ffffff;
                color: var(--thi247-text-dark);
            }

            .back {
                background-color: var(--thi247-primary); 
                color: white;
                transform: rotateY(180deg);
            }
            
            /* 3. Nút Điều hướng */
            .nav-buttons button {
                width: 150px;
                padding: 10px 20px;
                font-size: 1.1rem !important;
                font-weight: 700;
                border-radius: 25px;
                transition: all 0.3s ease;
            }
            #prev-btn, #next-btn {
                background-color: var(--thi247-secondary) !important;
                border-color: var(--thi247-secondary) !important;
            }
            #prev-btn:hover, #next-btn:hover {
                background-color: #0056b3 !important;
                border-color: #0056b3 !important;
            }
            
            /* 4. Bảng danh sách */
            .flashcard-table {
                width: 100%;
                border-collapse: separate;
                border-spacing: 0;
                margin-top: 20px;
                border-radius: 10px;
                overflow: hidden; 
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            }
            .flashcard-table th {
                background-color: var(--thi247-primary);
                color: white;
                padding: 12px 15px;
                font-weight: 700;
                text-align: left;
            }
            .flashcard-table td {
                background-color: white;
                padding: 10px 15px;
                border-bottom: 1px solid #eee;
            }
            .flashcard-table tbody tr:hover td {
                background-color: #f8f8f8;
            }
        </style>
    </head>
    <body>
        <div class="header">
            <%@include file="../header.jsp" %>            
        </div>
        <div class="container mt-5">
            <a class="btn btn-primary fs-5" style="background-color:var(--thi247-secondary) !important; border-color:var(--thi247-secondary) !important;" 
               href="${pageContext.request.contextPath}/SectionsController?action=get" >
                <i class="fa-solid fa-arrow-left me-2"></i> Trở về Học phần
            </a>
            
            <h2 class="text-center mb-4 mt-4" style="color: var(--thi247-primary); font-weight: 700;">Học phần: ${section.title}</h2>

            <div id="flashcard-container" class="flashcard-container fade-in">
                <div class="flashcard">
                    <div class="flashcard-content front" id="flashcard-front"></div>
                    <div class="flashcard-content back" id="flashcard-back"></div>
                </div>
            </div>

            <div class="text-center mt-3 fs-5" style="font-weight: 600; color: var(--thi247-text-muted);">
                <span id="current-index">1</span>/<span id="total-count">0</span>
            </div>

            <div class="nav-buttons d-flex justify-content-center gap-4 mt-4">
                <button id="prev-btn" class="btn btn-secondary"><i class="fa-solid fa-chevron-left me-2"></i> Trước</button>
                <button id="next-btn" class="btn btn-secondary">Tiếp <i class="fa-solid fa-chevron-right ms-2"></i></button>
            </div>
        </div>

        <div class="container mt-5">
            <h4 class="text-center mb-3" style="color: var(--thi247-secondary); font-weight: 700;">Danh sách Flashcards</h4>
            <table class="flashcard-table">
                <thead>
                    <tr>
                        <th style="width: 50%;">Câu hỏi</th>
                        <th style="width: 50%;">Trả lời</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="card" items="${flashcards}">
                        <tr>
                            <td>${card.question}</td>
                            <td>${card.answer}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <div class="footer">
            <%@ include file="../footer.jsp" %>
        </div>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            // Flashcards được lấy từ server
            const flashcards = [
            <c:forEach var="flashcard" items="${flashcards}">
                {question: "${flashcard.question}", answer: "${flashcard.answer}"},
            </c:forEach>
            ];

            let currentIndex = 0;
            const flashcardContainer = document.getElementById("flashcard-container");
            const flashcardFront = document.getElementById("flashcard-front");
            const flashcardBack = document.getElementById("flashcard-back");
            const flashcardElement = document.querySelector(".flashcard");

            // Các phần tử hiển thị số thứ tự
            const currentIndexElement = document.getElementById("current-index");
            const totalCountElement = document.getElementById("total-count");

            // Đặt tổng số flashcards
            totalCountElement.textContent = flashcards.length;

            // Hiển thị flashcard
            function showFlashcard() {
                if (flashcards.length === 0) {
                     flashcardFront.textContent = "Không có thẻ nào trong học phần này.";
                     flashcardBack.textContent = "Không có thẻ nào trong học phần này.";
                     return;
                }
                
                const flashcard = flashcards[currentIndex];
                flashcardFront.innerHTML = flashcard.question; 
                flashcardBack.innerHTML = flashcard.answer;

                // Cập nhật số thứ tự
                currentIndexElement.textContent = currentIndex + 1;

                // Đặt lại trạng thái không lật thẻ
                if (flashcardElement.classList.contains("flipped")) {
                    flashcardElement.classList.remove("flipped");
                }

                // Hiệu ứng chuyển tiếp
                flashcardContainer.classList.remove("fade-in");
                setTimeout(() => {
                    flashcardContainer.classList.add("fade-in");
                }, 50);
            }

            // Xử lý lật flashcard
            flashcardContainer.addEventListener("click", () => {
                flashcardElement.classList.toggle("flipped");
            });

            // Xử lý nút điều hướng
            document.getElementById("next-btn").addEventListener("click", () => {
                if (currentIndex < flashcards.length - 1) {
                    currentIndex++;
                    showFlashcard();
                }
            });

            document.getElementById("prev-btn").addEventListener("click", () => {
                if (currentIndex > 0) {
                    currentIndex--;
                    showFlashcard();
                }
            });

            // Hiển thị flashcard đầu tiên khi load
            if (flashcards.length > 0) {
                showFlashcard();
            } else {
                showFlashcard(); // Hiển thị thông báo không có thẻ
                document.getElementById("next-btn").disabled = true;
                document.getElementById("prev-btn").disabled = true;
            }
        </script>
    </body>
</html>