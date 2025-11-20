<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
<jsp:include page="header.jsp"></jsp:include>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        var container = document.getElementById("tagID");
        var tag = container.getElementsByClassName("tag");
        var current = container.getElementsByClassName("active");
        
        if (current.length > 0) {
            current[0].className = current[0].className.replace(" active", "");
        }
        tag[1].className += " active";
    </script>
    
    <style type="text/css">
        /* Các biến màu chủ đạo của THI247 */
        :root {
            --thi247-primary: #17a2b8; /* Xanh ngọc */
            --thi247-secondary: #007bff; /* Xanh dương */
            --thi247-light-blue: #e0f2f7; /* Nền xanh nhạt */
            --thi247-text-dark: #343a40;
            --thi247-danger: #dc3545;
        }

        /* 1. Màu nền đồng bộ và reset margin */
        body {
            background-color: var(--thi247-light-blue);
            color: var(--thi247-text-dark);
            padding-bottom: 50px;
            margin: 0; 
        }

        /* 2. Cấu trúc và Card */
        .container {
            margin-top: 30px;
            max-width: 1000px;
            margin-left: auto;
            margin-right: auto;
            position: relative; /* Đặt relative cho container để nút trở về có thể nằm ngay trên card */
        }
        .card {
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            border: none;
            margin-bottom: 20px;
            background-color: #fff;
        }

        /* 3. Tiêu đề bài đăng chính */
        .forum-title {
            color: var(--thi247-primary);
            font-weight: 800;
            font-size: 1.8rem;
            margin-top: 10px;
            margin-bottom: 15px;
        }
        .post-info-meta {
            font-size: 0.9em;
            color: var(--thi247-text-muted);
        }
        .post-content-text {
            font-size: 1.05rem;
            line-height: 1.6;
            margin-top: 10px; 
            padding-bottom: 15px;
        }
        
        /* Tối ưu hóa ảnh */
        .post-image, .comment-image {
            max-width: 100%; 
            height: auto;
            border-radius: 8px;
            margin-top: 10px;
            object-fit: contain;
        }
        .post-author-name {
            font-weight: 700;
            color: var(--thi247-text-dark);
        }
        
        /* 4. Khu vực Bình luận & Dropdown */
        #comment-forum {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--thi247-secondary);
            margin-bottom: 20px;
            margin-top: 30px;
            text-align: left;
            border-bottom: 2px solid #ddd;
            padding-bottom: 5px;
        }
        
        /* Dropdown Tác vụ/Báo cáo */
        .dropbtn {
            padding: 0 10px;
            font-size: 1.2rem;
            color: var(--thi247-text-muted);
            background: none;
            border: none;
            cursor: pointer;
            line-height: 1; 
        }
        .report-dropdown {
            background-color: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border-radius: 8px;
            padding: 5px;
            right: 0;
            left: auto;
            min-width: 120px;
        }
        
        /* 5. Khối nhập Bình luận (Chat Box) */
        .comment-input-card {
            margin-top: 20px;
        }
        .chat-container {
            display: flex;
            align-items: center; 
            border: 1px solid #ddd;
            border-radius: 10px;
            padding: 8px 10px;
            background-color: #fff;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
        }

        .file-upload-wrapper {
            position: relative;
            display: flex;
            align-items: center;
            margin-right: 10px;
        }
        .file-upload-wrapper input[type="file"] {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            opacity: 0;
            cursor: pointer;
        }
        .file-upload-label {
            background-color: #f0f0f0;
            color: var(--thi247-text-dark);
            padding: 8px 12px;
            border-radius: 6px;
            font-size: 0.9em;
            font-weight: 600;
            white-space: nowrap;
            transition: background-color 0.2s;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        
        #submit-comment {
            border: none; 
            outline: none;
            resize: none;
            padding: 10px;
            font-size: 1rem;
            min-height: 40px; 
            margin: 0 10px;
            flex-grow: 1;
            background: none;
        }

        .btn-primary {
            background-color: var(--thi247-primary) !important;
            border-color: var(--thi247-primary) !important;
            height: 40px;
            width: 40px;
            padding: 8px;
            border-radius: 50%;
            font-size: 1.2rem;
        }
        
        /* 6. Nút Trở về (STYLE FIX) */
        .btn-back-style {
            background-color: #4da6ff !important; 
            border-color: #4da6ff !important;
            color: white;
            width: 120px; /* Độ rộng vừa phải */
            height: 40px; /* Chiều cao vừa phải */
            border-radius: 20px;
            padding: 5px 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
            font-size: 1rem; 
            margin-bottom: 10px;
        }
        .btn-back-style i {
             margin-right: 8px;
        }

        /* 7. Preview ảnh */
        #image-preview2 {
            max-width: 200px;
            height: auto;
            border: 1px solid #ddd;
        }
        #delete-image2 {
            background-color: var(--thi247-danger);
            color: white;
            border-radius: 50%;
            padding: 5px 8px;
            font-size: 1rem;
            top: 0;
            right: 0;
        }
        
        /* Giữ lại style break-word */
        a, input, p, h3 {
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
        tag[1].className += " active";
    </script>


<%
int postID = (Integer)session.getAttribute("postID");
Forum forum = new ForumDAO().findPostByID(postID);
Users user = new UserDAO().findByUserID(forum.getUserID());
%>
    
<div class="container-fluid bg-primary py-5 mb-5 page-header" style="background-color: var(--thi247-primary) !important;">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-10 text-center">
                <h1 class="text-white animated slideInDown">Chi tiết bài đăng</h1>
            </div>
        </div>
    </div>
</div>

<div class="container">
    <a class="btn btn-primary btn-back-style" href="${pageContext.request.contextPath}/forum.jsp">
        <i class="fa-solid fa-arrow-left"></i> Trở về
    </a>
    
    <div class="main-body p-0">
        <div class="card mb-4">
            <div class="card-body p-4">
                <div class="media forum-item d-flex">
                    <a href="UserProfile?userID=<%=user.getUserID()%>" data-target=".forum-content" class="me-3">
                        <img src="<%=user.getAvatarURL()%>" class="rounded-circle" width="50" height="50" alt="User Avatar"/>
                    </a>
                    <div class="media-body">
                        <h6 class="mb-1">
                            <a href="UserProfile?userID=<%=user.getUserID()%>" class="post-author-name text-decoration-none"><%=user.getUsername()%></a>
                            <span class="post-info-meta d-block"><%=forum.getPostDate()%></span>
                        </h6>
                    </div>
                </div>
                
                <h3 class="forum-title"><%=forum.getPostTitle()%></h3>
                <p class="post-content-text text-secondary"><%=forum.getPostContext()%></p>
                
                <% if(forum.getPostImg() != null && !forum.getPostImg().isEmpty()){ %>
                <div class="text-center">
                    <img src="<%=forum.getPostImg()%>" class="post-image" alt="Ảnh bài đăng"/>
                </div>
                <% } %>
                
                <%-- Đã loại bỏ hoàn toàn phần báo cáo bài đăng chính --%>

            </div>
        </div>
        
        <h3 id="comment-forum">Bình luận</h3>
        
        <div id="comment-list">
            <%
                List<Comments> cmts = new ForumDAO().findAllCommentsByPostID(postID);
                for(int i = cmts.size() - 1; i >= 0; i--){
                    Comments cmt = cmts.get(i);
                    // Đã loại bỏ các biến modal ID liên quan đến Sửa/Xóa
                    Users otherUser = new UserDAO().findByUserID(cmt.getUserID());
                    boolean isCurrentUserComment = (session.getAttribute("currentUser") != null && ((Users)session.getAttribute("currentUser")).getUserID() == cmt.getUserID());
            %>

            <div class="card mb-3">
                <div class="card-body p-3 d-flex position-relative">
                    <a href="UserProfile?userID=<%=cmt.getUserID()%>" class="me-3 mt-1">
                        <img src="<%=otherUser.getAvatarURL()%>" class="rounded-circle" width="40" height="40" alt="Commenter Avatar"/>
                    </a>
                    
                    <div class="media-body">
                        <h6 class="mb-0">
                            <a href="UserProfile?userID=<%=cmt.getUserID()%>" class="comment-user-name text-decoration-none"><%=otherUser.getUsername()%></a>
                            <span class="comment-meta d-block"><%=cmt.getCommentDate()%></span>
                        </h6>
                        <p class="comment-body"><%=cmt.getCommentContext()%></p>
                        
                        <% if(cmt.getCommentURL() != null && !cmt.getCommentURL().isEmpty()){ %>
                            <img src="<%=cmt.getCommentURL()%>" class="comment-image" alt="Ảnh bình luận"/>
                        <% } %>
                    </div>
                    
                    <%-- Đã loại bỏ hoàn toàn phần dropdown Sửa/Xóa bình luận --%>
                    
                </div>
            </div>
            <% } %>
            
            <% if(cmts.isEmpty()){ %>
                <h5 id="comment-forum" class="text-center text-muted">Chưa có bình luận nào</h5>
            <% } %>
        </div>
        
        <% Users currentUser = (Users)session.getAttribute("currentUser"); %>
        <% if(currentUser != null){ %>
        <div class="card comment-input-card">
            <div class="card-body p-3">
                <div class="media forum-item d-flex align-items-start">
                    <a href="profile.jsp" class="me-3 mt-1">
                        <img src="<%=currentUser.getAvatarURL()%>" class="rounded-circle" width="50" height="50" alt="User Avatar"/>
                    </a>
                    <div class="media-body w-100">
                        <form method="POST" action="PostComments" enctype="multipart/form-data">
                            <input type="hidden" name="postID" value="<%=postID%>">
                            
                            <div class="chat-container">
                                <div class="file-upload-wrapper">
                                    <label for="image-upload2" class="file-upload-label">
                                        <i class="fa fa-image" title="Thêm ảnh"></i> Chọn tệp
                                    </label>
                                    <input id="image-upload2" type="file" name="image" accept="image/*">
                                </div>
                                <span id="file-name-display" class="text-muted me-2" style="font-size: 0.9em; white-space: nowrap; overflow: hidden;">Không có tệp nào được chọn</span>

                                <textarea id="submit-comment" required name="comment" placeholder="Nhập bình luận" rows="1" class="ms-0 me-0"></textarea>
                                
                                <button type="submit" class="btn btn-primary ms-2">
                                    <i class="fa fa-paper-plane"></i>
                                </button>
                            </div>
                            
                            <div id="image-preview-wrapper2" style="position: relative;">
                                <img id="image-preview2" src="" alt="Preview" width="200px" height="auto" class="mt-2" style="display: none;">
                                <button id="delete-image2" type="button" style="display: none"><i class="fa fa-times"></i></button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <% } %>

    </div>
</div>

<jsp:include page="footer.jsp"></jsp:include>

<a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>
<script>
    // Hàm cho Dropdown Sửa/Xóa bình luận
    function myFunction(id) {
        var dropdown = document.getElementById("myDropdown" + id);
        if (dropdown) dropdown.classList.toggle("show");
    }

    // Đóng dropdown khi click ra ngoài
    window.onclick = function (event) {
        if (!event.target.matches('.dropbtn') && !event.target.closest('.dropdown-content')) {
            var dropdowns = document.querySelectorAll(".dropdown-content.show");
            dropdowns.forEach(function(openDropdown) {
                openDropdown.classList.remove('show');
            });
        }
    }

    // Auto-resize textarea cho bình luận mới
    document.addEventListener("DOMContentLoaded", function () {
        var textarea = document.getElementById("submit-comment");
        if (textarea) {
            function autoResize() {
                textarea.style.height = "auto";
                textarea.style.height = (textarea.scrollHeight) + "px";
            }
            textarea.addEventListener("input", autoResize);
            setTimeout(autoResize, 0); 
        }
        
        // Cập nhật tên file khi chọn (giữ nguyên logic)
        document.getElementById('image-upload2').addEventListener('change', function (event) {
            const fileNameDisplay = document.getElementById('file-name-display');
            const file = event.target.files[0];
            
            if (file) {
                fileNameDisplay.textContent = file.name;

                // Logic preview ảnh
                var reader = new FileReader();
                var imgElement = document.getElementById('image-preview2');
                var deleteBtn = document.getElementById('delete-image2');

                reader.onload = function (e) {
                    imgElement.src = e.target.result;
                    imgElement.style.display = 'block';
                    deleteBtn.style.display = 'inline-block';
                };

                reader.readAsDataURL(file);
                
            } else {
                fileNameDisplay.textContent = "Không có tệp nào được chọn";
            }
        });

        document.getElementById('delete-image2').addEventListener('click', function (event) {
            event.preventDefault();
            document.getElementById('image-preview2').src = '#';
            document.getElementById('image-preview2').style.display = 'none';
            document.getElementById('delete-image2').style.display = 'none';
            document.getElementById('image-upload2').value = '';
            document.getElementById('file-name-display').textContent = "Không có tệp nào được chọn";
        });
        
    });

    // Code cho báo cáo (toggleReport)
    function toggleReport(button) {
        var dropdownContent = button.nextElementSibling;
        dropdownContent.classList.toggle("show");
    }
</script>