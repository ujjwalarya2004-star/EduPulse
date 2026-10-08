<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.*" %>
<%@ page import="java.util.List" %>
<jsp:include page="/includes/header.jsp" />

<%
    List<LeaveRequest> leaveRequests = (List<LeaveRequest>) request.getAttribute("leaveRequests");
    List<Student> students = (List<Student>) request.getAttribute("students");
%>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">Student Leave Desk</h3>
            <p class="text-muted mb-0">Submit leave applications and review student absence requests.</p>
        </div>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#applyLeaveModal">
            <i class="bi bi-plus-lg me-1"></i>Apply for Leave
        </button>
    </div>

    <div class="card border-0 shadow-sm">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>Student</th>
                            <th>From Date</th>
                            <th>To Date</th>
                            <th>Reason</th>
                            <th>Status</th>
                            <th>Applied Date</th>
                            <th>Reviewer Note</th>
                            <th class="text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (leaveRequests != null) {
                            for (LeaveRequest lr : leaveRequests) { %>
                                <tr>
                                    <td>
                                        <div class="fw-semibold text-dark"><%= lr.getStudentName() %></div>
                                        <div class="small text-muted"><%= lr.getEnrollmentNo() %></div>
                                    </td>
                                    <td><%= lr.getFromDate() %></td>
                                    <td><%= lr.getToDate() %></td>
                                    <td><%= lr.getReason() %></td>
                                    <td>
                                        <span class="badge <%= "APPROVED".equalsIgnoreCase(lr.getStatus()) ? "bg-success" : ("REJECTED".equalsIgnoreCase(lr.getStatus()) ? "bg-danger" : "bg-warning text-dark") %>">
                                            <%= lr.getStatus() %>
                                        </span>
                                    </td>
                                    <td><%= lr.getAppliedDate() %></td>
                                    <td><%= lr.getReviewRemarks() != null ? lr.getReviewRemarks() : "-" %></td>
                                    <td class="text-end">
                                        <% if ("PENDING".equalsIgnoreCase(lr.getStatus())) { %>
                                            <form action="<%= request.getContextPath() %>/leaves" method="POST" class="d-inline">
                                                <input type="hidden" name="action" value="status">
                                                <input type="hidden" name="leaveId" value="<%= lr.getLeaveId() %>">
                                                <input type="hidden" name="status" value="APPROVED">
                                                <input type="hidden" name="remarks" value="Approved by department">
                                                <button type="submit" class="btn btn-sm btn-outline-success">Approve</button>
                                            </form>
                                            <form action="<%= request.getContextPath() %>/leaves" method="POST" class="d-inline">
                                                <input type="hidden" name="action" value="status">
                                                <input type="hidden" name="leaveId" value="<%= lr.getLeaveId() %>">
                                                <input type="hidden" name="status" value="REJECTED">
                                                <input type="hidden" name="remarks" value="Attendance requirements not met">
                                                <button type="submit" class="btn btn-sm btn-outline-danger">Reject</button>
                                            </form>
                                        <% } else { %>
                                            <span class="text-muted small">Decided</span>
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

<!-- Modal: Apply Leave -->
<div class="modal fade" id="applyLeaveModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content border-0 shadow">
            <form action="<%= request.getContextPath() %>/leaves" method="POST">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Submit Leave Application</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body row g-3">
                    <div class="col-12">
                        <label class="form-label fw-semibold">Select Student *</label>
                        <select name="studentId" class="form-select" required>
                            <% if (students != null) {
                                for (Student st : students) { %>
                                    <option value="<%= st.getStudentId() %>"><%= st.getName() %> (<%= st.getEnrollmentNo() %>)</option>
                            <%  }
                            } %>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">From Date *</label>
                        <input type="date" name="fromDate" class="form-control" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">To Date *</label>
                        <input type="date" name="toDate" class="form-control" required>
                    </div>
                    <div class="col-12">
                        <label class="form-label fw-semibold">Reason for Absence *</label>
                        <textarea name="reason" class="form-control" rows="3" placeholder="Provide reason or attach medical advice..." required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Submit Application</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
