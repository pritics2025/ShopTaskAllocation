package controller;

import java.io.IOException;
import java.util.List;

import implementors.NotificationImplements;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Notification;
import operations.NotificationOperations;

@WebServlet("/notifications")
public class AdminNotificationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp?error=Access denied or session expired.");
            return;
        }
        
        System.out.println("NotificationsServlet: Fetching all notifications for admin");
        
        List<Notification> notifications = null;
        try {
            // Test database connection
            System.out.println("NotificationsServlet: Testing database connection...");
            java.sql.Connection conn = db_config.GetConnection.getConnection();
            if (conn != null) {
                System.out.println("NotificationsServlet: Database connection successful!");
                conn.close();
            } else {
                System.out.println("NotificationsServlet: Database connection failed!");
            }
            
            NotificationOperations notifOps = new NotificationImplements();
            notifications = notifOps.getAllNotifications();
            System.out.println("NotificationsServlet: Fetched " + (notifications != null ? notifications.size() : 0) + " notifications");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load notifications: " + e.getMessage());
        }
        
        request.setAttribute("notifications", notifications != null ? notifications : new java.util.ArrayList<Notification>());
        request.getRequestDispatcher("adminNotifications.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) {
            request.setAttribute("error", "No action specified.");
            doGet(request, response);
            return;
        }
        
        boolean success = false;
        
        try {
            if ("markAsRead".equals(action)) {
                String notificationIdStr = request.getParameter("notificationId");
                if (notificationIdStr == null || notificationIdStr.isEmpty()) {
                    request.setAttribute("error", "Notification ID is required.");
                    doGet(request, response);
                    return;
                }
                
                int notificationId = Integer.parseInt(notificationIdStr);
                NotificationOperations notifOps = new NotificationImplements();
                success = notifOps.markNotificationRead(notificationId);
                System.out.println("NotificationsServlet: Marked notification " + notificationId + " as read");
                
                if (success) {
                    request.setAttribute("success", "Notification marked as read!");
                } else {
                    request.setAttribute("error", "Failed to mark notification as read.");
                }
            } else if ("markAllAsRead".equals(action)) {
                NotificationOperations notifOps = new NotificationImplements();
                List<Notification> notifications = notifOps.getAllNotifications();
                
                success = true;
                for (Notification notif : notifications) {
                    if (!notif.isRead()) {
                        if (!notifOps.markNotificationRead(notif.getNotificationId())) {
                            success = false;
                            break;
                        }
                    }
                }
                
                if (success) {
                    request.setAttribute("success", "All notifications marked as read!");
                } else {
                    request.setAttribute("error", "Failed to mark all notifications as read.");
                }
            } else if ("createNotification".equals(action)) {
                String message = request.getParameter("message");
                String userIdStr = request.getParameter("userId");
                
                if (message == null || message.isEmpty()) {
                    request.setAttribute("error", "Message is required.");
                    doGet(request, response);
                    return;
                }
                
                NotificationOperations notifOps = new NotificationImplements();
                
                if (userIdStr == null || userIdStr.isEmpty()) {
                    // Send to all users
                    // This would require implementing a method to send notifications to all users
                    success = true; // Placeholder
                } else {
                    int userId = Integer.parseInt(userIdStr);
                    // This would require implementing a method to send notification to a specific user
                    success = true; // Placeholder
                }
                
                if (success) {
                    request.setAttribute("success", "Notification created successfully!");
                } else {
                    request.setAttribute("error", "Failed to create notification.");
                }
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Invalid ID format.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
        }
        
        doGet(request, response);
    }
}