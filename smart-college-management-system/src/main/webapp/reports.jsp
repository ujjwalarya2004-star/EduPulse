<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<jsp:include page="/includes/header.jsp" />

<%
    List<Map<String, Object>> deptReport = (List<Map<String, Object>>) request.getAttribute("deptReport");
    List<Student> students = (List<Student>) request.getAttribute("students");
    List<Attendance> attendanceSummary = (List<Attendance>) request.getAttribute("attendanceSummary");
    List<StudentFee> feeRecords = (List<StudentFee>) request.getAttribute("feeRecords");
    List<AcademicRisk> riskStudents = (List<AcademicRisk>) request.getAttribute("riskStudents");
%>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">DBMS Analytical Reports</h3>
            <p class="text-muted mb-0">Relational SQL queries utilizing GROUP BY, aggregations, INNER JOINs, and HAVING clauses.</p>
        </div>
        <button class="btn btn-outline-dark btn-sm" onclick="window.print()">
            <i class="bi bi-printer me-1"></i>Print Report
        </button>
    </div>

    <!-- Reports Tab Navigation -->
    <div class="card border-0 shadow-sm">
        <div class="card-header bg-white border-bottom-0">
            <ul class="nav nav-tabs card-header-tabs" role="tablist">
                <li class="nav-item"><a class="nav-link active" data-bs-toggle="tab" href="#deptSum">Department Summary</a></li>
                <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#lowAttRep">Low Attendance Students</a></li>
                <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#feeRep">Fee Defaulters</a></li>
                <li class="nav-item"><a class="nav-link" data-bs-toggle="tab" href="#allStudentsRep">Student Directory</a></li>
            </ul>
        </div>
        <div class="card-body p-4 tab-content">
            <!-- 1. Department Aggregate Summary -->
            <div class="tab-pane fade show active" id="deptSum">
                <h6 class="fw-bold mb-3 text-dark">Department-Wise Relational Breakdown (GROUP BY dept_id)</h6>
                <div class="table-responsive">
                    <table class="table table-bordered align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Department</th>
                                <th>Code</th>
                                <th>Students Enrolled</th>
                                <th>Faculty Strength</th>
                                <th>Curriculum Subjects</th>
                                <th>Avg Dept Attendance</th>
                                <th>Total Arrears (Pending)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (deptReport != null) {
                                for (Map<String, Object> row : deptReport) { %>
                                    <tr>
                                        <td><strong><%= row.get("deptName") %></strong></td>
                                        <td><span class="badge bg-primary"><%= row.get("deptCode") %></span></td>
                                        <td><%= row.get("totalStudents") %></td>
                                        <td><%= row.get("totalFaculty") %></td>
                                        <td><%= row.get("totalSubjects") %></td>
                                        <td><%= row.get("avgDeptAttendance") %>%</td>
                                        <td class="text-danger fw-bold">&#8377; <%= String.format("%,.2f", row.get("deptPendingFees")) %></td>
                                    </tr>
                            <%  }
                            } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- 2. Low Attendance Report -->
            <div class="tab-pane fade" id="lowAttRep">
                <h6 class="fw-bold mb-3 text-danger">Students Below 75% Attendance Threshold</h6>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Enrollment No</th>
                                <th>Student</th>
                                <th>Subject</th>
                                <th>Total Classes</th>
                                <th>Attended</th>
                                <th>Percentage</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (attendanceSummary != null) {
                                for (Attendance a : attendanceSummary) {
                                    if (a.isLowAttendance()) { %>
                                        <tr>
                                            <td><%= a.getEnrollmentNo() %></td>
                                            <td><strong><%= a.getStudentName() %></strong></td>
                                            <td><%= a.getSubjectCode() %> - <%= a.getSubjectName() %></td>
                                            <td><%= a.getTotalClasses() %></td>
                                            <td><%= a.getClassesAttended() %></td>
                                            <td><span class="badge badge-low-attendance fs-6"><%= a.getAttendancePercentage() %>%</span></td>
                                        </tr>
                            <%      }
                                }
                            } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- 3. Fee Arrears Report -->
            <div class="tab-pane fade" id="feeRep">
                <h6 class="fw-bold mb-3 text-warning">Pending Fee Defaulters List</h6>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Enrollment No</th>
                                <th>Student Name</th>
                                <th>Department</th>
                                <th>Due Amount</th>
                                <th>Due Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (feeRecords != null) {
                                for (StudentFee sf : feeRecords) { %>
                                    <tr>
                                        <td><%= sf.getEnrollmentNo() %></td>
                                        <td><strong><%= sf.getStudentName() %></strong></td>
                                        <td><%= sf.getDeptCode() %> - Sem <%= sf.getSemester() %></td>
                                        <td class="text-danger fw-bold">&#8377; <%= String.format("%,.2f", sf.getPendingAmount()) %></td>
                                        <td><%= sf.getDueDate() %></td>
                                    </tr>
                            <%  }
                            } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- 4. All Students Directory -->
            <div class="tab-pane fade" id="allStudentsRep">
                <h6 class="fw-bold mb-3 text-dark">Active Student Directory Registry</h6>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Enrollment No</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Dept</th>
                                <th>Semester</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (students != null) {
                                for (Student st : students) { %>
                                    <tr>
                                        <td><%= st.getEnrollmentNo() %></td>
                                        <td><strong><%= st.getName() %></strong></td>
                                        <td><%= st.getEmail() %></td>
                                        <td><%= st.getPhone() %></td>
                                        <td><%= st.getDeptCode() %></td>
                                        <td>Sem <%= st.getSemester() %></td>
                                    </tr>
                            <%  }
                            } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/includes/footer.jsp" />
