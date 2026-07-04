<%@page import="model.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/includes/navbar.jsp" %>
<%@ include file="/includes/sidebar-staff.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - STASYNC</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="css/styles.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }
        
        .navbar {
            background: linear-gradient(90deg, #007bff, #0056b3);
            box-shadow: 0 2px 10px rgba(0,123,255,0.3);
            padding: 0.5rem 1rem;
        }
        
        .sidebar {
            position: fixed;
            top: 56px;
            left: 0;
            height: calc(100vh - 56px);
            width: 250px;
background: linear-gradient(90deg, #007bff, #0056b3);            color: white;
            transition: transform 0.3s ease;
            z-index: 1000;
            overflow-y: auto;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }
        
        .sidebar.collapsed {
            transform: translateX(-100%);
        }
        
        .sidebar .nav-link {
            color: rgba(255,255,255,0.8);
            padding: 0.75rem 1rem;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            transition: background 0.3s ease, color 0.3s ease;
        }
        
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            background: #007bff;
            color: white;
        }
        
        .main-content {
            margin-left: 250px;
            padding: 2rem;
            transition: margin-left 0.3s ease;
            animation: fadeIn 0.8s ease-out;
        }
        
        .main-content.collapsed {
            margin-left: 0;
        }
        
        .card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            overflow: hidden;
        }
        
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 30px rgba(0,0,0,0.15);
        }
        
        .profile-header {
            background: linear-gradient(90deg, #007bff, #0056b3);
            color: white;
            padding: 2rem;
            text-align: center;
        }
        
        .profile-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            border: 4px solid white;
            margin-bottom: 1rem;
        }
        
        .btn {
            border-radius: 8px;
            transition: all 0.3s ease;
            font-weight: 500;
        }
        
        .btn:hover {
            transform: scale(1.05);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }
        
        .alert {
            border-radius: 10px;
            border: none;
            animation: slideInDown 0.5s ease-out;
        }
        
        .form-control, .form-select {
            border-radius: 8px;
            border: 1px solid #ddd;
            padding: 0.75rem;
            transition: all 0.3s ease;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0,123,255,0.25);
            transform: translateY(-2px);
        }
        
        .info-item {
            padding: 0.75rem;
            border-bottom: 1px solid #eee;
        }
        
        .info-item:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: 500;
            color: #6c757d;
        }
        
        .info-value {
            font-weight: 500;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @keyframes slideInDown {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
            }
            .main-content {
                margin-left: 0;
            }
            .sidebar.show {
                transform: translateX(0);
            }
        }
    </style>
</head>
<body>
    <div class="main-content" id="mainContent">
        <div class="container-fluid mt-5 pt-4">
            <div class="row">
                <div class="col-12">
                    <h2 class="mb-4 text-primary"><i class="bi bi-person-circle me-2"></i>My Profile</h2>
                </div>
            </div>
            
            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success d-flex align-items-center" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i>
                    <div><%= request.getAttribute("success") %></div>
                </div>
            <% } %>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger d-flex align-items-center" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>
                    <div><%= request.getAttribute("error") %></div>
                </div>
            <% } %>
            
            <div class="row">
                <!-- Profile Information Card -->
                <div class="col-lg-4 mb-4">
                    <div class="card">
                        <div class="profile-header">
                            <img src="https://picsum.photos/seed/staff<%= session.getAttribute("userId") %>/120/120.jpg" alt="Profile" class="profile-avatar">
                            <h4><%= session.getAttribute("name") != null ? session.getAttribute("name") : "Staff Member" %></h4>
                            <p class="mb-0"><i class="bi bi-person-badge me-1"></i> <%= session.getAttribute("role") %></p>
                        </div>
                        <div class="card-body">
                            <% User user = (User) request.getAttribute("user"); 
                               if (user != null) { %>
                                <div class="info-item">
                                    <div class="info-label">Username</div>
                                    <div class="info-value"><%= user.getUsername() != null ? user.getUsername() : "N/A" %></div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Full Name</div>
                                    <div class="info-value"><%= user.getName() != null ? user.getName() : "N/A" %></div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Contact</div>
                                    <div class="info-value"><%= user.getContact() != null ? user.getContact() : "N/A" %></div>
                                </div>
                                <div class="info-item">
                                    <div class="info-label">Role</div>
                                    <div class="info-value"><%= user.getRole() != null ? user.getRole() : "N/A" %></div>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
                
                <!-- Edit Profile Form -->
                <div class="col-lg-8 mb-4">
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0"><i class="bi bi-pencil-square me-2"></i>Edit Profile</h5>
                        </div>
                        <div class="card-body">
                            <form method="post" action="staffProfile">
                                <input type="hidden" name="action" value="updateProfile">
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="username" class="form-label fw-bold">Username</label>
                                        <input type="text" class="form-control" id="username" name="username" 
                                               value="<%= user != null && user.getUsername() != null ? user.getUsername() : "" %>" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="name" class="form-label fw-bold">Full Name</label>
                                        <input type="text" class="form-control" id="name" name="name" 
                                               value="<%= user != null && user.getName() != null ? user.getName() : "" %>" required>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label for="contact" class="form-label fw-bold">Contact</label>
                                        <input type="text" class="form-control" id="contact" name="contact" 
                                               value="<%= user != null && user.getContact() != null ? user.getContact() : "" %>" required>
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <label for="password" class="form-label fw-bold">New Password (leave blank to keep current)</label>
                                        <input type="password" class="form-control" id="password" name="password">
                                    </div>
                                </div>
                                <div class="text-end">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="bi bi-save me-1"></i> Update Profile
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const sidebarToggle = document.getElementById('sidebarToggle');
            const sidebar = document.getElementById('sidebar');
            const mainContent = document.getElementById('mainContent');
            
            if (sidebarToggle) {
                sidebarToggle.addEventListener('click', function() {
                    sidebar.classList.toggle('show');
                    mainContent.classList.toggle('collapsed');
                });
            }
            
            window.addEventListener('resize', function() {
                if (window.innerWidth > 992) {
                    sidebar.classList.remove('show');
                    mainContent.classList.remove('collapsed');
                }
            });
        });
    </script>
</body>
</html>