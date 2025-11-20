<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp"></jsp:include>

<style>
    /* CSS TÙY CHỈNH CHO TRANG ĐĂNG KÝ */
    #intro {
        min-height: 100vh; /* Đảm bảo form căn giữa màn hình */
        background-color: #f7f9fc; /* Màu nền nhẹ nhàng */
        padding-top: 50px;
        padding-bottom: 50px;
    }
    .register-form-container {
        max-width: 450px;
        margin: auto;
    }
    .form-control:focus {
        border-color: var(--bs-primary);
        box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, .25); /* Tối ưu shadow focus */
    }
    .google-btn {
        display: inline-flex;
        align-items: center;
        padding: 10px 20px;
        border-radius: 5px;
        background-color: #ffffff; /* Nền trắng */
        color: #333; /* Màu chữ đen */
        text-decoration: none;
        font-weight: 600;
        border: 1px solid #ccc;
        transition: all 0.2s ease-in-out;
    }
    .google-btn:hover {
        background-color: #f1f1f1;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        color: #000;
    }
    .google-btn i {
        font-size: 1.2rem;
        margin-right: 10px;
        color: #DB4437; /* Màu Google đỏ */
    }
</style>

<script>
    /* VẪN GIỮ CÁCH XỬ LÝ ACTIVE TAG TRÊN HEADER */
    document.addEventListener('DOMContentLoaded', function() {
        var container = document.getElementById("tagID");
        if (container) {
            var current = container.getElementsByClassName("active");
            if (current.length > 0) {
                current[0].className = current[0].className.replace(" active", "");
            }
        }
    });
</script>

<div id="intro" class="bg-light d-flex align-items-center">
    <div class="container">
        <div class="row justify-content-center">
            <div class="register-form-container col-lg-5 col-md-7">
                <form class="bg-white rounded-3 shadow-lg p-5" action="RegisterServlet" method="POST">
                    
                    <h4 class="card-title text-center mb-4 fw-bold text-primary">Đăng ký Tài khoản</h4>
                    <hr class="mb-4">

                    <div class="mb-3">
                        <label for="usernameInput" class="form-label visually-hidden">Tên đăng nhập</label>
                        <input type="text" id="usernameInput" minlength="8" class="form-control" name="username" placeholder="👤 Tên đăng nhập" required/>
                    </div>

                    <div class="mb-3">
                        <label for="emailInput" class="form-label visually-hidden">Email</label>
                        <input type="email" id="emailInput" class="form-control" name="email" placeholder="✉️ Email" required/>
                    </div>

                    <div class="mb-4">
                        <label for="passwordInput" class="form-label visually-hidden">Mật khẩu</label>
                        <input type="password" id="passwordInput" minlength="10" class="form-control" name="password" 
                               placeholder="🔒 Mật khẩu" 
                               pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{10,}" 
                               title="Mật khẩu phải có ít nhất 1 chữ cái hoa, 1 chữ cái thường, 1 số và ít nhất là 10 ký tự!" required/>
                    </div>
                    
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger p-2" role="alert">
                            <i class="bi bi-exclamation-triangle-fill"></i> ${errorMessage}
                        </div>
                    </c:if>
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success p-2" role="alert">
                            <i class="bi bi-check-circle-fill"></i> ${successMessage}
                        </div>
                    </c:if>

                    <div class="text-center mb-3">
                        <span>Đã có tài khoản? 
                            <a href="login.jsp" class="text-primary fw-bold text-decoration-none">Đăng nhập ngay</a>
                        </span>
                    </div>

                    <button type="submit" class="btn btn-primary w-100 py-2 fw-bold" data-mdb-ripple-init>
                        Đăng ký
                    </button>
                    
                </form>
                
                <div class="text-center mt-3">
                    <span class="text-muted">Hoặc tiếp tục với</span>
                    <div class="mt-2">
                        <a href="https://accounts.google.com/o/oauth2/auth?scope=https://www.googleapis.com/auth/userinfo.profile%20https://www.googleapis.com/auth/userinfo.email&redirect_uri=http://localhost:8080/THI247/LoginGoogleHandler&response_type=code&client_id=1029812003567-92uoqu8gm9iuqafta301erqdqjine7pc.apps.googleusercontent.com&approval_prompt=force" class="google-btn">
                            <i class="fa-brands fa-google"></i> Đăng ký bằng Google
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp"></jsp:include>
<a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>