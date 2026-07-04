package controller;

import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import implementors.AllocationImplements;
import implementors.TaskImplements;
import implementors.UserOperationsImpl;
import implementors.NotificationImplements;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Task;
import model.Allocation;
import model.User;
import model.Notification;
import operations.TaskOperations;
import operations.AllocationOperations;
import operations.UserOperations;
import operations.NotificationOperations;

@WebServlet("/admin")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm");

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp?error=Access denied or session expired.");
            return;
        }
        
        System.out.println("AdminServlet: Fetching data for admin dashboard");
        
        List<Task> tasks = null;
        List<Allocation> allocations = null;
        List<User> users = null;
        List<Notification> notifications = null;
        
        try {
            // Test database connection
            System.out.println("AdminServlet: Testing database connection...");
            java.sql.Connection conn = db_config.GetConnection.getConnection();
            if (conn != null) {
                System.out.println("AdminServlet: Database connection successful!");
                conn.close();
            } else {
                System.out.println("AdminServlet: Database connection failed!");
            }
            
            // Fetch tasks
            System.out.println("AdminServlet: Fetching tasks...");
            TaskOperations taskOps = new TaskImplements();
            tasks = taskOps.getAllTasks();
            System.out.println("AdminServlet: Fetched " + (tasks != null ? tasks.size() : 0) + " tasks");
            
            // Fetch allocations
            System.out.println("AdminServlet: Fetching allocations...");
            AllocationOperations allocOps = new AllocationImplements();
            allocations = allocOps.getAllAllocations();
            System.out.println("AdminServlet: Fetched " + (allocations != null ? allocations.size() : 0) + " allocations");
            
            // Fetch users
            System.out.println("AdminServlet: Fetching users...");
            UserOperations userOps = new UserOperationsImpl();
            users = userOps.getAllUsers();
            System.out.println("AdminServlet: Fetched " + (users != null ? users.size() : 0) + " users");
            
            // Fetch notifications
            System.out.println("AdminServlet: Fetching notifications...");
            NotificationOperations notifOps = new NotificationImplements();
            notifications = notifOps.getAllNotifications();
            System.out.println("AdminServlet: Fetched " + (notifications != null ? notifications.size() : 0) + " notifications");
            
            // Calculate statistics after data is fetched
            if (tasks != null && allocations != null && users != null) {
                // Task statistics
                int totalTasks = tasks.size();
                int highPriorityTasks = (int) tasks.stream().filter(t -> "high".equals(t.getPriority())).count();
                int completedTasks = (int) allocations.stream().filter(a -> "Completed".equals(a.getStatus())).count();
                
                // User statistics
                int totalUsers = users.size();
                int activeUsers = (int) users.stream().filter(u -> "staff".equals(u.getRole())).count();
                
                // Allocation statistics
                int totalAllocations = allocations.size();
                int pendingAllocations = (int) allocations.stream().filter(a -> "Pending".equals(a.getStatus())).count();
                
                // Set attributes for dashboard
                request.setAttribute("totalTasks", totalTasks);
                request.setAttribute("highPriorityTasks", highPriorityTasks);
                request.setAttribute("completedTasks", completedTasks);
                request.setAttribute("totalUsers", totalUsers);
                request.setAttribute("activeUsers", activeUsers);
                request.setAttribute("totalAllocations", totalAllocations);
                request.setAttribute("pendingAllocations", pendingAllocations);
            }
            
            // Set attributes
            request.setAttribute("tasks", tasks != null ? tasks : new java.util.ArrayList<Task>());
            request.setAttribute("allocations", allocations != null ? allocations : new java.util.ArrayList<Allocation>());
            request.setAttribute("users", users != null ? users : new java.util.ArrayList<User>());
            request.setAttribute("notifications", notifications != null ? notifications : new java.util.ArrayList<Notification>());
            request.setAttribute("dateFormat", dateFormat);
            
            request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("AdminServlet Error: " + e.getMessage());
            request.setAttribute("error", "Failed to load data: " + e.getMessage());
            request.getRequestDispatcher("adminDashboard.jsp").forward(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        System.out.println("AdminServlet: Processing POST action: " + action);
        
        if (action == null) {
            request.setAttribute("error", "No action specified.");
            doGet(request, response);
            return;
        }
        
        boolean success = false;
        
        try {
            if ("createTask".equals(action)) {
                Task task = new Task();
                task.setTaskName(request.getParameter("taskName"));
                task.setDescription(request.getParameter("description"));
                task.setPriority(request.getParameter("priority"));
                task.setTaskType(request.getParameter("taskType"));
                task.setAdminId((Integer) session.getAttribute("userId"));
                
                // Parse deadline
                String deadlineStr = request.getParameter("deadline");
                if (deadlineStr != null && !deadlineStr.isEmpty()) {
                    try {
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
                        Date date = sdf.parse(deadlineStr);
                        task.setDeadline(new Timestamp(date.getTime()));
                    } catch (ParseException e) {
                        request.setAttribute("error", "Invalid deadline format!");
                        doGet(request, response);
                        return;
                    }
                }
                
                TaskOperations ops = new TaskImplements();
                success = ops.addTask(task);
                System.out.println("AdminServlet: Task creation " + (success ? "successful" : "failed"));
                
            } else if ("assignTask".equals(action)) {
                Allocation alloc = new Allocation();
                alloc.setTaskId(Integer.parseInt(request.getParameter("taskId")));
                alloc.setUserId(Integer.parseInt(request.getParameter("staffId")));
                alloc.setStatus("Pending");
                alloc.setComments(request.getParameter("comments"));
                
                AllocationOperations ops = new AllocationImplements();
                success = ops.addAllocation(alloc);
                System.out.println("AdminServlet: Task assignment " + (success ? "successful" : "failed"));
                
                // Create notification for staff
                if (success) {
                    NotificationOperations notifOps = new NotificationImplements();
                    Notification notif = new Notification();
                    notif.setUserId(alloc.getUserId());
                    notif.setMessage("You have been assigned a new task: " + request.getParameter("taskName"));
                    notif.setRead(false);
                    notifOps.addNotification(notif);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
        }
        
        if (success) {
            request.setAttribute("success", "Operation successful!");
        } else {
            request.setAttribute("error", "Operation failed!");
        }
        doGet(request, response);
    }
}