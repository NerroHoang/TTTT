<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Sections</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sections.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="header">
            <%@ include file="../header.jsp" %>
        </div>
        <div class="content">
            <div class="d-flex justify-content-between align-items-center p-2">
                <a class="btn btn-primary" style="background-color:blue ; margin-top: 20px; margin-left: 5%" href="Home">Trở về</a>
                <a class="btn btn-primary" style="background-color:blue ; margin-top: 20px; margin-right: 5%" href="${pageContext.request.contextPath}/MySectionsController" >
                    Học phần của bạn
                </a>
            </div>
            <form action="${pageContext.request.contextPath}/SearchSectionController" class="search-bar d-flex justify-content-center">
                <input name="section_name"  type="text" maxlength="50" placeholder="Nhập tên section"/>
                <button class="btn btn-primary fw-bold" type="submit">Tìm kiếm</button>
            </form>

            <div class="mt-5">
                <div class="fs-3 fw-bold text-center">Học phần phổ biến</div>
                <div class="section-list">               
                    <c:forEach var="section" items="${public_sections}">
                        <div class="section-card" data-section-id="${section.sectionId}">
                            <h4>${section.title}</h4>
                            <p><strong>Created by:</strong> ${section.authorName}</p>
                            <p>
                                <strong>Date: </strong><fmt:formatDate value="${section.createdAtAsDate}" pattern="dd/MM/yyyy" />
                            </p>
                            <p><strong>Total Questions:</strong> ${section.numberFlashCard}</p>                 
                            <div class="status">
                                <c:choose>
                                    <c:when test="${section.status == 'private'}">private-status</c:when>
                                    <c:otherwise>public-status</c:otherwise>
                                </c:choose>
                            </div>                     
                        </div>
                    </c:forEach>
                </div>

                <c:if test="${hasMore}">
                    <div class="d-flex justify-content-center mt-3">
                        <button id="loadMoreButton" data-offset="${offset}" class="fs-5 fw-bold btn btn-primary">
                            Xem thêm
                        </button>
                    </div>
                </c:if>

            </div>

            <div class="d-flex justify-content-center mt-5">
                <a href="${pageContext.request.contextPath}/CreateSectionController?sectionId=0" 
                   class="p-5 fs-2 fw-bold mt-5 create-session d-flex justify-content-center flex-column align-items-center text-decoration-none text-dark">
                    <div>Tạo học phần mới</div>
                </a>
            </div>
        </div>
        <div class="footer">
            <%@ include file="../footer.jsp" %>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const redirectToViewFlashcardsController = function (id) {
                    window.location.href = "/THI247/ViewFlashcardsController?sectionId=" + id;
                };

                // Thêm sự kiện click cho các thẻ section-card
                const cards = document.querySelectorAll('.section-card');
                cards.forEach(function (card) {
                    card.addEventListener('click', function () {
                        const sectionId = card.getAttribute('data-section-id');
                        redirectToViewFlashcardsController(sectionId);
                    });
                });

                // Sự kiện khi nhấn nút "Xem thêm"
                const loadMoreButton = document.querySelector('#loadMoreButton');
                if (loadMoreButton) {
                    loadMoreButton.addEventListener('click', function (event) {
                        event.preventDefault();
                        const offset = loadMoreButton.getAttribute('data-offset');

                        // Lưu vị trí cuộn vào sessionStorage
                        sessionStorage.setItem('scrollPosition', window.scrollY);

                        window.location.href = `/THI247/SectionsController?action=more&offset=${offset}`;
                    });
                }

                // Đặt lại vị trí cuộn khi trang tải lại
                const scrollPosition = sessionStorage.getItem('scrollPosition');
                if (scrollPosition) {
                    window.scrollTo(0, parseInt(scrollPosition, 10));
                    sessionStorage.removeItem('scrollPosition'); // Xóa sau khi cuộn lại
                }

// Ngăn tải lại trang khi nhấn F5 hoặc Ctrl+R
                window.addEventListener('keydown', function (event) {
                    if ((event.keyCode === 116) || (event.ctrlKey && event.keyCode === 82) || (event.metaKey && event.keyCode === 82)) {
                        event.preventDefault();
                        window.location.href = '/THI247/SectionsController?action=get';
                    }
                });

                if (performance.getEntriesByType("navigation")[0].type === "reload") {
                    window.location.href = '/THI247/SectionsController?action=get';
                }
            });
        </script>
    </body>
</html>
