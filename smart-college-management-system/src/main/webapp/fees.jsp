<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.StudentFee" %>
<%@ page import="java.util.List" %>
<jsp:include page="/includes/header.jsp" />

<%
    List<StudentFee> feeRecords = (List<StudentFee>) request.getAttribute("feeRecords");
    String currentFilter = (String) request.getAttribute("currentFilter");
%>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">Fee Register & Accounts Ledger</h3>
            <p class="text-muted mb-0">Total fees, payments received, and automatically computed pending balances.</p>
        </div>
    </div>

    <!-- Status Filters -->
    <div class="card border-0 shadow-sm mb-4">
        <div class="card-body d-flex gap-2">
            <a href="<%= request.getContextPath() %>/fees" class="btn btn-sm <%= currentFilter == null || currentFilter.isEmpty() ? "btn-primary" : "btn-light border" %>">All Records</a>
            <a href="<%= request.getContextPath() %>/fees?status=PENDING" class="btn btn-sm <%= "PENDING".equalsIgnoreCase(currentFilter) ? "btn-primary" : "btn-light border" %>">Unpaid (Pending)</a>
            <a href="<%= request.getContextPath() %>/fees?status=PARTIAL" class="btn btn-sm <%= "PARTIAL".equalsIgnoreCase(currentFilter) ? "btn-primary" : "btn-light border" %>">Partial Payments</a>
            <a href="<%= request.getContextPath() %>/fees?status=PAID" class="btn btn-sm <%= "PAID".equalsIgnoreCase(currentFilter) ? "btn-primary" : "btn-light border" %>">Fully Paid</a>
        </div>
    </div>

    <!-- Fee Ledger Table -->
    <div class="card border-0 shadow-sm">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>Student</th>
                            <th>Dept / Sem</th>
                            <th>Total Assigned</th>
                            <th>Amount Paid</th>
                            <th>Pending Balance</th>
                            <th>Due Date</th>
                            <th>Status</th>
                            <th class="text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (feeRecords != null) {
                            for (StudentFee f : feeRecords) { %>
                                <tr>
                                    <td>
                                        <div class="fw-semibold text-dark"><%= f.getStudentName() %></div>
                                        <div class="small text-muted"><%= f.getEnrollmentNo() %></div>
                                    </td>
                                    <td><%= f.getDeptCode() %> - Sem <%= f.getSemester() %></td>
                                    <td>&#8377; <%= String.format("%,.2f", f.getTotalAmount()) %></td>
                                    <td class="text-success fw-semibold">&#8377; <%= String.format("%,.2f", f.getPaidAmount()) %></td>
                                    <td class="text-danger fw-bold">&#8377; <%= String.format("%,.2f", f.getPendingAmount()) %></td>
                                    <td><%= f.getDueDate() %></td>
                                    <td>
                                        <span class="badge <%= "PAID".equalsIgnoreCase(f.getStatus()) ? "bg-success" : ("PARTIAL".equalsIgnoreCase(f.getStatus()) ? "bg-warning text-dark" : "bg-danger") %>">
                                            <%= f.getStatus() %>
                                        </span>
                                    </td>
                                    <td class="text-end">
                                        <% if (f.getPendingAmount() > 0) { %>
                                            <a href="<%= request.getContextPath() %>/fees?action=pay&id=<%= f.getStudentFeeId() %>" class="btn btn-sm btn-success">
                                                <i class="bi bi-credit-card me-1"></i>Pay Fee
                                            </a>
                                        <% } else { %>
                                            <button class="btn btn-sm btn-outline-secondary" disabled>Cleared</button>
                                        <% } %>
                                    </td>
                                </tr>
                        <%  }
                        } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
