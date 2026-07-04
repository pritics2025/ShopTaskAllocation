package model;


public class Task {
    private int taskId;
    private String taskName;
    private String description;
    private java.sql.Timestamp deadline;  // DATETIME in DB
    private String priority;  // 'low', 'medium', 'high'
    private String taskType;  // 'Inventory', etc.
    private int adminId;
    
    // Constructors
    public Task() {}
    
    public Task(String taskName, String description, java.sql.Timestamp deadline, String priority, String taskType, int adminId) {
        this.taskName = taskName;
        this.description = description;
        this.setDeadline(deadline);
        this.priority = priority;
        this.taskType = taskType;
        this.adminId = adminId;
    }
    
    // Getters/Setters
    public int getTaskId() { return taskId; }
    public void setTaskId(int taskId) { this.taskId = taskId; }
    
    public String getTaskName() { return taskName; }
    public void setTaskName(String taskName) { this.taskName = taskName; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getPriority() { return priority; }
    public void setPriority(String priority) { this.priority = priority; }
    
    public String getTaskType() { return taskType; }
    public void setTaskType(String taskType) { this.taskType = taskType; }
    
    public int getAdminId() { return adminId; }
    public void setAdminId(int adminId) { this.adminId = adminId; }

	public java.sql.Timestamp getDeadline() {
		return deadline;
	}

	public void setDeadline(java.sql.Timestamp deadline) {
		this.deadline = deadline;
	}
}