<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
<jsp:include page="header.jsp"></jsp:include>
    <script>
        var container = document.getElementById("tagID");
        var tag = container.getElementsByClassName("tag");
        var current = container.getElementsByClassName("active");
        
        // Đảm bảo element active cũ được xóa
        if (current.length > 0) {
            current[0].className = current[0].className.replace(" active", "");
        }
        // Gán active cho tab có index 2 (nếu có, dựa vào cấu trúc menu của bạn)
        if (tag.length > 2) {
             tag[2].className += " active";
        }
    </script>
    
    <style>
        /* Các biến màu chủ đạo của THI247 */
        :root {
            --thi247-primary: #17a2b8; /* Xanh ngọc */
            --thi247-secondary: #007bff; /* Xanh dương */
            --thi247-light-blue: #e0f2f7; /* Nền xanh nhạt */
            --thi247-text-dark: #343a40;
        }

        /* 1. Màu nền đồng bộ */
        body {
            background-color: var(--thi247-light-blue); /* Đảm bảo nền xanh nhạt */
            padding-bottom: 50px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* 2. Tiêu đề Trang */
        .section-title {
            color: var(--thi247-secondary) !important; /* Đổi màu tiêu đề nhỏ thành xanh dương */
            font-weight: 700;
            letter-spacing: 1px;
        }
        h1.mb-5 {
            color: var(--thi247-text-dark);
            font-weight: 900; /* Rất đậm */
            font-size: 2.5rem;
            margin-top: 10px !important;
        }
        .bg-white {
            background-color: #ffffff !important;
            padding: 5px 15px !important;
            border-radius: 20px; /* Bo tròn tiêu đề nhỏ */
        }

        /* 3. Thiết kế Khối Môn học (Course Item) */
        .course-item {
            background-color: #ffffff !important;
            border-radius: 15px; /* Bo góc nhiều hơn, mềm mại hơn */
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15); /* Đổ bóng mạnh hơn, đẹp hơn */
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            border: 1px solid rgba(0, 0, 0, 0.05); /* Viền mờ nhẹ */
        }
        .course-item:hover {
            transform: translateY(-10px); /* Nảy lên rõ rệt */
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.25);
        }
        
        /* 4. Hình ảnh */
        .course-item .img-fluid {
            height: 220px; /* Tăng chiều cao ảnh */
            width: 100%;
            object-fit: cover;
        }

        /* 5. Tiêu đề Môn học */
        .course-item .text-center h3 {
            font-size: 1.6rem; /* Tiêu đề lớn hơn */
            font-weight: 800;
            color: var(--thi247-primary); /* Đổi màu tiêu đề chính thành màu primary */
            padding: 20px 10px; /* Cân đối padding */
            margin-bottom: 0 !important;
        }

        /* 6. Nút Xem câu hỏi */
        .course-item .btn-primary {
            background-color: var(--thi247-secondary) !important; /* Xanh dương */
            border-color: var(--thi247-secondary) !important;
            padding: 10px 30px; /* Tăng padding nút */
            font-weight: 700;
            font-size: 1.1rem;
            border-radius: 25px !important; /* Bo tròn hoàn toàn */
            transition: all 0.3s;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }
        .course-item .btn-primary:hover {
             background-color: #0056b3 !important;
             border-color: #0056b3 !important;
             transform: scale(1.05); /* Hiệu ứng phóng to nhẹ khi hover */
        }
        
        /* Cải thiện container */
        .container-xxl.py-5 {
            padding-top: 5rem !important; /* Tăng padding trên */
            padding-bottom: 5rem !important;
        }
        
        /* Cải thiện vị trí nút trong ảnh */
        .course-item .position-absolute {
            position: absolute;
            bottom: 0;
            left: 50%;
            transform: translateX(-50%); /* Căn giữa hoàn hảo */
            width: 100%;
            padding-bottom: 20px; /* Tăng khoảng cách dưới */
        }
    </style>
<%
List<Subjects> subjects = new ExamDAO().getAllSubject();
%>

    <div class="container-xxl py-5">
        <div class="container">
            <div class="text-center wow fadeInUp" data-wow-delay="0.1s">
                <h6 class="section-title bg-white text-center text-primary px-3">MÔN HỌC</h6>
                <h1 class="mb-5">DANH SÁCH CÁC MÔN HỌC</h1>
            </div>
            <div class="row g-4 justify-content-center">
                <%
                for(Subjects subject: subjects){
                %>
                <div class="col-lg-4 col-md-6 wow fadeInUp" data-wow-delay="0.1s">
                    <div class="course-item bg-light">
                        <div class="position-relative overflow-hidden">
                            <img class="img-fluid" src="img/course-1.jpg" alt="Môn <%=subject.getSubjectName()%>">
                            <div class="w-100 d-flex justify-content-center position-absolute mb-4">
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
    <jsp:include page="footer.jsp"></jsp:include>
    <a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i class="bi bi-arrow-up"></i></a>