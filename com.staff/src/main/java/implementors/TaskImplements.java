package implementors;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import java.util.Date;
import java.text.SimpleDateFormat;

import db_config.GetConnection;
import model.Task;
import operations.TaskOperations;

public class TaskImplements implements TaskOperations {
    private SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");

    @Override
    public boolean addTask(Task task) {
        // Validate deadline if provided
        if (task.getDeadline() != null) {
            // Check if deadline is in the future
            if (task.getDeadline().before(new Date())) {
                System.out.println("TaskImplements: Deadline must be in the future");
                return false;
            }
        }
        
        String sql = "INSERT INTO tasks (task_name, description, deadline, priority, task_type, admin_id) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, task.getTaskName());
            pstmt.setString(2, task.getDescription());
            
            // Handle deadline - can be null
            if (task.getDeadline() != null) {
                // Convert java.util.Date to java.sql.Timestamp
                pstmt.setTimestamp(3, new java.sql.Timestamp(task.getDeadline().getTime()));
            } else {
                pstmt.setNull(3, Types.TIMESTAMP);
            }
            
            pstmt.setString(4, task.getPriority());
            pstmt.setString(5, task.getTaskType());
            pstmt.setInt(6, task.getAdminId());
            
            System.out.println("TaskImplements: Adding task - Name: " + task.getTaskName() + 
                               ", Deadline: " + (task.getDeadline() != null ? dateFormat.format(task.getDeadline()) : "NULL") +
                               ", Priority: " + task.getPriority() +
                               ", Type: " + task.getTaskType() +
                               ", Admin ID: " + task.getAdminId());
            
            int result = pstmt.executeUpdate();
            
            if (result > 0) {
                // Get the generated task ID
                try (ResultSet generatedKeys = pstmt.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        task.setTaskId(generatedKeys.getInt(1));
                        System.out.println("TaskImplements: Task added successfully with ID: " + task.getTaskId());
                        return true;
                    }
                }
            }
            
            System.out.println("TaskImplements: Failed to add task, no rows affected");
            return false;
            
        } catch (SQLException e) {
            System.out.println("TaskImplements: SQLException while adding task: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public List<Task> getAllTasks() {
        List<Task> tasks = new ArrayList<>();
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM tasks ORDER BY deadline ASC");
            ResultSet rs = pstmt.executeQuery()) {
            while (rs.next()) {
                Task task = new Task();
                task.setTaskId(rs.getInt("task_id"));
                task.setTaskName(rs.getString("task_name"));
                task.setDescription(rs.getString("description"));
                task.setDeadline(rs.getTimestamp("deadline"));
                task.setPriority(rs.getString("priority"));
                task.setTaskType(rs.getString("task_type"));
                task.setAdminId(rs.getInt("admin_id"));
                tasks.add(task);
            }
        } catch (SQLException e) {
            System.out.println("TaskImplements: SQLException while getting all tasks: " + e.getMessage());
            e.printStackTrace();
        }
        return tasks;
    }
    
    @Override
    public Task getTaskById(int taskId) {
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM tasks WHERE task_id = ?")) {
            pstmt.setInt(1, taskId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                Task task = new Task();
                task.setTaskId(rs.getInt("task_id"));
                task.setTaskName(rs.getString("task_name"));
                task.setDescription(rs.getString("description"));
                task.setDeadline(rs.getTimestamp("deadline"));
                task.setPriority(rs.getString("priority"));
                task.setTaskType(rs.getString("task_type"));
                task.setAdminId(rs.getInt("admin_id"));
                return task;
            }
        } catch (SQLException e) {
            System.out.println("TaskImplements: SQLException while getting task by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
    
    @Override
    public boolean updateTask(Task task) {
        // Validate deadline if provided
        if (task.getDeadline() != null) {
            // Check if deadline is in the future
            if (task.getDeadline().before(new Date())) {
                System.out.println("TaskImplements: Deadline must be in the future");
                return false;
            }
        }
        
        String sql = "UPDATE tasks SET task_name = ?, description = ?, deadline = ?, priority = ?, task_type = ? WHERE task_id = ?";
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, task.getTaskName());
            pstmt.setString(2, task.getDescription());
            
            // Handle deadline - can be null
            if (task.getDeadline() != null) {
                pstmt.setTimestamp(3, new java.sql.Timestamp(task.getDeadline().getTime()));
            } else {
                pstmt.setNull(3, Types.TIMESTAMP);
            }
            
            pstmt.setString(4, task.getPriority());
            pstmt.setString(5, task.getTaskType());
            pstmt.setInt(6, task.getTaskId());
            
            System.out.println("TaskImplements: Updating task - ID: " + task.getTaskId() + 
                               ", Name: " + task.getTaskName() + 
                               ", Deadline: " + (task.getDeadline() != null ? dateFormat.format(task.getDeadline()) : "NULL") +
                               ", Priority: " + task.getPriority() +
                               ", Type: " + task.getTaskType());
            
            int result = pstmt.executeUpdate();
            
            if (result > 0) {
                System.out.println("TaskImplements: Task updated successfully with ID: " + task.getTaskId());
                return true;
            } else {
                System.out.println("TaskImplements: Failed to update task, no rows affected");
                return false;
            }
            
        } catch (SQLException e) {
            System.out.println("TaskImplements: SQLException while updating task: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean deleteTask(int taskId) {
        String sql = "DELETE FROM tasks WHERE task_id = ?";
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, taskId);
            int result = pstmt.executeUpdate();
            
            if (result > 0) {
                System.out.println("TaskImplements: Task deleted successfully with ID: " + taskId);
                return true;
            } else {
                System.out.println("TaskImplements: Failed to delete task, no rows affected");
                return false;
            }
            
        } catch (SQLException e) {
            System.out.println("TaskImplements: SQLException while deleting task: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}