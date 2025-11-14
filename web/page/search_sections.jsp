<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Search sections</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/search_sections.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">  
    </head>
    <body>
        <div class="header">
            <%@include file="../header.jsp" %>            
        </div>
        <div class="content">
            <a class="btn btn-primary" style="background-color:blue ; margin-top: 20px; margin-left: 5%" href="${pageContext.request.contextPath}/SectionsController?action=get">Trở về</a>
            <form action="${pageContext.request.contextPath}/SearchSectionController" class="search-bar d-flex justify-content-center">
                <input value="${sectionName}" name="section_name"  type="text" maxlength="50" placeholder="Nhập tên section" required/>
                <button class="btn btn-primary fw-bold" type="submit">Tìm kiếm</button>
            </form>
            <div class="fs-3 fw-bold text-center" style="margin-top: 20px">Kết quả tìm kiếm</div>
            <div class="section-list">
                <!-- JSTL Loop -->
                <c:forEach var="section" items="${searchResults}" >
                    <div class="section-card" onclick="redirectToViewFlashcardsController('${section.sectionId}')">
                        <h4>${section.title}</h4>
                        <p><strong>Created by:</strong> ${section.authorName}</p>
                        <p>
                            <strong>Date: </strong><fmt:formatDate value="${section.createdAtAsDate}" pattern="dd/MM/yyyy" />
                        </p>
                        <p><strong>Total Questions:</strong> ${section.numberFlashCard}</p>                 
                        <div class="status
                             <c:choose>
                                 <c:when test="${section.status == 'private'}">private-status</c:when>
                                 <c:otherwise>public-status</c:otherwise>
                             </c:choose>
                             text-center">
                            ${section.status}
                        </div>                   
                    </div>
                </c:forEach>
            </div>
        </div>
        <div class="footer">
            <%@ include file="../footer.jsp" %>
        </div>
        <script>
            const redirectToViewFlashcardsController = function (id) {
                window.location.href = '${pageContext.request.contextPath}/ViewFlashcardsController?sectionId=' + id;
            }
        </script>
    </body>
</html>