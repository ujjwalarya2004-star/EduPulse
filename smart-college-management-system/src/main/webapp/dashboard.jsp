<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.DashboardStats" %>
<%@ page import="com.college.model.AcademicRisk" %>
<%@ page import="java.util.List" %>
<jsp:include page="/includes/header.jsp" />

<%
    DashboardStats stats = (DashboardStats) request.getAttribute("stats");
    List<AcademicRisk> highRiskStudents = (List<AcademicRisk>) request.getAttribute("highRiskStudents");
%>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">Administrative Dashboard</h3>
            <p class="text-muted mb-0">Real-time statistics sourced directly from normalized MySQL database.</p>
        </div>
        <div>
            <a href="<%= request.getContextPath() %>/students?action=add" class="btn btn-primary btn-sm me-2">
                <i class="bi bi-person-plus me-1"></i>Add Student
            </a>
            <a href="<%= request.getContextPath() %>/attendance" class="btn btn-outline-primary btn-sm">
                <i class="bi bi-calendar-check me-1"></i>Mark Attendance
            </a>
        </div>
    </div>

    <!-- Statistics Cards -->
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="card card-stat p-3 bg-white border-start border-4 border-primary">
                <div class="d-flex justify-content-between">
                    <div>
                        <span class="text-muted small fw-semibold">TOTAL STUDENTS</span>
                        <h2 class="fw-bold text-dark mt-2 mb-0"><%= stats != null ? stats.getTotalStudents() : 0 %></h2>
                    </div>
                    <div class="p-3 bg-primary-subtle text-primary rounded-3 align-self-center">
                        <i class="bi bi-people-fill fs-3"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card card-stat p-3 bg-white border-start border-4 border-success">
                <div class="d-flex justify-content-between">
                    <div>
                        <span class="text-muted small fw-semibold">TOTAL FACULTY</span>
                        <h2 class="fw-bold text-dark mt-2 mb-0"><%= stats != null ? stats.getTotalFaculty() : 0 %></h2>
                    </div>
                    <div class="p-3 bg-success-subtle text-success rounded-3 align-self-center">
                        <i class="bi bi-person-badge-fill fs-3"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card card-stat p-3 bg-white border-start border-4 border-info">
                <div class="d-flex justify-content-between">
                    <div>
                        <span class="text-muted small fw-semibold">TOTAL SUBJECTS</span>
                        <h2 class="fw-bold text-dark mt-2 mb-0"><%= stats != null ? stats.getTotalSubjects() : 0 %></h2>
                    </div>
                    <div class="p-3 bg-info-subtle text-info rounded-3 align-self-center">
                        <i class="bi bi-journal-text fs-3"></i>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card card-stat p-3 bg-white border-start border-4 border-secondary">
                <div class="d-flex justify-content-between">
                    <div>
                        <span class="text-muted small fw-semibold">DEPARTMENTS</span>
                        <h2 class="fw-bold text-dark mt-2 mb-0"><%= stats != null ? stats.getTotalDepartments() : 0 %></h2>
                    </div>
                    <div class="p-3 bg-secondary-subtle text-secondary rounded-3 align-self-center">
                        <i class="bi bi-buildings-fill fs-3"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Alert KPI Row -->
    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="card card-stat p-3 bg-white border-start border-4 border-danger">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <span class="text-muted small fw-semibold">LOW ATTENDANCE (&lt; 75%)</span>
                        <h3 class="fw-bold text-danger mt-1 mb-0"><%= stats != null ? stats.getLowAttendanceStudentsCount() : 0 %> Students</h3>
                    </div>
                    <a href="<%= request.getContextPath() %>/attendance?action=view" class="btn btn-outline-danger btn-sm">Inspect</a>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card card-stat p-3 bg-white border-start border-4 border-warning">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <span class="text-muted small fw-semibold">PENDING FEES</span>
                        <h3 class="fw-bold text-warning mt-1 mb-0"><%= stats != null ? stats.getPendingFeeStudentsCount() : 0 %> Students</h3>
                    </div>
                    <a href="<%= request.getContextPath() %>/fees?status=PENDING" class="btn btn-outline-warning btn-sm">View Ledger</a>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="card card-stat p-3 bg-white border-start border-4 border-dark">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <span class="text-muted small fw-semibold">FEES COLLECTED</span>
                        <h3 class="fw-bold text-success mt-1 mb-0">&#8377; <%= String.format("%,.0f", stats != null ? stats.getTotalFeesCollected() : 0.0) %></h3>
                    </div>
                    <span class="badge bg-danger">Pending: &#8377; <%= String.format("%,.0f", stats != null ? stats.getTotalFeesPending() : 0.0) %></span>
                </div>
            </div>
        </div>
    </div>

    <!-- Academic Risk Alert Table -->
    <div class="card border-0 shadow-sm mb-4">
        <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
            <div class="d-flex align-items-center gap-2">
                <i class="bi bi-exclamation-triangle-fill text-danger fs-5"></i>
                <h5 class="fw-bold mb-0 text-dark">Academic Attention Required (High-Risk Students)</h5>
            </div>
            <a href="<%= request.getContextPath() %>/academic-risk" class="btn btn-sm btn-outline-danger">Full Risk Matrix</a>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>Student</th>
                            <th>Dept / Sem</th>
                            <th>Attendance</th>
                            <th>Avg Marks</th>
                            <th>Pending Fees</th>
                            <th>Trigger Reasons</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (highRiskStudents != null && !highRiskStudents.isEmpty()) { 
                            for (AcademicRisk r : highRiskStudents) { %>
                                <tr>
                                    <td>
                                        <div class="fw-semibold text-dark"><%= r.getStudentName() %></div>
                                        <div class="small text-muted"><%= r.getEnrollmentNo() %></div>
                                    </td>
                                    <td><%= r.getDeptCode() %> - Sem <%= r.getSemester() %></td>
                                    <td>
                                        <span class="badge <%= r.getOverallAttendancePct() < 75.0 ? "badge-low-attendance" : "badge-ok-attendance" %>">
                                            <%= r.getOverallAttendancePct() %>%
                                        </span>
                                    </td>
                                    <td>
                                        <span class="badge <%= r.getAvgMarks() < 50.0 ? "bg-danger-subtle text-danger" : "bg-light text-dark" %>">
                                            <%= r.getAvgMarks() %> / 120
                                        </span>
                                    </td>
                                    <td>
                                        <span class="fw-semibold text-danger">&#8377; <%= String.format("%,.2f", r.getPendingFees()) %></span>
                                    </td>
                                    <td>
                                        <% for (String reason : r.getRiskReasons()) { %>
                                            <div class="small text-danger"><i class="bi bi-dot"></i><%= reason %></div>
                                        <% } %>
                                    </td>
                                    <td>
                                        <a href="<%= request.getContextPath() %>/students?action=view&id=<%= r.getStudentId() %>" class="btn btn-sm btn-light border">
                                            Profile
                                        </a>
                                    </td>
                                </tr>
                        <%  } 
                        } else { %>
                            <tr>
                                <td colspan="7" class="text-center py-4 text-muted">No students currently in academic risk criteria.</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
