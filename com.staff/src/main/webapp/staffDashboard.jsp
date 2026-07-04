<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.ArrayList, model.Allocation, model.Notification, java.text.SimpleDateFormat" %>
<%@ include file="/includes/navbar.jsp" %>
<%@ include file="/includes/sidebar-staff.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Dashboard - STASYNC</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="includes/style.css" rel="stylesheet"> 
</head>
<body>
    <div class="main-content" id="mainContent">
        <div class="container-fluid mt-5 pt-4">
            <div class="row">
                <div class="col-12">
                    <h2 class="mb-4 text-success"><i class="bi bi-person-check me-2"></i>Staff Dashboard</h2>
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
            
            <!-- Stats Cards Row -->
            <div class="row mb-4">
                <div class="col-md-4 mb-3">
                    <div class="card text-center bg-success text-white">
                        <div class="card-body">
                            <i class="bi bi-check2-square fs-1 mb-2"></i>
                            <h5 class="card-title">My Allocations</h5>
                            <% List<Allocation> allocations = (List<Allocation>) request.getAttribute("allocations");
                               int allocCount = (allocations != null) ? allocations.size() : 0; %>
                            <h3 class="text-warning"><%= allocCount %></h3>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-3">
                    <div class="card text-center bg-info text-white">
                        <div class="card-body">
                            <i class="bi bi-bell fs-1 mb-2"></i>
                            <h5 class="card-title">Unread Notifications</h5>
                            <% List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
                               int notifCount = (notifications != null) ? notifications.size() : 0; %>
                            <h3 class="text-white"><%= notifCount %></h3>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-3">
                    <div class="card text-center bg-warning text-white">
                        <div class="card-body">
                            <i class="bi bi-clock fs-1 mb-2"></i>
                            <h5 class="card-title">Pending Tasks</h5>
                            <% int pendingCount = 0;
                               if (allocations != null) {
                                   for (Allocation alloc : allocations) {
                                       if ("Pending".equals(alloc.getStatus())) pendingCount++;
                                   }
                               } %>
                            <h3 class="text-dark"><%= pendingCount %></h3>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="row">
                <!-- Notifications Card -->
                <div class="col-lg-4 mb-4">
                    <div class="card h-100">
                        <div class="card-header bg-info text-white d-flex justify-content-between align-items-center">
                            <h5 class="mb-0"><i class="bi bi-bell me-2"></i>Notifications (<%= notifCount %> unread)</h5>
                            <% if (notifications != null && notifications.size() > 0) { %>
                                <a href="staffNotifications" class="btn btn-sm btn-light">View All</a>
                            <% } %>
                        </div>
                        <div class="card-body">
                            <% if (notifications != null && !notifications.isEmpty()) {
                                   // Show only first 3 notifications
                                   int maxNotifs = Math.min(notifications.size(), 3);
                                   for (int i = 0; i < maxNotifs; i++) { 
                                       Notification notif = notifications.get(i); %>
                                <div class="notification-item">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <p class="mb-1"><%= notif.getMessage() != null ? notif.getMessage() : "No message" %></p>
                                            <small class="text-muted">
                                                <i class="bi bi-clock me-1"></i>
                                                <%= notif.getCreatedAt() != null ? notif.getCreatedAt() : "N/A" %>
                                            </small>
                                        </div>
                                        <form method="post" action="staff">
                                            <input type="hidden" name="action" value="markRead">
                                            <input type="hidden" name="notificationId" value="<%= notif.getNotificationId() %>">
                                            <button type="submit" class="btn btn-sm btn-outline-primary" title="Mark as read">
                                                <i class="bi bi-check"></i>
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            <%   }
                               if (notifications.size() > 3) { %>
                                   <div class="text-center mt-2">
                                       <a href="staffNotifications" class="btn btn-sm btn-outline-info">View All Notifications</a>
                                   </div>
                               <% }
                               } else { %>
                                <div class="text-center text-muted py-4">
                                    <i class="bi bi-bell-slash fs-1 mb-2"></i>
                                    <p>No unread notifications.</p>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
                
                <!-- Allocations Table -->
                <div class="col-lg-8 mb-4">
                    <div class="card h-100">
                        <div class="card-header bg-success text-white d-flex justify-content-between align-items-center">
                            <h5 class="mb-0"><i class="bi bi-clipboard-check me-2"></i>Your Allocations</h5>
                            <% if (allocations != null && allocations.size() > 0) { %>
                                <a href="staffAllocations" class="btn btn-sm btn-light">View All</a>
                            <% } %>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table mb-0">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Task Name</th>
                                            <th>Status</th>
                                            <th>Assigned Date</th>
                                            <th>Deadline</th>
                                            <th>Priority</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% if (allocations != null && !allocations.isEmpty()) {
                                               // Show only first 5 allocations
                                               int maxAllocs = Math.min(allocations.size(), 5);
                                               SimpleDateFormat dateFormat = (SimpleDateFormat) request.getAttribute("dateFormat");
                                               for (int i = 0; i < maxAllocs; i++) { 
                                                   Allocation alloc = allocations.get(i); %>
                                            <tr>
                                                <td><%= alloc.getAllocationId() %></td>
                                                <td><%= alloc.getTaskName() != null ? alloc.getTaskName() : "Unknown Task" %></td>
                                                <td>
                                                    <span class="badge bg-<%= "Completed".equals(alloc.getStatus()) ? "success" : "In-Progress".equals(alloc.getStatus()) ? "warning" : "secondary" %>">
                                                        <%= alloc.getStatus() != null ? alloc.getStatus() : "Pending" %>
                                                    </span>
                                                </td>
                                                <td><%= alloc.getAssignedDate() != null ? dateFormat.format(alloc.getAssignedDate()) : "N/A" %></td>
                                                <td><%= alloc.getTaskDeadline() != null ? dateFormat.format(alloc.getTaskDeadline()) : "No Deadline" %></td>
                                                <td>
                                                    <span class="badge bg-<%= "high".equals(alloc.getTaskPriority()) ? "danger" : "medium".equals(alloc.getTaskPriority()) ? "warning" : "success" %>">
                                                        <%= alloc.getTaskPriority() != null ? alloc.getTaskPriority() : "N/A" %>
                                                    </span>
                                                </td>
                                                <td>
                                                    <% if (!"Completed".equals(alloc.getStatus())) { %>
                                                        <form method="post" action="staff" class="status-form">
                                                            <input type="hidden" name="action" value="updateStatus">
                                                            <input type="hidden" name="allocationId" value="<%= alloc.getAllocationId() %>">
                                                            <select name="status" class="form-select form-select-sm">
                                                                <option value="Pending" <%= "Pending".equals(alloc.getStatus()) ? "selected" : "" %>>Pending</option>
                                                                <option value="In-Progress" <%= "In-Progress".equals(alloc.getStatus()) ? "selected" : "" %>>In-Progress</option>
                                                                <option value="Completed">Completed</option>
                                                            </select>
                                                            <input type="text" name="comments" class="form-control form-control-sm" placeholder="Comments" value="<%= alloc.getComments() != null ? alloc.getComments() : "" %>" style="width: 120px;">
                                                            <button type="submit" class="btn btn-sm btn-primary">Update</button>
                                                        </form>
                                                    <% } else { %>
                                                        <span class="text-success"><i class="bi bi-check-circle-fill"></i> Completed</span>
                                                    <% } %>
                                                </td>
                                            </tr>
                                        <%   }
                                           } else { %>
                                            <tr>
                                                <td colspan="7" class="text-center text-muted py-4">
                                                    <i class="bi bi-inbox fs-1 mb-2"></i>
                                                    <p>No allocations assigned yet.</p>
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