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

@WebServlet("/adminProfile")
public class AdminProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp?error=Access denied or session expired.");
            return;
        }
        
        Integer userIdObj = (Integer) session.getAttribute("userId");
        if (userIdObj == null) {
            session.invalidate();
            response.sendRedirect("login.jsp?error=Invalid user session.");
            return;
        }
        
        System.out.println("AdminProfileServlet: Fetching profile for admin userId=" + userIdObj);
        
        User user = null;
        try {
            // Test database connection
            System.out.println("AdminProfileServlet: Testing database connection...");
            java.sql.Connection conn = db_config.GetConnection.getConnection();
            if (conn != null) {
                System.out.println("AdminProfileServlet: Database connection successful!");
                conn.close();
            } else {
                System.out.println("AdminProfileServlet: Database connection failed!");
            }
            
            UserOperations userOps = new UserOperationsImpl();
            user = userOps.getUserbyId(userIdObj);
            System.out.println("AdminProfileServlet: Fetched user: " + (user != null ? user.getUsername() : "null"));
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load user profile: " + e.getMessage());
        }
        
        request.setAttribute("user", user);
        request.getRequestDispatcher("adminProfile.jsp").forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
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
                System.out.println("AdminProfileServlet: Updated profile for userId=" + userIdObj);
                
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