<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Smart College Student Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 50%, #0f172a 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', system-ui, sans-serif;
        }
        .login-card {
            max-width: 440px;
            width: 100%;
            background: #ffffff;
            border-radius: 1rem;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.25);
            padding: 2.5rem;
        }
    </style>
</head>
<body>
<div class="login-card">
    <div class="text-center mb-4">
        <div class="d-inline-flex p-3 bg-primary-subtle text-primary rounded-circle mb-3">
            <i class="bi bi-mortarboard-fill fs-2"></i>
        </div>
        <h4 class="fw-bold text-dark mb-1">Smart College Portal</h4>
        <p class="text-muted small">DBMS Mini-Project Authentication</p>
    </div>

    <% if (request.getAttribute("errorMessage") != null) { %>
        <div class="alert alert-danger py-2 small" role="alert">
            <i class="bi bi-exclamation-circle me-1"></i><%= request.getAttribute("errorMessage") %>
        </div>
    <% } %>

    <% if (request.getParameter("msg") != null) { %>
        <div class="alert alert-success py-2 small" role="alert">
            <i class="bi bi-check-circle me-1"></i><%= request.getParameter("msg") %>
        </div>
    <% } %>

    <form action="<%= request.getContextPath() %>/login" method="POST">
        <div class="mb-3">
            <label class="form-label small fw-semibold">Username</label>
            <div class="input-group">
                <span class="input-group-text bg-light"><i class="bi bi-person"></i></span>
                <input type="text" name="username" id="username" class="form-control" placeholder="admin or faculty_sharma" required autofocus>
            </div>
        </div>

        <div class="mb-4">
            <label class="form-label small fw-semibold">Password</label>
            <div class="input-group">
                <span class="input-group-text bg-light"><i class="bi bi-lock"></i></span>
                <input type="password" name="password" id="password" class="form-control" placeholder="••••••••" required>
            </div>
        </div>

        <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold">
            <i class="bi bi-box-arrow-in-right me-2"></i>Sign In
        </button>
    </form>

    <div class="mt-4 pt-3 border-top">
        <p class="text-muted small fw-semibold mb-2 text-center">Quick-Fill Demo Credentials:</p>
        <div class="d-flex gap-2">
            <button type="button" class="btn btn-outline-secondary btn-sm flex-fill" onclick="fillCreds('admin', 'admin123')">
                <i class="bi bi-shield-lock me-1"></i>Admin
            </button>
            <button type="button" class="btn btn-outline-secondary btn-sm flex-fill" onclick="fillCreds('faculty_sharma', 'faculty123')">
                <i class="bi bi-person-workspace me-1"></i>Faculty
            </button>
        </div>
    </div>
</div>

<script>
function fillCreds(u, p) {
    document.getElementById('username').value = u;
    document.getElementById('password').value = p;
}
</script>
</body>
</html>
