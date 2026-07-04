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
import model.Allocation;
import model.Task;
import model.User;
import operations.AllocationOperations;
import operations.TaskOperations;
import operations.UserOperations;

@WebServlet("/manageAllocations")
public class ManageAllocationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp?error=Access denied or session expired.");
            return;
        }
        
        System.out.println("ManageAllocationsServlet: Fetching data for allocations management");
        
        try {
            // Fetch allocations
            AllocationOperations allocOps = new AllocationImplements();
            List<Allocation> allocations = allocOps.getAllAllocations();
            System.out.println("ManageAllocationsServlet: Fetched " + (allocations != null ? allocations.size() : 0) + " allocations");
            
            // Fetch tasks for dropdown
            TaskOperations taskOps = new TaskImplements();
            List<Task> tasks = taskOps.getAllTasks();
            System.out.println("ManageAllocationsServlet: Fetched " + (tasks != null ? tasks.size() : 0) + " tasks");
            
            // Fetch users for dropdown
            UserOperations userOps = new UserOperationsImpl();
            List<User> users = userOps.getAllUsers();
            System.out.println("ManageAllocationsServlet: Fetched " + (users != null ? users.size() : 0) + " users");
            
            // Set attributes
            request.setAttribute("allocations", allocations != null ? allocations : new java.util.ArrayList<Allocation>());
            request.setAttribute("tasks", tasks != null ? tasks : new java.util.ArrayList<Task>());
            request.setAttribute("users", users != null ? users : new java.util.ArrayList<User>());
            
            request.getRequestDispatcher("manageAllocations.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load data: " + e.getMessage());
            request.getRequestDispatcher("manageAllocations.jsp").forward(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        System.out.println("ManageAllocationsServlet: Processing action: " + action);
        
        if (action == null) {
            request.setAttribute("error", "No action specified.");
            doGet(request, response);
            return;
        }
        
        boolean success = false;
        AllocationOperations allocOps = new AllocationImplements();
        
        try {
            if ("createAllocation".equals(action)) {
                Allocation alloc = new Allocation();
                alloc.setTaskId(Integer.parseInt(request.getParameter("taskId")));
                alloc.setUserId(Integer.parseInt(request.getParameter("staffId")));
                alloc.setStatus("Pending");
                alloc.setComments(request.getParameter("comments"));
                
                success = allocOps.addAllocation(alloc);
                System.out.println("ManageAllocationsServlet: Allocation creation " + (success ? "successful" : "failed"));
                
            } else if ("updateAllocation".equals(action)) {
                Allocation alloc = new Allocation();
                alloc.setAllocationId(Integer.parseInt(request.getParameter("allocationId")));
                alloc.setTaskId(Integer.parseInt(request.getParameter("taskId")));
                alloc.setUserId(Integer.parseInt(request.getParameter("staffId")));
                alloc.setStatus(request.getParameter("status"));
                alloc.setComments(request.getParameter("comments"));
                
                success = allocOps.updateAllocation(alloc);
                System.out.println("ManageAllocationsServlet: Allocation update " + (success ? "successful" : "failed"));
                
            } else if ("deleteAllocation".equals(action)) {
                int allocationId = Integer.parseInt(request.getParameter("allocationId"));
                success = allocOps.deleteAllocation(allocationId);
                System.out.println("ManageAllocationsServlet: Allocation deletion " + (success ? "successful" : "failed"));
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