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

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // ✅ FIX: Get connection from GetConnection
        UserOperations userOps = new UserOperationsImpl();


        User user = userOps.getUserbyUsername(username);

        if (user != null && password.equals(user.getPassword())) {  // Simple check
            HttpSession session = request.getSession();
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("role", user.getRole());
            session.setAttribute("name", user.getName());
            session.setAttribute("username", user.getUsername());

            System.out.println("Login Successfully: userId=" + user.getUserId() + ", role=" + user.getRole());

            if ("admin".equals(user.getRole())) {
                response.sendRedirect("admin");
            } else if ("staff".equals(user.getRole())) {
                response.sendRedirect("staff");
            } else {
                response.sendRedirect("login.jsp?error=Invalid role");
            }
        } else {
            response.sendRedirect("login.jsp?error=Invalid credentials");
        }
    }
}
