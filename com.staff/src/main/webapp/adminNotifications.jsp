<%@page import="model.Notification"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ include file="/includes/navbar.jsp" %>
<%@ include file="/includes/sidebar-admin.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notifications - STASYNC</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="includes/style.css" rel="stylesheet">
    
</head>
<body>
    <div class="main-content" id="mainContent">
        <div class="container-fluid mt-5 pt-4">
            <div class="row">
                <div class="col-12">
                    <h2 class="mb-4 text-info"><i class="bi bi-bell me-2"></i>Notifications</h2>
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
            
            <!-- Notifications Header with Actions -->
            <div class="row mb-4">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header bg-info text-white d-flex justify-content-between align-items-center">
                            <h5 class="mb-0"><i class="bi bi-bell-fill me-2"></i>All Notifications</h5>
                            <div>
                                <form action="notifications" method="post" style="display: inline;">
                                    <input type="hidden" name="action" value="markAllAsRead">
                                    <button type="submit" class="btn btn-light btn-sm me-2">
                                        <i class="bi bi-check-all me-1"></i> Mark All as Read
                                    </button>
                                </form>
                                <button class="btn btn-light btn-sm" data-bs-toggle="modal" data-bs-target="#addNotificationModal">
                                    <i class="bi bi-plus-circle me-1"></i> Add Notification
                                </button>
                            </div>
                        </div>
                        <div class="card-body">
                            <% List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
                               if (notifications != null && !notifications.isEmpty()) {
                                   for (Notification notif : notifications) { %>
                                <div class="notification-item <%= !notif.isRead() ? "unread" : "" %>">
                                    <div class="notification-header">
                                        <h6 class="mb-0"><%= notif.getMessage() != null ? notif.getMessage() : "No message" %></h6>
                                        <div>
                                            <% if (!notif.isRead()) { %>
                                                <form method="post" action="notifications" style="display: inline;">
                                                    <input type="hidden" name="action" value="markAsRead">
                                                    <input type="hidden" name="notificationId" value="<%= notif.getNotificationId() %>">
                                                    <button type="submit" class="btn btn-sm btn-outline-primary me-1">
                                                        <i class="bi bi-check"></i> Mark as Read
                                                    </button>
                                                </form>
                                            <% } %>
                                        </div>
                                    </div>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div class="notification-time">
                                            <i class="bi bi-clock me-1"></i>
                                            <%= notif.getCreatedAt() != null ? notif.getCreatedAt() : "N/A" %>
                                        </div>
                                        <div>
                                            <%-- This would require a type field in the Notification model --%>
                                            <span class="notification-type type-system">System</span>
                                        </div>
                                    </div>
                                </div>
                            <%   }
                               } else { %>
                                <div class="text-center text-muted py-4">
                                    <i class="bi bi-bell-slash fs-1 mb-2"></i>
                                    <p>No notifications available.</p>
                                </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Notifications Summary Cards -->
            <div class="row">
                <div class="col-md-3 mb-3">
                    <div class="card text-center bg-info text-white">
                        <div class="card-body">
                            <i class="bi bi-bell fs-1 mb-2"></i>
                            <h5 class="card-title">Total Notifications</h5>
                            <% int totalCount = (notifications != null) ? notifications.size() : 0; %>
                            <h3><%= totalCount %></h3>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="card text-center bg-danger text-white">
                        <div class="card-body">
                            <i class="bi bi-exclamation-circle fs-1 mb-2"></i>
                            <h5 class="card-title">Unread Notifications</h5>
                            <% int unreadCount = 0;
                               if (notifications != null) {
                                   for (Notification notif : notifications) {
                                       if (!notif.isRead()) unreadCount++;
                                   }
                               } %>
                            <h3><%= unreadCount %></h3>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="card text-center bg-success text-white">
                        <div class="card-body">
                            <i class="bi bi-check-circle fs-1 mb-2"></i>
                            <h5 class="card-title">Read Notifications</h5>
                            <% int readCount = 0;
                               if (notifications != null) {
                                   for (Notification notif : notifications) {
                                       if (notif.isRead()) readCount++;
                                   }
                               } %>
                            <h3><%= readCount %></h3>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="card text-center bg-warning text-white">
                        <div class="card-body">
                            <i class="bi bi-trash fs-1 mb-2"></i>
                            <h5 class="card-title">Deleted Notifications</h5>
                            <h3>0</h3>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Add Notification Modal -->
    <div class="modal fade" id="addNotificationModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New Notification</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="notifications" method="post">
                        <input type="hidden" name="action" value="createNotification">
                        <div class="mb-3">
                            <label for="message" class="form-label">Message</label>
                            <textarea class="form-control" id="message" name="message" rows="3" required></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="userId" class="form-label">User (leave empty for all users)</label>
                            <select class="form-select" id="userId" name="userId">
                                <option value="">All Users</option>
                                <%-- This would require fetching users from the database --%>
                            </select>
                        </div>
                        <div class="text-end">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary">Add Notification</button>
                        </div>
                    </form>
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