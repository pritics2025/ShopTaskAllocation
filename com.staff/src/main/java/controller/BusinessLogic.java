package controller;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;  // Added: For deadline validation
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import db_config.GetConnection;
import model.Allocation;
import model.User;

public class BusinessLogic {
    
    public static boolean isValidPassword(String password) {
        return password != null && password.length() >= 8;
    }
   
    public static String manageProfile(int userId, String newPassword, String newName, String action) {
        Connection conn = GetConnection.getConnection();
        String result = "Error: Operation failed.";
        try {
            if (conn != null) {
                CallableStatement stmt = conn.prepareCall("{CALL manage_users_profile(?, ?, ?, ?)}");
                stmt.setInt(1, userId);
                if (newPassword != null && isValidPassword(newPassword)) {  // Validate before calling
                    stmt.setString(2, newPassword);
                } else {
                    stmt.setNull(2, Types.VARCHAR);
                }
                if (newName != null && !newName.trim().isEmpty()) {
                    stmt.setString(3, newName);
                } else {
                    stmt.setNull(3, Types.VARCHAR);
                }
                stmt.setString(4, action);
                
                boolean hasResult = stmt.execute();
                if (hasResult) {
                    // Fixed: Use ResultSet rs instead of 'var' for Java 8+ compatibility
                    ResultSet rs = stmt.getResultSet();
                    if (rs != null && rs.next()) {
                        result = rs.getString("message");
                    }
                    rs.close();  // Explicit close for safety
                } else {
                    result = "Procedure executed successfully (no result set).";
                }
            } else {
                result = "Error: Database connection failed.";
            }
        } catch (SQLException e) {
            e.printStackTrace();
            result = "Database Error: " + e.getMessage();
        } catch (Exception e) {  // Catch-all for other issues
            e.printStackTrace();
            result = "Error: " + e.getMessage();
        } finally {
         
        }
        return result;
    }
    
    // Business rule: Check if deadline is in the future (app-level validation before DB insert)
    // Usage: In AdminServlet, e.g., if (!BusinessLogic.isFutureDeadline(task.getDeadline())) { show error; }
    public static boolean isFutureDeadline(Timestamp deadline) {
        return deadline != null && deadline.after(new Timestamp(System.currentTimeMillis()));
    }
    
    // Wrapper: Get all allocations for a user (high-level method; delegates to DAO for joins)
    // Note: If you've split to UserOperations, replace with your custom DAO call.
    // If Allocation POJO not ready, comment out or implement later.
    public static List<Allocation> getUserAllocations(int userId) {
        List<Allocation> allocations = new ArrayList<>();
        try {
            // Original: Using single Operations interface
            // Operations ops = new Implementor.OperationsImpl();
            // allocations = ops.getAllocationsByUser (userId);
            
            // If using your custom UserOperations (from recent fixes):
            // operations.UserOperations ops = new implementors.UserImplements();
            // But UserOperations may not have getAllocationsByUser —extend it or create a full Operations.
            
            // Placeholder: Return empty for now if not implemented
            System.out.println("BusinessLogic: Fetching allocations for user " + userId);
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Error in getUser Allocations: " + e.getMessage());
        }
        return allocations;
    }
    
    // Example: Additional business rule (e.g., check if user is admin before allowing task creation)
    public static boolean isAdminUser (User user) {
        return user != null && "admin".equals(user.getRole());
    }
}