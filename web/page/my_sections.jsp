<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My sections</title>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/my-sections.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">     
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <style>
            .section-delete i {
                cursor: pointer;
                font-size: 1.5rem;
                color: red;
            }
            .status {
                font-weight: bold;
                text-transform: uppercase;
                display: inline-block;
                padding: 3px 10px;
                border-radius: 8px;
                margin-top: 10px;
            }
            .status-public {
                color: white;
                background-color: green;
            }
            .status-private {
                color: white;
                background-color: red;
            }
            .section-card {
                cursor: pointer;
                transition: transform 0.3s;
            }
            .section-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 4px 8px rgba(0,0,0,0.2);
            }
        </style>    </head>
    <body>
        <div class="header">
            <%@include file="../header.jsp" %>            
        </div>
        <a class="btn btn-primary" style="background-color:blue ; margin-top: 7%; margin-left: 5%" href="${pageContext.request.contextPath}/SectionsController?action=get">Trở về</a>

        <div class="section-list">
            <c:forEach var="section" items="${my_sections}">
                <div class="section-card" onclick="redirectToView('${section.sectionId}')">
                    <h4>${section.title}</h4>
                    <p><strong>Created by:</strong> ${section.authorName}</p>
                    <p><strong>Date: </strong><fmt:formatDate value="${section.createdAtAsDate}" pattern="dd/MM/yyyy" /></p>
                    <p><strong>Total Questions:</strong> ${section.numberFlashCard}</p> 
                    <!-- Hiển thị trạng thái public/private -->
                    <div class="status ${section.status == 'public' ? 'status-public' : 'status-private'}">
                        ${section.status == 'public' ? 'Công khai' : 'Riêng tư'}
                    </div>                
                    <div class="footer mt-3">
                        <a href="${pageContext.request.contextPath}/CreateSectionController?sectionId=${section.sectionId}"
                           class="btn btn-primary" onclick="event.stopPropagation();">Edit</a>
                        <div class="section-delete fs-4">
                            <i class="fa-regular fa-trash-can" onclick="showDeletePopup('${section.sectionId}', event)"></i>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- Popup Xác Nhận Xóa -->
        <div id="deletePopup" class="popup-container">
            <div class="popup-content">
                <h4>Xác nhận xóa</h4>
                <p>Bạn có chắc chắn muốn xóa học phần này không?</p>
                <div class="popup-actions">
                    <button class="btn btn-danger" id="confirmDelete">Xóa</button>
                    <button class="btn btn-secondary" onclick="closeDeletePopup()">Hủy</button>
                </div>
            </div>
        </div>

        <!-- Popup Cảnh Báo -->
        <div id="warningPopup" class="popup-container">
            <div class="popup-content">
                <h4>Cảnh báo</h4>
                <p>Bạn không có quyền xóa học phần này.</p>
                <button class="btn btn-secondary" onclick="closePopup('warningPopup')">Đóng</button>
            </div>
        </div>

        <!-- Popup Xóa Thành Công -->
        <div id="successPopup" class="popup-container">
            <div class="popup-content">
                <h4>Thành công</h4>
                <p>Xóa học phần thành công!</p>
                <button class="btn btn-secondary" onclick="closePopup('successPopup')">Đóng</button>
            </div>
        </div>

        <!-- Hiển thị popup từ session -->
        <%
            Boolean notPremium = (Boolean) session.getAttribute("notPremium");
            Boolean deleteSuccess = (Boolean) session.getAttribute("deleteSuccess");

            if (Boolean.TRUE.equals(notPremium)) {
                session.removeAttribute("notPremium");
        %>
        <script>document.getElementById('warningPopup').style.display = 'flex';</script>
        <%
            }
            if (Boolean.TRUE.equals(deleteSuccess)) {
                session.removeAttribute("deleteSuccess");
        %>
        <script>document.getElementById('successPopup').style.display = 'flex';</script>
        <%
            }
        %>

        <div class="footer">
            <%@ include file="../footer.jsp" %>
        </div>
        <!-- JavaScript -->
        <script>
            let sectionIdToDelete = null;

            function redirectToView(sectionId) {
                window.location.href = '${pageContext.request.contextPath}/ViewFlashcardsController?sectionId=' + sectionId;
            }

            function showDeletePopup(id, event) {
                event.preventDefault();
                event.stopPropagation();  // Ngăn chặn sự kiện lan truyền
                sectionIdToDelete = id;
                document.getElementById('deletePopup').style.display = 'flex';
            }

            function closeDeletePopup() {
                document.getElementById('deletePopup').style.display = 'none';
            }

            function closePopup(popupId) {
                document.getElementById(popupId).style.display = 'none';
            }

            document.getElementById('confirmDelete').onclick = function () {
                if (sectionIdToDelete) {
                    window.location.href = '${pageContext.request.contextPath}/DeleteSectionController?sectionId=' + sectionIdToDelete;
                }
            };
        </script>

    </body>

</html>