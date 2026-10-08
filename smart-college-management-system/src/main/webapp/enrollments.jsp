<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.*" %>
<%@ page import="java.util.List" %>
<jsp:include page="/includes/header.jsp" />

<%
    List<Enrollment> enrollments = (List<Enrollment>) request.getAttribute("enrollments");
    List<Student> students = (List<Student>) request.getAttribute("students");
    List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
%>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">Student Course Enrollment (M:N Junction Table)</h3>
            <p class="text-muted mb-0">Proper normalized relational enrollment mapping between students and subjects.</p>
        </div>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#enrollModal">
            <i class="bi bi-link-45deg me-1"></i>Enroll Student in Subject
        </button>
    </div>

    <div class="card border-0 shadow-sm">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>Enrollment ID</th>
                            <th>Student</th>
                            <th>Subject</th>
                            <th>Academic Year</th>
                            <th>Enrolled On</th>
                            <th class="text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (enrollments != null) {
                            for (Enrollment en : enrollments) { %>
                                <tr>
                                    <td>#<%= en.getEnrollmentId() %></td>
                                    <td>
                                        <div class="fw-semibold text-dark"><%= en.getStudentName() %></div>
                                        <div class="small text-muted"><%= en.getEnrollmentNo() %></div>
                                    </td>
                                    <td>
                                        <span class="badge bg-primary-subtle text-primary"><%= en.getSubjectCode() %></span>
                                        <strong><%= en.getSubjectName() %></strong>
                                    </td>
                                    <td><%= en.getAcademicYear() %></td>
                                    <td><%= en.getEnrolledAt() %></td>
                                    <td class="text-end">
                                        <form action="<%= request.getContextPath() %>/enrollments" method="POST" class="d-inline" onsubmit="return confirm('Deregister student from this subject?');">
                                            <input type="hidden" name="action" value="remove">
                                            <input type="hidden" name="id" value="<%= en.getEnrollmentId() %>">
                                            <button type="submit" class="btn btn-sm btn-outline-danger">
                                                <i class="bi bi-x-circle me-1"></i>Deregister
                                            </button>
                                        </form>
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

<!-- Modal: Enroll -->
<div class="modal fade" id="enrollModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content border-0 shadow">
            <form action="<%= request.getContextPath() %>/enrollments" method="POST">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Enroll Student in Subject</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Select Student *</label>
                        <select name="studentId" class="form-select" required>
                            <% if (students != null) {
                                for (Student st : students) { %>
                                    <option value="<%= st.getStudentId() %>"><%= st.getName() %> (<%= st.getEnrollmentNo() %> - <%= st.getDeptCode() %>)</option>
                            <%  }
                            } %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Select Subject *</label>
                        <select name="subjectId" class="form-select" required>
                            <% if (subjects != null) {
                                for (Subject sub : subjects) { %>
                                    <option value="<%= sub.getSubjectId() %>"><%= sub.getSubjectCode() %> - <%= sub.getSubjectName() %> (Sem <%= sub.getSemester() %>)</option>
                            <%  }
                            } %>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Academic Year *</label>
                        <input type="text" name="academicYear" class="form-control" value="2025-2026" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Confirm Enrollment</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
