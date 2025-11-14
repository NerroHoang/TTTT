<%@page contentType="text/html" pageEncoding="UTF-8" import="DAO.*, model.*, java.util.*"%>
<jsp:include page="header.jsp"></jsp:include>
<%
    // Lấy examID từ request
    int examID = Integer.parseInt(request.getParameter("examID"));
    Exam exam = new ExamDAO().getExamByID(examID);
    Users user = (Users)session.getAttribute("currentUser");
    int price = exam.getPrice();
%>

<div class="container">
    <div class="row">
        <div class="col-lg-12">
            <h2 class="my-5">Chi tiết bài kiểm tra</h2>
            <div class="course-item bg-light">
                <div class="position-relative overflow-hidden">
                    <img class="img-fluid" src="img/course-1.jpg" alt="">
                    <div class="w-100 d-flex justify-content-center position-absolute bottom-0 start-0 mb-4">
                        <%
                        // Kiểm tra nếu người dùng đã mua hoặc bài thi miễn phí thì hiển thị nút "Vào thi"
                        if (price == 0 || new StudentExamDAO().checkExamPay(user.getUserID(), examID)) {
                        %>
                            <a href="StartExam?examID=<%= exam.getExamID() %>" class="flex-shrink-0 btn btn-sm btn-primary px-3" style="border-radius: 30px;">Vào thi</a>
                        <%
                        } else if (price > 0 && user.getBalance() >= price) {
                        %>
                            <button class="flex-shrink-0 btn btn-sm btn-primary px-3" style="border-radius:30px" type="button" data-toggle="modal" data-target="#purchaseModal">
                                Mua và vào thi
                            </button>
                            <!-- Modal để xác nhận mua bài thi -->
                            <div class="modal fade" id="purchaseModal" tabindex="-1" role="dialog" aria-labelledby="purchaseModalLabel" aria-hidden="true">
                                <div class="modal-dialog modal-lg" role="document">
                                    <div class="modal-content" style="width: 500px; margin: auto">
                                        <form action="PurchaseExam" method="POST">
                                            <input type="hidden" name="price" value="<%= price %>"/>
                                            <input type="hidden" name="examID" value="<%= exam.getExamID() %>">
                                            <div class="modal-header d-flex align-items-center bg-primary text-white">
                                                <h6 class="modal-title mb-0" id="purchaseModalLabel" style="color: white">Xác nhận mua?</h6>
                                            </div>
                                            <div class="modal-body">
                                                <div class="form-group">                       
                                                    <div class="modal-footer">
                                                        <button type="button" class="btn btn-light" data-dismiss="modal">Hủy</button>
                                                        <input type="submit" class="btn btn-primary" value="Xác nhận"/>
                                                    </div>
                                                </div> 
                                            </div>
                                        </form>
                                    </div> 
                                </div>                        
                            </div> 
                        <%
                        } else {
                        %>
                            <button class="flex-shrink-0 btn btn-sm btn-primary px-3" style="border-radius:30px" type="button" data-toggle="modal" data-target="#noBalanceModal">
                                Không đủ tiền
                            </button>
                            <!-- Modal để yêu cầu nạp tiền -->
                            <div class="modal fade" id="noBalanceModal" tabindex="-1" role="dialog" aria-labelledby="noBalanceModalLabel" aria-hidden="true">
                                <div class="modal-dialog modal-lg" role="document">
                                    <div class="modal-content" style="width: 500px; margin: auto">
                                        <div class="modal-header d-flex align-items-center bg-primary text-white">
                                            <h6 class="modal-title mb-0" id="noBalanceModalLabel" style="color: white">Bạn không đủ tiền để thanh toán! Nạp thêm tiền?</h6>
                                        </div>
                                        <div class="modal-body">
                                            <div class="form-group">                       
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-light" data-dismiss="modal">Hủy</button>
                                                    <a href="recharge.jsp"><button class="btn btn-primary">Xác nhận</button></a>
                                                </div>
                                            </div> 
                                        </div>
                                    </div> 
                                </div>                        
                            </div> 
                        <% 
                        }
                        %>
                    </div>
                </div>
                <div class="text-center p-4 pb-0">
                    <h3 class="mb-0"><%= exam.getExamName() %></h3>
                    <h5><%= exam.getCreateDate() %></h5>
                    <p>Thời gian làm bài: <%= exam.getTimer() %> phút</p>
                    <p>Giá: 
                        <%
                        if (price == 0) {
                        %>
                            Miễn phí
                        <%
                        } else {
                        %>
                            <%= price %> coin
                        <%
                        }
                        %>
                    </p>
                    <p>Môn học: <%= new ExamDAO().getSubjectByID(exam.getSubjectID()).getSubjectName() %></p>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="footer.jsp"></jsp:include>
