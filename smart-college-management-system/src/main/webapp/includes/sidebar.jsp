<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.User" %>
<%
    User user = (User) session.getAttribute("currentUser");
    String currentUri = request.getRequestURI();
%>
<aside class="sidebar">
    <div class="brand d-flex align-items-center gap-2">
        <i class="bi bi-database-fill-gear text-primary fs-4"></i>
        <span>Smart College</span>
    </div>

    <ul class="sidebar-nav">
        <li class="nav-item">
            <a href="<%= request.getContextPath() %>/dashboard" class="nav-link <%= currentUri.contains("dashboard") ? "active" : "" %>">
                <i class="bi bi-speedometer2"></i> Dashboard
            </a>
        </li>
        <li class="nav-item">
            <a href="<%= request.getContextPath() %>/academic-risk" class="nav-link <%= currentUri.contains("academic-risk") ? "active" : "" %>">
                <i class="bi bi-exclamation-octagon text-warning"></i> Academic Risk
            </a>
        </li>

        <li class="nav-item text-uppercase px-3 pt-3 pb-1 text-muted" style="font-size: 0.72rem; letter-spacing: 0.05em;">Academic Management</li>

        <li class="nav-item">
            <a href="<%= request.getContextPath() %>/students" class="nav-link <%= currentUri.contains("students") ? "active" : "" %>">
                <i class="bi bi-people"></i> Students
            </a>
        </li>
        <li class="nav-item">
            <a href="<%= request.getContextPath() %>/departments" class="nav-link <%= currentUri.contains("departments") ? "active" : "" %>">
                <i class="bi bi-building"></i> Departments
            </a>
        </li>
        <li class="nav-item">
            <a href="<%= request.getContextPath() %>/faculty" class="nav-link <%= currentUri.contains("faculty") ? "active" : "" %>">
                <i class="bi bi-person-badge"></i> Faculty
            </a>
        </li>
        <li class="nav-item">
            <a href="<%= request.getContextPath() %>/subjects" class="nav-link <%= currentUri.contains("subjects") ? "active" : "" %>">
                <i class="bi bi-journal-bookmark"></i> Subjects
            </a>
        </li>
        <li class="nav-item">
            <a href="<%= request.getContextPath() %>/enrollments" class="nav-link <%= currentUri.contains("enrollments") ? "active" : "" %>">
                <i class="bi bi-diagram-3"></i> Enrollments
            </a>
        </li>

        <li class="nav-item text-uppercase px-3 pt-3 pb-1 text-muted" style="font-size: 0.72rem; letter-spacing: 0.05em;">Operations</li>

        <li class="nav-item">
            <a href="<%= request.getContextPath() %>/attendance" class="nav-link <%= currentUri.contains("attendance") ? "active" : "" %>">
                <i class="bi bi-calendar-check"></i> Attendance
            </a>
        </li>
        <li class="nav-item">
            <a href="<%= request.getContextPath() %>/marks" class="nav-link <%= currentUri.contains("marks") ? "active" : "" %>">
                <i class="bi bi-award"></i> Marks & Results
            </a>
        </li>
        <li class="nav-item">
            <a href="<%= request.getContextPath() %>/fees" class="nav-link <%= currentUri.contains("fees") ? "active" : "" %>">
                <i class="bi bi-cash-stack"></i> Fees Ledger
            </a>
        </li>
        <li class="nav-item">
            <a href="<%= request.getContextPath() %>/leaves" class="nav-link <%= currentUri.contains("leaves") ? "active" : "" %>">
                <i class="bi bi-calendar2-range"></i> Leave Requests
            </a>
        </li>
        <li class="nav-item">
            <a href="<%= request.getContextPath() %>/reports" class="nav-link <%= currentUri.contains("reports") ? "active" : "" %>">
                <i class="bi bi-file-earmark-bar-graph"></i> Reports
            </a>
        </li>

        <li class="nav-item pt-4 px-3">
            <a href="<%= request.getContextPath() %>/logout" class="btn btn-outline-danger w-100 btn-sm text-start">
                <i class="bi bi-box-arrow-right me-2"></i> Logout
            </a>
        </li>
    </ul>
</aside>
