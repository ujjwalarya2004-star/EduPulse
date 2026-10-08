<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.*" %>
<%@ page import="java.util.List" %>
<jsp:include page="/includes/header.jsp" />

<%
    Student s = (Student) request.getAttribute("student");
    List<Marks> transcript = (List<Marks>) request.getAttribute("transcript");
    Double totalMarksAll = (Double) request.getAttribute("totalMarksAll");
    Integer totalMax = (Integer) request.getAttribute("totalMax");
    Double overallPct = (Double) request.getAttribute("overallPct");
%>

<div class="container-fluid">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">Official Semester Grade Sheet</h3>
            <p class="text-muted mb-0">Certified student grade and performance report card.</p>
        </div>
        <button class="btn btn-outline-dark" onclick="window.print()">
            <i class="bi bi-printer me-1"></i>Print Report Card
        </button>
    </div>

    <% if (s != null) { %>
    <div class="card border-0 shadow-sm p-4">
        <!-- University / College Header -->
        <div class="text-center pb-4 border-bottom mb-4">
            <h3 class="fw-bold mb-1 text-primary">SMART COLLEGE OF ENGINEERING & TECHNOLOGY</h3>
            <p class="text-muted small mb-1">Affiliated to State Technical University &bull; Approved by AICTE</p>
            <h5 class="fw-bold text-dark mt-3">SEMESTER EXAMINATION TRANSCRIPT</h5>
        </div>

        <!-- Student Particulars -->
        <div class="row g-3 mb-4">
            <div class="col-md-3"><strong>Name:</strong> <%= s.getName() %></div>
            <div class="col-md-3"><strong>Enrollment No:</strong> <%= s.getEnrollmentNo() %></div>
            <div class="col-md-3"><strong>Department:</strong> <%= s.getDeptCode() %></div>
            <div class="col-md-3"><strong>Semester:</strong> <%= s.getSemester() %></div>
        </div>

        <!-- Grades Table -->
        <div class="table-responsive mb-4">
            <table class="table table-bordered align-middle">
                <thead class="table-light text-center">
                    <tr>
                        <th>Subject Code</th>
                        <th>Subject Name</th>
                        <th>Credits</th>
                        <th>Assignment (20)</th>
                        <th>Internal (30)</th>
                        <th>Practical (20)</th>
                        <th>End-Sem (50)</th>
                        <th>Total (120)</th>
                        <th>Grade</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (transcript != null) {
                        for (Marks m : transcript) { %>
                            <tr>
                                <td class="text-center font-monospace"><%= m.getSubjectCode() %></td>
                                <td><strong><%= m.getSubjectName() %></strong></td>
                                <td class="text-center"><%= m.getCredits() %></td>
                                <td class="text-center"><%= m.getAssignmentMarks() %></td>
                                <td class="text-center"><%= m.getInternalMarks() %></td>
                                <td class="text-center"><%= m.getPracticalMarks() %></td>
                                <td class="text-center"><%= m.getEndSemMarks() %></td>
                                <td class="text-center"><strong><%= m.getTotalMarks() %></strong></td>
                                <td class="text-center"><span class="badge <%= "F".equalsIgnoreCase(m.getGrade()) ? "bg-danger" : "bg-primary" %>"><%= m.getGrade() %></span></td>
                            </tr>
                    <%  }
                    } %>
                </tbody>
            </table>
        </div>

        <!-- Summary Totals -->
        <div class="card bg-light border-0 p-3 mb-4">
            <div class="row text-center">
                <div class="col-md-4">
                    <span class="text-muted small">Total Marks Obtained</span>
                    <h4 class="fw-bold text-dark mt-1"><%= totalMarksAll != null ? totalMarksAll : 0 %> / <%= totalMax != null ? totalMax : 0 %></h4>
                </div>
                <div class="col-md-4">
                    <span class="text-muted small">Cumulative Percentage</span>
                    <h4 class="fw-bold text-primary mt-1"><%= overallPct != null ? overallPct : 0 %>%</h4>
                </div>
                <div class="col-md-4">
                    <span class="text-muted small">Result Classification</span>
                    <h4 class="fw-bold mt-1 <%= (overallPct != null && overallPct >= 50) ? "text-success" : "text-danger" %>">
                        <%= (overallPct != null && overallPct >= 50) ? "PASSED WITH DISTINCTION" : "REQUIRES REMEDIAL" %>
                    </h4>
                </div>
            </div>
        </div>
    </div>
    <% } %>
</div>

<jsp:include page="/includes/footer.jsp" />
