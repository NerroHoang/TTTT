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
    </script>

<%
// ====================================================================
// KHAI BÁO VÀ KHỞI TẠO BIẾN CẦN THIẾT
// ====================================================================

// Lấy thông tin từ request (user id cần xem) và session (người đang đăng nhập)
Integer idObj = (Integer)request.getAttribute("userID"); 
if (idObj == null) {
    idObj = (Integer)session.getAttribute("userID");
}

if (idObj == null) {
    response.sendRedirect("error.jsp?msg=UserIDNotFound");
    return;
}
int id = idObj.intValue(); 

Users user = new UserDAO().findByUserID(id); 
Users currentUser = (Users)session.getAttribute("currentUser"); 

if (user == null) {
    response.sendRedirect("error.jsp?msg=UserNotFound");
    return; 
}

String role = "Không xác định";
if(user.getRole() == 1) role = "Admin";
else if(user.getRole() == 2) role = "Giáo viên";
else role = "Học sinh";

TeacherRequest requests = null;
Subjects subject = null;
if(user != null) {
    requests = new AdminDAO().getRequestByUserID(id);
    if(requests != null){
        subject = new ExamDAO().getSubjectByID(requests.getSubjectID());
    }
}
// ====================================================================
%>

    <style>
        /* Các biến màu chủ đạo của THI247 */
        :root {
            --thi247-primary: #17a2b8; /* Xanh ngọc */
            --thi247-secondary: #007bff; /* Xanh dương */
            --thi247-light-blue: #e0f2f7; /* Nền xanh nhạt */
            --thi247-text-dark: #343a40;
            --thi247-text-muted: #6c757d;
            --thi247-danger: #dc3545; /* Màu đỏ cho nút báo cáo */
        }

        /* 1. Màu nền đồng bộ */
        body {
            background-color: var(--thi247-light-blue);
            padding-bottom: 50px;
        }

        /* 2. Cấu trúc tổng thể */
        #main {
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
            background: none; 
            box-shadow: none;
        }
        .container {
            margin-top: 30px;
            max-width: 1000px;
        }
        
        /* 3. Thiết kế Card */
        .card {
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            border: none;
            margin-bottom: 20px;
            background-color: #fff;
        }
        .card-body {
            padding: 20px;
        }
        
        /* 4. Khối bên trái: Avatar và Bài đăng */
        .profile-avatar-img {
            border-radius: 50%;
            border: 4px solid var(--thi247-secondary); 
            object-fit: cover;
            margin-bottom: 15px;
        }
        .profile-username h2 {
            font-size: 1.5rem;
            color: var(--thi247-text-dark);
            font-weight: 700;
            margin-bottom: 5px;
        }
        .profile-role-text {
            font-size: 1.1rem;
            color: var(--thi247-primary);
            font-weight: 600;
        }
        
        /* 5. Bài đăng gần đây */
        .recent-posts-header {
            padding: 15px;
            border-bottom: 1px solid #ddd;
            font-weight: 700;
            color: var(--thi247-secondary);
        }
        .recent-posts-list a {
            color: var(--thi247-text-dark);
            text-decoration: none;
            transition: color 0.2s;
            display: flex;
            align-items: center;
        }
        .recent-posts-list a:hover {
            color: var(--thi247-primary);
        }
        .list-group-item {
             border: none;
             padding: 12px 15px;
             border-bottom: 1px solid #f0f0f0;
        }

        /* 6. Chi tiết Profile */
        .profile-overview {
            padding: 20px;
        }
        .profile-overview .row {
            padding: 12px 0;
            border-bottom: 1px solid #f0f0f0;
            display: flex;
            align-items: center;
        }
        .profile-overview .row:last-child {
            border-bottom: none;
        }
        .profile-overview .label {
            font-weight: 600;
            color: var(--thi247-text-muted);
            font-size: 1rem;
            display: flex;
            align-items: center;
        }
        .profile-overview .label i {
             margin-right: 8px;
             color: var(--thi247-primary);
        }
        .profile-overview .col-lg-9, .col-md-8 {
             color: var(--thi247-text-dark);
        }

        /* 7. Nút Trở lại (Style mới) */
        .btn-back-style {
            background-color: var(--thi247-secondary) !important;
            border-color: var(--thi247-secondary) !important;
            border-radius: 25px;
            padding: 8px 20px;
            font-weight: 600;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            display: inline-flex;
            align-items: center;
            margin-bottom: 15px;
            color: white; /* Đảm bảo chữ trắng */
        }
        .btn-back-style i {
            margin-right: 8px;
        }
        
        /* 8. Nút Report */
        .btn-report {
            background-color: var(--thi247-danger);
            color: white;
            padding: 10px 20px;
            border-radius: 25px;
            font-weight: 600;
            margin-top: 15px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            display: inline-flex; /* Đảm bảo icon và text nằm trên cùng một hàng */
            align-items: center;
        }
        .btn-report i {
            margin-right: 8px;
        }

    </style>

<main id="main" class="main">
    <div class="container mt-4">
        
        <a href="${pageContext.request.contextPath}/forum.jsp" class="btn btn-primary btn-back-style">
            <i class="fas fa-arrow-left"></i> Trở lại
        </a>
        
        <section class="section profile">
            <div class="row">

                <div class="col-xl-4">
                    <div class="card">
                        <div class="card-body profile-card pt-4 d-flex flex-column align-items-center">
                            <img src="<%=user.getAvatarURL()%>"class="rounded-circle profile-avatar-img" width="130" height="130" alt="User Avatar">
                            <div class="profile-username">
                                <h2><%=user.getUsername()%></h2>
                                <h3 class="profile-role-text"><%=role%></h3>  
                            </div>
                            
                            <%
                            if(currentUser != null && currentUser.getRole() == 3 && currentUser.getUserID() != user.getUserID()){
                            %>
                            <button
                                class="btn btn-primary btn-report"
                                type="button"
                                data-toggle="modal"
                                data-target="#Report"
                                >
                                <i class="fas fa-flag"></i> Báo cáo người dùng 
                            </button>
                            <%
                            }
                            %>
                        </div>
                    </div>
                    
                    <div class="card mt-3">
                        <div class="card-body p-0">
                            <div class="list-group-item recent-posts-header d-flex justify-content-between align-items-center">
                                <h5 class="mb-0 text-primary">Bài đăng gần đây</h5>
                                <a href="ViewAllPost?userID=<%=user.getUserID()%>" class="text-decoration-none">Xem tất cả</a>
                            </div>
                            
                            <ul class="list-group list-group-flush recent-posts-list">
                                <%
                                List<Forum> forums = new ForumDAO().getAllPostFromUserID(user.getUserID());
                                if(forums.size() > 0){
                                    int count = 0;
                                    for(int i = forums.size() - 1; i >= 0 && count < 5; i--){
                                        Forum forum = forums.get(i);
                                        String str;
                                        if(forum.getPostTitle().length() > 30) 
                                            str = forum.getPostTitle().substring(0, 30) + "...";
                                        else str = forum.getPostTitle();
                                %>
                                <li class="list-group-item d-flex align-items-center">
                                    <a href="ForumDetail?postID=<%=forum.getPostID()%>">
                                        <i class="far fa-comment-dots me-2"></i> <%=str%>
                                    </a>
                                </li>
                                <%
                                        count++;
                                    }
                                } else {
                                %>
                                <li class="list-group-item text-center text-muted">
                                    <%=user.getUsername()%> chưa đăng bài viết nào!
                                </li>
                                <%
                                }
                                %>
                            </ul>
                        </div>
                    </div>
                </div>

                <div class="col-xl-8">
                    <div class="card">
                        <div class="card-body pt-3 profile-overview">

                            <h5 class="card-title text-primary">Thông tin cá nhân</h5>

                            <div class="row">
                                <div class="col-lg-3 col-md-4 label"><i class="fas fa-user-tag me-2"></i>Vai trò</div>
                                <div class="col-lg-9 col-md-8"><%=role%></div>
                            </div>

                            <div class="row">
                                <div class="col-lg-3 col-md-4 label"><i class="fas fa-birthday-cake me-2"></i>Ngày Sinh</div>
                                <div class="col-lg-9 col-md-8"><%= (user.getDob() != null) ? user.getDob() : "(Chưa cập nhật)" %></div>
                            </div>

                            <div class="row">
                                <div class="col-lg-3 col-md-4 label"><i class="fas fa-map-marker-alt me-2"></i>Nơi ở</div>
                                <div class="col-lg-9 col-md-8"><%= (user.getAddress() != null) ? user.getAddress() : "(Chưa cập nhật)" %></div>
                            </div>

                            <div class="row">
                                <div class="col-lg-3 col-md-4 label"><i class="fas fa-phone-alt me-2"></i>SĐT</div>
                                <div class="col-lg-9 col-md-8"><%= (user.getPhone() != null) ? user.getPhone() : "(Chưa cập nhật)" %></div>
                            </div>

                            <div class="row">
                                <div class="col-lg-3 col-md-4 label"><i class="fas fa-envelope me-2"></i>Email</div>
                                <div class="col-lg-9 col-md-8"><%=user.getEmail()%></div>
                            </div>          
                        </div>
                    </div></div>
                
                <%
                if(currentUser != null && currentUser.getRole() == 3){
                %>
                <div
                    class="modal fade"
                    id="Report"
                    tabindex="-1"
                    role="dialog"
                    aria-labelledby="threadModalLabel"
                    aria-hidden="true"
                    >
                    <div class="modal-dialog modal-lg" role="document">
                        <div class="modal-content">
                            <form action="NewReport" id="reportForm" method="POST" enctype="multipart/form-data">
                                <input type="hidden" name="link" value="user-profiles.jsp"/>
                                <input type="hidden" name="otherUserID" value="<%=id%>"/>
                                <div class="modal-header d-flex align-items-center bg-primary text-white">
                                    <h6 class="modal-title mb-0">Báo cáo người dùng</h6>
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                                </div>
                                <div class="modal-body">
                                    <div class="form-group">
                                        <label for="threadTitle">Lý do báo cáo</label>
                                        <div class="checkbox-group" style="display: flex; flex-wrap: wrap; gap: 10px; margin-top: 20px;">
                                            <label class="checkbox-container" style="width: 30%;"><input type="checkbox" name="reasons" value="1"/><span class="checkmark"></span> Lạm dụng ngôn từ</label>
                                            <label class="checkbox-container" style="width: 30%;"><input type="checkbox" name="reasons" value="2"/><span class="checkmark"></span> Hành vi gây rối diễn đàn</label>
                                            <label class="checkbox-container" style="width: 30%;"><input type="checkbox" name="reasons" value="3"/><span class="checkmark"></span> Tạo bài đăng sai mục đích</label>
                                            <label class="checkbox-container" style="width: 30%;"><input type="checkbox" name="reasons" value="4"/><span class="checkmark"></span> Bài đăng Không liên quan</label>
                                            <label class="checkbox-container" style="width: 30%;"><input type="checkbox" name="reasons" value="5"/><span class="checkmark"></span> Spam Bình luận quảng cáo</label>
                                            <label class="checkbox-container" style="width: 30%;"><input type="checkbox" name="reasons" value="6"/><span class="checkmark"></span> Bình luận phản cảm</label>
                                            <label class="checkbox-container" style="width: 30%;"><input type="checkbox" name="reasons" value="7" class="reason-checkbox"/><span class="checkmark"></span> lý do báo cáo khác</label>
                                        </div>
                                        <br>
                                        <div class="form-group" id="details-container" style="display: none;">
                                            <label for="thread-detail">Chi tiết</label>
                                            <textarea type="text" class="form-control" name="context" id="thread-detail" placeholder="Chi tiết" rows="5" style="resize: none; overflow: hidden;"></textarea>
                                        </div>
                                        <div id="image-preview-container">
                                            <label for="myfile">Chọn ảnh:</label>
                                            <input id="image-upload" type="file" name="image" accept="image/*">
                                            <br>
                                            <div id="image-preview-wrapper" style="position: relative;">
                                                <img id="image-preview" src="#" width="400" height="400" alt="Preview Image" style="display:none;">
                                                <button id="delete-image"><i class="fa fa-times"></i></button>
                                            </div>
                                        </div>
                                        <br><br>
                                        <textarea class="form-control summernote" style="display: none"></textarea>
                                        <div class="custom-file form-control-sm mt-3" style="max-width: 300px"></div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button onclick="removeURL(this)" type="button" class="btn btn-light" data-dismiss="modal">Hủy</button>
                                    <input type="submit" class="btn btn-primary" value="Gửi báo cáo"/>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
                <%
                }
                %>
                </div>
        </section>

    </main><script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.bundle.min.js"></script>
    <script type="text/javascript"></script>
    <script>
        // Hàm này không cần thiết nếu dùng thẻ <a> có href trực tiếp
        // function goToForumPage() { 
        //     window.location.href = "forum.jsp"; 
        // }

        function goToViewAllUsers() {
            window.location.href = "view-all-user.jsp";
        }

        // --- REPORT MODAL JS LOGIC (Đã giữ nguyên logic cũ) ---
        document.getElementById('image-upload').addEventListener('change', function (event) {
            var file = event.target.files[0];
            var reader = new FileReader();

            reader.onload = function (e) {
                var imgElement = document.getElementById('image-preview');
                imgElement.src = e.target.result;
                imgElement.style.display = 'block';
                document.getElementById('delete-image').style.display = 'inline-block';
            }

            reader.readAsDataURL(file);
        });

        document.getElementById('delete-image').addEventListener('click', function (event) {
            event.preventDefault(); 
            var imgElement = document.getElementById('image-preview');
            imgElement.src = '#'; 
            imgElement.style.display = 'none';
            document.getElementById('delete-image').style.display = 'none';
            document.getElementById('image-upload').value = '';
        });

        function removeURL() {
            var imgElement = document.getElementById('image-preview');
            imgElement.src = '#'; 
            imgElement.style.display = 'none';
            document.getElementById('image-upload').value = '';
        }

        // Function to show/hide the "Chi tiết" textarea
        document.querySelectorAll('.reason-checkbox').forEach(checkbox => {
            checkbox.addEventListener('change', () => {
                const detailsContainer = document.getElementById('details-container');
                const anyChecked = Array.from(document.querySelectorAll('.reason-checkbox')).some(cb => cb.checked);
                detailsContainer.style.display = anyChecked ? 'block' : 'none';

                // Toggle required attribute
                document.getElementById('thread-detail').required = anyChecked;
            });
        });
        document.getElementById('reportForm').addEventListener('submit', function (event) {
            var checkboxes = document.querySelectorAll('input[name="reasons"]');
            var isChecked = false;

            for (var i = 0; i < checkboxes.length; i++) {
                if (checkboxes[i].checked) {
                    isChecked = true;
                    break;
                }
            }

            if (!isChecked) {
                alert('Vui lòng chọn ít nhất một lý do báo cáo.');
                event.preventDefault(); // Ngăn chặn việc nộp biểu mẫu
            }
        });
    </script>

<jsp:include page="footer.jsp"></jsp:include>

<a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>