package controller;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import implementors.AllocationImplements;
import implementors.NotificationImplements;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Allocation;
import model.Notification;
import operations.AllocationOperations;
import operations.NotificationOperations;

@WebServlet("/staff")
public class StaffDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm");

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"staff".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp?error=Access denied or session expired.");
            return;
        }
        
        // Safe userId extraction: Prevent NPE
        Integer userIdObj = (Integer) session.getAttribute("userId");
        if (userIdObj == null) {
            System.err.println("StaffServlet: userId is null in session - invalidating and redirecting");
            session.invalidate();
            response.sendRedirect("login.jsp?error=Invalid user session.");
            return;
        }
        int userId = userIdObj.intValue();  // Safe unboxing
        
        System.out.println("StaffServlet: Fetching data for staff userId=" + userId);  // Debug log
        
        // Initialize empty lists as fallback
        List<Allocation> allocations = new ArrayList<>();
        List<Notification> notifications = new ArrayList<>();
        
        try {
            // Test database connection
            System.out.println("StaffServlet: Testing database connection...");
            java.sql.Connection conn = db_config.GetConnection.getConnection();
            if (conn != null) {
                System.out.println("StaffServlet: Database connection successful!");
                conn.close();
            } else {
                System.out.println("StaffServlet: Database connection failed!");
            }
            
            // Fetch allocations
            System.out.println("StaffServlet: Fetching allocations...");
            AllocationOperations allocOps = new AllocationImplements();
            allocations = allocOps.getAllocationsByUser(userId);
            System.out.println("StaffServlet: Fetched " + (allocations != null ? allocations.size() : 0) + " allocations");
            
            // Fetch notifications
            System.out.println("StaffServlet: Fetching notifications...");
            NotificationOperations notifOps = new NotificationImplements();
            notifications = notifOps.getUnreadNotifications(userId);
            System.out.println("StaffServlet: Fetched " + (notifications != null ? notifications.size() : 0) + " notifications");
            
        } catch (Exception e) {  // Catch DB/DAO errors
            e.printStackTrace();
            System.err.println("StaffServlet Error fetching data: " + e.getMessage());
            // Keep empty lists - don't crash
            request.setAttribute("error", "Failed to load data: " + e.getMessage());
        }
        
        // Always set attributes (non-null)
        request.setAttribute("allocations", allocations != null ? allocations : new ArrayList<Allocation>());
        request.setAttribute("notifications", notifications != null ? notifications : new ArrayList<Notification>());
        request.setAttribute("dateFormat", dateFormat);
        
        request.getRequestDispatcher("staffDashboard.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"staff".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        // Safe userId (same as doGet)
        Integer userIdObj = (Integer) session.getAttribute("userId");
        if (userIdObj == null) {
            session.invalidate();
            response.sendRedirect("login.jsp?error=Invalid session.");
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
            if ("updateStatus".equals(action)) {
                String allocationIdStr = request.getParameter("allocationId");
                if (allocationIdStr == null || allocationIdStr.isEmpty()) {
                    request.setAttribute("error", "Allocation ID is required.");
                    doGet(request, response);
                    return;
                }
                
                int allocationId = Integer.parseInt(allocationIdStr);
                String status = request.getParameter("status");
                String comments = request.getParameter("comments");
                
                AllocationOperations allocOps = new AllocationImplements();
                success = allocOps.updateAllocationStatus(allocationId, status, comments);
                System.out.println("StaffServlet: Updated allocation " + allocationId + " to " + status);
            } else if ("markRead".equals(action)) {
                String notificationIdStr = request.getParameter("notificationId");
                if (notificationIdStr == null || notificationIdStr.isEmpty()) {
                    request.setAttribute("error", "Notification ID is required.");
                    doGet(request, response);
                    return;
                }
                
                int notificationId = Integer.parseInt(notificationIdStr);
                NotificationOperations notifOps = new NotificationImplements();
                success = notifOps.markNotificationRead(notificationId);
                System.out.println("StaffServlet: Marked notification " + notificationId + " as read");
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("error", "Invalid ID format.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
        }
        
        if (success) {
            request.setAttribute("success", "Update successful!");
        } else if (request.getAttribute("error") == null) {
            request.setAttribute("error", "Update failed!");
        }
        doGet(request, response);  
    }
}