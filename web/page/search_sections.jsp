<%@page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Tìm kiếm học phần - THI247</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
        
        <style>
            /* --- MANG STYLE TỪ SECTIONS.JSP SANG ĐỂ ĐỒNG BỘ --- */
            :root {
                --thi247-primary: #17a2b8; 
                --thi247-secondary: #007bff;
                --thi247-light-blue: #e0f2f7;
                --thi247-text-dark: #343a40;
                --thi247-text-muted: #6c757d;
            }

            body {
                background-color: var(--thi247-light-blue);
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
            }
            
            .content {
                padding: 30px 20px;
                max-width: 1300px;
                margin: auto;
                width: 100%;
                flex: 1; /* Đẩy footer xuống dưới cùng nếu nội dung ngắn */
            }

            /* 1. Nút Trở về (Đồng bộ style) */
            .btn-navigation {
                background-color: var(--thi247-secondary) !important;
                border-color: var(--thi247-secondary) !important;
                border-radius: 25px;
                padding: 10px 22px;
                font-weight: 600;
                box-shadow: 0 4px 8px rgba(0,0,0,0.1);
                transition: all 0.3s ease;
                color: white !important;
                text-decoration: none;
            }
            .btn-navigation:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 12px rgba(0,0,0,0.15);
                background-color: #0056b3 !important;
            }

            /* 2. Thanh tìm kiếm (Đồng bộ style) */
            .search-bar {
                margin-top: 20px;
                margin-bottom: 40px;
                display: flex;
                justify-content: center;
                align-items: stretch;
            }
            .search-bar input[type="text"] {
                padding: 12px 20px;
                border: 1px solid #ced4da;
                border-right: none;
                border-radius: 28px 0 0 28px;
                width: 500px;
                max-width: 80%;
                font-size: 1.05rem;
                outline: none;
                transition: all 0.3s ease;
            }
            .search-bar input[type="text"]:focus {
                border-color: var(--thi247-primary);
                box-shadow: 0 0 0 0.2rem rgba(23, 162, 184, 0.25);
            }
            .search-bar button {
                border-radius: 0 28px 28px 0;
                padding: 12px 28px;
                background-color: var(--thi247-primary);
                border-color: var(--thi247-primary);
                font-weight: 700;
                font-size: 1.05rem;
                color: white;
                transition: background-color 0.3s ease;
            }
            .search-bar button:hover {
                background-color: #138496;
                border-color: #138496;
            }

            /* 3. Card Style (Đồng bộ) */
            .section-list {
                display: flex;
                flex-wrap: wrap;
                gap: 25px;
                justify-content: center;
            }
            .section-card {
                background-color: #ffffff;
                border-radius: 15px;
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
                padding: 25px 30px;
                width: 380px;
                min-height: 220px;
                cursor: pointer;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                position: relative;
            }
            .section-card:hover {
                transform: translateY(-8px);
                box-shadow: 0 15px 40px rgba(0, 0, 0, 0.2);
            }
            .section-card h4 {
                color: var(--thi247-primary);
                font-size: 1.6rem;
                font-weight: 800;
                margin-bottom: 15px;
                padding-right: 60px; /* Tránh đè lên status */
                
                /* Xử lý text quá dài */
                white-space: nowrap; 
                overflow: hidden;
                text-overflow: ellipsis;
            }
            .section-card p {
                font-size: 0.95rem;
                margin-bottom: 8px;
                color: var(--thi247-text-muted);
                display: flex;
                align-items: center;
            }
            .section-card p i {
                margin-right: 10px;
                color: var(--thi247-primary);
                width: 20px;
                text-align: center;
            }

            /* 4. Status Badge (Đồng bộ) */
            .section-card .status {
                position: absolute;
                top: 20px;
                right: 20px;
            }
            .status-badge {
                display: inline-block;
                font-size: 0.85rem;
                font-weight: 700;
                padding: 6px 12px;
                border-radius: 25px;
                color: white;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            }
            .status-private { background-color: #ffb300; }
            .status-public { background-color: #28a745; }

            /* 5. Tiêu đề kết quả & Empty State */
            .result-title {
                font-weight: 800;
                color: var(--thi247-text-dark);
                margin-bottom: 30px;
                position: relative;
                display: inline-block;
            }
            .result-title::after {
                content: '';
                display: block;
                width: 50%;
                height: 4px;
                background: var(--thi247-secondary);
                margin: 5px auto 0;
                border-radius: 2px;
            }
            
            .empty-state {
                text-align: center;
                padding: 50px;
                color: var(--thi247-text-muted);
            }
            .empty-state i {
                font-size: 4rem;
                margin-bottom: 20px;
                color: #dee2e6;
            }
        </style>
    </head>
    <body>
        <div class="header">
            <%@include file="../header.jsp" %>            
        </div>

        <div class="content">
            <div class="mb-4">
                <a class="btn btn-navigation" href="${pageContext.request.contextPath}/SectionsController?action=get">
                    <i class="fas fa-arrow-left me-2"></i> Trở về danh sách
                </a>
            </div>

            <form action="${pageContext.request.contextPath}/SearchSectionController" class="search-bar">
                <input value="${sectionName}" name="section_name" type="text" maxlength="50" placeholder="Nhập tên học phần muốn tìm..." required/>
                <button type="submit"><i class="fas fa-search me-1"></i> Tìm kiếm</button>
            </form>

            <div class="text-center">
                <h3 class="result-title">Kết quả tìm kiếm: "${sectionName}"</h3>
            </div>

            <div class="section-list">
                <c:choose>
                    <%-- TRƯỜNG HỢP CÓ KẾT QUẢ --%>
                    <c:when test="${not empty searchResults}">
                        <c:forEach var="section" items="${searchResults}">
                            <div class="section-card" data-id="${section.sectionId}">
                                <h4>${section.title}</h4>
                                <p><i class="fas fa-user"></i> <strong>Tác giả:</strong> ${section.authorName}</p>
                                <p>
                                    <i class="fas fa-calendar-alt"></i> 
                                    <strong>Ngày tạo:</strong> 
                                    <fmt:formatDate value="${section.createdAtAsDate}" pattern="dd/MM/yyyy" />
                                </p>
                                <p><i class="fas fa-question-circle"></i> <strong>Số câu hỏi:</strong> ${section.numberFlashCard}</p>
                                
                                <div class="status">
                                    <c:choose>
                                        <c:when test="${section.status == 'private'}">
                                            <span class="status-badge status-private">Cá nhân</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-public">Công khai</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>                    
                            </div>
                        </c:forEach>
                    </c:when>
                    
                    <%-- TRƯỜNG HỢP KHÔNG CÓ KẾT QUẢ (EMPTY STATE) --%>
                    <c:otherwise>
                        <div class="empty-state w-100">
                            <i class="fas fa-search"></i>
                            <h4>Không tìm thấy học phần nào phù hợp</h4>
                            <p>Hãy thử tìm kiếm với từ khóa khác hoặc kiểm tra lại chính tả.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="footer">
            <%@ include file="../footer.jsp" %>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                // Xử lý sự kiện click vào card
                const cards = document.querySelectorAll('.section-card');
                cards.forEach(card => {
                    card.addEventListener('click', function() {
                        const id = this.getAttribute('data-id');
                        window.location.href = '${pageContext.request.contextPath}/ViewFlashcardsController?sectionId=' + id;
                    });
                });
            });
        </script>
    </body>
</html>