package controller;

import java.io.IOException;
import java.util.List;

import implementors.AllocationImplements;
import implementors.TaskImplements;
import implementors.UserOperationsImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Task;
import model.Allocation;
import model.User;
import operations.TaskOperations;
import operations.AllocationOperations;
import operations.UserOperations;

@WebServlet("/reports")
public class ReportsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp?error=Access denied or session expired.");
            return;
        }
        
        String reportType = request.getParameter("type");
        
        if ("taskSummary".equals(reportType)) {
            generateTaskSummaryReport(request, response);
        } else if ("userPerformance".equals(reportType)) {
            generateUserPerformanceReport(request, response);
        } else {
            request.getRequestDispatcher("reports.jsp").forward(request, response);
        }
    }
    
    private void generateTaskSummaryReport(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            TaskOperations taskOps = new TaskImplements();
            List<Task> tasks = taskOps.getAllTasks();
            
            AllocationOperations allocOps = new AllocationImplements();
            List<Allocation> allocations = allocOps.getAllAllocations();
            
            // Calculate task statistics
            int totalTasks = tasks.size();
            int highPriorityTasks = (int) tasks.stream().filter(t -> "high".equals(t.getPriority())).count();
            int mediumPriorityTasks = (int) tasks.stream().filter(t -> "medium".equals(t.getPriority())).count();
            int lowPriorityTasks = (int) tasks.stream().filter(t -> "low".equals(t.getPriority())).count();
            
            int completedTasks = (int) allocations.stream().filter(a -> "Completed".equals(a.getStatus())).count();
            int inProgressTasks = (int) allocations.stream().filter(a -> "In-Progress".equals(a.getStatus())).count();
            int pendingTasks = (int) allocations.stream().filter(a -> "Pending".equals(a.getStatus())).count();
            
            // Set attributes for report
            request.setAttribute("totalTasks", totalTasks);
            request.setAttribute("highPriorityTasks", highPriorityTasks);
            request.setAttribute("mediumPriorityTasks", mediumPriorityTasks);
            request.setAttribute("lowPriorityTasks", lowPriorityTasks);
            request.setAttribute("completedTasks", completedTasks);
            request.setAttribute("inProgressTasks", inProgressTasks);
            request.setAttribute("pendingTasks", pendingTasks);
            request.setAttribute("tasks", tasks);
            request.setAttribute("allocations", allocations);
            
            request.getRequestDispatcher("taskSummaryReport.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to generate report: " + e.getMessage());
            request.getRequestDispatcher("reports.jsp").forward(request, response);
        }
    }
    
    private void generateUserPerformanceReport(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            UserOperations userOps = new UserOperationsImpl();
            List<User> users = userOps.getAllUsers();
            
            AllocationOperations allocOps = new AllocationImplements();
            List<Allocation> allocations = allocOps.getAllAllocations();
            
            // Calculate user performance statistics
            int totalUsers = users.size();
            int activeUsers = (int) users.stream().filter(u -> "staff".equals(u.getRole())).count();
            
            // Set attributes for report
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("activeUsers", activeUsers);
            request.setAttribute("users", users);
            request.setAttribute("allocations", allocations);
            
            request.getRequestDispatcher("userPerformanceReport.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to generate report: " + e.getMessage());
            request.getRequestDispatcher("reports.jsp").forward(request, response);
        }
    }
}