package model;

import java.sql.Timestamp;

public class Notification {
    private int notificationId;
    private int userId;
    private String message;
    private Timestamp createdAt;
    private boolean isRead;
    
    // Constructors
    public Notification() {}
    
    public Notification(int userId, String message) {
        this.setUserId(userId);
        this.message = message;
    }
    
    
    // Getters/Setters
    public int getNotificationId() { return notificationId; }
    public void setNotificationId(int notificationId) { this.notificationId = notificationId; }
    
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    public boolean isRead() { return isRead; }
    public void setRead(boolean isRead) { this.isRead = isRead; }

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}
}