<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.*" %>
<%@ page import="java.util.List" %>
<jsp:include page="/includes/header.jsp" />

<%
    List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
    List<Marks> marksList = (List<Marks>) request.getAttribute("marksList");
    List<Student> allStudents = (List<Student>) request.getAttribute("allStudents");
    Integer selectedSubjectId = (Integer) request.getAttribute("selectedSubjectId");
%>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">Marks Management</h3>
            <p class="text-muted mb-0">Record assignment, internal, practical, and end-semester marks.</p>
        </div>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#enterMarksModal">
            <i class="bi bi-plus-lg me-1"></i>Enter Student Marks
        </button>
    </div>

    <!-- Filter by Subject -->
    <div class="card border-0 shadow-sm mb-4">
        <div class="card-body">
            <form action="<%= request.getContextPath() %>/marks" method="GET" class="row g-2 align-items-center">
                <div class="col-md-6">
                    <select name="subjectId" class="form-select" onchange="this.form.submit()">
                        <option value="">-- Choose Subject to View Marks Ledger --</option>
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

    <!-- Marks Ledger Table -->
    <div class="card border-0 shadow-sm">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>Student</th>
                            <th>Assignment (Max 20)</th>
                            <th>Internal (Max 30)</th>
                            <th>Practical (Max 20)</th>
                            <th>End-Sem (Max 50)</th>
                            <th>Total (Max 120)</th>
                            <th>Grade</th>
                            <th>Transcript</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (marksList != null && !marksList.isEmpty()) {
                            for (Marks m : marksList) { %>
                                <tr>
                                    <td>
                                        <div class="fw-semibold text-dark"><%= m.getStudentName() %></div>
                                        <div class="small text-muted"><%= m.getEnrollmentNo() %></div>
                                    </td>
                                    <td><%= m.getAssignmentMarks() %></td>
                                    <td><%= m.getInternalMarks() %></td>
                                    <td><%= m.getPracticalMarks() %></td>
                                    <td><%= m.getEndSemMarks() %></td>
                                    <td><strong><%= m.getTotalMarks() %></strong></td>
                                    <td><span class="badge <%= "F".equalsIgnoreCase(m.getGrade()) ? "bg-danger" : "bg-primary" %>"><%= m.getGrade() %></span></td>
                                    <td>
                                        <a href="<%= request.getContextPath() %>/marks?action=result&studentId=<%= m.getStudentId() %>" class="btn btn-sm btn-outline-primary">
                                            Grade Card
                                        </a>
                                    </td>
                                </tr>
                        <%  }
                        } else { %>
                            <tr>
                                <td colspan="8" class="text-center py-4 text-muted">Select a subject above to view entered marks.</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- Modal: Enter Marks -->
<div class="modal fade" id="enterMarksModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content border-0 shadow">
            <form action="<%= request.getContextPath() %>/marks" method="POST">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Enter Examination Marks</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body row g-3">
                    <div class="col-12">
                        <label class="form-label fw-semibold">Select Student *</label>
                        <select name="studentId" class="form-select" required>
                            <% if (allStudents != null) {
                                for (Student st : allStudents) { %>
                                    <option value="<%= st.getStudentId() %>"><%= st.getName() %> (<%= st.getEnrollmentNo() %>)</option>
                            <%  }
                            } %>
                        </select>
                    </div>
                    <div class="col-12">
                        <label class="form-label fw-semibold">Select Subject *</label>
                        <select name="subjectId" class="form-select" required>
                            <% if (subjects != null) {
                                for (Subject sub : subjects) { %>
                                    <option value="<%= sub.getSubjectId() %>"><%= sub.getSubjectCode() %> - <%= sub.getSubjectName() %></option>
                            <%  }
                            } %>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Assignment Marks (0 - 20) *</label>
                        <input type="number" step="0.5" min="0" max="20" name="assignmentMarks" class="form-control" value="15" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Internal/MST (0 - 30) *</label>
                        <input type="number" step="0.5" min="0" max="30" name="internalMarks" class="form-control" value="22" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Practical Marks (0 - 20) *</label>
                        <input type="number" step="0.5" min="0" max="20" name="practicalMarks" class="form-control" value="16" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">End-Sem Marks (0 - 50) *</label>
                        <input type="number" step="0.5" min="0" max="50" name="endSemMarks" class="form-control" value="38" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Marks</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
