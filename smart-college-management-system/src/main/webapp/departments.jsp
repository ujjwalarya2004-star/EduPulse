<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.Department" %>
<%@ page import="java.util.List" %>
<jsp:include page="/includes/header.jsp" />

<%
    List<Department> departments = (List<Department>) request.getAttribute("departments");
%>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">Department Management</h3>
            <p class="text-muted mb-0">Configure academic departments and branches with live headcounts.</p>
        </div>
        <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addDeptModal">
            <i class="bi bi-plus-lg me-1"></i>Add Department
        </button>
    </div>

    <div class="row g-3">
        <% if (departments != null) {
            for (Department d : departments) { %>
                <div class="col-md-6 col-lg-4">
                    <div class="card border-0 shadow-sm h-100">
                        <div class="card-body p-4">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <span class="badge bg-primary fs-6"><%= d.getDeptCode() %></span>
                                <div class="dropdown">
                                    <button class="btn btn-sm btn-light border" type="button" data-bs-toggle="dropdown">
                                        <i class="bi bi-three-dots-vertical"></i>
                                    </button>
                                    <ul class="dropdown-menu dropdown-menu-end">
                                        <li>
                                            <form action="<%= request.getContextPath() %>/departments" method="POST" onsubmit="return confirm('Delete department <%= d.getDeptCode() %>?');">
                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="id" value="<%= d.getDeptId() %>">
                                                <button type="submit" class="dropdown-item text-danger">Delete</button>
                                            </form>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            <h5 class="fw-bold text-dark"><%= d.getDeptName() %></h5>
                            <p class="text-muted small"><%= d.getDescription() != null ? d.getDescription() : "Academic division" %></p>
                            
                            <hr class="my-3 text-secondary">
                            
                            <div class="row text-center">
                                <div class="col-4">
                                    <h5 class="fw-bold mb-0 text-dark"><%= d.getStudentCount() %></h5>
                                    <span class="text-muted" style="font-size: 0.75rem;">Students</span>
                                </div>
                                <div class="col-4">
                                    <h5 class="fw-bold mb-0 text-dark"><%= d.getFacultyCount() %></h5>
                                    <span class="text-muted" style="font-size: 0.75rem;">Faculty</span>
                                </div>
                                <div class="col-4">
                                    <h5 class="fw-bold mb-0 text-dark"><%= d.getSubjectCount() %></h5>
                                    <span class="text-muted" style="font-size: 0.75rem;">Subjects</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
        <%  }
        } %>
    </div>
</div>

<!-- Modal: Add Department -->
<div class="modal fade" id="addDeptModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content border-0 shadow">
            <form action="<%= request.getContextPath() %>/departments" method="POST">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold">Add Academic Department</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Department Code *</label>
                        <input type="text" name="deptCode" class="form-control" placeholder="e.g. CSE, IT, ECE" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Department Name *</label>
                        <input type="text" name="deptName" class="form-control" placeholder="e.g. Computer Science & Engineering" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Description</label>
                        <textarea name="description" class="form-control" rows="3" placeholder="Brief outline of the curriculum and focus"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light border" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary">Create Department</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
