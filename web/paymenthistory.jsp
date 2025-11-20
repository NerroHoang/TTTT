<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.text.NumberFormat"%>
<%@page import="java.time.format.DateTimeFormatter"%>
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
        
        .table-responsive {
            border-radius: 10px;
            overflow: hidden;
            border: 1px solid #ddd;
        }

        .table thead th {
            background-color: var(--thi247-primary);
            color: white;
            font-weight: 700;
            vertical-align: middle;
            text-align: center !important;
            padding: 12px;
        }
        
        .table td {
            vertical-align: middle;
            text-align: center;
            background-color: white;
            padding: 10px;
            color: var(--thi247-text-dark);
            font-size: 0.95em;
        }
        
        /* Cải thiện hiển thị tiền tệ */
        .money-cell {
            font-weight: 600;
            color: #28a745; /* Xanh lá cho tiền */
        }

        /* Giữ lại các style break-word */
        a, input, p {
            overflow-wrap: break-word;
            word-break: break-word;
        }

    </style>
    
    <script>
        var container = document.getElementById("tagID");
        var tag = container.getElementsByClassName("tag");
        var current = container.getElementsByClassName("active");
        
        if (current.length > 0) {
            current[0].className = current[0].className.replace(" active", "");
        }
    </script>

<%
if(session.getAttribute("currentUser") != null){
Users user = (Users)session.getAttribute("currentUser");
// Giả định DAO hoạt động đúng
List<Payment> paymentList = new UserDAO().getAllPaymentByID(user.getUserID());
%>

<div class="container-fluid bg-primary py-5 mb-5 page-header">
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-10 text-center">
                <h1 class="display-3 text-white animated slideInDown">
                    Lịch sử giao dịch
                </h1>
                <h3 class="text-white animated slideInDown">Dưới đây là danh sách giao dịch nạp tiền của bạn</h3>
            </div>
        </div>
    </div>
</div>
<main id="main" class="main" style="margin-left: 0">
    <section class="section">
        <div style="margin-bottom: 20px;">
             <a class="btn btn-primary btn-back" href="recharge.jsp">
                 <i class="fas fa-arrow-left me-2"></i> Trở về
             </a>
        </div>
        
        <div class="row">
            <div class="col-lg-12">
                <div class="card">
                    <div class="card-body p-4">
                        <h5 class="card-title text-center text-primary" style="font-weight: 700;">Chi tiết giao dịch đã thực hiện</h5>
                        
                        <%
                        if(paymentList.size() > 0){
                        %>
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Số tiền (VND)</th>
                                        <th>Ngày thanh toán</th>
                                        <th>Mã thanh toán</th>
                                        <th>Ngân hàng</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                    for(int i = paymentList.size() - 1; i >= 0; i--){
                                        Payment payment = paymentList.get(i);
                                        // Định dạng tiền tệ
                                        NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
                                        String money = currencyFormatter.format(payment.getAmount());
                                    %>
                                    <tr>
                                        <td><%=payment.getPaymentID()%></td>
                                        <td class="money-cell"><%=money%></td>
                                        <td><%=payment.getPaymentDate()%></td>
                                        <td><%=payment.getPaymentCode()%></td>
                                        <td><%=payment.getBank()%></td>
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
                            <h3 class="mb-0">Bạn chưa từng thực hiện một giao dịch nào!</h3>
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
<script>
    document.addEventListener("DOMContentLoaded", function (event) {
        var scrollpos = localStorage.getItem('scrollpos');
        if (scrollpos)
            window.scrollTo(0, scrollpos);
    });

    window.onbeforeunload = function (e) {
        localStorage.setItem('scrollpos', window.scrollY);
    };

</script>

<%
    }
%>
<jsp:include page="footer.jsp"></jsp:include>

<a href="#" class="back-to-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>