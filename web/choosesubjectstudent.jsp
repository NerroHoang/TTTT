<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
<jsp:include page="header.jsp"></jsp:include>
    <script>
        var container = document.getElementById("tagID");
        var tag = container.getElementsByClassName("tag");
        var current = container.getElementsByClassName("active");
        current[0].className = current[0].className.replace(" active", "");
        tag[2].className += " active";
    </script>

    <style>
        body {
            /* Màu xanh nhạt tương thích với màu chủ đạo của THI247 */
            background-color: #e0f2f7; 
        }
        /* Đảm bảo các khối chính có nền trắng để nổi bật trên nền xanh nhạt */
        .course-item.bg-light {
             background-color: #ffffff !important;
        }
        /* Cập nhật màu nút Trở về nếu cần (đã giữ nguyên màu xanh của bạn) */
        .btn-blue-back {
             background-color: #467bcb !important; /* Sử dụng màu xanh đậm hơn một chút cho nút Trở về */
             border-color: #467bcb !important;
        }
    </style>
<%
List<Subjects> subjects = new ExamDAO().getAllSubject();
%>

<div class="container-xxl py-5">
    <div class="container">
        <a class="btn btn-primary mt-3" href="Home">Trở về</a>
        
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
                        <img class="img-fluid" src="<%=subject.getSubjectImg()%>" alt="">
                        <div class="w-100 d-flex justify-content-center position-absolute bottom-0 start-0 mb-4">
                            <a href="ChangeSubjectStudent?subjectID=<%=subject.getSubjectID()%>" class="flex-shrink-0 btn btn-sm btn-primary px-3" style="border-radius: 30px;">Xem các bài kiểm tra</a>
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
<jsp:include page="footer.jsp"></jsp:include>
<a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>