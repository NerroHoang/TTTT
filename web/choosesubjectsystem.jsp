<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
<jsp:include page="header.jsp"></jsp:include>
    
    <style>
        /* Các biến màu chủ đạo của THI247 (Giả định từ header.jsp) */
        :root {
            --thi247-primary: #17a2b8; /* Xanh ngọc */
            --thi247-secondary: #007bff; /* Xanh dương */
            --thi247-light-blue: #e0f2f7; /* Nền xanh nhạt */
            --thi247-text-dark: #343a40;
        }

        /* KHẮC PHỤC LỖI NỀN: Áp dụng !important */
        body {
            background-color: var(--thi247-light-blue) !important;
            padding-bottom: 50px;
        }

        /* 2. Tiêu đề Trang */
        /* Cần đảm bảo text-primary luôn là màu xanh chủ đạo */
        .section-title {
            color: var(--thi247-primary) !important;
            font-weight: 700;
        }
        h1.mb-5 {
            color: var(--thi247-text-dark);
            font-weight: 800;
        }
        
        /* 3. Thiết kế Khối Môn học (Course Item) - Đồng bộ style */
        .course-item {
            background-color: #ffffff !important;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
            transition: transform 0.3s ease;
        }
        .course-item:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 25px rgba(0, 0, 0, 0.25);
        }
        
        .course-item .img-fluid {
            height: 200px;
            width: 100%;
            object-fit: cover;
        }

        .course-item .text-center h3 {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--thi247-text-dark);
            padding-bottom: 15px;
        }

        /* 4. Nút Hành động (Xem câu hỏi) */
        .course-item .btn-primary {
            background-color: var(--thi247-secondary) !important;
            border-color: var(--thi247-secondary) !important;
            padding: 8px 20px;
            font-weight: 600;
            transition: all 0.3s;
        }
        .course-item .btn-primary:hover {
             background-color: #0056b3 !important;
             border-color: #0056b3 !important;
        }
        
        /* 5. Nút Trở về */
        .btn-back-style {
            background-color: var(--thi247-secondary) !important;
            border-color: var(--thi247-secondary) !important;
            border-radius: 25px;
            padding: 8px 20px;
            font-weight: 600;
            color: white;
            display: inline-flex;
            align-items: center;
        }
        
        /* Cải thiện container */
        .container-xxl.py-5 {
            padding-top: 4rem !important;
            padding-bottom: 4rem !important;
        }
    </style>
    
    <script>
        var container = document.getElementById("tagID");
        var tag = container.getElementsByClassName("tag");
        var current = container.getElementsByClassName("active");
        current[0].className = current[0].className.replace(" active", "");
        tag[2].className += " active";
    </script>
<%
List<Subjects> subjects = new ExamDAO().getAllSubject();
%>

    <div class="container-xxl py-5">
        <div class="container">
            
            <a class="btn btn-primary btn-back-style mt-3" href="Home">
                <i class="fas fa-arrow-left me-2"></i> Trở về
            </a>

            <div class="text-center wow fadeInUp" data-wow-delay="0.1s">
                <h6 class="section-title bg-white text-center text-primary px-3">Môn học</h6>
                <h1 class="mb-5">Danh sách các môn học</h1>
            </div>
            
            <div class="row g-4 justify-content-center">
                <%
                for(Subjects subject: subjects){
                %>
                <div class="col-lg-4 col-md-6 wow fadeInUp" data-wow-delay="0.1s">
                    <div class="course-item bg-light">
                        <div class="position-relative overflow-hidden">
                            <img class="img-fluid" src="<%=subject.getSubjectImg()%>" alt="<%=subject.getSubjectName()%> Image">
                            
                            <div class="w-100 d-flex justify-content-center position-absolute bottom-0 start-0 mb-4">
                                <a href="ChangeSubjectUser?subjectID=<%=subject.getSubjectID()%>" class="flex-shrink-0 btn btn-sm btn-primary px-3" style="border-radius: 30px;">
                                    <i class="fas fa-search me-1"></i> Xem câu hỏi
                                </a>
                            </div>
                        </div>
                        <div class="text-center p-4 pb-0">
                            <h3 class="mb-0"><%=subject.getSubjectName()%></h3>
                        </div>
                    </div>
                </div>
                <%
                    }
                %>
            </div>
        </div>
    </div>
    <jsp:include page="footer.jsp"></jsp-include>
    <a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>