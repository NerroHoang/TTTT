<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
<jsp:include page="header.jsp"></jsp:include>
    <style>
        .btn-xoa{
            color: black;
        }

    </style>
    <script>
        var container = document.getElementById("tagID");
        var tag = container.getElementsByClassName("tag");
        var current = container.getElementsByClassName("active");
        current[0].className = current[0].className.replace(" active", "");
    </script>

<%
if(session.getAttribute("currentUser") != null){
Users user = (Users)session.getAttribute("currentUser");
List<Notification> notis = new NotificationDAO().getAllNotification();
%>
<div class="container-fluid bg-primary py-5 mb-5 page-header">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-10 text-center">
                <h1 class="display-3 text-white animated slideInDown">Thông báo hệ thống</h1>

                <%
                 String role;
                            if(user.getRole() == 1){                            
                %>
                <h3 class="text-white animated slideInDown">Dưới đây là danh sách những thông báo bạn đã đăng lên hệ thống</h3>

                <%
                    } else{
                %>
                <h3 class="text-white animated slideInDown">Dưới đây là danh sách những thông báo của hệ thống</h3>
                <%
                }
                %>
            </div>
        </div>
    </div>
</div>
<main id="main" class="main" style="margin-left: 0">
    <a class="btn btn-primary" style="background-color:blue ; margin-left: 9%;" href="notification.jsp">Trở về</a>
    <section class="section" style="margin: auto">

        <div class="col-lg-12" >

            <div class="card">
                <div class="card-body" style="justify-content: center; margin: auto; width: 1200px">
                    <!-- Table with stripped rows -->
                    <%
                    if(notis.size() > 0){
                    %>
                    <table class="table datatable">
                        <thead>
                            <tr style="text-align: center">
                                <th style="text-align: center">ID</th>
                                <th style="text-align: center">Thông báo</th>
                                <th style="text-align: center" data-type="date">Ngày đăng</th>
                                    <%if(user.getRole() == 1){%>
                                <th style="text-align: center">Tác vụ</th>
                                    <% 
                                        } 
                                    %>
                            </tr>
                        </thead>
                        <tbody>
                            <!--bai dang-->
                            <%
                            for(int i = notis.size() - 1; i >= 0; i--){
                                Notification noti = notis.get(i);
                                String modalId = "threadModal" + i;

                            %>
                            <tr>
                                <td style="text-align: center"><%=noti.getNotiID()%></td>
                                <td style="text-align: center"><%=noti.getNotiName()%></td>
                                <td style="text-align: center"><%=noti.getNotiCreateDate()%></td>
                                <%if(user.getRole() == 1){%>
                                <td style="display: flex; text-align: center; justify-content: center">
                                    <div class="inner-sidebar-header justify-content-center" style="background-color: red; border-radius: 5px">
                                        <button
                                            class="btn btn-danger"
                                            type="button"
                                            data-toggle="modal"
                                            data-target="#<%= modalId %>"  
                                            >
                                            Xoá
                                        </button>
                                    </div>
                                </td>
                                <% 
                                    } 
                                %>
                            </tr>
                        <div class="modal fade" id="<%= modalId %>" tabindex="-1" role="dialog" aria-labelledby="threadModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-lg" role="document">
                                <div class="modal-content" style="width: 500px; margin: auto">
                                    <form action="DeleteNotification" method="POST">
                                        <input type="hidden" name="notiID" value="<%=noti.getNotiID()%>">
                                        <div class="modal-header d-flex align-items-center bg-primary text-white">
                                            <h6 class="modal-title mb-0" id="threadModalLabel">Xác nhận xóa thông báo
                                                <div class="modal-body">
                                                    <div class="form-group">                       
                                                        <div class="modal-footer">
                                                            <button type="button" class="btn btn-light" data-dismiss="modal" >Hủy</button>
                                                            <input type="submit" class="btn btn-primary" style="background-color: red" value="Xoá thông báo"/>
                                                        </div>
                                                    </div> 
                                                </div>
                                                </form>
                                        </div> 
                                </div>                        
                            </div>      
                        </div>
                        <%
                            }
                          }
                          else{
                        %>
                        <h3 class="text-center">bạn chưa từng làm một bài kiểm tra nào!</h3>
                        <%
                            }
                        %>
                        <!--ket thuc bai dang-->
                        </tbody>
                    </table>
                    <!-- End Table with stripped rows -->

                </div>

            </div>
        </div>
    </section>

</main><!-- End #main -->

<!-- Vendor JS Files -->
<script src="assets/vendor/apexcharts/apexcharts.min.js"></script>
<script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="assets/vendor/chart.js/chart.umd.js"></script>
<script src="assets/vendor/echarts/echarts.min.js"></script>
<script src="assets/vendor/quill/quill.js"></script>
<script src="assets/vendor/simple-datatables/simple-datatables.js"></script>
<script src="assets/vendor/tinymce/tinymce.min.js"></script>
<script src="assets/vendor/php-email-form/validate.js"></script>

<!-- Template Main JS File -->
<script src="assets/js/main.js"></script>
<script src="https://code.jquery.com/jquery-1.10.2.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript"></script>
<%
    }
%>
<jsp:include page="footer.jsp"></jsp:include>

<a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>
