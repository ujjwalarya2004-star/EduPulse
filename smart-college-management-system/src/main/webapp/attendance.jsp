<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.*" %>
<%@ page import="java.util.List" %>
<jsp:include page="/includes/header.jsp" />

<%
    List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
    List<Enrollment> enrolledStudents = (List<Enrollment>) request.getAttribute("enrolledStudents");
    Integer selectedSubjectId = (Integer) request.getAttribute("selectedSubjectId");
%>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">Attendance Desk</h3>
            <p class="text-muted mb-0">Select subject and date, then mark student attendance.</p>
        </div>
        <a href="<%= request.getContextPath() %>/attendance?action=view" class="btn btn-outline-primary">
            <i class="bi bi-clock-history me-1"></i>View Attendance Register
        </a>
    </div>

    <!-- Step 1: Subject Selection Card -->
    <div class="card border-0 shadow-sm mb-4">
        <div class="card-body">
            <form action="<%= request.getContextPath() %>/attendance" method="GET" class="row g-3 align-items-end">
                <div class="col-md-6">
                    <label class="form-label fw-semibold">Select Subject *</label>
                    <select name="subjectId" class="form-select" onchange="this.form.submit()">
                        <option value="">-- Choose Course --</option>
                        <% if (subjects != null) {
                            for (Subject s : subjects) { %>
                                <option value="<%= s.getSubjectId() %>" <%= (selectedSubjectId != null && selectedSubjectId.equals(s.getSubjectId())) ? "selected" : "" %>>
                                    <%= s.getSubjectCode() %> - <%= s.getSubjectName() %> (Sem <%= s.getSemester() %>)
                                </option>
                        <%  }
                        } %>
                    </select>
                </div>
                <div class="col-md-4">
                    <button type="submit" class="btn btn-primary">Load Class Roster</button>
                </div>
            </form>
        </div>
    </div>

    <% if (enrolledStudents != null && !enrolledStudents.isEmpty()) { %>
        <!-- Step 2: Student Attendance Marking Form -->
        <div class="card border-0 shadow-sm">
            <div class="card-header bg-white py-3 d-flex justify-content-between align-items-center">
                <h5 class="fw-bold mb-0">Class Roster (<%= enrolledStudents.size() %> Enrolled Students)</h5>
                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="markAll(true)">Mark All Present</button>
            </div>
            <div class="card-body p-4">
                <form action="<%= request.getContextPath() %>/attendance" method="POST">
                    <input type="hidden" name="subjectId" value="<%= selectedSubjectId %>">

                    <div class="row mb-4">
                        <div class="col-md-4">
                            <label class="form-label fw-semibold">Attendance Date *</label>
                            <input type="date" name="attendanceDate" class="form-control" value="<%= new java.sql.Date(System.currentTimeMillis()) %>" required>
                        </div>
                    </div>

                    <div class="table-responsive mb-4">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th style="width: 50px;">Present</th>
                                    <th>Enrollment No</th>
                                    <th>Student Name</th>
                                    <th>Department</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Enrollment en : enrolledStudents) { %>
                                    <tr>
                                        <td>
                                            <input type="hidden" name="allStudentIds" value="<%= en.getStudentId() %>">
                                            <input class="form-check-input student-att-check" type="checkbox" name="presentStudents" value="<%= en.getStudentId() %>" checked>
                                        </td>
                                        <td><span class="badge bg-light text-dark border"><%= en.getEnrollmentNo() %></span></td>
                                        <td><strong><%= en.getStudentName() %></strong></td>
                                        <td><%= en.getDeptCode() %></td>
                                    </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" class="btn btn-success px-4 fw-semibold">
                            <i class="bi bi-check2-all me-1"></i>Save Attendance Records
                        </button>
                        <a href="<%= request.getContextPath() %>/dashboard" class="btn btn-light border px-4">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    <% } else if (selectedSubjectId != null) { %>
        <div class="alert alert-warning">
            No students are currently enrolled in this subject. Please enroll students via the <a href="<%= request.getContextPath() %>/enrollments">Enrollments tab</a> first.
        </div>
    <% } %>
</div>

<script>
function markAll(status) {
    document.querySelectorAll('.student-att-check').forEach(cb => cb.checked = status);
}
</script>

<jsp:include page="/includes/footer.jsp" />
