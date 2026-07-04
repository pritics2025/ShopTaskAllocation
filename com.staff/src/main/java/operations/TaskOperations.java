package operations;

import java.util.List;

import model.Task;

public interface TaskOperations {
	 public boolean addTask(Task task);
	    public List<Task> getAllTasks();
	    public Task getTaskById(int taskId);
	    public boolean updateTask(Task task);
	    boolean deleteTask(int id);
}



