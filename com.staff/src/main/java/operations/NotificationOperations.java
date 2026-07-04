package operations;

import java.util.List;

import model.Notification;

public interface NotificationOperations {

	public List<Notification> getUnreadNotifications(int userId);
    public boolean markNotificationRead(int notificationId);
	List<Notification> getAllNotifications();
	List<Notification> getAllNotificationsForUser(int userId);
	boolean deleteNotification(int notificationId);
	boolean addNotification(Notification notification);

	
}
	