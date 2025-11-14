<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <title>${section.sectionId == 0 ? "Tạo Học Phần" : "Chỉnh Sửa Học Phần"}</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/create-section.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    </head>
    <body>
        <div class="header">
            <%@include file="../header.jsp" %>

        </div>
        <div class="backs">
            <c:choose>
                <c:when test="${section.sectionId != 0}">
                    <!-- Nếu sectionId không bằng 0, trả về trang MySectionsController -->
                    <a class="btn btn-primary" style="background-color:blue ; margin-top: 7%; margin-left: 5%; margin-bottom: -5%" href="${pageContext.request.contextPath}/MySectionsController?action=get">Trở về</a>
                </c:when>
                <c:otherwise>
                    <!-- Nếu sectionId bằng 0, trả về trang SectionsController -->
                    <a class="btn btn-primary" style="background-color:blue ; margin-top: 7%; margin-left: 5%; margin-bottom: -5%" href="${pageContext.request.contextPath}/SectionsController?action=get">Trở về</a>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="container mt-5">
            <h3 class="text-center">${section.sectionId == 0 ? "Tạo Học Phần Mới" : "Chỉnh Sửa Học Phần"}</h3>

            <!-- Form tạo/chỉnh sửa section -->
            <form action="${pageContext.request.contextPath}/CreateSectionController" method="POST" id="createSectionForm">
                <input type="hidden" name="sectionId" value="${section.sectionId}" />

                <!-- Tiêu đề -->
                <div class="mb-3">
                    <label class="form-label">Tiêu đề</label>
                    <input type="text" name="title" class="form-control" placeholder="Nhập tiêu đề học phần" required value="${section.title}"/>
                </div>

                <!-- Mô tả -->
                <div class="mb-3">
                    <label class="form-label">Mô tả</label>
                    <textarea name="description" class="form-control" rows="3" placeholder="Nhập mô tả" required>${section.description}</textarea>
                </div>

                <!-- Trạng thái -->
                <div class="mb-3">
                    <label class="form-label">Trạng thái</label>
                    <select name="status" class="form-select">
                        <option value="private" ${section.status == "private" ? "selected" : ""}>Riêng tư</option>
                        <option value="public" ${section.status == "public" ? "selected" : ""}>Công khai</option>
                    </select>
                </div>

                <!-- Flashcard -->
                <div id="flashcards-container" class="mb-3">
                    <h5>Flashcards</h5>
                    <c:forEach var="flashcard" items="${flashcards}">
                        <div class="flashcard mb-3">
                            <div class="row">
                                <div class="col-md-5">
                                    <input type="text" name="term[]" class="form-control" placeholder="Thuật ngữ" required value="${flashcard.question}"/>
                                </div>
                                <div class="col-md-5">
                                    <input type="text" name="definition[]" class="form-control" placeholder="Định nghĩa" required value="${flashcard.answer}"/>
                                </div>
                                <div class="col-md-2 text-center">
                                    <button type="button" class="btn btn-danger delete-flashcard"><i class="fa fa-trash"></i></button>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <!-- Nút thêm flashcard -->
                <div class="text-center mb-3">
                    <button type="button" class="btn btn-success" id="addFlashcardBtn"><i class="fa fa-plus"></i> Thêm Flashcard</button>
                </div>

                <!-- Nút submit -->
                <div class="text-center">
                    <button type="submit" class="btn btn-primary">Xác nhận</button>
                </div>
            </form>
        </div>

        <!-- Popup cảnh báo -->
        <div id="noAccessPopup" class="popup-container" style="display: none;">
            <div class="popup-content">
                <h4>Cảnh báo</h4>
                <p>Bạn không có quyền</p>
                <button class="btn btn-secondary" onclick="closePopup()">Đóng</button>
            </div>
        </div>

        <div class="footer">
            <%@ include file="../footer.jsp" %>
        </div>
        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <!-- jQuery để thêm flashcard và xóa -->
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <script>
                    $(document).ready(function () {
                        // Thêm flashcard mới
                        $("#addFlashcardBtn").click(function () {
                            const flashcard = `
                        <div class="flashcard mb-3">
                            <div class="row">
                                <div class="col-md-5">
                                    <input type="text" name="term[]" class="form-control" placeholder="Thuật ngữ" required/>
                                </div>
                                <div class="col-md-5">
                                    <input type="text" name="definition[]" class="form-control" placeholder="Định nghĩa" required/>
                                </div>
                                <div class="col-md-2 text-center">
                                    <button type="button" class="btn btn-danger delete-flashcard"><i class="fa fa-trash"></i></button>
                                </div>
                            </div>
                        </div>`;
                            $("#flashcards-container").append(flashcard);
                        });

                        // Xóa flashcard
                        $(document).on("click", ".delete-flashcard", function () {
                            $(this).closest(".flashcard").remove();
                        });

                        // Hiển thị popup cảnh báo khi không có quyền
            <% if (request.getAttribute("noAccess") != null) { %>
                        document.getElementById("noAccessPopup").style.display = "flex";
            <% } %>
                    });

                    function closePopup() {
                        document.getElementById("noAccessPopup").style.display = "none";
                    }
        </script>

        <!-- Popup CSS -->
        <style>
            .popup-container {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.5);
                display: flex;
                justify-content: center;
                align-items: center;
                z-index: 9999;
            }

            .popup-content {
                background: white;
                padding: 20px;
                border-radius: 10px;
                text-align: center;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            }
        </style>
    </body>
</html>