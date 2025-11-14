<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
<jsp:include page="header.jsp"></jsp:include>
<%
if(session.getAttribute("currentUser") != null){
Users user = (Users)session.getAttribute("currentUser");
if(user.getRole() == 2){
TeacherRequest requests = new AdminDAO().getRequestByUserID(user.getUserID());
%>

<script>
    var container = document.getElementById("tagID");
    var tag = container.getElementsByClassName("tag");
    var current = container.getElementsByClassName("active");
    current[0].className = current[0].className.replace(" active", "");
    tag[2].className += " active";
</script>
<br><!-- comment -->

<div class="text-center wow fadeInUp" data-wow-delay="0.1s">
    <h3 class="section-title bg-white text-center text-primary px-3">Thành công</h3>

</div>

<div class="row" style="border-radius: 10px">
    <div class="col-lg-12" style="width: 1000px; margin: auto;">
        <div class="card">
            <div class="card-body">
                <div class="container-xxl py-5">
                    <div class="container">
                        <div class="text-center wow fadeInUp" data-wow-delay="0.1s">
                            <h1 class="mb-5">Tài khoản của bạn đã được nâng cấp lên User VIP</h1>
                        </div>
                        <div class="text-center wow fadeInUp" data-wow-delay="0.1s">
                            <h1 class="mb-5">Thời gian sử dụng của bạn là: <%= user.getExpirationDate() != null ? user.getExpirationDate().toString() : "Chưa có thông tin" %> </h1>
                        </div>

                        <br>
                        <div class="row g-4 justify-content-center">
                            <div class="col-lg-4 col-md-6 wow fadeInUp">
                                <div class="course-item bg-light">
                                    <div class="position-relative overflow-hidden"></div>
                                    <div class="text-center p-4 pb-0">
                                        <a href="Home" style="text-decoration: none">
                                            <h3 class="mb-0">Quay về trang chủ</h3>
                                        </a>  
                                    </div>
                                </div>
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
}
%>

<jsp:include page="footer.jsp"></jsp:include>
<!-- Back to Top -->
<a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>
