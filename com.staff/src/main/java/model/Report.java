package model;

public class Report {
    private String title;
    private int totalTasks;
    private int totalUsers;
    private int pendingAllocations;

    // getters and setters
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public int getTotalTasks() { return totalTasks; }
    public void setTotalTasks(int totalTasks) { this.totalTasks = totalTasks; }

    public int getTotalUsers() { return totalUsers; }
    public void setTotalUsers(int totalUsers) { this.totalUsers = totalUsers; }

    public int getPendingAllocations() { return pendingAllocations; }
    public void setPendingAllocations(int pendingAllocations) { this.pendingAllocations = pendingAllocations; }
}
