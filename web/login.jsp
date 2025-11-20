<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp"></jsp:include>

<style>
    /* CSS TÁI SỬ DỤNG TỪ TRANG ĐĂNG KÝ (register.jsp) */
    #intro {
        min-height: calc(100vh - 100px); 
        background-color: #f7f9fc; 
        padding-top: 50px;
        padding-bottom: 50px;
    }
    .register-form-container { 
        max-width: 450px;
        margin: auto;
    }
    .form-control:focus {
        border-color: var(--bs-primary);
        box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, .25); 
    }
    
    /* ======== ĐIỀU CHỈNH NÚT GOOGLE TẠI ĐÂY ======== */
    .google-btn {
        display: flex; /* Dùng flex để căn giữa nội dung */
        align-items: center;
        justify-content: center;
        padding: 10px 20px;
        border-radius: 0.5rem; /* Bo tròn tương tự nút Đăng nhập */
        background-color: #ffffff; /* Nền trắng */
        color: #333; /* Màu chữ đen */
        text-decoration: none;
        font-weight: 600;
        border: 1px solid #ccc;
        box-shadow: 0 2px 4px rgba(0,0,0,0.08); /* Đổ bóng nhẹ */
        transition: all 0.2s ease-in-out;
    }
    .google-btn:hover {
        background-color: #f5f5f5; /* Thay đổi màu khi hover */
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15); /* Shadow mạnh hơn khi hover */
        color: #000;
        border-color: #aaa;
    }
    .google-btn i {
        font-size: 1.2rem;
        margin-right: 10px;
        color: #DB4437; /* Đảm bảo màu Google đỏ nổi bật */
    }
    /* ============================================== */

    .btn-primary.w-100.py-2.fw-bold {
        font-size: 1rem;
    }
</style>

<script>
    /* Script để xóa class 'active' khỏi navigation bar. */
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
                <form class="bg-white rounded-3 shadow-lg p-5" action="login" method="POST">
                    
                    <h4 class="card-title text-center mb-4 fw-bold text-primary">Đăng nhập Tài khoản</h4>
                    <hr class="mb-4">

                    <div class="mb-3">
                        <label for="emailInput" class="form-label visually-hidden">Email</label>
                        <input type="email" id="emailInput" class="form-control" name="email" placeholder="✉️ Email" required/>
                    </div>

                    <div class="mb-3"> 
                        <label for="passwordInput" class="form-label visually-hidden">Mật khẩu</label>
                        <input type="password" id="passwordInput" class="form-control" name="password" placeholder="🔒 Mật khẩu" required/>
                    </div>
                    
                    <c:if test="${not empty loginWarning || not empty errorMessage}">
                        <div class="alert alert-danger p-2 mb-3" role="alert">
                            <i class="bi bi-exclamation-triangle-fill"></i> ${loginWarning} ${errorMessage}
                        </div>
                    </c:if>

                    <div class="d-flex justify-content-end mb-4">
                        <a href="RequestPasswordServlet" class="text-primary fw-bold text-decoration-none" style="font-size: 0.9rem;">Quên mật khẩu?</a>
                    </div>
                    
                    <button type="submit" class="btn btn-primary w-100 py-2 fw-bold" data-mdb-ripple-init>
                        Đăng nhập
                    </button>
                    
                    <div class="text-center mt-3">
                        <span>Chưa có tài khoản? 
                            <a href="register.jsp" class="text-primary fw-bold text-decoration-none">Đăng ký ở đây</a>
                        </span>
                    </div>

                </form>
                
                <div class="text-center mt-3">
                    <span class="text-muted fw-semibold">Hoặc tiếp tục với</span>
                    <div class="mt-2">
                        <a href="https://accounts.google.com/o/oauth2/auth?scope=https://www.googleapis.com/auth/userinfo.profile%20https://www.googleapis.com/auth/userinfo.email&redirect_uri=http://localhost:8080/THI247/LoginGoogleHandler&response_type=code&client_id=621245293637-s73d1t26r1djdn1k8p1bogge2hu7tjgb.apps.googleusercontent.com&approval_prompt=force" class="google-btn w-100">
                            <i class="fa-brands fa-google"></i> Đăng nhập bằng Google
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp"></jsp:include>
<a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>