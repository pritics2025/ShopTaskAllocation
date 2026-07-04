package controller;

import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import implementors.TaskImplements;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Task;
import operations.TaskOperations;

@WebServlet("/manageTasks")
public class ManageTasksServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp?error=Access denied or session expired.");
            return;
        }
        
        System.out.println("ManageTasksServlet: Fetching all tasks");
        
        try {
            TaskOperations ops = new TaskImplements();
            List<Task> tasks = ops.getAllTasks();
            System.out.println("ManageTasksServlet: Fetched " + (tasks != null ? tasks.size() : 0) + " tasks");
            
            request.setAttribute("tasks", tasks != null ? tasks : new java.util.ArrayList<Task>());
            request.getRequestDispatcher("manageTasks.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load tasks: " + e.getMessage());
            request.getRequestDispatcher("manageTasks.jsp").forward(request, response);
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"admin".equals(session.getAttribute("role"))) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        System.out.println("ManageTasksServlet: Processing action: " + action);
        
        if (action == null) {
            request.setAttribute("error", "No action specified.");
            doGet(request, response);
            return;
        }
        
        boolean success = false;
        TaskOperations ops = new TaskImplements();
        
        try {
            if ("createTask".equals(action)) {
                Task task = new Task();
                task.setTaskName(request.getParameter("taskName"));
                task.setDescription(request.getParameter("description"));
                task.setPriority(request.getParameter("priority"));
                task.setTaskType(request.getParameter("taskType"));
                task.setAdminId((Integer) session.getAttribute("userId"));
                
                // Parse deadline
                String deadlineStr = request.getParameter("deadline");
                System.out.println("ManageTasksServlet: Deadline string: " + deadlineStr);
                
                if (deadlineStr != null && !deadlineStr.isEmpty()) {
                    try {
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                        Date date = sdf.parse(deadlineStr);
                        task.setDeadline(new Timestamp(date.getTime()));
                        System.out.println("ManageTasksServlet: Parsed deadline: " + task.getDeadline());
                    } catch (ParseException e) {
                        System.out.println("ManageTasksServlet: Error parsing deadline: " + e.getMessage());
                        request.setAttribute("error", "Invalid deadline format! Please use the date picker.");
                        doGet(request, response);
                        return;
                    }
                }
                
                success = ops.addTask(task);
                System.out.println("ManageTasksServlet: Task creation " + (success ? "successful" : "failed"));
                
            } else if ("updateTask".equals(action)) {
                Task task = new Task();
                task.setTaskId(Integer.parseInt(request.getParameter("taskId")));
                task.setTaskName(request.getParameter("taskName"));
                task.setDescription(request.getParameter("description"));
                task.setPriority(request.getParameter("priority"));
                task.setTaskType(request.getParameter("taskType"));
                
                // Parse deadline
                String deadlineStr = request.getParameter("deadline");
                System.out.println("ManageTasksServlet: Deadline string for update: " + deadlineStr);
                
                if (deadlineStr != null && !deadlineStr.isEmpty()) {
                    try {
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                        Date date = sdf.parse(deadlineStr);
                        task.setDeadline(new Timestamp(date.getTime()));
                        System.out.println("ManageTasksServlet: Parsed deadline for update: " + task.getDeadline());
                    } catch (ParseException e) {
                        System.out.println("ManageTasksServlet: Error parsing deadline for update: " + e.getMessage());
                        request.setAttribute("error", "Invalid deadline format! Please use the date picker.");
                        doGet(request, response);
                        return;
                    }
                }
                
                success = ops.updateTask(task);
                System.out.println("ManageTasksServlet: Task update " + (success ? "successful" : "failed"));
                
            } else if ("deleteTask".equals(action)) {
                int taskId = Integer.parseInt(request.getParameter("taskId"));
                success = ops.deleteTask(taskId);
                System.out.println("ManageTasksServlet: Task deletion " + (success ? "successful" : "failed"));
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
        }
        
        if (success) {
            request.setAttribute("success", "Operation successful!");
        } else {
            request.setAttribute("error", "Operation failed!");
        }
        doGet(request, response);
    }

	public SimpleDateFormat getDateFormat() {
		return dateFormat;
	}

	public void setDateFormat(SimpleDateFormat dateFormat) {
		this.dateFormat = dateFormat;
	}
}