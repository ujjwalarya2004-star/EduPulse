<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.Student" %>
<%@ page import="com.college.model.Department" %>
<%@ page import="java.util.List" %>
<jsp:include page="/includes/header.jsp" />

<%
    List<Student> students = (List<Student>) request.getAttribute("students");
    List<Department> departments = (List<Department>) request.getAttribute("departments");
%>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">Student Management</h3>
            <p class="text-muted mb-0">Browse, filter, search and manage student academic profiles.</p>
        </div>
        <a href="<%= request.getContextPath() %>/students?action=add" class="btn btn-primary">
            <i class="bi bi-plus-lg me-1"></i>Add New Student
        </a>
    </div>

    <!-- Filter & Search Bar -->
    <div class="card border-0 shadow-sm mb-4">
        <div class="card-body">
            <form action="<%= request.getContextPath() %>/students" method="GET" class="row g-2 align-items-center">
                <div class="col-md-5">
                    <div class="input-group">
                        <span class="input-group-text bg-white"><i class="bi bi-search"></i></span>
                        <input type="text" name="q" value="<%= request.getParameter("q") != null ? request.getParameter("q") : "" %>" class="form-control" placeholder="Search by Name, Enrollment No, or Email...">
                    </div>
                </div>
                <div class="col-md-3">
                    <select name="dept" class="form-select">
                        <option value="">All Departments</option>
                        <% if (departments != null) { 
                            for (Department d : departments) { %>
                                <option value="<%= d.getDeptId() %>" <%= (request.getParameter("dept") != null && request.getParameter("dept").equals(String.valueOf(d.getDeptId()))) ? "selected" : "" %>>
                                    <%= d.getDeptCode() %> - <%= d.getDeptName() %>
                                </option>
                        <%  } 
                        } %>
                    </select>
                </div>
                <div class="col-md-2">
                    <select name="sem" class="form-select">
                        <option value="">All Semesters</option>
                        <% for (int i = 1; i <= 8; i++) { %>
                            <option value="<%= i %>" <%= (request.getParameter("sem") != null && request.getParameter("sem").equals(String.valueOf(i))) ? "selected" : "" %>>Semester <%= i %></option>
                        <% } %>
                    </select>
                </div>
                <div class="col-md-2 d-flex gap-2">
                    <button type="submit" class="btn btn-primary flex-fill">Filter</button>
                    <a href="<%= request.getContextPath() %>/students" class="btn btn-light border">Reset</a>
                </div>
            </form>
        </div>
    </div>

    <!-- Student Table -->
    <div class="card border-0 shadow-sm">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th>Enrollment No</th>
                            <th>Student Name</th>
                            <th>Department</th>
                            <th>Semester</th>
                            <th>Contact</th>
                            <th>Attendance</th>
                            <th>Fees Status</th>
                            <th class="text-end">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (students != null && !students.isEmpty()) { 
                            for (Student s : students) { %>
                                <tr>
                                    <td><span class="badge bg-light text-dark border"><%= s.getEnrollmentNo() %></span></td>
                                    <td>
                                        <div class="fw-semibold text-dark"><%= s.getName() %></div>
                                        <div class="small text-muted"><%= s.getEmail() %></div>
                                    </td>
                                    <td><span class="badge bg-info-subtle text-info border"><%= s.getDeptCode() %></span></td>
                                    <td>Sem <%= s.getSemester() %></td>
                                    <td><%= s.getPhone() %></td>
                                    <td>
                                        <span class="badge <%= s.getOverallAttendancePct() < 75.0 ? "badge-low-attendance" : "badge-ok-attendance" %>">
                                            <%= s.getOverallAttendancePct() %>%
                                        </span>
                                    </td>
                                    <td>
                                        <% if (s.getPendingFees() > 0) { %>
                                            <span class="badge bg-danger-subtle text-danger">&#8377; <%= String.format("%,.0f", s.getPendingFees()) %> Due</span>
                                        <% } else { %>
                                            <span class="badge bg-success-subtle text-success">Cleared</span>
                                        <% } %>
                                    </td>
                                    <td class="text-end">
                                        <a href="<%= request.getContextPath() %>/students?action=view&id=<%= s.getStudentId() %>" class="btn btn-sm btn-outline-primary" title="View 360 Profile">
                                            <i class="bi bi-eye"></i>
                                        </a>
                                        <a href="<%= request.getContextPath() %>/students?action=edit&id=<%= s.getStudentId() %>" class="btn btn-sm btn-outline-secondary" title="Edit">
                                            <i class="bi bi-pencil"></i>
                                        </a>
                                        <form action="<%= request.getContextPath() %>/students" method="POST" class="d-inline" onsubmit="return confirm('Delete student <%= s.getName() %>? This will cascade attendance, marks and enrollments.');">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="<%= s.getStudentId() %>">
                                            <button type="submit" class="btn btn-sm btn-outline-danger" title="Delete">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                        <%  } 
                        } else { %>
                            <tr>
                                <td colspan="8" class="text-center py-4 text-muted">No student records found matching the query.</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
