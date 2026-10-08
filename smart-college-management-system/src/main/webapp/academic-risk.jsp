<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.AcademicRisk" %>
<%@ page import="java.util.List" %>
<jsp:include page="/includes/header.jsp" />

<%
    List<AcademicRisk> riskStudents = (List<AcademicRisk>) request.getAttribute("riskStudents");
%>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1 text-danger">
                <i class="bi bi-shield-exclamation me-2"></i>Academic Attention Required (Risk Matrix)
            </h3>
            <p class="text-muted mb-0">Automated SQL rule-based early warning system for student retention and intervention.</p>
        </div>
    </div>

    <!-- Rule Criteria Box -->
    <div class="card border-danger-subtle bg-danger-subtle bg-opacity-25 shadow-sm mb-4">
        <div class="card-body">
            <h6 class="fw-bold text-danger mb-2"><i class="bi bi-info-circle me-1"></i>Risk Detection Rules Applied:</h6>
            <ul class="mb-0 small text-dark">
                <li><strong>Attendance Violation:</strong> Overall attendance strictly below <strong>75%</strong> requirement.</li>
                <li><strong>Academic Performance:</strong> Average marks below <strong>50%</strong> (below 60 out of 120 marks).</li>
                <li><strong>Fee Arrears:</strong> Outstanding/pending semester fees exceeding <strong>&#8377; 0</strong>.</li>
            </ul>
        </div>
    </div>

    <!-- Risk Students Table -->
    <div class="card border-0 shadow-sm">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>Student</th>
                            <th>Department</th>
                            <th>Attendance</th>
                            <th>Avg Marks</th>
                            <th>Pending Fees</th>
                            <th>Flagged Deficiencies</th>
                            <th class="text-end">Intervention</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (riskStudents != null && !riskStudents.isEmpty()) {
                            for (AcademicRisk r : riskStudents) { %>
                                <tr>
                                    <td>
                                        <div class="fw-bold text-dark"><%= r.getStudentName() %></div>
                                        <div class="small text-muted"><%= r.getEnrollmentNo() %></div>
                                        <div class="small text-muted"><%= r.getEmail() %> &bull; <%= r.getPhone() %></div>
                                    </td>
                                    <td><span class="badge bg-secondary"><%= r.getDeptCode() %> &bull; Sem <%= r.getSemester() %></span></td>
                                    <td>
                                        <span class="badge <%= r.getOverallAttendancePct() < 75.0 ? "badge-low-attendance fs-6" : "badge-ok-attendance" %>">
                                            <%= r.getOverallAttendancePct() %>%
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge <%= (r.getAvgMarks() > 0 && r.getAvgMarks() < 50.0) ? "bg-danger text-white fs-6" : "bg-light text-dark" %>">
                                            <%= r.getAvgMarks() %> / 120
                                        </span>
                                    </td>
                                    <td>
                                        <span class="fw-bold text-danger fs-6">&#8377; <%= String.format("%,.2f", r.getPendingFees()) %></span>
                                    </td>
                                    <td>
                                        <% for (String reason : r.getRiskReasons()) { %>
                                            <div class="small text-danger fw-semibold">
                                                <i class="bi bi-x-circle-fill me-1"></i><%= reason %>
                                            </div>
                                        <% } %>
                                    </td>
                                    <td class="text-end">
                                        <a href="<%= request.getContextPath() %>/students?action=view&id=<%= r.getStudentId() %>" class="btn btn-sm btn-primary">
                                            Open 360 Profile
                                        </a>
                                    </td>
                                </tr>
                        <%  }
                        } else { %>
                            <tr>
                                <td colspan="7" class="text-center py-4 text-muted">All students meet attendance, academic, and fee criteria.</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
