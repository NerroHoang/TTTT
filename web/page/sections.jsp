<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Học phần</title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/sections.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        
        <style>
            /* Các biến màu chủ đạo của THI247 */
            :root {
                --thi247-primary: #17a2b8; /* Màu xanh ngọc chủ đạo */
                --thi247-secondary: #007bff; /* Màu xanh dương bổ sung */
                --thi247-light-blue: #e0f2f7; /* Màu xanh nhạt cho nền */
                --thi247-text-dark: #343a40;
                --thi247-text-muted: #6c757d;
            }

            /* 1. Đồng bộ màu nền */
            body {
                background-color: var(--thi247-light-blue); /* Màu xanh nhạt đồng bộ */
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            .content {
                padding: 30px 20px;
                max-width: 1300px;
                margin: auto;
            }
            
            /* 2. Thanh tìm kiếm */
            .search-bar {
                margin-top: 30px;
                margin-bottom: 50px; /* Tăng khoảng cách dưới */
                display: flex;
                justify-content: center;
                align-items: stretch; /* Đảm bảo input và button cùng chiều cao */
            }
            .search-bar input[type="text"] {
                padding: 12px 20px; /* Tăng padding */
                border: 1px solid #ced4da; /* Viền mềm hơn */
                border-right: none; /* Bỏ viền giữa input và button */
                border-radius: 28px 0 0 28px; /* Bo góc nhiều hơn */
                width: 450px; /* Rộng hơn một chút */
                max-width: 80%;
                font-size: 1.05rem;
                outline: none; /* Bỏ outline khi focus */
                transition: all 0.3s ease;
            }
            .search-bar input[type="text"]:focus {
                border-color: var(--thi247-primary);
                box-shadow: 0 0 0 0.2rem rgba(23, 162, 184, 0.25); /* Shadow nhẹ khi focus */
            }
            .search-bar button {
                border-radius: 0 28px 28px 0; /* Bo góc nhiều hơn */
                padding: 12px 28px; /* Tăng padding */
                background-color: var(--thi247-primary); 
                border-color: var(--thi247-primary);
                font-weight: 700;
                font-size: 1.05rem;
                transition: background-color 0.3s ease, border-color 0.3s ease;
            }
            .search-bar button:hover {
                background-color: #138496; /* Xanh đậm hơn khi hover */
                border-color: #138496;
            }

            /* 3. Nút Trở về và Học phần của bạn */
            .btn-navigation {
                background-color: var(--thi247-secondary) !important; /* Sử dụng màu xanh dương bổ sung */
                border-color: var(--thi247-secondary) !important;
                border-radius: 25px; /* Bo tròn hơn */
                padding: 10px 22px; /* Tăng padding */
                font-weight: 600;
                box-shadow: 0 4px 8px rgba(0,0,0,0.1); /* Đổ bóng nhẹ */
                transition: all 0.3s ease;
            }
            .btn-navigation:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 12px rgba(0,0,0,0.15);
            }
            
            /* 4. THIẾT KẾ MỚI CHO SECTION CARD: TO HƠN, ĐẸP HƠN, THANH LỊCH HƠN */
            .section-list {
                display: flex;
                flex-wrap: wrap;
                gap: 25px; /* Khoảng cách giữa các thẻ */
                justify-content: center;
                margin-top: 30px;
            }
            .section-card {
                background-color: #ffffff;
                border-radius: 15px; /* Bo góc nhiều hơn, mềm mại hơn */
                /* Đổ bóng tinh tế */
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1); 
                padding: 25px 30px; /* Tăng padding, cân đối hơn */
                width: 380px; /* Rộng hơn nữa */
                min-height: 220px; /* Chiều cao tối thiểu */
                cursor: pointer;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                border: none; /* Bỏ viền cứng */
                position: relative; /* Dùng cho status */
            }
            .section-card:hover {
                transform: translateY(-8px); /* Nảy lên rõ rệt hơn */
                box-shadow: 0 15px 40px rgba(0, 0, 0, 0.2);
            }
            .section-card h4 {
                color: var(--thi247-primary); /* Đổi màu tiêu đề thành màu primary */
                font-size: 1.6rem; /* Tiêu đề lớn hơn */
                font-weight: 800; /* Rất đậm */
                margin-bottom: 15px;
                line-height: 1.3;
            }
            .section-card p {
                font-size: 0.95rem; /* Kích thước chữ vừa phải */
                margin-bottom: 8px;
                color: var(--thi247-text-muted); /* Màu chữ xám dịu */
                display: flex;
                align-items: center;
            }
            .section-card p i {
                margin-right: 8px;
                color: var(--thi247-primary); /* Icon màu primary */
                font-size: 1.1em;
            }
            .section-card strong {
                font-weight: 600; /* Đậm vừa phải */
                color: var(--thi247-text-dark); /* Màu chữ đậm cho thông tin chính */
            }
            /* Đổi vị trí Status */
            .section-card .status {
                position: absolute; /* Đặt status ở góc */
                top: 20px;
                right: 20px;
                
            }
            .section-card .private-status,
            .section-card .public-status {
                display: inline-block;
                font-size: 0.85rem;
                font-weight: 700;
                padding: 6px 12px;
                border-radius: 25px; /* Bo tròn hoàn toàn */
                color: white;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }
            .section-card .private-status {
                background-color: #ffb300; /* Màu vàng cam sống động */
            }
            .section-card .public-status {
                background-color: #28a745; /* Màu xanh lá cây nổi bật */
            }
            
            /* 5. Nút Tạo học phần mới */
            .create-session {
                border: 3px dashed var(--thi247-primary); /* Dùng màu primary cho border */
                background-color: #ffffff;
                border-radius: 15px; /* Đồng bộ bo góc với section-card */
                width: 380px; /* Đồng bộ kích thước với section-card */
                min-height: 220px;
                transition: all 0.3s ease;
                text-align: center;
                color: var(--thi247-primary) !important;
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08); /* Đổ bóng nhẹ hơn */
            }
            .create-session:hover {
                background-color: #f8fcff; /* Màu nền nhẹ khi hover */
                border-color: var(--thi247-secondary); /* Đổi màu border khi hover */
                transform: translateY(-5px);
                box-shadow: 0 12px 30px rgba(0, 0, 0, 0.15);
            }
            .create-session .fa-plus-circle {
                font-size: 3rem !important; /* Icon lớn hơn */
                margin-bottom: 15px;
                color: var(--thi247-primary);
            }
            .create-session .fs-4 {
                font-weight: 700;
                color: var(--thi247-primary);
            }
            
            /* 6. Tiêu đề "Học phần phổ biến" */
            .section-title-popular {
                font-size: 2.5rem; /* Tiêu đề lớn hơn */
                font-weight: 900; /* Rất đậm */
                color: var(--thi247-primary);
                text-align: center;
                margin-bottom: 40px; /* Khoảng cách dưới */
                position: relative;
                display: inline-block; /* Để đường gạch chân phù hợp với chiều rộng text */
                padding-bottom: 10px;
            }
            .section-title-popular::after {
                content: '';
                position: absolute;
                left: 50%;
                bottom: 0;
                transform: translateX(-50%);
                width: 80px; /* Độ dài gạch chân */
                height: 4px; /* Độ dày gạch chân */
                background-color: var(--thi247-secondary); /* Màu gạch chân */
                border-radius: 2px;
            }

            /* 7. Nút Xem thêm */
            #loadMoreButton {
                border-radius: 28px; /* Đồng bộ với search button */
                padding: 12px 35px;
                font-weight: 700;
                background-color: var(--thi247-secondary);
                border-color: var(--thi247-secondary);
                transition: all 0.3s ease;
            }
            #loadMoreButton:hover {
                background-color: #0056b3;
                border-color: #0056b3;
                transform: translateY(-2px);
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            }
            
        </style>
    </head>
    <body>
        <div class="header">
            <%@ include file="../header.jsp" %>
        </div>
        <div class="content">
            <div class="d-flex justify-content-between align-items-center p-2">
                <a class="btn btn-primary btn-navigation" href="Home">
                    <i class="fas fa-arrow-left me-2"></i> Trở về
                </a>
                <a class="btn btn-primary btn-navigation" href="${pageContext.request.contextPath}/MySectionsController" >
                    Học phần của bạn <i class="fas fa-book-open ms-2"></i>
                </a>
            </div>
            <form action="${pageContext.request.contextPath}/SearchSectionController" class="search-bar">
                <input name="section_name"  type="text" maxlength="50" placeholder="Nhập tên học phần..."/>
                <button class="btn btn-primary fw-bold" type="submit">Tìm kiếm</button>
            </form>

            <div class="mt-5">
                <div class="text-center">
                    <h2 class="section-title-popular">Học phần phổ biến</h2>
                </div>
                <div class="section-list">                
                    <c:forEach var="section" items="${public_sections}">
                        <div class="section-card" data-section-id="${section.sectionId}">
                            <h4>${section.title}</h4>
                            <p><i class="fas fa-user"></i><strong>Tác giả:</strong> ${section.authorName}</p>
                            <p>
                                <i class="fas fa-calendar-alt"></i><strong>Ngày tạo: </strong><fmt:formatDate value="${section.createdAtAsDate}" pattern="dd/MM/yyyy" />
                            </p>
                            <p><i class="fas fa-question-circle"></i><strong>Tổng số thẻ:</strong> ${section.numberFlashCard}</p>             
                            <div class="status">
                                <c:choose>
                                    <c:when test="${section.status == 'private'}">
                                        <span class="private-status">Cá nhân</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="public-status">Công khai</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>                   
                        </div>
                    </c:forEach>
                </div>

                <c:if test="${hasMore}">
                    <div class="d-flex justify-content-center mt-5">
                        <button id="loadMoreButton" data-offset="${offset}" class="fs-5 fw-bold btn btn-primary">
                            Xem thêm <i class="fas fa-chevron-down ms-2"></i>
                        </button>
                    </div>
                </c:if>

            </div>

            <div class="d-flex justify-content-center mt-5">
                <a href="${pageContext.request.contextPath}/CreateSectionController?sectionId=0" 
                   class="fs-2 fw-bold mt-5 create-session d-flex justify-content-center flex-column align-items-center text-decoration-none">
                    <div><i class="fas fa-plus-circle mb-3"></i></div>
                    <div class="fs-4">Tạo học phần mới</div>
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
                    // Cần đảm bảo context path là đúng, giả sử nó là /THI247
                    window.location.href = "${pageContext.request.contextPath}/ViewFlashcardsController?sectionId=" + id;
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

                        window.location.href = `${pageContext.request.contextPath}/SectionsController?action=more&offset=${offset}`;
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
                        window.location.href = `${pageContext.request.contextPath}/SectionsController?action=get`;
                    }
                });

                // Kiểm tra nếu trang được tải lại từ cache hoặc history
                if (performance.getEntriesByType("navigation")[0].type === "reload") {
                    window.location.href = `${pageContext.request.contextPath}/SectionsController?action=get`;
                }
            });
        </script>
    </body>
</html>