<%@page import="model.Task"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ include file="/includes/navbar.jsp" %>
<%@ include file="/includes/sidebar-admin.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Tasks - STASYNC</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="includes/style.css" rel="stylesheet">
</head>
<body>
    <div class="main-content" id="mainContent">
        <div class="container-fluid mt-5 pt-4">
            <div class="row">
                <div class="col-12">
                    <h2 class="mb-4 text-primary"><i class="bi bi-list-task me-2"></i>Manage Tasks</h2>
                </div>
            </div>
            
            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success"><%= request.getAttribute("success") %></div>
            <% } %>
            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
            <% } %>
            
            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                            <h5 class="mb-0"><i class="bi bi-clipboard-check me-2"></i>All Tasks</h5>
                            <button class="btn btn-light" data-bs-toggle="modal" data-bs-target="#addTaskModal">
                                <i class="bi bi-plus-circle me-1"></i> Add New Task
                            </button>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Task Name</th>
                                            <th>Description</th>
                                            <th>Priority</th>
                                            <th>Type</th>
                                            <th>Deadline</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% List<Task> tasks = (List<Task>) request.getAttribute("tasks");
                                           if (tasks != null && !tasks.isEmpty()) {
                                               for (Task task : tasks) { %>
                                            <tr>
                                                <td><%= task.getTaskId() %></td>
                                                <td><%= task.getTaskName() != null ? task.getTaskName() : "N/A" %></td>
                                                <td><%= task.getDescription() != null ? task.getDescription() : "N/A" %></td>
                                                <td>
                                                    <span class="badge bg-<%= "high".equals(task.getPriority()) ? "danger" : "medium".equals(task.getPriority()) ? "warning" : "success" %>">
                                                        <%= task.getPriority() != null ? task.getPriority() : "N/A" %>
                                                    </span>
                                                </td>
                                                <td><%= task.getTaskType() != null ? task.getTaskType() : "N/A" %></td>
                                                <td><%= task.getDeadline() != null ? task.getDeadline() : "No Deadline" %></td>
                                                <td>
                                                    <button class="btn btn-sm btn-outline-primary" data-bs-toggle="modal" data-bs-target="#editTaskModal<%= task.getTaskId() %>">
                                                        <i class="bi bi-pencil"></i> Edit
                                                    </button>
                                                    <button class="btn btn-sm btn-outline-danger ms-1" onclick="confirmDelete(<%= task.getTaskId() %>)">
                                                        <i class="bi bi-trash"></i> Delete
                                                    </button>
                                                </td>
                                            </tr>
                                            
                                            <!-- Edit Task Modal -->
                                            <div class="modal fade" id="editTaskModal<%= task.getTaskId() %>" tabindex="-1" aria-hidden="true">
                                                <div class="modal-dialog">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title">Edit Task</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <form action="manageTasks" method="post">
                                                                <input type="hidden" name="action" value="updateTask">
                                                                <input type="hidden" name="taskId" value="<%= task.getTaskId() %>">
                                                                <div class="mb-3">
                                                                    <label for="taskName<%= task.getTaskId() %>" class="form-label">Task Name</label>
                                                                    <input type="text" class="form-control" id="taskName<%= task.getTaskId() %>" name="taskName" value="<%= task.getTaskName() != null ? task.getTaskName() : "" %>" required>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label for="description<%= task.getTaskId() %>" class="form-label">Description</label>
                                                                    <textarea class="form-control" id="description<%= task.getTaskId() %>" name="description" rows="3"><%= task.getDescription() != null ? task.getDescription() : "" %></textarea>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label for="priority<%= task.getTaskId() %>" class="form-label">Priority</label>
                                                                    <select class="form-select" id="priority<%= task.getTaskId() %>" name="priority" required>
                                                                        <option value="high" <%= "high".equals(task.getPriority()) ? "selected" : "" %>>High</option>
                                                                        <option value="medium" <%= "medium".equals(task.getPriority()) ? "selected" : "" %>>Medium</option>
                                                                        <option value="low" <%= "low".equals(task.getPriority()) ? "selected" : "" %>>Low</option>
                                                                    </select>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label for="taskType<%= task.getTaskId() %>" class="form-label">Task Type</label>
                                                                    <input type="text" class="form-control" id="taskType<%= task.getTaskId() %>" name="taskType" value="<%= task.getTaskType() != null ? task.getTaskType() : "" %>">
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label for="deadline<%= task.getTaskId() %>" class="form-label">Deadline</label>
                                                                    <input type="datetime-local" class="form-control" id="deadline<%= task.getTaskId() %>" name="deadline" value="<%= task.getDeadline() != null ? task.getDeadline().toString().replace(" ", "T") : "" %>">
                                                                </div>
                                                                <div class="text-end">
                                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                                                    <button type="submit" class="btn btn-primary">Update Task</button>
                                                                </div>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        <%   }
                                           } else { %>
                                            <tr>
                                                <td colspan="7" class="text-center text-muted py-4">
                                                    <i class="bi bi-inbox fs-1 mb-2"></i>
                                                    <p>No tasks available.</p>
                                                </td>
                                            </tr>
                                        <% } %>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Add Task Modal -->
    <div class="modal fade" id="addTaskModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New Task</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="manageTasks" method="post">
                        <input type="hidden" name="action" value="createTask">
                        <div class="mb-3">
                            <label for="taskName" class="form-label">Task Name</label>
                            <input type="text" class="form-control" id="taskName" name="taskName" required>
                        </div>
                        <div class="mb-3">
                            <label for="description" class="form-label">Description</label>
                            <textarea class="form-control" id="description" name="description" rows="3"></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="priority" class="form-label">Priority</label>
                            <select class="form-select" id="priority" name="priority" required>
                                <option value="high">High</option>
                                <option value="medium">Medium</option>
                                <option value="low">Low</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="taskType" class="form-label">Task Type</label>
                            <input type="text" class="form-control" id="taskType" name="taskType">
                        </div>
                        <div class="mb-3">
                            <label for="deadline" class="form-label">Deadline</label>
                           <input type="datetime-local" class="form-control" id="deadline" name="deadline">
                        </div>
                        <div class="text-end">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-primary">Add Task</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Confirm Delete</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <p>Are you sure you want to delete this task? This action cannot be undone.</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <form id="deleteForm" action="manageTasks" method="post" style="display: inline;">
                        <input type="hidden" name="action" value="deleteTask">
                        <input type="hidden" id="deleteTaskId" name="taskId">
                        <button type="submit" class="btn btn-danger">Delete</button>
                    </form>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmDelete(taskId) {
            document.getElementById('deleteTaskId').value = taskId;
            var deleteModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
            deleteModal.show();
        }
        
        document.addEventListener('DOMContentLoaded', function() {
            const sidebarToggle = document.getElementById('sidebarToggle');
            const sidebar = document.getElementById('sidebar');
            const mainContent = document.getElementById('mainContent');
            
            if (sidebarToggle) {
                sidebarToggle.addEventListener('click', function() {
                    sidebar.classList.toggle('show');
                    mainContent.classList.toggle('collapsed');
                });
            }
            
            window.addEventListener('resize', function() {
                if (window.innerWidth > 992) {
                    sidebar.classList.remove('show');
                    mainContent.classList.remove('collapsed');
                }
            });
        });
    </script>
</body>
</html>