<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.college.model.User" %>
<%
    User currentUser = (User) session.getAttribute("currentUser");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Smart College Student Management System</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link href="<%= request.getContextPath() %>/css/style.css" rel="stylesheet">
</head>
<body>
<div class="d-flex">
    <!-- Include Sidebar -->
    <jsp:include page="/includes/sidebar.jsp" />

    <!-- Main Content Area -->
    <div class="main-content flex-grow-1">
        <!-- Top Navbar -->
        <header class="top-navbar shadow-sm">
            <div class="d-flex align-items-center gap-3">
                <span class="fs-5 fw-bold text-dark">
                    <i class="bi bi-mortarboard-fill text-primary me-2"></i>Smart College DBMS
                </span>
                <span class="badge bg-primary-subtle text-primary border border-primary-subtle">DBMS Mini-Project</span>
            </div>

            <div class="d-flex align-items-center gap-3">
                <div class="text-end d-none d-md-block">
                    <div class="fw-semibold text-dark"><%= (currentUser != null) ? currentUser.getDisplayName() : "Guest" %></div>
                    <span class="badge <%= (currentUser != null && currentUser.isAdmin()) ? "bg-danger text-white" : "bg-info text-dark" %>">
                        <%= (currentUser != null) ? currentUser.getRole() : "ANONYMOUS" %>
                    </span>
                </div>
                <div class="dropdown">
                    <button class="btn btn-light rounded-circle border shadow-sm p-2" type="button" data-bs-toggle="dropdown">
                        <i class="bi bi-person-circle fs-5 text-secondary"></i>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end shadow">
                        <li><h6 class="dropdown-header">Signed in as <%= (currentUser != null) ? currentUser.getUsername() : "Guest" %></h6></li>
                        <li><a class="dropdown-item" href="<%= request.getContextPath() %>/dashboard"><i class="bi bi-speedometer2 me-2"></i>Dashboard</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger" href="<%= request.getContextPath() %>/logout"><i class="bi bi-box-arrow-right me-2"></i>Logout</a></li>
                    </ul>
                </div>
            </div>
        </header>

        <!-- Message Alerts -->
        <% if (request.getParameter("msg") != null) { %>
            <div class="alert alert-success alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i><%= request.getParameter("msg") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger alert-dismissible fade show shadow-sm" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i><%= request.getParameter("error") %>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        <% } %>
