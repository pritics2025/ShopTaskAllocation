package implementors;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import db_config.GetConnection;
import model.User;
import operations.UserOperations;

public class UserOperationsImpl implements UserOperations {

    @Override
    public boolean addUser(User user) {
        String sql = "INSERT INTO users (username, password, role, name, contact) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            System.out.println("UserOperationsImpl: Adding user: " + user.getUsername());
            
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());  // Hash in production
            pstmt.setString(3, user.getRole());
            pstmt.setString(4, user.getName());
            pstmt.setString(5, user.getContact());
            
            int result = pstmt.executeUpdate();
            
            if (result > 0) {
                // Get the generated user ID
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        user.setUserId(generatedKeys.getInt(1));
                        System.out.println("UserOperationsImpl: User added successfully with ID: " + user.getUserId());
                    }
                }
                return true;
            }
            
            System.out.println("UserOperationsImpl: Failed to add user, no rows affected");
            return false;

        } catch (SQLException e) {
            System.out.println("UserOperationsImpl: SQLException while adding user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public User getUserbyUsername(String username) {
        String sql = "SELECT * FROM users WHERE LOWER(username) = ?";
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            System.out.println("UserOperationsImpl: Looking up user by username: " + username);
            
            pstmt.setString(1, username.trim().toLowerCase());
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
                user.setName(rs.getString("name"));
                user.setContact(rs.getString("contact"));
                System.out.println("UserOperationsImpl: Found user: " + user.getUsername() + " with ID: " + user.getUserId());
                return user;
            } else {
                System.out.println("UserOperationsImpl: No user found with username: " + username);
            }

        } catch (SQLException e) {
            System.out.println("UserOperationsImpl: SQLException while looking up user: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public User getUserbyId(int userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            System.out.println("UserOperationsImpl: Looking up user by ID: " + userId);
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
                user.setName(rs.getString("name"));
                user.setContact(rs.getString("contact"));
                System.out.println("UserOperationsImpl: Found user: " + user.getUsername() + " with ID: " + user.getUserId());
                return user;
            } else {
                System.out.println("UserOperationsImpl: No user found with ID: " + userId);
            }

        } catch (SQLException e) {
            System.out.println("UserOperationsImpl: SQLException while looking up user by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public boolean updateUser(User user) {
        String sql = "UPDATE users SET username = ?, password = ?, name = ?, contact = ? WHERE user_id = ?";
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            System.out.println("UserOperationsImpl: Updating user: " + user.getUsername() + " with ID: " + user.getUserId());
            
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getName());
            pstmt.setString(4, user.getContact());
            pstmt.setInt(5, user.getUserId());
            
            int result = pstmt.executeUpdate();
            
            if (result > 0) {
                System.out.println("UserOperationsImpl: User updated successfully");
                return true;
            } else {
                System.out.println("UserOperationsImpl: Failed to update user, no rows affected");
                return false;
            }

        } catch (SQLException e) {
            System.out.println("UserOperationsImpl: SQLException while updating user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteUser(int id) {
        String sql = "DELETE FROM users WHERE user_id = ?";
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            System.out.println("UserOperationsImpl: Deleting user with ID: " + id);
            
            ps.setInt(1, id);
            int result = ps.executeUpdate();
            
            if (result > 0) {
                System.out.println("UserOperationsImpl: User deleted successfully");
                return true;
            } else {
                System.out.println("UserOperationsImpl: Failed to delete user, no rows affected");
                return false;
            }

        } catch (SQLException e) {
            System.out.println("UserOperationsImpl: SQLException while deleting user: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users";
        try (Connection conn = GetConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            System.out.println("UserOperationsImpl: Getting all users");
            
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
                user.setName(rs.getString("name"));
                user.setContact(rs.getString("contact"));
                list.add(user);
            }
            
            System.out.println("UserOperationsImpl: Found " + list.size() + " users");

        } catch (SQLException e) {
            System.out.println("UserOperationsImpl: SQLException while getting all users: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }
}