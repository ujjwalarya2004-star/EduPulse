<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="/includes/header.jsp" />

<%
    Integer studentFeeId = (Integer) request.getAttribute("studentFeeId");
%>

<div class="container-fluid">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white py-3">
                    <h5 class="fw-bold mb-0">Record Fee Payment & Issue Receipt</h5>
                </div>
                <div class="card-body p-4">
                    <form action="<%= request.getContextPath() %>/fees" method="POST">
                        <input type="hidden" name="studentFeeId" value="<%= studentFeeId %>">

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Receipt Number *</label>
                            <input type="text" name="receiptNo" class="form-control" value="REC-2026-<%= System.currentTimeMillis() % 10000 %>" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Payment Amount (&#8377;) *</label>
                            <input type="number" step="100" min="100" name="amountPaid" class="form-control" placeholder="e.g. 25000" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Payment Method *</label>
                            <select name="paymentMethod" class="form-select" required>
                                <option value="ONLINE">Online Net Banking</option>
                                <option value="UPI">UPI (Google Pay / PhonePe)</option>
                                <option value="CHEQUE">Bank Cheque / DD</option>
                                <option value="CASH">Cash Deposit</option>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Transaction Reference / Cheque No.</label>
                            <input type="text" name="transactionRef" class="form-control" placeholder="e.g. UPI_TXN_881923">
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Payment Date *</label>
                            <input type="date" name="paymentDate" class="form-control" value="<%= new java.sql.Date(System.currentTimeMillis()) %>" required>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-semibold">Remarks</label>
                            <input type="text" name="remarks" class="form-control" placeholder="e.g. Installment payment received">
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-success px-4">Confirm Payment</button>
                            <a href="<%= request.getContextPath() %>/fees" class="btn btn-light border px-4">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
