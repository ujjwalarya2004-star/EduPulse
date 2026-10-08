<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.Department" %>
<%@ page import="java.util.List" %>
<jsp:include page="/includes/header.jsp" />

<%
    List<Department> departments = (List<Department>) request.getAttribute("departments");
%>

<div class="container-fluid">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white py-3">
                    <h5 class="fw-bold mb-0">Register New Student</h5>
                </div>
                <div class="card-body p-4">
                    <form action="<%= request.getContextPath() %>/students" method="POST">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Enrollment Number *</label>
                                <input type="text" name="enrollmentNo" class="form-control" placeholder="e.g. EN2024CS10" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Full Name *</label>
                                <input type="text" name="name" class="form-control" placeholder="Student's legal name" required>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Email Address *</label>
                                <input type="email" name="email" class="form-control" placeholder="student@college.edu" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Phone Number *</label>
                                <input type="tel" name="phone" class="form-control" placeholder="10-digit mobile" required>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Gender *</label>
                                <select name="gender" class="form-select" required>
                                    <option value="MALE">Male</option>
                                    <option value="FEMALE">Female</option>
                                    <option value="OTHER">Other</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Date of Birth *</label>
                                <input type="date" name="dob" class="form-control" required>
                            </div>
                            <div class="col-md-4">
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
                                <label class="form-label fw-semibold">Current Semester *</label>
                                <select name="semester" class="form-select" required>
                                    <% for (int i = 1; i <= 8; i++) { %>
                                        <option value="<%= i %>">Semester <%= i %></option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Admission Year *</label>
                                <input type="number" name="admissionYear" class="form-control" value="2024" min="2018" max="2026" required>
                            </div>

                            <div class="col-12">
                                <label class="form-label fw-semibold">Residential Address *</label>
                                <textarea name="address" class="form-control" rows="3" placeholder="Full permanent address" required></textarea>
                            </div>

                            <div class="col-12 pt-3 border-top d-flex gap-2">
                                <button type="submit" class="btn btn-primary px-4">Register Student</button>
                                <a href="<%= request.getContextPath() %>/students" class="btn btn-light border px-4">Cancel</a>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
