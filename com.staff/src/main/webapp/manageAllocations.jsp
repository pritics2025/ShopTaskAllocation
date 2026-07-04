<%@page import="model.Allocation"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Task, model.User" %>
<%@ include file="/includes/navbar.jsp" %>
<%@ include file="/includes/sidebar-admin.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Allocations - STASYNC</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="includes/style.css" rel="stylesheet">
</head>
<body>
    <div class="main-content" id="mainContent">
        <div class="container-fluid mt-5 pt-4">
            <div class="row">
                <div class="col-12">
                    <h2 class="mb-4"><i class="bi bi-people-fill me-2"></i>Manage Allocations</h2>
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
                            <h5 class="mb-0"><i class="bi bi-clipboard-data me-2"></i>All Allocations</h5>
                            <button class="btn btn-light" data-bs-toggle="modal" data-bs-target="#addAllocationModal">
                                <i class="bi bi-plus-circle me-1"></i> Add New Allocation
                            </button>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Task</th>
                                            <th>Staff</th>
                                            <th>Status</th>
                                            <th>Comments</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% List<Allocation> allocations = (List<Allocation>) request.getAttribute("allocations");
                                           if (allocations != null && !allocations.isEmpty()) {
                                               for (Allocation alloc : allocations) { %>
                                            <tr>
                                                <td><%= alloc.getAllocationId() %></td>
                                                <td><%= alloc.getTaskName() != null ? alloc.getTaskName() : "N/A" %></td>
                                                <td><%= alloc.getUserName() != null ? alloc.getUserName() : "N/A" %></td>
                                                <td>
                                                    <span class="badge bg-<%= "Completed".equals(alloc.getStatus()) ? "success" : "In-Progress".equals(alloc.getStatus()) ? "info" : "warning" %>">
                                                        <%= alloc.getStatus() != null ? alloc.getStatus() : "Pending" %>
                                                    </span>
                                                </td>
                                                <td><%= alloc.getComments() != null ? alloc.getComments() : "" %></td>
                                                <td>
                                                    <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#editAllocationModal<%= alloc.getAllocationId() %>">
                                                        <i class="bi bi-pencil"></i> Edit
                                                    </button>
                                                    <button class="btn btn-sm btn-outline-danger ms-1" onclick="confirmDelete(<%= alloc.getAllocationId() %>)">
                                                        <i class="bi bi-trash"></i> Delete
                                                    </button>
                                                </td>
                                            </tr>
                                            
                                            <!-- Edit Allocation Modal -->
                                            <div class="modal fade" id="editAllocationModal<%= alloc.getAllocationId() %>" tabindex="-1" aria-hidden="true">
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title">Edit Allocation</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <form action="manageAllocations" method="post">
                                                                <input type="hidden" name="action" value="updateAllocation">
                                                                <input type="hidden" name="allocationId" value="<%= alloc.getAllocationId() %>">
                                                                <div class="mb-3">
                                                                    <label for="taskId<%= alloc.getAllocationId() %>" class="form-label">Task</label>
                                                                    <select class="form-select" id="taskId<%= alloc.getAllocationId() %>" name="taskId" required>
                                                                        <% List<Task> tasks = (List<Task>) request.getAttribute("tasks");
                                                                           if (tasks != null && !tasks.isEmpty()) {
                                                                               for (Task task : tasks) { %>
                                                                        <option value="<%= task.getTaskId() %>" <%= task.getTaskId() == alloc.getTaskId() ? "selected" : "" %>>
                                                                            <%= task.getTaskName() != null ? task.getTaskName() : "N/A" %>
                                                                        </option>
                                                                        <%   }
                                                                           } %>
                                                                    </select>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label for="staffId<%= alloc.getAllocationId() %>" class="form-label">Staff</label>
                                                                    <select class="form-select" id="staffId<%= alloc.getAllocationId() %>" name="staffId" required>
                                                                        <% List<User> users = (List<User>) request.getAttribute("users");
                                                                           if (users != null && !users.isEmpty()) {
                                                                               for (User user : users) {
                                                                                   if ("staff".equals(user.getRole())) { %>
                                                                        <option value="<%= user.getUserId() %>" <%= user.getUserId() == alloc.getUserId() ? "selected" : "" %>>
                                                                            <%= user.getName() != null ? user.getName() : "N/A" %>
                                                                        </option>
                                                                        <%       }
                                                                               }
                                                                           } %>
                                                                    </select>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label for="status<%= alloc.getAllocationId() %>" class="form-label">Status</label>
                                                                    <select class="form-select" id="status<%= alloc.getAllocationId() %>" name="status" required>
                                                                        <option value="Pending" <%= "Pending".equals(alloc.getStatus()) ? "selected" : "" %>>Pending</option>
                                                                        <option value="In-Progress" <%= "In-Progress".equals(alloc.getStatus()) ? "selected" : "" %>>In-Progress</option>
                                                                        <option value="Completed" <%= "Completed".equals(alloc.getStatus()) ? "selected" : "" %>>Completed</option>
                                                                    </select>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label for="comments<%= alloc.getAllocationId() %>" class="form-label">Comments</label>
                                                                    <textarea class="form-control" id="comments<%= alloc.getAllocationId() %>" name="comments" rows="3"><%= alloc.getComments() != null ? alloc.getComments() : "" %></textarea>
                                                                </div>
                                                                <div class="text-end">
                                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                                    <button type="submit" class="btn btn-primary">Update Allocation</button>
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
                                                    <i class="bi bi-clipboard-data fs-1 mb-2"></i>
                                                    <p>No allocations available.</p>
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
    
    <!-- Add Allocation Modal -->
    <div class="modal fade" id="addAllocationModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New Allocation</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="manageAllocations" method="post">
                        <input type="hidden" name="action" value="createAllocation">
                        <div class="mb-3">
                            <label for="taskId" class="form-label">Task</label>
                            <select class="form-select" id="taskId" name="taskId" required>
                                <% List<Task> tasks = (List<Task>) request.getAttribute("tasks");
                                   if (tasks != null && !tasks.isEmpty()) {
                                       for (Task task : tasks) { %>
                                <option value="<%= task.getTaskId() %>">
                                    <%= task.getTaskName() != null ? task.getTaskName() : "N/A" %>
                                </option>
                                <%   }
                                   } %>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="staffId" class="form-label">Staff</label>
                            <select class="form-select" id="staffId" name="staffId" required>
                                <% List<User> users = (List<User>) request.getAttribute("users");
                                   if (users != null && !users.isEmpty()) {
                                       for (User user : users) {
                                           if ("staff".equals(user.getRole())) { %>
                                <option value="<%= user.getUserId() %>">
                                    <%= user.getName() != null ? user.getName() : "N/A" %>
                                </option>
                                <%       }
                                       }
                                   } %>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="status" class="form-label">Status</label>
                            <select class="form-select" id="status" name="status" required>
                                <option value="Pending">Pending</option>
                                <option value="In-Progress">In-Progress</option>
                                <option value="Completed">Completed</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="comments" class="form-label">Comments</label>
                            <textarea class="form-control" id="comments" name="comments" rows="3"></textarea>
                        </div>
                        <div class="text-end">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary">Add Allocation</button>
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
                    <p>Are you sure you want to delete this allocation? This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <form id="deleteForm" action="manageAllocations" method="post" style="display: inline;">
                        <input type="hidden" name="action" value="deleteAllocation">
                        <input type="hidden" id="deleteAllocationId" name="allocationId">
                        <button type="submit" class="btn btn-danger">Delete</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmDelete(allocationId) {
            document.getElementById('deleteAllocationId').value = allocationId;
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