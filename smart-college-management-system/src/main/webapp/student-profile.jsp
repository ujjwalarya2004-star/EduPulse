<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.*" %>
<%@ page import="java.util.List" %>
<jsp:include page="/includes/header.jsp" />

<%
    Student s = (Student) request.getAttribute("student");
    List<Enrollment> enrollments = (List<Enrollment>) request.getAttribute("enrollments");
    List<Attendance> attendanceHistory = (List<Attendance>) request.getAttribute("attendanceHistory");
    List<Marks> transcript = (List<Marks>) request.getAttribute("transcript");
    List<FeePayment> feePayments = (List<FeePayment>) request.getAttribute("feePayments");
%>

<div class="container-fluid">
    <% if (s != null) { %>
    <!-- Top Header Card -->
    <div class="card border-0 shadow-sm mb-4">
        <div class="card-body p-4 d-flex justify-content-between align-items-center flex-wrap gap-3">
            <div class="d-flex align-items-center gap-3">
                <div class="p-3 bg-primary-subtle text-primary rounded-circle">
                    <i class="bi bi-person-fill fs-1"></i>
                </div>
                <div>
                    <h3 class="fw-bold mb-1 text-dark"><%= s.getName() %></h3>
                    <div class="d-flex gap-2 align-items-center">
                        <span class="badge bg-secondary"><%= s.getEnrollmentNo() %></span>
                        <span class="badge bg-primary-subtle text-primary border"><%= s.getDeptCode() %> &bull; Sem <%= s.getSemester() %></span>
                        <span class="badge bg-success-subtle text-success"><%= s.getStatus() %></span>
                        <% if (s.isAcademicRisk()) { %>
                            <span class="badge bg-danger"><i class="bi bi-exclamation-triangle me-1"></i>Academic Attention Required</span>
                        <% } %>
                    </div>
                </div>
            </div>
            <div>
                <a href="<%= request.getContextPath() %>/marks?action=result&studentId=<%= s.getStudentId() %>" class="btn btn-outline-primary me-2">
                    <i class="bi bi-file-earmark-medical me-1"></i>Official Transcript
                </a>
                <a href="<%= request.getContextPath() %>/students?action=edit&id=<%= s.getStudentId() %>" class="btn btn-light border">
                    <i class="bi bi-pencil me-1"></i>Edit Profile
                </a>
            </div>
        </div>
    </div>

    <!-- Quick Stats Metric Row -->
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="card border-0 shadow-sm p-3 bg-white">
                <span class="text-muted small fw-semibold">OVERALL ATTENDANCE</span>
                <div class="d-flex justify-content-between align-items-center mt-2">
                    <h3 class="fw-bold mb-0 <%= s.getOverallAttendancePct() < 75.0 ? "text-danger" : "text-success" %>">
                        <%= s.getOverallAttendancePct() %>%
                    </h3>
                    <span class="badge <%= s.getOverallAttendancePct() < 75.0 ? "badge-low-attendance" : "badge-ok-attendance" %>">
                        <%= s.getOverallAttendancePct() < 75.0 ? "Below 75% Warning" : "Satisfactory" %>
                    </span>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-0 shadow-sm p-3 bg-white">
                <span class="text-muted small fw-semibold">AVERAGE SEMESTER MARKS</span>
                <div class="d-flex justify-content-between align-items-center mt-2">
                    <h3 class="fw-bold mb-0 <%= (s.getAvgMarks() > 0 && s.getAvgMarks() < 50.0) ? "text-danger" : "text-dark" %>">
                        <%= s.getAvgMarks() %> / 120
                    </h3>
                    <span class="badge bg-light text-muted border">Out of 120 Max</span>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-0 shadow-sm p-3 bg-white">
                <span class="text-muted small fw-semibold">FEE ACCOUNT BALANCE</span>
                <div class="d-flex justify-content-between align-items-center mt-2">
                    <h3 class="fw-bold mb-0 <%= s.getPendingFees() > 0 ? "text-danger" : "text-success" %>">
                        &#8377; <%= String.format("%,.2f", s.getPendingFees()) %>
                    </h3>
                    <span class="badge <%= s.getPendingFees() > 0 ? "bg-danger-subtle text-danger" : "bg-success-subtle text-success" %>">
                        <%= s.getPendingFees() > 0 ? "Pending Due" : "Fully Settled" %>
                    </span>
                </div>
            </div>
        </div>
    </div>

    <!-- Details Tabs -->
    <div class="card border-0 shadow-sm">
        <div class="card-header bg-white border-bottom-0">
            <ul class="nav nav-tabs card-header-tabs" role="tablist">
                <li class="nav-item"><a class="nav-link active" data-bs-toggle="tab" href="#bio">Personal Details</a></li>
                <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#subjectsTab">Enrolled Subjects (<%= enrollments != null ? enrollments.size() : 0 %>)</a></li>
                <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#attTab">Attendance History</a></li>
                <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#marksTab">Academic Performance</a></li>
                <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#feesTab">Fee Receipts</a></li>
            </ul>
        </div>
        <div class="card-body p-4 tab-content">
            <!-- 1. Bio Tab -->
            <div class="tab-pane fade show active" id="bio">
                <div class="row g-3">
                    <div class="col-md-4"><strong class="text-muted small d-block">Email:</strong> <%= s.getEmail() %></div>
                    <div class="col-md-4"><strong class="text-muted small d-block">Phone:</strong> <%= s.getPhone() %></div>
                    <div class="col-md-4"><strong class="text-muted small d-block">Gender:</strong> <%= s.getGender() %></div>
                    <div class="col-md-4"><strong class="text-muted small d-block">Date of Birth:</strong> <%= s.getDob() %></div>
                    <div class="col-md-4"><strong class="text-muted small d-block">Department:</strong> <%= s.getDeptName() %></div>
                    <div class="col-md-4"><strong class="text-muted small d-block">Admission Year:</strong> <%= s.getAdmissionYear() %></div>
                    <div class="col-12"><strong class="text-muted small d-block">Permanent Address:</strong> <%= s.getAddress() %></div>
                </div>
            </div>

            <!-- 2. Subjects Tab -->
            <div class="tab-pane fade" id="subjectsTab">
                <table class="table table-hover align-middle">
                    <thead><tr><th>Subject Code</th><th>Subject Name</th><th>Academic Year</th><th>Enrolled On</th></tr></thead>
                    <tbody>
                        <% if (enrollments != null && !enrollments.isEmpty()) { 
                            for (Enrollment en : enrollments) { %>
                                <tr>
                                    <td><span class="badge bg-light text-dark border"><%= en.getSubjectCode() %></span></td>
                                    <td><strong><%= en.getSubjectName() %></strong></td>
                                    <td><%= en.getAcademicYear() %></td>
                                    <td><%= en.getEnrolledAt() %></td>
                                </tr>
                        <%  } 
                        } else { %>
                            <tr><td colspan="4" class="text-center text-muted">No course enrollments found.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <!-- 3. Attendance Tab -->
            <div class="tab-pane fade" id="attTab">
                <table class="table table-hover align-middle">
                    <thead><tr><th>Date</th><th>Subject</th><th>Status</th><th>Faculty Remarks</th></tr></thead>
                    <tbody>
                        <% if (attendanceHistory != null && !attendanceHistory.isEmpty()) { 
                            for (Attendance a : attendanceHistory) { %>
                                <tr>
                                    <td><%= a.getAttendanceDate() %></td>
                                    <td><%= a.getSubjectCode() %> - <%= a.getSubjectName() %></td>
                                    <td>
                                        <span class="badge <%= "PRESENT".equalsIgnoreCase(a.getStatus()) ? "bg-success" : "bg-danger" %>">
                                            <%= a.getStatus() %>
                                        </span>
                                    </td>
                                    <td><%= a.getRemarks() != null ? a.getRemarks() : "-" %></td>
                                </tr>
                        <%  } 
                        } else { %>
                            <tr><td colspan="4" class="text-center text-muted">No attendance logs available.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <!-- 4. Marks Tab -->
            <div class="tab-pane fade" id="marksTab">
                <table class="table table-hover align-middle">
                    <thead><tr><th>Subject</th><th>Assignment (20)</th><th>Internal (30)</th><th>Practical (20)</th><th>End-Sem (50)</th><th>Total (120)</th><th>Grade</th></tr></thead>
                    <tbody>
                        <% if (transcript != null && !transcript.isEmpty()) { 
                            for (Marks m : transcript) { %>
                                <tr>
                                    <td><strong><%= m.getSubjectCode() %></strong> - <%= m.getSubjectName() %></td>
                                    <td><%= m.getAssignmentMarks() %></td>
                                    <td><%= m.getInternalMarks() %></td>
                                    <td><%= m.getPracticalMarks() %></td>
                                    <td><%= m.getEndSemMarks() %></td>
                                    <td><strong><%= m.getTotalMarks() %></strong></td>
                                    <td><span class="badge <%= "F".equalsIgnoreCase(m.getGrade()) ? "bg-danger" : "bg-primary" %>"><%= m.getGrade() %></span></td>
                                </tr>
                        <%  } 
                        } else { %>
                            <tr><td colspan="7" class="text-center text-muted">No marks submitted yet.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <!-- 5. Fees Tab -->
            <div class="tab-pane fade" id="feesTab">
                <table class="table table-hover align-middle">
                    <thead><tr><th>Receipt No</th><th>Amount Paid</th><th>Method</th><th>Txn Reference</th><th>Payment Date</th><th>Remarks</th></tr></thead>
                    <tbody>
                        <% if (feePayments != null && !feePayments.isEmpty()) { 
                            for (FeePayment p : feePayments) { %>
                                <tr>
                                    <td><span class="badge bg-light text-dark border"><%= p.getReceiptNo() %></span></td>
                                    <td><strong class="text-success">&#8377; <%= String.format("%,.2f", p.getAmountPaid()) %></strong></td>
                                    <td><span class="badge bg-info-subtle text-info"><%= p.getPaymentMethod() %></span></td>
                                    <td><%= p.getTransactionRef() != null ? p.getTransactionRef() : "-" %></td>
                                    <td><%= p.getPaymentDate() %></td>
                                    <td><%= p.getRemarks() != null ? p.getRemarks() : "-" %></td>
                                </tr>
                        <%  } 
                        } else { %>
                            <tr><td colspan="6" class="text-center text-muted">No payment transactions recorded.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <% } %>
</div>

<jsp:include page="/includes/footer.jsp" />
