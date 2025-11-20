<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.ParseException" %>
<jsp:include page="header.jsp"></jsp:include>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            var container = document.getElementById("tagID");
            if (container) {
                var current = container.getElementsByClassName("active");
                if (current.length > 0) {
                    current[0].className = current[0].className.replace(" active", "");
                }
            }
        });
    </script>

    <style>
        /* 1. Tái sử dụng bộ màu từ Profile */
        :root {
            --thi247-primary: #17a2b8; /* Xanh ngọc */
            --thi247-secondary: #007bff; /* Xanh dương */
            --thi247-light-blue: #e0f2f7; /* Nền xanh nhạt */
            --thi247-text-dark: #343a40;
            --thi247-text-muted: #6c757d;
        }

        body {
            background-color: var(--thi247-light-blue);
            padding-bottom: 50px;
        }

        .main-content-edit {
            padding-top: 40px;
            padding-bottom: 40px;
        }

        /* 2. Card Styles */
        .card {
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            border: none;
            background-color: #fff;
            margin-bottom: 20px;
        }

        /* 3. Avatar & Upload Overlay */
        .profile-avatar-container {
            position: relative;
            width: 150px;
            height: 150px;
            margin: 0 auto;
            cursor: pointer;
        }

        .profile-avatar-img {
            width: 100%;
            height: 100%;
            border: 4px solid var(--thi247-primary);
            object-fit: cover;
            transition: all 0.3s ease;
        }

        .avatar-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            border-radius: 50%; /* Bo tròn theo ảnh */
            display: flex;
            justify-content: center;
            align-items: center;
            opacity: 0;
            transition: opacity 0.3s ease;
            color: white;
            font-size: 1.5rem;
        }

        .profile-avatar-container:hover .avatar-overlay {
            opacity: 1;
        }

        /* 4. Form Input Styles */
        .form-control {
            border-radius: 25px; /* Bo tròn input */
            padding: 10px 20px;
            border: 1px solid #ced4da;
        }

        .form-control:focus {
            border-color: var(--thi247-primary);
            box-shadow: 0 0 0 0.2rem rgba(23, 162, 184, 0.25);
        }

        .form-label-custom {
            font-weight: 600;
            color: var(--thi247-text-dark);
            margin-top: 10px; /* Căn chỉnh label theo chiều dọc */
        }

        /* 5. Buttons */
        .btn-save {
            background-color: var(--thi247-primary);
            border-color: var(--thi247-primary);
            color: white;
            border-radius: 25px;
            padding: 10px 30px;
            font-weight: 600;
            transition: all 0.3s;
        }

        .btn-save:hover {
            background-color: #138496;
            transform: translateY(-2px);
        }

        .btn-back {
            background-color: var(--thi247-secondary);
            border-color: var(--thi247-secondary);
            color: white;
            border-radius: 25px;
            padding: 8px 20px;
            font-weight: 600;
            margin-bottom: 20px;
            display: inline-block;
            text-decoration: none;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .btn-change-pass {
            background-color: #6c757d;
            color: white;
            border-radius: 25px;
            padding: 8px 20px;
            text-decoration: none;
            font-size: 0.9rem;
            transition: 0.3s;
            border: none;
            display: inline-block;
        }
        .btn-change-pass:hover {
            background-color: #5a6268;
            color: white;
        }

        /* 6. Typography */
        .profile-role {
            font-weight: 600;
            color: var(--thi247-secondary);
        }
    </style>

<%
    Users user = (Users) session.getAttribute("currentUser");
    if (user != null) {
        String role;
        if (user.getRole() == 1)
            role = "Admin";
        else if (user.getRole() == 2)
            role = "Giáo Viên";
        else
            role = "Học Sinh";
%>

<div class="container main-content-edit">
    <a class="btn btn-back" href="profile.jsp"><i class="fas fa-arrow-left me-2"></i> Trở về Profile</a>

    <div class="main-body">
        <div class="row gutters-sm">
            <div class="col-lg-4 mb-3">
                <div class="card h-100">
                    <div class="card-body">
                        <form id="updateForm" action="avatarUpdate" method="POST" enctype="multipart/form-data">
                            <div class="d-flex flex-column align-items-center text-center">

                                <div class="profile-avatar-container" onclick="UpdateImage()">
                                    <input type="file" name="file" id="imgupload" accept="image/*" style="display:none" onchange="submitForm()"/>
                                    <img src="<%=user.getAvatarURL()%>" alt="Avatar" class="rounded-circle profile-avatar-img">

                                    <div class="avatar-overlay">
                                        <i class="fas fa-camera"></i>
                                    </div>
                                </div>

                                <div class="mt-3">
                                    <h4 class="text-primary"><%=user.getUsername()%></h4>
                                    <p class="profile-role mb-1"><%=role%></p>
                                    <p class="text-muted font-size-sm">Nhấn vào ảnh để thay đổi avatar</p>
                                </div>

                                <hr class="w-100 my-3">

                                <a href="changepassword.jsp" class="btn-change-pass">
                                    <i class="fas fa-key me-1"></i> Đổi mật khẩu
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <div class="col-lg-8">
                <div class="card h-100">
                    <div class="card-body p-4">
                        <h5 class="card-title text-primary mb-4" style="font-weight: 700;">Chỉnh sửa thông tin</h5>

                        <form action="update" method="POST">
                            <div class="row mb-3 align-items-center">
                                <div class="col-sm-3">
                                    <h6 class="mb-0 form-label-custom">Username</h6>
                                </div>
                                <div class="col-sm-9 text-secondary">
                                    <input type="text" class="form-control" name="username" value="<%=user.getUsername()%>">
                                    <c:if test="${not empty message_username}">
                                        <small class="text-danger mt-1 d-block">${message_username}</small>
                                    </c:if>
                                </div>
                            </div>

                            <div class="row mb-3 align-items-center">
                                <div class="col-sm-3">
                                    <h6 class="mb-0 form-label-custom">Họ và tên</h6>
                                </div>
                                <div class="col-sm-9 text-secondary">
                                    <input type="text" class="form-control" name="fullname" placeholder="Nhập họ tên đầy đủ" value="<%= (user.getFullname() != null) ? user.getFullname() : ""%>">
                                </div>
                            </div>

                            <div class="row mb-3 align-items-center">
                                <div class="col-sm-3">
                                    <h6 class="mb-0 form-label-custom">Số điện thoại</h6>
                                </div>
                                <div class="col-sm-9 text-secondary">
                                    <input type="tel" class="form-control" name="phone" pattern="[0-9]{10}" title="Số điện thoại phải có 10 chữ số" placeholder="Nhập số điện thoại" value="<%=(user.getPhone() != null) ? user.getPhone() : ""%>">
                                </div>
                            </div>

                            <div class="row mb-3 align-items-center">
                                <div class="col-sm-3">
                                    <h6 class="mb-0 form-label-custom">Nơi ở</h6>
                                </div>
                                <div class="col-sm-9 text-secondary">
                                    <input type="text" class="form-control" name="address" placeholder="Nhập địa chỉ hiện tại" value="<%= (user.getAddress() != null) ? user.getAddress() : ""%>">
                                </div>
                            </div>

                            <div class="row mb-3 align-items-center">
                                <div class="col-sm-3">
                                    <h6 class="mb-0 form-label-custom">Ngày sinh</h6>
                                </div>
                                <%
                                    // Xử lý Date Format giữ nguyên logic cũ
                                    String dobStr = user.getDob();
                                    String formattedDobStr = "";
                                    if (dobStr != null && !dobStr.isEmpty()) {
                                        try {
                                            SimpleDateFormat originalFormat = new SimpleDateFormat("dd-MM-yyyy");
                                            Date dob = originalFormat.parse(dobStr);
                                            SimpleDateFormat newFormat = new SimpleDateFormat("yyyy-MM-dd");
                                            formattedDobStr = newFormat.format(dob);
                                        } catch (ParseException e) {
                                            e.printStackTrace();
                                        }
                                    }
                                %>
                                <div class="col-sm-9 text-secondary">
                                    <input type="date" class="form-control" name="dob" value="<%= formattedDobStr%>">
                                </div>
                            </div>

                            <hr class="my-4">

                            <div class="row">
                                <div class="col-sm-12 text-end">
                                    <button type="submit" class="btn btn-save">
                                        <i class="fas fa-save me-2"></i> Lưu thay đổi
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function UpdateImage() {
        document.getElementById("imgupload").click();
    }
    function submitForm() {
        document.getElementById("updateForm").submit();
    }
</script>

<%
    }
%>

<jsp:include page="footer.jsp"></jsp:include>
<a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i class="bi bi-arrow-up"></i></a>