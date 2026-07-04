<% request.setAttribute("activePage", "dashboard"); %>
<%@page import="model.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.ArrayList, model.Task, model.Allocation, model.Notification" %>
<%@ include file="/includes/navbar.jsp" %>
<%@ include file="/includes/sidebar-admin.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - STASYNC</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="includes/style.css" rel="stylesheet">
</head>
<body>
    <div class="main-content" id="mainContent">
        <div class="container-fluid">
            <div class="row mb-4">
                <div class="col-12">
                    <h1 class="mb-4"><i class="fas fa-tachometer-alt me-2"></i>Admin Dashboard</h1>
                </div>
            </div>
            
            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle me-2"></i>
                    <%= request.getAttribute("success") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle me-2"></i>
                    <%= request.getAttribute("error") %>
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            <% } %>
            
            <!-- Stats Cards Row -->
            <div class="row mb-4">
                <div class="col-md-3 mb-4">
                    <div class="stats-card">
                        <div class="stats-icon">
                            <i class="fas fa-tasks"></i>
                        </div>
                        <div class="stats-value">
                            <% List<Task> tasks = (List<Task>) request.getAttribute("tasks");
                               int taskCount = (tasks != null) ? tasks.size() : 0; %>
                            <%= taskCount %>
                        </div>
                        <div class="stats-label">Total Tasks</div>
                    </div>
                </div>
                <div class="col-md-3 mb-4">
                    <div class="stats-card">
                        <div class="stats-icon">
                            <i class="fas fa-users"></i>
                        </div>
                        <div class="stats-value">
                            <% List<User> users = (List<User>) request.getAttribute("users");
                               int userCount = (users != null) ? users.size() : 0; %>
                            <%= userCount %>
                        </div>
                        <div class="stats-label">Total Users</div>
                    </div>
                </div>
                <div class="col-md-3 mb-4">
                    <div class="stats-card">
                        <div class="stats-icon">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div class="stats-value">
                            <% List<Allocation> allocations = (List<Allocation>) request.getAttribute("allocations");
                               int pendingCount = 0;
                               if (allocations != null) {
                                   for (Allocation alloc : allocations) {
                                       if ("Pending".equals(alloc.getStatus())) pendingCount++;
                                   }
                               } %>
                            <%= pendingCount %>
                        </div>
                        <div class="stats-label">Pending Allocations</div>
                    </div>
                </div>
                <div class="col-md-3 mb-4">
                    <div class="stats-card">
                        <div class="stats-icon text-info">
                            <i class="fas fa-bell"></i>
                        </div>
                        <div class="stats-value text-info">
                            <% List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
                               int notifCount = (notifications != null) ? notifications.size() : 0; %>
                            <%= notifCount %>
                        </div>
                        <div class="stats-label">Notifications</div>
                    </div>
                </div>
            </div>
            
            <div class="row">
                <!-- Notifications Card -->
                <div class="col-lg-4 mb-4">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0"><i class="fas fa-bell me-2"></i>Notifications</h5>
                        </div>
                        <div class="card-body">
                            <% if (notifications != null && !notifications.isEmpty()) {
                                   // Show only first 3 notifications
                                   int maxNotifs = Math.min(notifications.size(), 3);
                                   for (int i = 0; i < maxNotifs; i++) { 
                                       Notification notif = notifications.get(i); %>
                                <div class="notification-item">
                                    <i class="fas fa-info-circle me-2"></i>
                                    <%= notif.getMessage() != null ? notif.getMessage() : "No message" %>
                                    <small class="d-block text-muted">(<%= notif.getCreatedAt() != null ? notif.getCreatedAt() : "N/A" %>)</small>
                                </div>
                            <%   }
                               if (notifications.size() > 3) { %>
                                   <div class="text-center mt-3">
                                       <a href="notifications" class="btn btn-sm">View All Notifications</a>
                                   </div>
                               <% }
                               } else { %>
                                <div class="text-center py-4">
                                    <i class="fas fa-bell-slash text-muted fs-1 mb-2"></i>
                                    <p class="text-muted">No notifications.</p>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
                
                <!-- Recent Tasks Table -->
                <div class="col-lg-8 mb-4">
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0"><i class="fas fa-clipboard-list me-2"></i>Recent Tasks</h5>
                            <% if (tasks != null && tasks.size() > 0) { %>
                                <a href="manageTasks" class="btn btn-light btn-sm">View All Tasks</a>
                            <% } %>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Task Name</th>
                                            <th>Priority</th>
                                            <th>Deadline</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% if (tasks != null && !tasks.isEmpty()) {
                                               // Show only first 5 tasks
                                               int maxTasks = Math.min(tasks.size(), 5);
                                               for (int i = 0; i < maxTasks; i++) { 
                                                   Task task = tasks.get(i); %>
                                            <tr>
                                                <td><%= task.getTaskId() %></td>
                                                <td><%= task.getTaskName() != null ? task.getTaskName() : "Unnamed Task" %></td>
                                                <td>
                                                    <span class="badge bg-<%= "high".equals(task.getPriority()) ? "danger" : "medium".equals(task.getPriority()) ? "warning" : "success" %>">
                                                        <%= task.getPriority() != null ? task.getPriority() : "N/A" %>
                                                    </span>
                                                </td>
                                                <td><%= task.getDeadline() != null ? task.getDeadline() : "No Deadline" %></td>
                                                <td>
                                                    <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#editTaskModal<%= task.getTaskId() %>">
                                                        <i class="fas fa-pencil-alt"></i>
                                                    </button>
                                                    <button class="btn btn-sm btn-outline-danger ms-1" onclick="confirmDeleteTask(<%= task.getTaskId() %>)">
                                                        <i class="fas fa-trash-alt"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        <%   }
                                           } else { %>
                                            <tr>
                                                <td colspan="5" class="text-center text-muted py-4">
                                                    <i class="fas fa-inbox fs-1 mb-2"></i>
                                                    <p>No tasks available.</p>
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
            
            <!-- Allocations Overview -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0"><i class="fas fa-tasks me-2"></i>Allocations Overview</h5>
                            <% if (allocations != null && allocations.size() > 0) { %>
                                <a href="manageAllocations" class="btn btn-light btn-sm">View All Allocations</a>
                            <% } %>
                        </div>
                        <div class="card-body">
                            <% if (allocations != null && !allocations.isEmpty()) { %>
                                <div class="table-responsive">
                                    <table class="table table-hover">
                                        <thead>
                                            <tr>
                                                <th>Allocation ID</th>
                                                <th>Task</th>
                                                <th>Staff</th>
                                                <th>Status</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <% // Show only first 5 allocations
                                               int maxAllocs = Math.min(allocations.size(), 5);
                                               for (int i = 0; i < maxAllocs; i++) { 
                                                   Allocation alloc = allocations.get(i); %>
                                            <tr>
                                                <td><%= alloc.getAllocationId() %></td>
                                                <td><%= alloc.getTaskName() != null ? alloc.getTaskName() : "N/A" %></td>
                                                <td><%= alloc.getUserName() != null ? alloc.getUserName() : "N/A" %></td>
                                                <td>
                                                    <span class="badge bg-<%= "Completed".equals(alloc.getStatus()) ? "success" : "In-Progress".equals(alloc.getStatus()) ? "info" : "warning" %>">
                                                        <%= alloc.getStatus() %>
                                                    </span>
                                                </td>
                                                <td>
                                                    <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#editAllocationModal<%= alloc.getAllocationId() %>">
                                                        <i class="fas fa-pencil-alt"></i>
                                                    </button>
                                                    <button class="btn btn-sm btn-outline-danger ms-1" onclick="confirmDeleteAllocation(<%= alloc.getAllocationId() %>)">
                                                        <i class="fas fa-trash-alt"></i>
                                                    </button>
                                                </td>
                                            </tr>
                                        <% } %>
                                        </tbody>
                                    </table>
                                </div>
                            <% } else { %>
                                <div class="text-center text-muted py-4">
                                    <i class="fas fa-tasks fs-1 mb-2"></i>
                                    <p>No allocations yet.</p>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Reports Section -->
            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header">
                            <h5 class="mb-0"><i class="fas fa-chart-bar me-2"></i>Reports</h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <div class="card report-card h-100" onclick="window.location.href='reports?type=taskSummary'">
                                        <div class="card-body">
                                            <div class="text-center">
                                                <div class="report-icon text-primary">
                                                    <i class="fas fa-tasks"></i>
                                                </div>
                                                <h5 class="card-title">Task Summary Report</h5>
                                                <p class="card-text">View comprehensive task statistics including status, priority, and completion rates.</p>
                                                <button class="btn btn-primary mt-3">View Report</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="col-md-6 mb-3">
                                    <div class="card report-card h-100" onclick="window.location.href='reports?type=userPerformance'">
                                        <div class="card-body">
                                            <div class="text-center">
                                                <div class="report-icon text-success">
                                                    <i class="fas fa-users"></i>
                                                </div>
                                                <h5 class="card-title">User Performance Report</h5>
                                                <p class="card-text">Analyze staff performance based on task completion rates and efficiency metrics.</p>
                                                <button class="btn btn-success mt-3">View Report</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Delete Task Confirmation Modal -->
    <div class="modal fade" id="deleteTaskConfirmModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Confirm Delete</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete this task? This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <form id="deleteTaskForm" action="manageTasks" method="post" class="inline-form">
                        <input type="hidden" name="action" value="deleteTask">
                        <input type="hidden" id="deleteTaskId" name="taskId">
                        <button type="submit" class="btn btn-danger">Delete</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Delete Allocation Confirmation Modal -->
    <div class="modal fade" id="deleteAllocationConfirmModal" tabindex="-1" aria-hidden="true">
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
                    <form id="deleteAllocationForm" action="manageAllocations" method="post" class="inline-form">
                        <input type="hidden" name="action" value="deleteAllocation">
                        <input type="hidden" id="deleteAllocationId" name="allocationId">
                        <button type="submit" class="btn btn-danger">Delete</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Toast Container -->
    <div class="toast-container position-fixed bottom-0 end-0 p-3">
        <div id="successToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="toast-header">
                <i class="fas fa-check-circle me-2"></i>
                <strong class="me-auto">Success</strong>
                <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
            <div class="toast-body">
                Operation completed successfully!
            </div>
        </div>
        
        <div id="errorToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="toast-header">
                <i class="fas fa-exclamation-circle me-2"></i>
                <strong class="me-auto">Error</strong>
                <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
            <div class="toast-body">
                Operation failed. Please try again.
            </div>
        </div>
    </div>
    
    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Sidebar toggle
            const sidebarToggle = document.getElementById('sidebarToggle');
            const sidebar = document.getElementById('sidebar');
            const mainContent = document.getElementById('mainContent');
            
            if (sidebarToggle) {
                sidebarToggle.addEventListener('click', function() {
                    sidebar.classList.toggle('collapsed');
                    mainContent.classList.toggle('collapsed');
                });
            }
            
            // Delete confirmation functions
            window.confirmDeleteTask = function(taskId) {
                document.getElementById('deleteTaskId').value = taskId;
                var deleteModal = new bootstrap.Modal(document.getElementById('deleteTaskConfirmModal'));
                deleteModal.show();
            };
            
            window.confirmDeleteAllocation = function(allocationId) {
                document.getElementById('deleteAllocationId').value = allocationId;
                var deleteModal = new bootstrap.Modal(document.getElementById('deleteAllocationConfirmModal'));
                deleteModal.show();
            };
            
            // Show success/error toasts if URL parameters exist
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.get('success')) {
                const successToast = new bootstrap.Toast(document.getElementById('successToast'));
                successToast.show();
            }
            
            if (urlParams.get('error')) {
                const errorToast = new bootstrap.Toast(document.getElementById('errorToast'));
                errorToast.show();
            }
        });
    </script>
</body>
</html>