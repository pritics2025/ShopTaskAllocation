<% request.setAttribute("activePage", "reports"); %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.Task, model.Allocation" %>
<%@ include file="/includes/navbar.jsp" %>
<%@ include file="/includes/sidebar-admin.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Task Summary Report - STASYNC</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/npm/chart.js@3.7.1/dist/chart.min.js" rel="stylesheet">
    <link href="includes/style.css" rel="stylesheet">
</head>
<body>
    <div class="main-content" id="mainContent">
        <div class="container-fluid mt-5 pt-4">
            <div class="row mb-4">
                <div class="col-12 d-flex justify-content-between align-items-center">
                    <h2 class="text-primary"><i class="bi bi-file-earmark-text me-2"></i>Task Summary Report</h2>
                    <div>
                        <button class="btn btn-outline-primary me-2" onclick="printReport()">
                            <i class="bi bi-printer me-1"></i> Print Report
                        </button>
                        <a href="reports" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left me-1"></i> Back to Reports
                        </a>
                    </div>
                </div>
            </div>
            
            <div class="row mb-4">
                <div class="col-md-3 mb-3">
                    <div class="card stat-card bg-primary text-white">
                        <div class="card-body">
                            <div class="stat-number"><%= request.getAttribute("totalTasks") != null ? request.getAttribute("totalTasks") : "0" %></div>
                            <div class="text">Total Tasks</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="card stat-card bg-danger text-white">
                        <div class="card-body">
                            <div class="stat-number"><%= request.getAttribute("highPriorityTasks") != null ? request.getAttribute("highPriorityTasks") : "0" %></div>
                            <div class="text">High Priority</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="card stat-card bg-warning text-white">
                        <div class="card-body">
                            <div class="stat-number"><%= request.getAttribute("mediumPriorityTasks") != null ? request.getAttribute("mediumPriorityTasks") : "0" %></div>
                            <div class="text">Medium Priority</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-3 mb-3">
                    <div class="card stat-card bg-success text-white">
                        <div class="card-body">
                            <div class="stat-number"><%= request.getAttribute("lowPriorityTasks") != null ? request.getAttribute("lowPriorityTasks") : "0" %></div>
                            <div class="text">Low Priority</div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="row mb-4">
                <div class="col-md-4 mb-3">
                    <div class="card stat-card bg-success text-white">
                        <div class="card-body">
                            <div class="stat-number"><%= request.getAttribute("completedTasks") != null ? request.getAttribute("completedTasks") : "0" %></div>
                            <div class="text">Completed Tasks</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-3">
                    <div class="card stat-card bg-info text-white">
                        <div class="card-body">
                            <div class="stat-number"><%= request.getAttribute("inProgressTasks") != null ? request.getAttribute("inProgressTasks") : "0" %></div>
                            <div class="text">In Progress</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-4 mb-3">
                    <div class="card stat-card bg-secondary text-white">
                        <div class="card-body">
                            <div class="stat-number"><%= request.getAttribute("pendingTasks") != null ? request.getAttribute("pendingTasks") : "0" %></div>
                            <div class="text">Pending Tasks</div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="row">
                <div class="col-md-6 mb-4">
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0">Task Distribution by Priority</h5>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <canvas id="priorityChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-6 mb-4">
                    <div class="card">
                        <div class="card-header bg-success text-white">
                            <h5 class="mb-0">Task Status Distribution</h5>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <canvas id="statusChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header bg-info text-white">
                            <h5 class="mb-0">Task Details</h5>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Task Name</th>
                                            <th>Priority</th>
                                            <th>Type</th>
                                            <th>Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                       <% 
List<Task> tasks = (List<Task>) request.getAttribute("tasks");
List<Allocation> allocations = (List<Allocation>) request.getAttribute("allocations");

if (tasks != null && !tasks.isEmpty()) {
    for (Task task : tasks) { 
        // Find allocation for this task
        String status = "Not Assigned";
        // Add null check for allocations
        if (allocations != null) {
            for (Allocation alloc : allocations) { 
                if (alloc.getTaskId() == task.getTaskId()) {
                    status = alloc.getStatus();
                    break;
                }
            }
        }
%>
                                        <tr>
                                            <td><%= task.getTaskId() %></td>
                                            <td><%= task.getTaskName() != null ? task.getTaskName() : "N/A" %></td>
                                            <td>
                                                <span class="badge bg-<%= "high".equals(task.getPriority()) ? "danger" : "medium".equals(task.getPriority()) ? "warning" : "success" %>">
                                                    <%= task.getPriority() != null ? task.getPriority() : "N/A" %>
                                                </span>
                                            </td>
                                            <td><%= task.getTaskType() != null ? task.getTaskType() : "N/A" %></td>
                                            <td>
                                                <span class="badge bg-<%= "Completed".equals(status) ? "success" : "In-Progress".equals(status) ? "info" : "secondary" %>">
                                                    <%= status %>
                                                </span>
                                            </td>
                                        </tr>
                                        <%   }
                                           } else { %>
                                        <tr>
                                            <td colspan="6" class="text-center text-muted py-4">
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
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script>
        function printReport() {
            // Hide elements we don't want to print
            const elementsToHide = document.querySelectorAll('.sidebar, .btn, .no-print, .navbar');
            elementsToHide.forEach(el => {
                el.classList.add('print-hidden');
            });
            
            // Print the page
            window.print();
            
            // Show the elements again after printing
            setTimeout(() => {
                elementsToHide.forEach(el => {
                    el.classList.remove('print-hidden');
                });
            }, 1000);
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
            
            // Task Priority Chart
            const priorityCtx = document.getElementById('priorityChart').getContext('2d');
            const priorityChart = new Chart(priorityCtx, {
                type: 'pie',
                data: {
                    labels: ['High Priority', 'Medium Priority', 'Low Priority'],
                    datasets: [{
                        data: [
                            <%= request.getAttribute("highPriorityTasks") != null ? request.getAttribute("highPriorityTasks") : 0 %>,
                            <%= request.getAttribute("mediumPriorityTasks") != null ? request.getAttribute("mediumPriorityTasks") : 0 %>,
                            <%= request.getAttribute("lowPriorityTasks") != null ? request.getAttribute("lowPriorityTasks") : 0 %>
                        ],
                        backgroundColor: [
                            'rgba(220, 53, 69, 0.7)',
                            'rgba(255, 193, 7, 0.7)',
                            'rgba(40, 167, 69, 0.7)'
                        ],
                        borderColor: [
                            'rgba(220, 53, 69, 1)',
                            'rgba(255, 193, 7, 1)',
                            'rgba(40, 167, 69, 1)'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                        },
                        title: {
                            display: true,
                            text: 'Task Distribution by Priority'
                        }
                    }
                }
            });
            
            // Task Status Chart
            const statusCtx = document.getElementById('statusChart').getContext('2d');
            const statusChart = new Chart(statusCtx, {
                type: 'doughnut',
                data: {
                    labels: ['Completed', 'In Progress', 'Pending'],
                    datasets: [{
                        data: [
                            <%= request.getAttribute("completedTasks") != null ? request.getAttribute("completedTasks") : 0 %>,
                            <%= request.getAttribute("inProgressTasks") != null ? request.getAttribute("inProgressTasks") : 0 %>,
                            <%= request.getAttribute("pendingTasks") != null ? request.getAttribute("pendingTasks") : 0 %>
                        ],
                        backgroundColor: [
                            'rgba(40, 167, 69, 0.7)',
                            'rgba(23, 162, 184, 0.7)',
                            'rgba(108, 117, 125, 0.7)'
                        ],
                        borderColor: [
                            'rgba(40, 167, 69, 1)',
                            'rgba(23, 162, 184, 1)',
                            'rgba(108, 117, 125, 1)'
                        ],
                        borderWidth: 1
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom',
                        },
                        title: {
                            display: true,
                            text: 'Task Status Distribution'
                        }
                    }
                }
            });
        });
    </script>
</body>
</html>