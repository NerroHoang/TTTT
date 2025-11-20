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
            --thi247-success: #28a745;
        }

        /* 1. Màu nền đồng bộ */
        body {
            background-color: var(--thi247-light-blue);
            padding-bottom: 50px;
        }

        /* 2. Cấu trúc và Card */
        .recharge-container {
            padding: 40px 0;
            max-width: 900px;
            margin: auto;
        }
        
        .card {
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            border: none;
            padding: 20px;
        }

        /* 3. Tiêu đề và Link */
        .card-body h4 {
            font-weight: 700;
            color: var(--thi247-primary);
        }
        .card-body a {
            font-weight: 600;
            color: var(--thi247-secondary) !important;
            text-decoration: none;
        }

        /* 4. Form và Input */
        .form-control {
            border-radius: 8px;
            padding: 10px 15px;
            font-size: 1.05rem;
            height: auto;
        }
        
        /* Input Số dư hiện tại */
        .form-control[disabled] {
            font-weight: 700;
            color: var(--thi247-success) !important;
            background-color: #f8f8f8;
        }
        
        /* Select Số tiền */
        .form-select {
            border-radius: 8px;
            padding: 10px 15px;
            font-size: 1.05rem;
        }

        /* 5. Nút Xác nhận */
        #submit_button {
            background-color: var(--thi247-primary);
            border-color: var(--thi247-primary);
            font-weight: 700;
            padding: 10px 30px;
            border-radius: 25px;
            width: 200px;
            margin: auto; /* Căn giữa nút */
            display: block; /* Cần thiết cho margin: auto */
        }
    </style>

<%
if(session.getAttribute("currentUser")!= null){
Users user = (Users)session.getAttribute("currentUser");
NumberFormat currencyFormatter = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
%>
    <div class="recharge-container">
        <div class="row">
            <div class="col-lg-12">
                <div class="card">
                    <div class="card-body">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                            <h4 class="text-primary">Thanh toán VNPAY</h4>
                            <a href="paymenthistory.jsp">Xem lịch sử thanh toán</a>
                        </div>
                        <form class="row g-3" action="vnpayajax" id="frmCreateOrder" method="post">        
                            <div class="col-md-12 mb-3">
                                <label class="form-label">Số dư hiện tại</label>
                                <div class="input-group">
                                    <input type="text" class="form-control" value="<%=user.getBalance()%>" disabled>
                                    <span class="input-group-text"><i class="fas fa-coins text-warning"></i> Coin</span>
                                </div>
                            </div>
                            <div class="col-md-12 mb-4">
                                <label for="amount" class="form-label">Chọn gói nạp tiền</label>
                                <select class="form-select" id="amount" name="amount" required>
                                    <option value="10000" selected><%=currencyFormatter.format(10000)%> => 10 coin</option>
                                    <option value="20000"><%=currencyFormatter.format(20000)%> => 20 coin</option>
                                    <option value="50000"><%=currencyFormatter.format(50000)%> => 50 coin</option>
                                    <option value="100000"><%=currencyFormatter.format(100000)%> => 100 coin</option>
                                    <option value="200000"><%=currencyFormatter.format(200000)%> => 200 coin</option>
                                    <option value="500000"><%=currencyFormatter.format(500000)%> => 500 coin</option>
                                </select>
                            </div>
                            <div class="col-12 text-center">
                                <button id="submit_button" class="btn btn-primary" type="submit">
                                    <i class="fas fa-shopping-cart me-2"></i> Xác nhận thanh toán
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>  
    </div>    
<%
    }
%>
<jsp:include page="footer.jsp"></jsp:include>
<script src="https://code.jquery.com/jquery-1.10.2.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link href="https://pay.vnpay.vn/lib/vnpay/vnpay.css" rel="stylesheet" />
<script src="https://pay.vnpay.vn/lib/vnpay/vnpay.min.js"></script>

<script type="text/javascript">
    $("#frmCreateOrder").submit(function () {
        var postData = $("#frmCreateOrder").serialize();
        var submitUrl = $("#frmCreateOrder").attr("action");
        $.ajax({
            type: "POST",
            url: submitUrl,
            data: postData,
            dataType: 'JSON',
            success: function (x) {
                console.log("Response:", x); // Added console log for debugging
                if (x.code === '00') {
                    if (window.vnpay) {
                        vnpay.open({width: 768, height: 600, url: x.data});
                    } else {
                        location.href = x.data;
                    }
                } else {
                    alert(x.Message);
                    console.log("Error message:", x.Message); // Added console log for debugging
                }
            },
            error: function (jqXHR, textStatus, errorThrown) {
                alert("An error occurred. Please try again.");
                console.log("AJAX Error:", textStatus, errorThrown); // Added console log for debugging
            }
        });
        return false;
    });
</script>