package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import implementors.UserOperationsImpl;
import model.User;
import operations.UserOperations;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get and trim form parameters
        String name = request.getParameter("name");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        String contact = request.getParameter("contact");

        // Debug output
        System.out.println("RegisterServlet: Processing registration for username=" + username);

        // Basic validation
        if (name == null || name.trim().isEmpty() || 
            username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty() || 
            role == null || role.trim().isEmpty() || 
            contact == null || contact.trim().isEmpty()) {
            
            System.out.println("RegisterServlet: Validation failed - empty fields");
            response.sendRedirect("registration.jsp?error=All fields are required.");
            return;
        }

        if (password.length() < 8) {
            response.sendRedirect("registration.jsp?error=Password must be at least 8 characters.");
            return;
        }

        // Trim values
        name = name.trim();
        username = username.trim().toLowerCase(); // lowercase for case-insensitive check
        password = password.trim();
        role = role.trim();
        contact = contact.trim();

        // Test database connection
        try {
            java.sql.Connection conn = db_config.GetConnection.getConnection();
            if (conn != null) {
                System.out.println("RegisterServlet: Database connection successful");
                conn.close();
            } else {
                System.out.println("RegisterServlet: Database connection failed");
                response.sendRedirect("registration.jsp?error=Database connection failed. Please try again later.");
                return;
            }
        } catch (Exception e) {
            System.out.println("RegisterServlet: Database connection error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("registration.jsp?error=Database error. Please try again later.");
            return;
        }

        // Check if username exists (case-insensitive)
        UserOperations userOps = new UserOperationsImpl();
        User existingUser = userOps.getUserbyUsername(username);
        
        if (existingUser != null) {
            System.out.println("RegisterServlet: Username already exists: " + username);
            response.sendRedirect("registration.jsp?error=Username already exists. Choose another.");
            return;
        }

        // Create new user
        User newUser = new User();
        newUser.setName(name);
        newUser.setUsername(username);
        newUser.setPassword(password); // TODO: hash in production
        newUser.setRole(role);
        newUser.setContact(contact);

        System.out.println("RegisterServlet: Adding user to database: " + username);

        // Add to DB
        boolean added = userOps.addUser(newUser);
        if (!added) {
            System.out.println("RegisterServlet: Failed to add user to database");
            response.sendRedirect("registration.jsp?error=Registration failed. Please try again.");
            return;
        }

        System.out.println("RegisterServlet: User successfully registered: " + username);

        // Successful registration → redirect to login page with success message
        response.sendRedirect("login.jsp?success=Registration successful! You can now login.");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect("registration.jsp");
    }
}		