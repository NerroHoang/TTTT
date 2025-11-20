<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp"></jsp:include>

<style>
    /* --- CSS ĐỒNG BỘ VỚI TRANG LOGIN/REGISTER --- */
    #intro {
        min-height: calc(100vh - 100px); 
        background-color: #f7f9fc; 
        padding-top: 50px;
        padding-bottom: 50px;
    }
    .form-container { 
        max-width: 450px;
        margin: auto;
    }
    .form-control:focus {
        border-color: var(--bs-primary);
        box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, .25); 
    }
    .card-title {
        font-weight: 700;
        color: var(--bs-primary);
    }
    .btn-back {
        text-decoration: none;
        font-weight: 600;
        color: #6c757d;
        transition: color 0.2s;
    }
    .btn-back:hover {
        color: var(--bs-primary);
    }
</style>

<script>
    /* Script xóa active tag trên header */
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

<%
    if(session.getAttribute("currentUser") != null){
    Users user = (Users)session.getAttribute("currentUser");
%>

<div id="intro" class="bg-light d-flex align-items-center">
    <div class="container">
        <div class="row justify-content-center">
            <div class="form-container col-lg-5 col-md-7">
                
                <form class="bg-white rounded-3 shadow-lg p-5" action="ChangePassword" method="POST">
                    
                    <div class="text-center mb-4">
                        <h4 class="card-title">Đổi mật khẩu</h4>
                        <p class="text-muted small">Cập nhật mật khẩu mới cho tài khoản của bạn</p>
                    </div>
                    <hr class="mb-4">

                    <%
                    // Logic kiểm tra mật khẩu cũ (giữ nguyên)
                    if(!user.getPassword().isBlank()){
                    %>
                    <div class="mb-3">
                        <label for="oldPass" class="form-label visually-hidden">Mật khẩu cũ</label>
                        <input type="password" id="oldPass" minlength="10" class="form-control" name="oldPassword" placeholder="🔑 Mật khẩu cũ" required/>
                    </div>
                    <%
                        } else {
                    %>
                        <input type="hidden" name="oldPassword" value=""/>
                    <%
                        }
                    %>

                    <div class="mb-3">
                        <label for="newPass" class="form-label visually-hidden">Mật khẩu mới</label>
                        <input type="password" id="newPass" minlength="8" class="form-control" name="newPassword" 
                               placeholder="🔒 Mật khẩu mới" 
                               pattern="(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,}" 
                               title="Mật khẩu phải có ít nhất 1 chữ cái hoa, 1 chữ cái thường, 1 số và ít nhất là 8 ký tự!" required/>
                    </div>

                    <div class="mb-4">
                        <label for="confirmPass" class="form-label visually-hidden">Xác nhận mật khẩu</label>
                        <input type="password" id="confirmPass" minlength="10" class="form-control" name="confirmPassword" placeholder="🛡️ Xác nhận mật khẩu" required/>
                    </div>

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger p-2 mb-3" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-1"></i> ${errorMessage}
                        </div>
                    </c:if>
                    
                    <button type="submit" class="btn btn-primary w-100 py-2 fw-bold mb-3" data-mdb-ripple-init>
                        Lưu thay đổi
                    </button>

                    <div class="text-center">
                        <a href="profile.jsp" class="btn-back">
                            <i class="bi bi-arrow-left"></i> Quay lại hồ sơ
                        </a>
                    </div>

                </form>
            </div>
        </div>
    </div>
</div>

<%
    } else {
        // Nếu chưa đăng nhập, chuyển hướng hoặc thông báo (tuỳ logic của bạn)
        response.sendRedirect("login.jsp");
    }
%>

<jsp:include page="footer.jsp"></jsp:include>
<a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>