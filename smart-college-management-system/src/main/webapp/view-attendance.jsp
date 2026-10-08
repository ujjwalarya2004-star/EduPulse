<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.*" %>
<%@ page import="java.util.List" %>
<jsp:include page="/includes/header.jsp" />

<%
    List<Attendance> summaries = (List<Attendance>) request.getAttribute("summaries");
    List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
    Integer selectedSubjectId = (Integer) request.getAttribute("selectedSubjectId");
%>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">Attendance Percentage Register</h3>
            <p class="text-muted mb-0">Dynamic calculation of total classes, attended classes, and percentage.</p>
        </div>
        <a href="<%= request.getContextPath() %>/attendance" class="btn btn-primary">
            <i class="bi bi-calendar-check me-1"></i>Mark New Attendance
        </a>
    </div>

    <!-- Filter by Subject -->
    <div class="card border-0 shadow-sm mb-4">
        <div class="card-body">
            <form action="<%= request.getContextPath() %>/attendance" method="GET" class="row g-2 align-items-center">
                <input type="hidden" name="action" value="view">
                <div class="col-md-6">
                    <select name="subjectId" class="form-select" onchange="this.form.submit()">
                        <option value="">All Subjects Combined</option>
                        <% if (subjects != null) {
                            for (Subject s : subjects) { %>
                                <option value="<%= s.getSubjectId() %>" <%= (selectedSubjectId != null && selectedSubjectId.equals(s.getSubjectId())) ? "selected" : "" %>>
                                    <%= s.getSubjectCode() %> - <%= s.getSubjectName() %>
                                </option>
                        <%  }
                        } %>
                    </select>
                </div>
            </form>
        </div>
    </div>

    <!-- Attendance Table -->
    <div class="card border-0 shadow-sm">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>Student</th>
                            <th>Subject</th>
                            <th>Total Classes</th>
                            <th>Classes Attended</th>
                            <th>Percentage</th>
                            <th>Academic Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (summaries != null && !summaries.isEmpty()) {
                            for (Attendance a : summaries) { %>
                                <tr>
                                    <td>
                                        <div class="fw-semibold text-dark"><%= a.getStudentName() %></div>
                                        <div class="small text-muted"><%= a.getEnrollmentNo() %></div>
                                    </td>
                                    <td>
                                        <span class="badge bg-light text-dark border"><%= a.getSubjectCode() %></span>
                                        <%= a.getSubjectName() %>
                                    </td>
                                    <td><strong><%= a.getTotalClasses() %></strong></td>
                                    <td><strong><%= a.getClassesAttended() %></strong></td>
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <div class="progress flex-grow-1" style="height: 6px;">
                                                <div class="progress-bar <%= a.isLowAttendance() ? "bg-danger" : "bg-success" %>" style="width: <%= a.getAttendancePercentage() %>%;"></div>
                                            </div>
                                            <span class="fw-bold small <%= a.isLowAttendance() ? "text-danger" : "text-success" %>"><%= a.getAttendancePercentage() %>%</span>
                                        </div>
                                    </td>
                                    <td>
                                        <% if (a.isLowAttendance()) { %>
                                            <span class="badge badge-low-attendance">
                                                <i class="bi bi-exclamation-triangle-fill me-1"></i>Low Attendance (&lt;75%)
                                            </span>
                                        <% } else { %>
                                            <span class="badge badge-ok-attendance">Eligible</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <a href="<%= request.getContextPath() %>/students?action=view&id=<%= a.getStudentId() %>" class="btn btn-sm btn-light border">
                                            Student Profile
                                        </a>
                                    </td>
                                </tr>
                        <%  }
                        } else { %>
                            <tr>
                                <td colspan="7" class="text-center py-4 text-muted">No attendance sessions recorded yet.</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
