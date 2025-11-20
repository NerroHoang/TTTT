<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
<jsp:include page="header.jsp"></jsp:include>

<style>
    .btn-xoa {
        color: black;
    }
    .table th, .table td {
        vertical-align: middle !important;
        text-align: center;
    }
    .modal-content {
        border-radius: 12px;
    }
</style>

<script>
    var container = document.getElementById("tagID");
    if (container) {
        var tag = container.getElementsByClassName("tag");
        var current = container.getElementsByClassName("active");
        if (current.length > 0) {
            current[0].className = current[0].className.replace(" active", "");
        }
    }
</script>

<%
if(session.getAttribute("currentUser") != null){
Users user = (Users)session.getAttribute("currentUser");
List<Notification> notis = new NotificationDAO().getAllNotification();
%>

<!-- ===== HEADER ===== -->
<div class="container-fluid bg-primary py-5 mb-5 page-header">
    <div class="container text-center py-4">
        <h1 class="display-4 text-white fw-bold">Thông báo hệ thống</h1>

        <% if(user.getRole() == 1){ %>
            <h3 class="text-white">Danh sách thông báo bạn đã đăng lên hệ thống</h3>
        <% } else { %>
            <h3 class="text-white">Danh sách thông báo của hệ thống</h3>
        <% } %>
    </div>
</div>

<!-- ===== MAIN ===== -->
<main id="main" class="main" style="margin-left: 0 !important;">

<section class="section">
    <div class="container">

        <div class="card shadow-sm">
            <div class="card-body">

                <% if(notis.size() > 0){ %>

                <div class="table-responsive">
                    <table class="table table-bordered table-hover">
                        <thead class="table-primary">
                            <tr>
                                <th>Thông báo</th>
                                <th data-type="date">Ngày đăng</th>
                                <% if(user.getRole() == 1){ %>
                                    <th>Tác vụ</th>
                                <% } %>
                            </tr>
                        </thead>

                        <tbody>
                        <% for(int i = notis.size() - 1; i >= 0; i--){ 
                               Notification noti = notis.get(i);
                               String modalId = "threadModal" + i;
                        %>
                            <tr>
                                <td><%=noti.getNotiName()%></td>
                                <td><%=noti.getNotiCreateDate()%></td>

                                <% if(user.getRole() == 1){ %>
                                <td>
                                    <button class="btn btn-danger btn-sm"
                                            data-toggle="modal"
                                            data-target="#<%= modalId %>">
                                        Xoá
                                    </button>
                                </td>
                                <% } %>
                            </tr>

                            <!-- ===== MODAL XÓA ===== -->
                            <div class="modal fade" id="<%= modalId %>" tabindex="-1">
                                <div class="modal-dialog">
                                    <div class="modal-content">

                                        <form action="DeleteNotification" method="POST">
                                            <input type="hidden" name="notiID" value="<%=noti.getNotiID()%>">

                                            <div class="modal-header bg-primary text-white">
                                                <h5 class="modal-title">Xác nhận xóa thông báo</h5>
                                                <button type="button" class="btn-close" data-dismiss="modal"></button>
                                            </div>

                                            <div class="modal-body">
                                                <p>Bạn có chắc chắn muốn xóa thông báo này không?</p>
                                            </div>

                                            <div class="modal-footer">
                                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                                                <button type="submit" class="btn btn-danger">Xóa</button>
                                            </div>

                                        </form>

                                    </div>
                                </div>
                            </div>
                            <!-- ===== END MODAL ===== -->

                        <% } %>
                        </tbody>
                    </table>
                </div>

                <% } else { %>
                    <h3 class="text-center my-4">Không có thông báo nào!</h3>
                <% } %>

            </div>
        </div>

    </div>
</section>

</main>

<!-- JS -->
<script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="assets/vendor/simple-datatables/simple-datatables.js"></script>
<script src="assets/js/main.js"></script>

<% } %>

<jsp:include page="footer.jsp"></jsp:include>

<a href="#" class="back-to-top d-flex align-items-center justify-content-center">
    <i class="bi bi-arrow-up-short"></i>
</a>
