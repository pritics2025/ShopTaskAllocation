<%@page import="model.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ include file="/includes/navbar.jsp" %>
<%@ include file="/includes/sidebar-admin.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - STASYNC</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="includes/style.css" rel="stylesheet">
       
</head>
<body>
    <div class="main-content" id="mainContent">
        <div class="container-fluid mt-5 pt-4">
            <div class="row">
                <div class="col-12">
                    <h2 class="mb-4"><i class="bi bi-person-gear me-2"></i>Manage Users</h2>
                </div>
            </div>
            
            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success"><%= request.getAttribute("success") %></div>
            <% } %>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
            <% } %>
            
            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                            <h5 class="mb-0"><i class="bi bi-people me-2"></i>All Users</h5>
                            <button class="btn btn-light" data-bs-toggle="modal" data-bs-target="#addUserModal">
                                <i class="bi bi-person-plus me-1"></i> Add New User
                            </button>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Username</th>
                                            <th>Name</th>
                                            <th>Role</th>
                                            <th>Contact</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% List<User> users = (List<User>) request.getAttribute("users");
                                           if (users != null && !users.isEmpty()) {
                                               for (User user : users) { %>
                                            <tr>
                                                <td><%= user.getUserId() %></td>
                                                <td><%= user.getUsername() != null ? user.getUsername() : "N/A" %></td>
                                                <td><%= user.getName() != null ? user.getName() : "N/A" %></td>
                                                <td>
                                                    <span class="badge bg-<%= "admin".equals(user.getRole()) ? "danger" : "success" %>">
                                                        <%= user.getRole() != null ? user.getRole() : "N/A" %>
                                                    </span>
                                                </td>
                                                <td><%= user.getContact() != null ? user.getContact() : "N/A" %></td>
                                                <td>
                                                    <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#editUserModal<%= user.getUserId() %>">
                                                        <i class="bi bi-pencil"></i> Edit
                                                    </button>
                                                    <button class="btn btn-sm btn-outline-danger ms-1" onclick="confirmDelete(<%= user.getUserId() %>)">
                                                        <i class="bi bi-trash"></i> Delete
                                                    </button>
                                                </td>
                                            </tr>
                                            
                                            <!-- Edit User Modal -->
                                            <div class="modal fade" id="editUserModal<%= user.getUserId() %>" tabindex="-1" aria-hidden="true">
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title">Edit User</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <form action="manageUsers" method="post">
                                                                <input type="hidden" name="action" value="updateUser">
                                                                <input type="hidden" name="userId" value="<%= user.getUserId() %>">
                                                                <div class="mb-3">
                                                                    <label for="username<%= user.getUserId() %>" class="form-label">Username</label>
                                                                    <input type="text" class="form-control" id="username<%= user.getUserId() %>" name="username" value="<%= user.getUsername() != null ? user.getUsername() : "" %>" required>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label for="name<%= user.getUserId() %>" class="form-label">Full Name</label>
                                                                    <input type="text" class="form-control" id="name<%= user.getUserId() %>" name="name" value="<%= user.getName() != null ? user.getName() : "" %>" required>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label for="role<%= user.getUserId() %>" class="form-label">Role</label>
                                                                    <select class="form-select" id="role<%= user.getUserId() %>" name="role" required>
                                                                        <option value="staff" <%= "staff".equals(user.getRole()) ? "selected" : "" %>>Staff Member</option>
                                                                        <option value="admin" <%= "admin".equals(user.getRole()) ? "selected" : "" %>>Admin (Shop Owner)</option>
                                                                    </select>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label for="contact<%= user.getUserId() %>" class="form-label">Contact</label>
                                                                    <input type="text" class="form-control" id="contact<%= user.getUserId() %>" name="contact" value="<%= user.getContact() != null ? user.getContact() : "" %>" required>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label for="password<%= user.getUserId() %>" class="form-label">New Password (leave blank to keep current)</label>
                                                                    <input type="password" class="form-control" id="password<%= user.getUserId() %>" name="password">
                                                                </div>
                                                                <div class="text-end">
                                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                                    <button type="submit" class="btn btn-primary">Update User</button>
                                                                </div>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        <%   }
                                           } else { %>
                                            <tr>
                                                <td colspan="6" class="text-center text-muted py-4">
                                                    <i class="bi bi-people fs-1 mb-2"></i>
                                                    <p>No users available.</p>
                                                </td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Add User Modal -->
    <div class="modal fade" id="addUserModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="manageUsers" method="post">
                        <input type="hidden" name="action" value="createUser">
                        <div class="mb-3">
                            <label for="username" class="form-label">Username</label>
                            <input type="text" class="form-control" id="username" name="username" required>
                        </div>
                        <div class="mb-3">
                            <label for="name" class="form-label">Full Name</label>
                            <input type="text" class="form-control" id="name" name="name" required>
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label">Password</label>
                            <input type="password" class="form-control" id="password" name="password" required>
                        </div>
                        <div class="mb-3">
                            <label for="role" class="form-label">Role</label>
                            <select class="form-select" id="role" name="role" required>
                                <option value="staff">Staff Member</option>
                                <option value="admin">Admin (Shop Owner)</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="contact" class="form-label">Contact</label>
                            <input type="text" class="form-control" id="contact" name="contact" required>
                        </div>
                        <div class="text-end">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary">Add User</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Confirm Delete</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete this user? This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <form id="deleteForm" action="manageUsers" method="post" style="display: inline;">
                        <input type="hidden" name="action" value="deleteUser">
                        <input type="hidden" id="deleteUserId" name="userId">
                        <button type="submit" class="btn btn-danger">Delete</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmDelete(userId) {
            document.getElementById('deleteUserId').value = userId;
            var deleteModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
            deleteModal.show();
        }
        
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