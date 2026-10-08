<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.Student" %>
<%@ page import="com.college.model.Department" %>
<%@ page import="java.util.List" %>
<jsp:include page="/includes/header.jsp" />

<%
    Student s = (Student) request.getAttribute("student");
    List<Department> departments = (List<Department>) request.getAttribute("departments");
%>

<div class="container-fluid">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white py-3">
                    <h5 class="fw-bold mb-0">Update Student Information</h5>
                </div>
                <div class="card-body p-4">
                    <% if (s != null) { %>
                    <form action="<%= request.getContextPath() %>/students" method="POST">
                        <input type="hidden" name="action" value="edit">
                        <input type="hidden" name="id" value="<%= s.getStudentId() %>">

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Enrollment Number</label>
                                <input type="text" name="enrollmentNo" class="form-control" value="<%= s.getEnrollmentNo() %>" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Full Name</label>
                                <input type="text" name="name" class="form-control" value="<%= s.getName() %>" required>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Email Address</label>
                                <input type="email" name="email" class="form-control" value="<%= s.getEmail() %>" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Phone Number</label>
                                <input type="tel" name="phone" class="form-control" value="<%= s.getPhone() %>" required>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Gender</label>
                                <select name="gender" class="form-select" required>
                                    <option value="MALE" <%= "MALE".equalsIgnoreCase(s.getGender()) ? "selected" : "" %>>Male</option>
                                    <option value="FEMALE" <%= "FEMALE".equalsIgnoreCase(s.getGender()) ? "selected" : "" %>>Female</option>
                                    <option value="OTHER" <%= "OTHER".equalsIgnoreCase(s.getGender()) ? "selected" : "" %>>Other</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Date of Birth</label>
                                <input type="date" name="dob" class="form-control" value="<%= s.getDob() %>" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Department</label>
                                <select name="deptId" class="form-select" required>
                                    <% if (departments != null) {
                                        for (Department d : departments) { %>
                                            <option value="<%= d.getDeptId() %>" <%= d.getDeptId() == s.getDeptId() ? "selected" : "" %>>
                                                <%= d.getDeptCode() %> - <%= d.getDeptName() %>
                                            </option>
                                    <%  }
                                    } %>
                                </select>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Semester</label>
                                <select name="semester" class="form-select" required>
                                    <% for (int i = 1; i <= 8; i++) { %>
                                        <option value="<%= i %>" <%= i == s.getSemester() ? "selected" : "" %>>Semester <%= i %></option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Admission Year</label>
                                <input type="number" name="admissionYear" class="form-control" value="<%= s.getAdmissionYear() %>" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Status</label>
                                <select name="status" class="form-select">
                                    <option value="ACTIVE" <%= "ACTIVE".equalsIgnoreCase(s.getStatus()) ? "selected" : "" %>>Active</option>
                                    <option value="SUSPENDED" <%= "SUSPENDED".equalsIgnoreCase(s.getStatus()) ? "selected" : "" %>>Suspended</option>
                                    <option value="GRADUATED" <%= "GRADUATED".equalsIgnoreCase(s.getStatus()) ? "selected" : "" %>>Graduated</option>
                                </select>
                            </div>

                            <div class="col-12">
                                <label class="form-label fw-semibold">Residential Address</label>
                                <textarea name="address" class="form-control" rows="3" required><%= s.getAddress() %></textarea>
                            </div>

                            <div class="col-12 pt-3 border-top d-flex gap-2">
                                <button type="submit" class="btn btn-primary px-4">Save Changes</button>
                                <a href="<%= request.getContextPath() %>/students" class="btn btn-light border px-4">Cancel</a>
                            </div>
                        </div>
                    </form>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
