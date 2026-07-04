<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.Connection, java.sql.DatabaseMetaData, java.sql.ResultSet, java.sql.Statement, db_config.GetConnection, implementors.UserOperationsImpl, model.User" %>
<!DOCTYPE html>
<html>
<head>
    <title>Registration Test</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h1>Registration Test</h1>
        
        <div class="card mb-4">
            <div class="card-header">
                Database Connection Test
            </div>
            <div class="card-body">
                <%
                    try {
                        Connection conn = GetConnection.getConnection();
                        if (conn != null) {
                            out.println("<div class='alert alert-success'>Database connection successful!</div>");
                            
                            // Check if users table exists
                            DatabaseMetaData metaData = conn.getMetaData();
                            ResultSet tables = metaData.getTables(null, null, "users", null);
                            if (tables.next()) {
                                out.println("<div class='alert alert-info'>Users table exists</div>");
                                
                                // Show table structure
                                out.println("<h5>Table Structure:</h5>");
                                out.println("<table class='table table-bordered'>");
                                out.println("<thead><tr><th>Column Name</th><th>Data Type</th></tr></thead>");
                                out.println("<tbody>");
                                
                                ResultSet columns = metaData.getColumns(null, null, "users", null);
                                while (columns.next()) {
                                    String columnName = columns.getString("COLUMN_NAME");
                                    String dataType = columns.getString("TYPE_NAME");
                                    out.println("<tr><td>" + columnName + "</td><td>" + dataType + "</td></tr>");
                                }
                                out.println("</tbody></table>");
                                
                                // Try to add a test user
                                UserOperationsImpl userOps = new UserOperationsImpl();
                                User testUser = new User();
                                testUser.setName("Test User");
                                testUser.setUsername("testuser" + System.currentTimeMillis());
                                testUser.setPassword("testpass");
                                testUser.setRole("staff");
                                testUser.setContact("test@example.com");
                                
                                boolean added = userOps.addUser(testUser);
                                if (added) {
                                    out.println("<div class='alert alert-success'>Test user added successfully! ID: " + testUser.getUserId() + "</div>");
                                    
                                    // Try to retrieve the test user
                                    User retrievedUser = userOps.getUserbyUsername(testUser.getUsername());
                                    if (retrievedUser != null) {
                                        out.println("<div class='alert alert-success'>Test user retrieved successfully!</div>");
                                        out.println("<p><strong>User Details:</strong></p>");
                                        out.println("<ul>");
                                        out.println("<li>ID: " + retrievedUser.getUserId() + "</li>");
                                        out.println("<li>Username: " + retrievedUser.getUsername() + "</li>");
                                        out.println("<li>Name: " + retrievedUser.getName() + "</li>");
                                        out.println("<li>Role: " + retrievedUser.getRole() + "</li>");
                                        out.println("<li>Contact: " + retrievedUser.getContact() + "</li>");
                                        out.println("</ul>");
                                        
                                        // Clean up - delete the test user
                                        userOps.deleteUser(retrievedUser.getUserId());
                                        out.println("<div class='alert alert-info'>Test user deleted</div>");
                                    } else {
                                        out.println("<div class='alert alert-danger'>Failed to retrieve test user</div>");
                                    }
                                } else {
                                    out.println("<div class='alert alert-danger'>Failed to add test user</div>");
                                }
                            } else {
                                out.println("<div class='alert alert-danger'>Users table does not exist</div>");
                            }
                            
                            conn.close();
                        } else {
                            out.println("<div class='alert alert-danger'>Database connection failed!</div>");
                        }
                    } catch (Exception e) {
                        out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
                        e.printStackTrace();
                    }
                %>
            </div>
        </div>
        
        <div class="card">
            <div class="card-header">
                Registration Form Test
            </div>
            <div class="card-body">
                <form method="post" action="register">
                    <div class="mb-3">
                        <label class="form-label">Full Name</label>
                        <input type="text" class="form-control" name="name" value="Test User" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Username</label>
                        <input type="text" class="form-control" name="username" value="testuser<%= System.currentTimeMillis() %>" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Password</label>
                        <input type="password" class="form-control" name="password" value="testpass123" required>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Role</label>
                        <select class="form-select" name="role" required>
                            <option value="staff">Staff Member</option>
                            <option value="admin">Admin (Shop Owner)</option>
                        </select>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label">Contact</label>
                        <input type="text" class="form-control" name="contact" value="test@example.com" required>
                    </div>
                    
                    <button type="submit" class="btn btn-primary">Register</button>
                </form>
            </div>
        </div>
    </div>
</body>
</html>