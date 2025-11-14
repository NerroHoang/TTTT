<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Flashcards View</title>
        <!-- Thêm Bootstrap CSS cho giao diện đẹp và responsive -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Thêm font-awesome để sử dụng biểu tượng -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <!-- Thêm CSS của bạn -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/view_flashcards.css">
    </head>
    <body>
        <div class="header">
            <%@include file="../header.jsp" %>            
        </div>
        <div class="container mt-5">
            <a class="btn btn-primary" style="background-color:blue ; margin-right: 5%" href="${pageContext.request.contextPath}/MySectionsController" >
                Trở về
            </a>
            <!-- Tiêu đề -->
            <h2 class="text-center mb-4">${section.title}</h2>

            <!-- Flashcards Container -->
            <div id="flashcard-container" class="flashcard-container fade-in">
                <div class="flashcard">
                    <div class="flashcard-content front" id="flashcard-front"></div>
                    <div class="flashcard-content back" id="flashcard-back"></div>
                </div>
            </div>

            <!-- Thông tin thứ tự câu hỏi -->
            <div class="text-center mt-3">
                <span id="current-index">1</span>/<span id="total-count">0</span>
            </div>

            <!-- Nút điều hướng -->
            <div class="nav-buttons d-flex justify-content-center gap-2 mt-4">
                <button id="prev-btn" class="btn btn-secondary fs-4"><i class="fa-solid fa-chevron-left"></i> Trước</button>
                <button id="next-btn" class="btn btn-secondary fs-4">Tiếp <i class="fa-solid fa-chevron-right"></i></button>
            </div>
        </div>

        <!-- Danh sách flashcards dưới dạng bảng -->
        <div class="container mt-5">
            <h4 class="text-center">Danh sách Flashcards</h4>
            <table class="flashcard-table">
                <thead>
                    <tr>
                        <th>Câu hỏi</th>
                        <th>Trả lời</th>
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
        <!-- Thêm jQuery và Bootstrap JS -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <!-- JavaScript điều khiển flashcard -->
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
                const flashcard = flashcards[currentIndex];
                flashcardFront.textContent = flashcard.question;
                flashcardBack.textContent = flashcard.answer;

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

            // Hiển thị flashcard đầu tiên
            showFlashcard();
        </script>
    </body>
</html>