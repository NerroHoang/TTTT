<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp"></jsp:include>
<!DOCTYPE html>

<style>
    /* CSS TÁI SỬ DỤNG TỪ TRANG ĐĂNG KÝ (register.jsp) */
    #intro {
        /* Đảm bảo form căn giữa màn hình */
        min-height: calc(100vh - 100px); /* Điều chỉnh để trừ header/footer */
        background-color: #f7f9fc; /* Màu nền nhẹ nhàng */
        padding-top: 50px;
        padding-bottom: 50px;
        display: flex;
        align-items: center; /* Căn giữa dọc */
    }
    .form-container { /* Sử dụng tên chung cho container form */
        max-width: 450px;
        margin: auto;
    }
    .form-control:focus {
        border-color: var(--bs-primary);
        box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, .25); 
    }
    .form-control {
        height: 50px;
        font-size: 1rem;
        border-radius: 0.5rem;
    }
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

<div id="intro" class="bg-light shadow-2-strong">
    <div class="mask d-flex align-items-center h-100 w-100">
        <div class="container">
            <div class="row justify-content-center">
                <div class="form-container col-lg-5 col-md-8"> 
                    <form class="bg-white rounded-3 shadow-lg p-5" action="RequestPasswordServlet" method="POST">
                        
                        <h4 class="card-title text-center mb-4 fw-bold text-primary">Khôi phục mật khẩu</h4>
                        <hr class="mb-4">
                        
                        <p class="text-center text-muted mb-4" style="font-size: 0.9rem;">
                            Vui lòng nhập email của bạn để nhận liên kết đặt lại mật khẩu.
                        </p>

                        <div class="form-outline mb-4">
                            <label for="emailInput" class="form-label visually-hidden">Email</label>
                            <input type="email" id="emailInput" class="form-control" name="email" placeholder="✉️ Email đã đăng ký" required/>
                        </div>

                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger p-2 mb-3" role="alert">
                                <i class="bi bi-exclamation-triangle-fill"></i> ${errorMessage}
                            </div>
                        </c:if>
                        
                        <button type="submit" class="btn btn-primary w-100 py-2 fw-bold" data-mdb-ripple-init>
                            Yêu cầu đổi mật khẩu
                        </button>
                        
                        <div class="text-center mt-3">
                            <a href="login.jsp" class="text-primary fw-bold text-decoration-none" style="font-size: 0.95rem;">Quay lại Đăng nhập</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp"></jsp:include>
<a href="#" class="btn btn-lg btn-primary btn-lg-square back-to-top"><i class="bi bi-arrow-up"></i></a>