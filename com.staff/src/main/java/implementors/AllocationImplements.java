package implementors;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import model.Allocation;
import operations.AllocationOperations;
import db_config.GetConnection;

public class AllocationImplements implements AllocationOperations {

    @Override
    public boolean addAllocation(Allocation allocation) {
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement("INSERT INTO allocations (user_id, task_id, status, comments) VALUES (?, ?, ?, ?)")) {
            pstmt.setInt(1, allocation.getUserId());
            pstmt.setInt(2, allocation.getTaskId());
            pstmt.setString(3, allocation.getStatus());
            pstmt.setString(4, allocation.getComments());
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public List<Allocation> getAllocationsByUser(int userId) {
        List<Allocation> allocations = new ArrayList<>();
        String sql = "SELECT a.*, t.task_name, t.deadline as task_deadline, t.priority as task_priority, u.username as user_name " +
                     "FROM allocations a " +
                     "JOIN tasks t ON a.task_id = t.task_id " +
                     "JOIN users u ON a.user_id = u.user_id " +
                     "WHERE a.user_id = ? ORDER BY a.assigned_date DESC";
        
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, userId);
            ResultSet rs = pstmt.executeQuery();
            
            while (rs.next()) {
                Allocation alloc = new Allocation();
                alloc.setAllocationId(rs.getInt("allocation_id"));
                alloc.setUserId(rs.getInt("user_id"));
                alloc.setUserName(rs.getString("user_name"));
                alloc.setTaskId(rs.getInt("task_id"));
                alloc.setStatus(rs.getString("status"));
                alloc.setAssignedDate(rs.getTimestamp("assigned_date"));
                alloc.setCompletionDate(rs.getTimestamp("completion_date"));
                alloc.setComments(rs.getString("comments"));
                alloc.setTaskName(rs.getString("task_name"));
                alloc.setTaskDeadline(rs.getTimestamp("task_deadline"));
                alloc.setTaskPriority(rs.getString("task_priority"));
                allocations.add(alloc);
                System.out.println("Allocation found: ID=" + alloc.getAllocationId() + ", Task=" + alloc.getTaskName());
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error fetching allocations for user " + userId + ": " + e.getMessage());
        }
        System.out.println("Returning " + allocations.size() + " allocations for user " + userId);
        return allocations;
    }
    
    @Override
    public boolean updateAllocationStatus(int allocationId, String status, String comments) {
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement("UPDATE allocations SET status = ?, comments = ?, completion_date = ? WHERE allocation_id = ?")) {
            pstmt.setString(1, status);
            pstmt.setString(2, comments);
            if ("Completed".equals(status)) {
                pstmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            } else {
                pstmt.setNull(3, Types.TIMESTAMP);
            }
            pstmt.setInt(4, allocationId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public List<Allocation> getAllAllocations() {
        List<Allocation> list = new ArrayList<>();
        String sql = "SELECT a.*, t.task_name, u.username " +
                     "FROM allocations a " +
                     "LEFT JOIN tasks t ON a.task_id = t.task_id " +
                     "LEFT JOIN users u ON a.user_id = u.user_id";
        
        try (Connection conn = GetConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {

            while (rs.next()) {
                Allocation alloc = new Allocation();
                alloc.setAllocationId(rs.getInt("allocation_id"));
                alloc.setTaskName(rs.getString("task_name"));
                alloc.setUserName(rs.getString("username"));
                alloc.setStatus(rs.getString("status"));
                list.add(alloc);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    @Override
    public boolean updateAllocation(Allocation alloc) {
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement("UPDATE allocations SET user_id = ?, task_id = ?, status = ?, comments = ? WHERE allocation_id = ?")) {
            
            pstmt.setInt(1, alloc.getUserId());
            pstmt.setInt(2, alloc.getTaskId());
            pstmt.setString(3, alloc.getStatus());
            pstmt.setString(4, alloc.getComments());
            pstmt.setInt(5, alloc.getAllocationId());
            
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public boolean deleteAllocation(int allocationId) {
        try (Connection conn = GetConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement("DELETE FROM allocations WHERE allocation_id = ?")) {
            
            pstmt.setInt(1, allocationId);
            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}