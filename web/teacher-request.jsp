<!DOCTYPE html>
<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, java.util.*, model.*"%>
<jsp:include page="header.jsp"></jsp:include>
    <br>
<%-- Lấy thông tin người dùng từ session --%>
<%
    Users user = (Users) session.getAttribute("currentUser");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<div class="row justify-content-center mt-5">
    
    <div class="col-lg-10">
        <div class="card shadow-lg">
            <div class="card-body">
                <a class="btn btn-primary" style="background-color:blue ; " href="profile.jsp">Trở về</a>
                <div class="container">
                    <h1 class="text-center mb-4">Chọn gói nâng cấp tài khoản</h1>

                    <div class="plans row justify-content-center">
                        <!-- Gói 20 Coin -->
                        <div class="plan col-md-5 mb-4 p-3 rounded shadow-sm bg-light">
                            <h2 class="text-center text-primary">20 Coin / Tháng</h2>
                            <p class="price text-center text-success">20 Coin</p>
                            <ul class="list-unstyled">
                                <li>Thẻ học không giới hạn</li>
                                <li>Hỗ trợ cơ bản</li>
                                <li>Không có tính năng nâng cao</li>
                            </ul>
                            <button class="btn btn-primary btn-block" onclick="choosePackage(20)">Chọn gói</button>
                        </div>

                        <!-- Gói 50 Coin -->
                        <div class="plan col-md-5 mb-4 p-3 rounded shadow-sm bg-light">
                            <h2 class="text-center text-primary">50 Coin / 3 Tháng</h2>
                            <p class="price text-center text-success">50 Coin</p>
                            <ul class="list-unstyled">
                                <li>Thẻ học không giới hạn</li>
                                <li>Hỗ trợ ưu tiên</li>
                                <li>Tính năng nâng cao</li>
                                <li>Không có quảng cáo</li>
                            </ul>
                            <button class="btn btn-primary btn-block" onclick="choosePackage(50)">Chọn gói</button>
                        </div>
                    </div>
                </div>

                <!-- Modal xác nhận nâng cấp -->
                <div class="modal" id="confirmModal" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Xác nhận nâng cấp tài khoản</h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                <p>Bạn có chắc chắn muốn nâng cấp tài khoản không?</p>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy</button>
                                <form action="UpgradeServlet" method="POST">
                                    <input type="hidden" id="selectedPackage" name="selectedPackage" value="">
                                    <button type="submit" class="btn btn-primary">Xác nhận</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Modal thông báo số dư không đủ -->
                <div class="modal" id="balanceModal" tabindex="-1" role="dialog" aria-hidden="true">
                    <div class="modal-dialog" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Thông báo</h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                <p>Bạn không có đủ số dư để nâng cấp gói. Bạn có muốn nạp thêm coin không?</p>
                            </div>
                            <div class="modal-footer">
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
    <script src="https://code.jquery.com/jquery-1.10.2.min.js"></script>
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
                                    // Đóng modal khi nhấn nút Hủy hoặc Không
                                    $('#confirmModal .btn-secondary, #balanceModal .btn-secondary').click(function () {
                                        $('#confirmModal, #balanceModal').modal('hide');
                                    });

                                    // Đóng modal khi nhấn vào dấu x
                                    $('#confirmModal .close, #balanceModal .close').click(function () {
                                        $('#confirmModal, #balanceModal').modal('hide');
                                    });
                                });

</script>

<!-- CSS nội tuyến -->
<style>
    /* CSS cho phần kế hoạch gói nâng cấp */
    .plans {
        display: flex;
        justify-content: center;
        gap: 2rem;
    }

    .plan {
        background-color: #f8f9fa;
        padding: 1.5rem;
        border-radius: 10px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        text-align: center;
        transition: all 0.3s ease;
        cursor: pointer;
    }

    .plan:hover {
        transform: scale(1.05);
        box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
    }

    .plan h2 {
        font-size: 24px;
        color: #007bff;
    }

    .plan .price {
        font-size: 22px;
        font-weight: bold;
        color: #28a745;
    }

    .plan ul {
        list-style: none;
        padding-left: 0;
        margin-bottom: 1.5rem;
    }

    .plan ul li {
        font-size: 16px;
        color: #6c757d;
    }

    .plan button {
        background-color: #007bff;
        color: white;
        font-size: 18px;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
    }

    .plan button:hover {
        background-color: #0056b3;
    }

    .footer button {
        background-color: #6c757d;
        color: white;
        font-size: 16px;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        cursor: pointer;
    }

    .footer button:hover {
        background-color: #5a6268;
    }

    /* Modal style */
    .modal-content {
        border-radius: 10px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }
</style>