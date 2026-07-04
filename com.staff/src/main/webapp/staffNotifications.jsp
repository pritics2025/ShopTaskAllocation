<%@page import="model.Notification"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ include file="/includes/navbar.jsp" %>
<%@ include file="/includes/sidebar-staff.jsp" %>
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
                            <form action="staffNotifications" method="post" style="display: inline;">
                                <input type="hidden" name="action" value="markAllAsRead">
                                <button type="submit" class="btn btn-light btn-sm">
                                    <i class="bi bi-check-all me-1"></i> Mark All as Read
                                </button>
                            </form>
                        </div>
                        <div class="card-body">
                            <% List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
                               if (notifications != null && !notifications.isEmpty()) {
                                   for (Notification notif : notifications) { %>
                                <div class="notification-item <%= !notif.isRead() ? "unread" : "" %>">
                                    <div class="notification-header">
                                        <h6 class="mb-0"><%= notif.getMessage() != null ? notif.getMessage() : "No message" %></h6>
                                        <% if (!notif.isRead()) { %>
                                            <form method="post" action="staffNotifications" style="display: inline;">
                                                <input type="hidden" name="action" value="markAsRead">
                                                <input type="hidden" name="notificationId" value="<%= notif.getNotificationId() %>">
                                                <button type="submit" class="btn btn-sm btn-outline-primary">
                                                    <i class="bi bi-check"></i> Mark as Read
                                                </button>
                                            </form>
                                        <% } else { %>
                                            <span class="badge bg-success"><i class="bi bi-check-circle"></i> Read</span>
                                        <% } %>
                                    </div>
                                    <div class="notification-time">
                                        <i class="bi bi-clock me-1"></i>
                                        <%= notif.getCreatedAt() != null ? notif.getCreatedAt() : "N/A" %>
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
                <div class="col-md-4 mb-3">
                    <div class="card text-center bg-info text-white">
                        <div class="card-body">
                            <i class="bi bi-bell fs-1 mb-2"></i>
                            <h5 class="card-title">Total Notifications</h5>
                            <% int totalCount = (notifications != null) ? notifications.size() : 0; %>
                            <h3><%= totalCount %></h3>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-3">
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
                <div class="col-md-4 mb-3">
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