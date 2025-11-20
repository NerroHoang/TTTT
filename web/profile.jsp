<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp"></jsp:include>

<style>
    /* 1. Thiết lập màu nền đồng bộ */
    :root {
        --thi247-primary: #17a2b8; /* Xanh ngọc */
        --thi247-secondary: #007bff; /* Xanh dương */
        --thi247-light-blue: #e0f2f7; /* Nền xanh nhạt */
        --thi247-text-dark: #343a40;
        --thi247-text-muted: #6c757d;
    }
    
    body {
        background-color: var(--thi247-light-blue); /* Áp dụng màu nền xanh nhạt */
        padding-bottom: 50px;
    }

    /* 2. Cấu trúc tổng thể */
    .main-content-profile {
        padding-top: 40px;
        padding-bottom: 40px;
    }

    /* 3. Thiết kế Card */
    .card {
        border-radius: 12px;
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
        border: none;
    }

    /* 4. Avatar và thông tin bên trái */
    .profile-avatar-img {
        width: 150px;
        height: 150px;
        border: 4px solid var(--thi247-primary); /* Viền nổi bật */
        object-fit: cover;
    }
    .profile-role {
        font-weight: 600;
        color: var(--thi247-secondary);
        margin-top: 5px;
    }
    
    /* 5. Khối Bài đăng gần đây */
    .recent-posts .card-header {
        background-color: #f8f9fa;
        border-bottom: 1px solid #eee;
        padding: 15px;
        border-radius: 12px 12px 0 0;
        font-weight: 700;
    }

    /* 6. Chi tiết thông tin cá nhân */
    .info-row {
        padding: 10px 0;
    }
    .info-label {
        font-weight: 600;
        color: var(--thi247-text-dark);
        font-size: 1rem;
    }
    .info-value {
        color: var(--thi247-text-muted);
        font-size: 1rem;
    }
    .btn-edit-profile {
        background-color: var(--thi247-primary);
        border-color: var(--thi247-primary);
        color: white;
        padding: 10px 25px;
        border-radius: 25px;
        font-weight: 600;
        transition: all 0.3s ease;
    }
    .btn-edit-profile:hover {
        background-color: #138496;
        border-color: #138496;
        transform: translateY(-2px);
    }

    /* 7. Nút Trở về */
    .btn-back {
        background-color: var(--thi247-secondary) !important;
        border-color: var(--thi247-secondary) !important;
        margin-top: 20px;
        border-radius: 25px;
        padding: 8px 20px;
        font-weight: 600;
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    }
    
    /* 8. Yêu cầu nâng cấp */
    .upgrade-link h5 {
        font-weight: 700;
        padding: 10px;
        margin: 0;
        border-radius: 12px;
        text-align: center;
        background-color: #e9ecef; /* Nền xám nhạt */
    }
    .upgrade-link a {
        text-decoration: none;
    }
    .text-warning-custom {
        color: #ffc107 !important; /* Màu vàng cam */
    }

</style>

<script>
    var container = document.getElementById("tagID");
    var tag = container.getElementsByClassName("tag");
    var current = container.getElementsByClassName("active");
    
    // Đảm bảo element active cũ được xóa
    if (current.length > 0) {
        current[0].className = current[0].className.replace(" active", "");
    }
    // Không cần gán active cho profile vì nó là menu riêng, nhưng nếu muốn, có thể gán:
    // document.querySelector('.nav-profile').classList.add('active'); 
</script>


<div class="container main-content-profile">
    <div class="main-body">
    <%
            Users user = (Users)session.getAttribute("currentUser");
            TeacherRequest requests = new AdminDAO().getRequestByUserID(user.getUserID());
            Subjects subject = new Subjects();
            if(requests != null){
                subject = new ExamDAO().getSubjectByID(requests.getSubjectID());
            }
            if(user != null){
            String role;
            if(user.getRole() == 1) role = "Admin";
            else if(user.getRole() == 2) role = "Giáo Viên/VIP";
            else role = "Học Sinh";
            
            // Không hiển thị mật khẩu dưới dạng * trong trang profile
            // String password = "";
            // for(int i = 0; i < user.getPassword().length(); i++){
            //     password += "*";
            // }
    %>

    <a class="btn btn-primary btn-back" href="Home"><i class="fas fa-arrow-left me-2"></i> Trở về</a>

    
    <div class="row gutters-sm mt-3">
        <div class="col-md-4 mb-3">
            <div class="card">
                <div class="card-body">
                    <div class="d-flex flex-column align-items-center text-center">
                        <img src="<%=user.getAvatarURL()%>" alt="User Avatar" class="rounded-circle profile-avatar-img">
                        <div class="mt-3">
                            <h4 class="text-primary"><%=user.getUsername()%></h4>
                            <p class="profile-role mb-1"><%=role%></p>
                            <p class="text-muted"><i class="fas fa-coins text-warning me-1"></i> Số dư: <%=user.getBalance()%></p>
                        </div>
                    </div>
                </div>
            </div>
            
            <%
            if(user.getRole() == 3){
            %>
            <div class="card mt-3 p-3 upgrade-link">
                <%
                if(requests == null){
                %>
                <a href="teacher-request.jsp"><h5 class="text-primary">Nâng cấp tài khoản (Trở thành Giáo Viên)</h5></a>
                
                <%
                    }else{
                %>
                <a href="#"><h5 class="text-warning-custom">Yêu cầu đang được xử lý</h5></a>
                <%
                    }
                %>
            </div>
            <%
                }
            %>

            <div class="card mt-3 recent-posts">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0 text-primary">Bài đăng gần đây</h5>
                    <a style="text-decoration: none; font-weight: 500;" href="ViewAllPostUser?userID=<%=user.getUserID()%>">Xem tất cả <i class="fas fa-arrow-right ms-1"></i></a>
                </div>
                <ul class="list-group list-group-flush">
                    <%
                    List<Forum> forums = new ForumDAO().getAllPostFromUserID(user.getUserID());
                    if(forums.size() > 0){
                        int size = (forums.size() > 5) ? forums.size() - 5 : 0;
                        for(int i = forums.size() - 1; i >= size; i--){
                        Forum forum = forums.get(i);
                        String str;
                        if(forum.getPostTitle().length() > 40) // Cắt ngắn tiêu đề cho list
                             str = forum.getPostTitle().substring(0, 40) + "...";
                        else str = forum.getPostTitle();
                    %>
                    <li class="list-group-item d-flex justify-content-between align-items-center flex-wrap">
                        <a
                            href="ForumDetail?postID=<%=forum.getPostID()%>"
                            class="text-body text-decoration-none"
                            title="<%=forum.getPostTitle()%>"
                            ><i class="far fa-comment-dots me-2"></i> <%=str%></a
                        >
                    </li>
                    <%
                        }
                    }
                    else{
                    %>
                    <li class="list-group-item text-center text-muted">
                        Bạn chưa đăng bài viết nào!
                    </li>
                    <%
                        }
                    %>
                </ul>
            </div>
        </div>
        
        <div class="col-md-8">
            <div class="card mb-3">
                <div class="card-body">
                    <h5 class="card-title text-primary mb-4" style="font-size: 1.5rem; font-weight: 700;">Thông tin cá nhân</h5>
                    
                    <div class="row info-row">
                        <div class="col-sm-3 info-label">
                            <i class="fas fa-user-tag me-2"></i>Username
                        </div>
                        <div class="col-sm-9 info-value">
                            <%=user.getUsername()%>
                        </div>
                    </div>
                    <hr>
                    <div class="row info-row">
                        <div class="col-sm-3 info-label">
                            <i class="fas fa-file-signature me-2"></i>Họ và tên
                        </div>
                        <div class="col-sm-9 info-value">
                            <%= (user.getFullname() != null && !user.getFullname().isEmpty()) ? user.getFullname() : "(Chưa cập nhật)" %>
                        </div>
                    </div>
                    <hr>
                    <div class="row info-row">
                        <div class="col-sm-3 info-label">
                            <i class="fas fa-phone-alt me-2"></i>Số điện thoại
                        </div>
                        <div class="col-sm-9 info-value">
                            <%=(user.getPhone() != null && !user.getPhone().isEmpty()) ? user.getPhone() : "(Chưa cập nhật)"%>
                        </div>
                    </div>
                    <hr>
                    <div class="row info-row">
                        <div class="col-sm-3 info-label">
                            <i class="fas fa-map-marker-alt me-2"></i>Nơi ở
                        </div>
                        <div class="col-sm-9 info-value">
                            <%= (user.getAddress() != null && !user.getAddress().isEmpty()) ? user.getAddress() : "(Chưa cập nhật)" %>
                        </div>
                    </div>
                    <hr>
                    <div class="row info-row">
                        <div class="col-sm-3 info-label">
                            <i class="fas fa-birthday-cake me-2"></i>Ngày sinh
                        </div>
                        <div class="col-sm-9 info-value">
                            <%= (user.getDob() != null && !user.getDob().isEmpty()) ? user.getDob() : "(Chưa cập nhật)" %>
                        </div>
                    </div>
                    <hr>
                    <div class="row info-row">
                        <div class="col-sm-3 info-label">
                            <i class="fas fa-envelope me-2"></i>Email
                        </div>
                        <div class="col-sm-9 info-value">
                            <%=user.getEmail()%>
                        </div>
                    </div>
                    <hr>
                    
                    <c:if test="${not empty message}">
                        <div class="alert alert-success mt-3" role="alert">${message}</div>
                    </c:if>
                    
                    <div class="row mt-4">
                        <div class="col-sm-12 text-center text-md-left">
                            <a class="btn btn-info btn-edit-profile" href="editprofile.jsp">
                                <i class="fas fa-edit me-2"></i> Chỉnh sửa thông tin
                            </a>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

    </div>
</div>
<%
    }
%>

<jsp:include page="footer.jsp"></jsp:include>

<a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i class="bi bi-arrow-up"></i></a>