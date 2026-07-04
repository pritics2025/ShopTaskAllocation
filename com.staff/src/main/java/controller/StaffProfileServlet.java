package controller;

import java.io.IOException;

import implementors.UserOperationsImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import operations.UserOperations;

@WebServlet("/staffProfile")
public class StaffProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

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
        
        System.out.println("StaffProfileServlet: Fetching profile for userId=" + userId);
        
        User user = null;
        try {
            // Test database connection
            System.out.println("StaffProfileServlet: Testing database connection...");
            java.sql.Connection conn = db_config.GetConnection.getConnection();
            if (conn != null) {
                System.out.println("StaffProfileServlet: Database connection successful!");
                conn.close();
            } else {
                System.out.println("StaffProfileServlet: Database connection failed!");
            }
            
            UserOperations userOps = new UserOperationsImpl();
            user = userOps.getUserbyId(userId);
            System.out.println("StaffProfileServlet: Fetched user: " + (user != null ? user.getUsername() : "null"));
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load user profile: " + e.getMessage());
        }
        
        request.setAttribute("user", user);
        request.getRequestDispatcher("staffProfile.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"staff".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
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
            if ("updateProfile".equals(action)) {
                User user = new User();
                user.setUserId(userIdObj);
                user.setUsername(request.getParameter("username"));
                user.setName(request.getParameter("name"));
                user.setContact(request.getParameter("contact"));
                
                // Only update password if a new one is provided
                String password = request.getParameter("password");
                if (password != null && !password.isEmpty()) {
                    user.setPassword(password);
                } else {
                    // Keep the existing password
                    UserOperations userOps = new UserOperationsImpl();
                    User existingUser = userOps.getUserbyId(userIdObj);
                    user.setPassword(existingUser.getPassword());
                }
                
                UserOperations userOps = new UserOperationsImpl();
                success = userOps.updateUser(user);
                System.out.println("StaffProfileServlet: Updated profile for userId=" + userIdObj);
                
                if (success) {
                    // Update session attributes
                    session.setAttribute("name", user.getName());
                    request.setAttribute("success", "Profile updated successfully!");
                } else {
                    request.setAttribute("error", "Failed to update profile.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
        }
        
        doGet(request, response);
    }
}