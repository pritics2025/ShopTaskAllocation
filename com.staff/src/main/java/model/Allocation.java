package model;

import java.sql.Timestamp;

public class Allocation {
    private int allocationId;
    private int userId;
    private String userName;
    private int taskId;
    private String status;  // 'Pending', 'In-Progress', 'Completed'
    private Timestamp assignedDate;
    private Timestamp completionDate;
    private String comments;
    private String taskName;	
    private java.sql.Timestamp taskDeadline;
    private String taskPriority;

    
    // Constructors
    public Allocation() {}
    
    public Allocation(int userId, int taskId, String status, String comments) {
        this.setUserId(userId);
        this.taskId = taskId;
        this.status = status;
        this.comments = comments;
    }
    
    // Getters/Setters
    public int getAllocationId() { return allocationId; }
    public void setAllocationId(int allocationId) { this.allocationId = allocationId; }
    
    public int getTaskId() { return taskId; }
    public void setTaskId(int taskId) { this.taskId = taskId; }
    
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    
    public Timestamp getAssignedDate() { return assignedDate; }
    public void setAssignedDate(Timestamp assignedDate) { this.assignedDate = assignedDate; }
    
    public Timestamp getCompletionDate() { return completionDate; }
    public void setCompletionDate(Timestamp completionDate) { this.completionDate = completionDate; }
    
    public String getComments() { return comments; }
    public void setComments(String comments) { this.comments = comments; }

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public String getTaskName() {
		return taskName;
	}

	public void setTaskName(String taskName) {
		this.taskName = taskName;
	}

	public java.sql.Timestamp getTaskDeadline() {
		return taskDeadline;
	}

	public void setTaskDeadline(java.sql.Timestamp taskDeadline) {
		this.taskDeadline = taskDeadline;
	}

	public String getTaskPriority() {
		return taskPriority;
	}

	public void setTaskPriority(String taskPriority) {
		this.taskPriority = taskPriority;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}
}