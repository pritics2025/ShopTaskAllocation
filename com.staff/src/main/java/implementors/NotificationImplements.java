package implementors;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Notification;
import operations.NotificationOperations;
import db_config.GetConnection;

public class NotificationImplements implements NotificationOperations {
    
    @Override
    public List<Notification> getUnreadNotifications(int userId) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM notifications WHERE user_id = ? AND is_read = 0 ORDER BY created_at DESC";
        
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Notification notif = new Notification();
                    notif.setNotificationId(rs.getInt("notification_id"));
                    notif.setUserId(rs.getInt("user_id"));
                    notif.setMessage(rs.getString("message"));
                    notif.setCreatedAt(rs.getTimestamp("created_at"));
                    notif.setRead(rs.getBoolean("is_read"));
                    list.add(notif);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("NotificationImplements Error: " + e.getMessage());
        }
        return list;
    }

    @Override
    public boolean markNotificationRead(int notificationId) {
        String sql = "UPDATE notifications SET is_read = 1 WHERE notification_id = ?";
        
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, notificationId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public List<Notification> getAllNotifications() {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM notifications ORDER BY created_at DESC";
        
        try (Connection conn = GetConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Notification notif = new Notification();
                notif.setNotificationId(rs.getInt("notification_id"));
                notif.setUserId(rs.getInt("user_id"));
                notif.setMessage(rs.getString("message"));
                notif.setCreatedAt(rs.getTimestamp("created_at"));
                notif.setRead(rs.getBoolean("is_read"));
                list.add(notif);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("NotificationImplements Error: " + e.getMessage());
        }
        return list;
    }
    
    @Override
    public List<Notification> getAllNotificationsForUser(int userId) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM notifications WHERE user_id = ? ORDER BY created_at DESC";
        
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Notification notif = new Notification();
                    notif.setNotificationId(rs.getInt("notification_id"));
                    notif.setUserId(rs.getInt("user_id"));
                    notif.setMessage(rs.getString("message"));
                    notif.setCreatedAt(rs.getTimestamp("created_at"));
                    notif.setRead(rs.getBoolean("is_read"));
                    list.add(notif);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("NotificationImplements Error: " + e.getMessage());
        }
        return list;
    }
    
    @Override
    public boolean addNotification(Notification notification) {
        String sql = "INSERT INTO notifications (user_id, message, is_read) VALUES (?, ?, ?)";
        
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setInt(1, notification.getUserId());
            pstmt.setString(2, notification.getMessage());
            pstmt.setBoolean(3, notification.isRead());
            
            int result = pstmt.executeUpdate();
            
            if (result > 0) {
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        notification.setNotificationId(generatedKeys.getInt(1));
                        return true;
                    }
                }
            }
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public boolean deleteNotification(int notificationId) {
        String sql = "DELETE FROM notifications WHERE notification_id = ?";
        
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, notificationId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}