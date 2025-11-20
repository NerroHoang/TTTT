<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="header.jsp"></jsp:include>
    
    <style>
        /* Các biến màu chủ đạo của THI247 */
        :root {
            --thi247-primary: #17a2b8; /* Xanh ngọc */
            --thi247-secondary: #007bff; /* Xanh dương */
            --thi247-light-blue: #e0f2f7; /* Nền xanh nhạt */
            --thi247-text-dark: #343a40;
        }

        /* 1. Màu nền đồng bộ */
        body {
            background-color: var(--thi247-light-blue);
            padding-bottom: 50px;
        }

        /* 2. Cải thiện khối Banner (Page Header) */
        .page-header {
            background-color: var(--thi247-primary) !important; 
            border-radius: 0 0 15px 15px; 
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 40px !important;
        }
        
        /* 3. Nút Trở về */
        .btn-back {
            background-color: var(--thi247-secondary) !important;
            border-color: var(--thi247-secondary) !important;
            margin-top: 20px;
            margin-left: 50px;
            margin-bottom: 15px;
            border-radius: 25px;
            padding: 8px 20px;
            font-weight: 600;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            display: inline-flex;
            align-items: center;
        }

        /* 4. Cấu trúc bảng */
        .section {
            padding: 0 50px;
            max-width: 1300px;
            margin: auto;
        }
        
        .card {
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            border: none;
        }

        .table thead th {
            background-color: var(--thi247-primary);
            color: white;
            font-weight: 700;
            vertical-align: middle;
            text-align: center !important;
        }
        
        .table td {
            vertical-align: middle;
            text-align: center;
        }
        
        /* 5. Nút Tác vụ */
        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 10px;
        }
        
        .action-buttons .btn {
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9em;
            font-weight: 600;
            min-width: 70px;
        }
        
        .btn-edit {
            background-color: var(--thi247-secondary); 
            border-color: var(--thi247-secondary);
        }
        
        .btn-delete-modal {
             background-color: #dc3545 !important;
             border-color: #dc3545 !important;
             color: white;
        }
        
        /* Đảm bảo link tiêu đề dễ đọc */
        table a {
             color: var(--thi247-text-dark);
             font-weight: 600;
             text-decoration: none;
        }
        table a:hover {
            color: var(--thi247-primary);
        }
        
        /* Tùy chỉnh Modal Xóa */
        .modal-content {
            border-radius: 10px;
        }
        .modal-header {
             background-color: var(--thi247-primary) !important;
             color: white;
             border-radius: 10px 10px 0 0;
             border-bottom: none;
        }
        .modal-footer .btn-delete-submit {
             background-color: #dc3545 !important;
             border-color: #dc3545 !important;
        }

    </style>
    <script>
        var container = document.getElementById("tagID");
        var tag = container.getElementsByClassName("tag");
        var current = container.getElementsByClassName("active");
        
        if (current.length > 0) {
            current[0].className = current[0].className.replace(" active", "");
        }
        // Giả sử không cần active tag nào trong trang này, hoặc bạn có thể gán active cho profile dropdown
    </script>

<%
if(session.getAttribute("userID") != null){
int id = (Integer)session.getAttribute("userID");
Users user = new UserDAO().findByUserID(id);
List<Forum> forums = new ForumDAO().getAllPostFromUserID(user.getUserID());
%>
<div class="container-fluid bg-primary py-5 mb-5 page-header">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-10 text-center">
                <h1 class="display-3 text-white animated slideInDown">Bài đăng của tôi</h1>
                <h3 class="text-white animated slideInDown">Danh sách những bài viết bạn đã đăng trên diễn đàn</h3>
            </div>
        </div>
    </div>
</div>
<main id="main" class="main" style="margin-left: 0">
    <a class="btn btn-primary btn-back" href="profile.jsp"><i class="fas fa-arrow-left me-2"></i> Trở về</a>
    <section class="section">
        <div class="row">
            <div class="col-lg-12">
                <div class="card">
                    <div class="card-body p-4">
                         <h5 class="card-title text-primary" style="text-align: center;">Quản lý Bài đăng</h5>
                        <%
                        if(forums.size() > 0){
                        %>
                        <div class="table-responsive">
                            <table class="table datatable table-hover">
                                <thead>
                                    <tr>
                                        <th style="width: 25%">Tiêu đề</th>
                                        <th style="width: 40%">Nội dung (Tóm tắt)</th>
                                        <th style="width: 15%" data-type="date" data-format="YYYY/DD/MM">Ngày đăng</th>
                                        <th style="width: 20%">Tác vụ</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                    String title;
                                    String content;
                                    for(int i = forums.size() - 1; i >= 0; i--){
                                        Forum forum = forums.get(i);
                                        String modalId = "threadModal" + forum.getPostID(); // Dùng Post ID để đảm bảo duy nhất
                                        
                                        if(forum.getPostTitle().length() > 40) 
                                            title = forum.getPostTitle().substring(0, 40) + "...";
                                        else title = forum.getPostTitle();
                                        
                                        if(forum.getPostContext().length() > 60) 
                                            content = forum.getPostContext().substring(0, 60) + "...";
                                        else content = forum.getPostContext();
                                    %>
                                    <tr>
                                        <td><a href="ForumDetail?postID=<%=forum.getPostID()%>" title="<%=forum.getPostTitle()%>"><%=title%></a></td>
                                        <td><%=content%></td>
                                        <td><%=forum.getPostDate()%></td>
                                        <td>
                                            <div class="action-buttons">
                                                <form action="PassDataPostUpdate" method="POST" style="margin: 0;">
                                                    <input type="hidden" name="userID" value="<%=id%>">
                                                    <input type="hidden" name="postID" value="<%=forum.getPostID()%>">
                                                    <input type="hidden" name="postIMG" value="<%=forum.getPostImg()%>">
                                                    <button type="submit" class="btn btn-primary btn-edit">Sửa</button>
                                                </form>
                                                
                                                <button
                                                    class="btn btn-delete-modal"
                                                    type="button"
                                                    data-toggle="modal"
                                                    data-target="#<%= modalId %>"
                                                    >
                                                    Xoá
                                                </button>
                                            </div>
                                            
                                            <div class="modal fade" id="<%= modalId %>" tabindex="-1" role="dialog" aria-labelledby="threadModalLabel" aria-hidden="true">
                                                <div class="modal-dialog modal-sm" role="document">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h6 class="modal-title mb-0">Xác nhận xóa?</h6>
                                                            <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button>
                                                        </div>
                                                        <div class="modal-body text-center">
                                                            <p>Bạn có chắc chắn muốn xóa bài đăng này?</p>
                                                            <form action="DeletePost" method="POST">
                                                                <input type="hidden" name="userID" value="<%=id%>">
                                                                <input type="hidden" name="postID" value="<%=forum.getPostID()%>">
                                                                <div class="modal-footer justify-content-center" style="border-top: none;">
                                                                    <button type="button" class="btn btn-light" data-dismiss="modal" >Hủy</button>
                                                                    <input type="submit" class="btn btn-primary btn-delete-submit" value="Xoá bài đăng"/>
                                                                </div>
                                                            </form>
                                                        </div> 
                                                    </div> 
                                                </div> 
                                            </div>
                                        </td>
                                    </tr>
                                    <%
                                        }
                                     %>
                                </tbody>
                            </table>
                        </div>
                        <%
                            }
                            else{
                        %>
                        <div class="alert alert-info text-center mt-3 mb-3">
                            <h3 class="mb-0">Bạn chưa đăng bài viết nào!</h3>
                        </div>
                        <%
                            }
                        %>
                        </div>
                </div>

            </div>
        </div>
    </section>

</main><script src="assets/vendor/apexcharts/apexcharts.min.js"></script>
<script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="assets/vendor/chart.js/chart.umd.js"></script>
<script src="assets/vendor/echarts/echarts.min.js"></script>
<script src="assets/vendor/quill/quill.js"></script>
<script src="assets/vendor/simple-datatables/simple-datatables.js"></script>
<script src="assets/vendor/tinymce/tinymce.min.js"></script>
<script src="assets/vendor/php-email-form/validate.js"></script>

<script src="assets/js/main.js"></script>
<script src="https://code.jquery.com/jquery-1.10.2.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript"></script>
<%
    }
%>
<jsp:include page="footer.jsp"></jsp:include>

<a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>