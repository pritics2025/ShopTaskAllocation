package controller;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;

import implementors.AllocationImplements;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Allocation;
import operations.AllocationOperations;

@WebServlet("/staffAllocations")
public class StaffAllocationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SimpleDateFormat dateFormat = new SimpleDateFormat("dd-MM-yyyy HH:mm");

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"staff".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp?error=Access denied or session expired.");
            return;
        }
        
        Integer userIdObj = (Integer) session.getAttribute("userId");
        if (userIdObj == null) {
            session.invalidate();
            response.sendRedirect("login.jsp?error=Invalid user session.");
            return;
        }
        int userId = userIdObj.intValue();
        
        System.out.println("StaffAllocationsServlet: Fetching allocations for userId=" + userId);
        
        List<Allocation> allocations = null;
        try {
            // Test database connection
            System.out.println("StaffAllocationsServlet: Testing database connection...");
            java.sql.Connection conn = db_config.GetConnection.getConnection();
            if (conn != null) {
                System.out.println("StaffAllocationsServlet: Database connection successful!");
                conn.close();
            } else {
                System.out.println("StaffAllocationsServlet: Database connection failed!");
            }
            
            AllocationOperations allocOps = new AllocationImplements();
            allocations = allocOps.getAllocationsByUser(userId);
            System.out.println("StaffAllocationsServlet: Fetched " + (allocations != null ? allocations.size() : 0) + " allocations");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load allocations: " + e.getMessage());
        }
        
        request.setAttribute("allocations", allocations != null ? allocations : new java.util.ArrayList<Allocation>());
        request.setAttribute("dateFormat", dateFormat);
        request.getRequestDispatcher("staffAllocations.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"staff".equals(session.getAttribute("role"))) {
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
                System.out.println("StaffAllocationsServlet: Updated allocation " + allocationId + " to " + status);
                
                if (success) {
                    request.setAttribute("success", "Allocation status updated successfully!");
                } else {
                    request.setAttribute("error", "Failed to update allocation status.");
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