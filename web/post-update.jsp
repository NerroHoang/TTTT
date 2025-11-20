<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
<jsp:include page="header.jsp"></jsp:include>
    
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
            background-color: var(--thi247-light-blue);
            padding-bottom: 50px;
        }
        
        /* 2. Cải thiện khối Banner (Page Header) */
        .page-header {
            background-color: var(--thi247-primary) !important; 
            border-radius: 0 0 15px 15px; 
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 40px !important;
        }

        /* 3. Bố cục form */
        .card {
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            border: none;
            padding: 20px; 
        }
        
        .section {
            padding: 0 15px;
        }
        
        /* 4. Input và Textarea */
        .form-control {
            border-radius: 8px;
            padding: 10px 15px;
            height: auto; /* Đặt lại height */
        }
        
        /* 5. Nút */
        .btn-update {
            background-color: var(--thi247-secondary); 
            border-color: var(--thi247-secondary);
            font-weight: 600;
            padding: 10px 30px;
            border-radius: 25px;
        }
        
        /* 6. Nút Trở về */
        .btn-back {
            background-color: var(--thi247-secondary) !important;
            border-color: var(--thi247-secondary) !important;
            margin-top: 20px;
            margin-bottom: 15px;
            margin-left: 20px;
            border-radius: 25px;
            padding: 8px 20px;
            font-weight: 600;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            display: inline-flex;
            align-items: center;
        }

        /* 7. Xem trước ảnh */
        #image-preview {
            max-width: 100%;
            height: auto;
            border-radius: 8px;
            margin-top: 10px;
            object-fit: contain;
            /* Giữ nguyên kích thước 500x200px nếu cần, nhưng tốt hơn nên dùng auto */
            /* width: 500px; height: 200px; */
        }
        #delete-image {
            background-color: rgba(220, 53, 69, 0.9);
            color: white;
            border-radius: 50%;
            padding: 5px 8px;
            font-size: 1rem;
            top: 15px;
            right: 15px;
        }
        
        /* Giữ lại style break-word */
        a, input, p {
            overflow-wrap: break-word;
            word-break: break-word;
        }
    </style>

    <script>
        var container = document.getElementById("tagID");
        var tag = container.getElementsByClassName("tag");
        var current = container.getElementsByClassName("active");
        
        if (current.length > 0) {
            current[0].className = current[0].className.replace(" active", "");
        }
    </script>


<%
// Lấy thông tin từ session (đã có sẵn)
int postID = (Integer)session.getAttribute("postID");
Forum forum = new ForumDAO().findPostByID(postID);
String postIMG = (String)session.getAttribute("postIMG");
%>

<div class="container-fluid bg-primary py-5 mb-5 page-header">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-10 text-center">
                <h1 class="text-white animated slideInDown">Chỉnh sửa bài đăng</h1>
            </div>
        </div>
    </div>
</div>

<main id="main" class="main">
    <a class="btn btn-primary btn-back" href="view-all-post-user.jsp"><i class="fas fa-arrow-left me-2"></i> Trở về</a>
    
    <section class="section">
        <div class="row">
            <div class="col-lg-8" style="margin: auto">
                <form action="UpdatePost" method="POST" enctype="multipart/form-data">
                    <div class="card">
                        <div class="card-body">
                            <input type="hidden" name="userID" value="<%=forum.getUserID()%>"/>
                            <input type="hidden" name="postID" value="<%=postID%>"/>
                            <input type="hidden" name="postIMG" id="imgURL" value="<%=postIMG%>"/>
                            
                            <div class="row mb-3">
                                <label class="col-sm-3 col-form-label" >Tiêu đề</label>
                                <div class="col-sm-9">
                                    <input type="text" name="title" class="form-control" value="<%=forum.getPostTitle()%>" required>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <label class="col-sm-3 col-form-label">Nội dung</label>
                                <div class="col-sm-9">
                                    <textarea class="form-control" name="context" rows="5" required style="resize: vertical;"><%=forum.getPostContext()%></textarea>
                                </div>
                            </div>
                            
                            <div class="row mb-3">
                                <label class="col-sm-3 col-form-label">Ảnh</label>
                                <div class="col-sm-9">
                                    <input class="form-control" name="file" type="file" accept="image/*" id="image-upload">
                                    
                                    <div id="image-preview-wrapper" class="mt-3">
                                        <img id="image-preview" src="<%=forum.getPostImg()%>" alt="Ảnh xem trước"/>
                                        <% 
                                        if(postIMG != null && !postIMG.isEmpty()){ 
                                        %>
                                        <button id="delete-image" type="button" style="display: inline-block"><i class="fa fa-times"></i></button>
                                        <%
                                        } else {
                                        %>
                                        <button id="delete-image" type="button" style="display: none"><i class="fa fa-times"></i></button>
                                        <%
                                        }
                                        %>
                                    </div>
                                </div>
                            </div>
                            
                            <hr class="mt-4 mb-4">
                            
                            <div class="row justify-content-center">
                                <div class="col-sm-12 text-center">
                                    <button type="submit" class="btn btn-primary btn-update">
                                        <i class="fas fa-sync-alt me-2"></i> Cập nhật
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>  
        </div>
    </section>
</main><a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>

<script src="assets/vendor/apexcharts/apexcharts.min.js"></script>
<script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="assets/vendor/chart.js/chart.umd.js"></script>
<script src="assets/vendor/echarts/echarts.min.js"></script>
<script src="assets/vendor/quill/quill.js"></script>
<script src="assets/vendor/simple-datatables/simple-datatables.js"></script>
<script src="assets/vendor/tinymce/tinymce.min.js"></script>
<script src="assets/vendor/php-email-form/validate.js"></script>

<script src="assets/js/main.js"></script>
<script>
    // JS cho việc xem trước và xóa ảnh
    document.getElementById('image-upload').addEventListener('change', function (event) {
        var file = event.target.files[0];
        var reader = new FileReader();

        reader.onload = function (e) {
            var imgElement = document.getElementById('image-preview');
            imgElement.src = e.target.result;
            imgElement.style.display = 'block';

            // Show delete button
            document.getElementById('delete-image').style.display = 'inline-block';
        }

        reader.readAsDataURL(file);
    });

    document.getElementById('delete-image').addEventListener('click', function (event) {
        event.preventDefault(); 

        var imgElement = document.getElementById('image-preview');
        imgElement.src = ''; 
        imgElement.style.display = 'none';

        // Hide delete button
        document.getElementById('delete-image').style.display = 'none';

        // Reset file input và URL ẩn
        document.getElementById('image-upload').value = '';
        document.getElementById('imgURL').value = ''; 
    });
    
    // Auto-resize textarea
    document.addEventListener('DOMContentLoaded', function() {
        var textarea = document.querySelector('textarea[name="context"]');
        if (textarea) {
            function autoResize() {
                textarea.style.height = 'auto';
                textarea.style.height = (textarea.scrollHeight) + 'px';
            }
            textarea.addEventListener('input', autoResize);
            autoResize(); // Kích hoạt lần đầu để thiết lập chiều cao ban đầu
        }
    });

    // Code cũ cho việc cuộn trang
    document.addEventListener("DOMContentLoaded", function (event) {
        var scrollpos = localStorage.getItem('scrollpos');
        if (scrollpos)
            window.scrollTo(0, scrollpos);
    });

    window.onbeforeunload = function (e) {
        localStorage.setItem('scrollpos', window.scrollY);
    };
</script>
<jsp:include page="footer.jsp"></jsp:include>