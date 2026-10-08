<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.Faculty" %>
<%@ page import="com.college.model.Department" %>
<%@ page import="java.util.List" %>
<jsp:include page="/includes/header.jsp" />

<%
    List<Faculty> facultyList = (List<Faculty>) request.getAttribute("facultyList");
    List<Department> departments = (List<Department>) request.getAttribute("departments");
%>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">Faculty Management</h3>
            <p class="text-muted mb-0">Professors, lecturers, and departmental instructors.</p>
        </div>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addFacultyModal">
            <i class="bi bi-person-plus me-1"></i>Add Faculty Member
        </button>
    </div>

    <div class="card border-0 shadow-sm">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>Employee ID</th>
                            <th>Name</th>
                            <th>Department</th>
                            <th>Designation</th>
                            <th>Qualification</th>
                            <th>Contact</th>
                            <th>Joining Date</th>
                            <th class="text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (facultyList != null) {
                            for (Faculty f : facultyList) { %>
                                <tr>
                                    <td><span class="badge bg-light text-dark border"><%= f.getEmployeeId() %></span></td>
                                    <td>
                                        <div class="fw-semibold text-dark"><%= f.getName() %></div>
                                        <div class="small text-muted"><%= f.getEmail() %></div>
                                    </td>
                                    <td><span class="badge bg-info-subtle text-info border"><%= f.getDeptCode() %></span></td>
                                    <td><%= f.getDesignation() %></td>
                                    <td><%= f.getQualification() %></td>
                                    <td><%= f.getPhone() %></td>
                                    <td><%= f.getJoiningDate() %></td>
                                    <td class="text-end">
                                        <form action="<%= request.getContextPath() %>/faculty" method="POST" class="d-inline" onsubmit="return confirm('Remove faculty <%= f.getName() %>?');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="<%= f.getFacultyId() %>">
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

<!-- Modal: Add Faculty -->
<div class="modal fade" id="addFacultyModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content border-0 shadow">
            <form action="<%= request.getContextPath() %>/faculty" method="POST">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Register Faculty Member</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body row g-3">
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Employee ID *</label>
                        <input type="text" name="employeeId" class="form-control" placeholder="e.g. FAC009" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Full Name *</label>
                        <input type="text" name="name" class="form-control" placeholder="Dr. / Prof." required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Email *</label>
                        <input type="email" name="email" class="form-control" placeholder="faculty@college.edu" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Phone *</label>
                        <input type="tel" name="phone" class="form-control" placeholder="Mobile number" required>
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
                        <label class="form-label fw-semibold">Designation *</label>
                        <input type="text" name="designation" class="form-control" placeholder="e.g. Associate Professor" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Qualification</label>
                        <input type="text" name="qualification" class="form-control" placeholder="e.g. Ph.D / M.Tech">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Joining Date *</label>
                        <input type="date" name="joiningDate" class="form-control" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Save Faculty</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
