<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
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
        
        /* 2. Căn chỉnh tổng thể */
        .card-container {
             padding: 40px 0;
        }

        /* 3. Thiết kế Gói Nâng cấp (Plan Cards) */
        .plans {
            gap: 2.5rem; /* Tăng khoảng cách giữa các gói */
        }

        .plan {
            background-color: #ffffff;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            text-align: center;
            transition: all 0.3s ease;
            cursor: pointer;
            border: 2px solid transparent; /* Viền mặc định */
        }

        .plan:hover {
            transform: translateY(-8px); /* Nảy lên */
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
            border: 2px solid var(--thi247-primary); /* Viền nổi bật khi hover */
        }
        
        .plan.best-value {
             border: 2px solid var(--thi247-primary);
        }

        .plan h2 {
            font-size: 1.6rem;
            font-weight: 700;
            color: var(--thi247-primary);
            margin-bottom: 15px;
        }

        .plan .price {
            font-size: 2.2rem;
            font-weight: 800;
            color: #28a745; /* Màu xanh lá cho giá */
            margin-bottom: 20px;
            display: block;
        }

        .plan ul {
            list-style: none;
            padding-left: 0;
            margin-bottom: 2rem;
            text-align: left;
        }

        .plan ul li {
            font-size: 1rem;
            color: var(--thi247-text-dark);
            margin-bottom: 10px;
        }
        .plan ul li::before {
            content: "\f00c"; /* Font Awesome Checkmark */
            font-family: "Font Awesome 6 Free";
            font-weight: 900;
            color: #28a745;
            margin-right: 10px;
        }
        .plan ul li.disabled::before {
            content: "\f00d"; /* Font Awesome Times */
            color: #dc3545;
        }

        .plan button {
            background-color: var(--thi247-secondary); /* Màu xanh dương cho nút */
            color: white;
            font-size: 1.1rem;
            padding: 12px 25px;
            border: none;
            border-radius: 25px;
            font-weight: 600;
            width: 100%;
            transition: background-color 0.3s ease;
        }

        .plan button:hover {
            background-color: #0056b3;
        }
        
        /* 4. Nút Trở về */
        .btn-back {
            background-color: var(--thi247-secondary) !important;
            border-color: var(--thi247-secondary) !important;
            margin-top: 20px;
            border-radius: 25px;
            padding: 8px 20px;
            font-weight: 600;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        
        /* 5. Modal Styling */
        .modal-header {
             background-color: var(--thi247-primary) !important;
             color: white;
             border-radius: 10px 10px 0 0;
             border-bottom: none;
        }
        .modal-title {
            color: white !important;
            font-weight: 700;
        }
        .modal-header .close {
            color: white;
        }
        .modal-footer .btn-primary {
             background-color: var(--thi247-primary);
             border-color: var(--thi247-primary);
        }
        
    </style>
    
    <br>
<%-- Lấy thông tin người dùng từ session --%>
<%
    Users user = (Users) session.getAttribute("currentUser");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<div class="row justify-content-center card-container">
    <div class="col-lg-10">
        <div class="card shadow-lg">
            <div class="card-body p-5">
                <a class="btn btn-primary btn-back" href="profile.jsp">
                     <i class="fas fa-arrow-left me-2"></i> Trở về
                </a>
                
                <div class="container">
                    <h1 class="text-center mb-5 mt-4" style="color: var(--thi247-primary); font-weight: 800;">Chọn gói nâng cấp tài khoản</h1>

                    <div class="plans row justify-content-center">
                        
                        <div class="plan col-md-5 mb-4">
                            <h2 class="text-center">Gói Cơ Bản</h2>
                            <p class="price text-center">100 Coin / Tháng</p>
                            <ul class="list-unstyled">
                                <li>Thẻ học (Flashcards) không giới hạn</li>
                                <li>Tạo bài kiểm tra cơ bản</li>
                                <li>Hỗ trợ cơ bản (Email)</li>
                                <li class="disabled">Không có tính năng nâng cao</li>
                                <li class="disabled">Có quảng cáo</li>
                            </ul>
                            <button class="btn btn-block" onclick="choosePackage(100)">Chọn gói</button>
                        </div>

                        <div class="plan col-md-5 mb-4 best-value">
                            <div class="position-absolute badge bg-warning text-dark px-3 py-1 rounded-pill" style="top: -15px; right: 15px; font-size: 0.8em; font-weight: 700;">TIẾT KIỆM NHẤT</div>
                            <h2 class="text-center">Gói VIP Pro</h2>
                            <p class="price text-center">250 Coin / 3 Tháng</p>
                            <ul class="list-unstyled">
                                <li>Thẻ học (Flashcards) không giới hạn</li>
                                <li>Tạo bài kiểm tra nâng cao (Quiz)</li>
                                <li>Hỗ trợ ưu tiên (Chat)</li>
                                <li>Tính năng thống kê chuyên sâu</li>
                                <li>Không có quảng cáo</li>
                            </ul>
                            <button class="btn btn-block" onclick="choosePackage(250)">Chọn gói</button>
                        </div>
                    </div>
                </div>

                <div class="modal fade" id="confirmModal" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog modal-sm" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Xác nhận nâng cấp</h5>
                                <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div class="modal-body text-center">
                                <p>Bạn có chắc chắn muốn nâng cấp tài khoản không?</p>
                            </div>
                            <div class="modal-footer justify-content-center">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                                <form action="UpgradeServlet" method="POST" style="margin: 0;">
                                    <input type="hidden" id="selectedPackage" name="selectedPackage" value="">
                                    <button type="submit" class="btn btn-primary">Xác nhận</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="modal fade" id="balanceModal" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Thông báo</h5>
                                <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div class="modal-body text-center">
                                <p>Bạn không có đủ số dư để nâng cấp gói. Bạn có muốn nạp thêm coin không?</p>
                                <p>Số dư hiện tại: **<%= user.getBalance() %>**</p>
                            </div>
                            <div class="modal-footer justify-content-center">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Không</button>
                                <a href="recharge.jsp" class="btn btn-primary">Có, nạp thêm</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp"></jsp:include>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.4.1/dist/js/bootstrap.bundle.min.js"></script>
    <script type="text/javascript">

        var selectedPackage = 0;

        // Kiểm tra gói dịch vụ đã chọn và hiển thị modal
        function choosePackage(coinsRequired) {
            var userBalance = <%= user.getBalance() %>;  // Lấy số dư của người dùng

            if (userBalance >= coinsRequired) {
                selectedPackage = coinsRequired;
                $('#confirmModal').modal('show');  // Hiển thị modal xác nhận
                document.getElementById("selectedPackage").value = coinsRequired;  // Gửi thông tin gói lên servlet
            } else {
                $('#balanceModal').modal('show');  // Hiển thị modal số dư không đủ
            }
        }

        $(document).ready(function () {
            // Đóng modal khi nhấn nút Hủy/Không (dùng data-dismiss của Bootstrap 4)
            // Đã đơn giản hóa code JS cho sạch sẽ
        });

    </script>