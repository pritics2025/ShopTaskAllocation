<%@page import="model.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/includes/navbar.jsp" %>
<%@ include file="/includes/sidebar-admin.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Profile - STASYNC</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="includes/style.css" rel="stylesheet">
</head>
<body>
    <div class="main-content" id="mainContent">
        <div class="container-fluid mt-5 pt-4">
            <div class="row">
                <div class="col-12">
                    <h2 class="mb-4"><i class="bi bi-person-circle me-2"></i>Admin Profile</h2>
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
                            <img src="https://picsum.photos/seed/admin<%= session.getAttribute("userId") %>/120/120.jpg" alt="Profile" class="profile-avatar">
                            <h4><%= session.getAttribute("name") != null ? session.getAttribute("name") : "Admin" %></h4>
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
                            <form method="post" action="adminProfile">
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