<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.Subject" %>
<%@ page import="com.college.model.Department" %>
<%@ page import="com.college.model.Faculty" %>
<%@ page import="java.util.List" %>
<jsp:include page="/includes/header.jsp" />

<%
    List<Subject> subjects = (List<Subject>) request.getAttribute("subjects");
    List<Department> departments = (List<Department>) request.getAttribute("departments");
    List<Faculty> facultyList = (List<Faculty>) request.getAttribute("facultyList");
%>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">Subject / Course Management</h3>
            <p class="text-muted mb-0">Curriculum courses, credits, and faculty assignments.</p>
        </div>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addSubjectModal">
            <i class="bi bi-journal-plus me-1"></i>Add Subject
        </button>
    </div>

    <div class="card border-0 shadow-sm">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>Subject Code</th>
                            <th>Subject Name</th>
                            <th>Department</th>
                            <th>Semester</th>
                            <th>Credits</th>
                            <th>Assigned Faculty</th>
                            <th>Enrolled Students</th>
                            <th class="text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (subjects != null) {
                            for (Subject s : subjects) { %>
                                <tr>
                                    <td><span class="badge bg-primary-subtle text-primary border"><%= s.getSubjectCode() %></span></td>
                                    <td><strong><%= s.getSubjectName() %></strong></td>
                                    <td><span class="badge bg-light text-dark border"><%= s.getDeptCode() %></span></td>
                                    <td>Sem <%= s.getSemester() %></td>
                                    <td><span class="badge bg-secondary"><%= s.getCredits() %> Credits</span></td>
                                    <td><%= s.getFacultyName() != null ? s.getFacultyName() : "<em class='text-muted'>Not Assigned</em>" %></td>
                                    <td><span class="badge bg-info-subtle text-info"><%= s.getEnrolledStudentCount() %> Students</span></td>
                                    <td class="text-end">
                                        <form action="<%= request.getContextPath() %>/subjects" method="POST" class="d-inline" onsubmit="return confirm('Delete subject <%= s.getSubjectCode() %>?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="<%= s.getSubjectId() %>">
                                            <button type="submit" class="btn btn-sm btn-outline-danger">
                                                <i class="bi bi-trash"></i>
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

<!-- Modal: Add Subject -->
<div class="modal fade" id="addSubjectModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content border-0 shadow">
            <form action="<%= request.getContextPath() %>/subjects" method="POST">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Create Subject</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body row g-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Subject Code *</label>
                        <input type="text" name="subjectCode" class="form-control" placeholder="e.g. CS405" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Credits *</label>
                        <input type="number" name="credits" class="form-control" min="1" max="6" value="4" required>
                    </div>
                    <div class="col-12">
                        <label class="form-label fw-semibold">Subject Name *</label>
                        <input type="text" name="subjectName" class="form-control" placeholder="Full descriptive course name" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Department *</label>
                        <select name="deptId" class="form-select" required>
                            <% if (departments != null) {
                                for (Department d : departments) { %>
                                    <option value="<%= d.getDeptId() %>"><%= d.getDeptCode() %> - <%= d.getDeptName() %></option>
                            <%  }
                            } %>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Semester *</label>
                        <select name="semester" class="form-select" required>
                            <% for (int i = 1; i <= 8; i++) { %>
                                <option value="<%= i %>">Semester <%= i %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="col-12">
                        <label class="form-label fw-semibold">Assign Faculty</label>
                        <select name="facultyId" class="form-select">
                            <option value="">-- Unassigned --</option>
                            <% if (facultyList != null) {
                                for (Faculty f : facultyList) { %>
                                    <option value="<%= f.getFacultyId() %>"><%= f.getName() %> (<%= f.getDeptCode() %>)</option>
                            <%  }
                            } %>
                        </select>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Subject</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
