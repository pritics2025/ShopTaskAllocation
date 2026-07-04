package controller;

import java.io.IOException;
import java.util.List;

import implementors.UserOperationsImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import operations.UserOperations;

@WebServlet("/manageUsers")
public class ManageUsersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp?error=Access denied or session expired.");
            return;
        }
        
        System.out.println("ManageUsersServlet: Fetching all users");
        
        try {
            UserOperations userOps = new UserOperationsImpl();
            List<User> users = userOps.getAllUsers();
            System.out.println("ManageUsersServlet: Fetched " + (users != null ? users.size() : 0) + " users");
            
            request.setAttribute("users", users != null ? users : new java.util.ArrayList<User>());
            request.getRequestDispatcher("manageUsers.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load users: " + e.getMessage());
            request.getRequestDispatcher("manageUsers.jsp").forward(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        System.out.println("ManageUsersServlet: Processing action: " + action);
        
        if (action == null) {
            request.setAttribute("error", "No action specified.");
            doGet(request, response);
            return;
        }
        
        boolean success = false;
        UserOperations userOps = new UserOperationsImpl();
        
        try {
            if ("createUser".equals(action)) {
                User user = new User();
                user.setName(request.getParameter("name"));
                user.setUsername(request.getParameter("username"));
                user.setPassword(request.getParameter("password"));
                user.setRole(request.getParameter("role"));
                user.setContact(request.getParameter("contact"));
                
                success = userOps.addUser(user);
                System.out.println("ManageUsersServlet: User creation " + (success ? "successful" : "failed"));
                
            } else if ("updateUser".equals(action)) {
                User user = new User();
                user.setUserId(Integer.parseInt(request.getParameter("userId")));
                user.setName(request.getParameter("name"));
                user.setUsername(request.getParameter("username"));
                user.setRole(request.getParameter("role"));
                user.setContact(request.getParameter("contact"));
                
                // Only update password if provided
                String password = request.getParameter("password");
                if (password != null && !password.isEmpty()) {
                    user.setPassword(password);
                } else {
                    // Keep existing password
                    User existingUser = userOps.getUserbyId(user.getUserId());
                    user.setPassword(existingUser.getPassword());
                }
                
                success = userOps.updateUser(user);
                System.out.println("ManageUsersServlet: User update " + (success ? "successful" : "failed"));
                
            } else if ("deleteUser".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                success = userOps.deleteUser(userId);
                System.out.println("ManageUsersServlet: User deletion " + (success ? "successful" : "failed"));
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