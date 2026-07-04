<% request.setAttribute("activePage", "reports"); %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, model.User, model.Allocation" %>
<%@ include file="/includes/navbar.jsp" %>
<%@ include file="/includes/sidebar-admin.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Performance Report - STASYNC</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/chart.js@3.7.1/dist/chart.min.js" rel="stylesheet">
    <link href="includes/style.css" rel="stylesheet">
</head>
<body>
    <div class="main-content" id="mainContent">
        <div class="container-fluid mt-5 pt-4">
            <div class="row mb-4">
                <div class="col-12 d-flex justify-content-between align-items-center">
                    <h2 class="text-success"><i class="bi bi-people me-2"></i>User Performance Report</h2>
                    <div>
                        <button class="btn btn-outline-success me-2" onclick="printReport()">
                            <i class="bi bi-printer me-1"></i> Print Report
                        </button>
                        <a href="reports" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left me-1"></i> Back to Reports
                        </a>
                    </div>
                </div>
            </div>
            
            <div class="row mb-4">
                <div class="col-md-6 mb-3">
                    <div class="card stat-card bg-primary text-white">
                        <div class="card-body">
                            <div class="stat-number"><%= request.getAttribute("totalUsers") != null ? request.getAttribute("totalUsers") : "0" %></div>
                            <div class="text">Total Users</div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 mb-3">
                    <div class="card stat-card bg-success text-white">
                        <div class="card-body">
                            <div class="stat-number"><%= request.getAttribute("activeUsers") != null ? request.getAttribute("activeUsers") : "0" %></div>
                            <div class="text">Active Staff</div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="row">
                <div class="col-md-6 mb-4">
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0">User Distribution</h5>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <canvas id="userChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div class="col-md-6 mb-4">
                    <div class="card">
                        <div class="card-header bg-success text-white">
                            <h5 class="mb-0">Task Completion by User</h5>
                        </div>
                        <div class="card-body">
                            <div class="chart-container">
                                <canvas id="taskCompletionChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header bg-info text-white">
                            <h5 class="mb-0">User Performance Details</h5>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>User</th>
                                            <th>Role</th>
                                            <th>Tasks Assigned</th>
                                            <th>Completed</th>
                                            <th>In Progress</th>
                                            <th>Pending</th>
                                            <th>Completion Rate</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <% 
                                        List<User> users = (List<User>) request.getAttribute("users");
                                        List<Allocation> allocations = (List<Allocation>) request.getAttribute("allocations");
                                        
                                        // Check if we have any staff users
                                        boolean hasStaffUsers = false;
                                        if (users != null) {
                                            for (User user : users) {
                                                if ("staff".equals(user.getRole())) {
                                                    hasStaffUsers = true;
                                                    break;
                                                }
                                            }
                                        }
                                        
                                        if (hasStaffUsers) {
                                            // We have staff users, so display them
                                            for (User user : users) { 
                                                if ("staff".equals(user.getRole())) {
                                                    int assigned = 0;
                                                    int completed = 0;
                                                    int inProgress = 0;
                                                    int pending = 0;
                                                    
                                                    // Add null check for allocations
                                                    if (allocations != null) {
                                                        for (Allocation alloc : allocations) {
                                                            if (alloc.getUserId() == user.getUserId()) {
                                                                assigned++;
                                                                if ("Completed".equals(alloc.getStatus())) {
                                                                    completed++;
                                                                } else if ("In-Progress".equals(alloc.getStatus())) {
                                                                    inProgress++;
                                                                } else if ("Pending".equals(alloc.getStatus())) {
                                                                    pending++;
                                                                }
                                                            }
                                                        }
                                                    }
                                                    
                                                    double completionRate = assigned > 0 ? (completed * 100.0 / assigned) : 0;
                                        %>
                                        <tr>
                                            <td>
                                                <div class="d-flex align-items-center">
                                                    <img src="https://picsum.photos/seed/user<%= user.getUserId() %>/40/40.jpg" alt="Avatar" class="user-avatar me-2">
                                                    <%= user.getName() != null ? user.getName() : "N/A" %>
                                                </div>
                                            </td>
                                            <td><%= user.getRole() %></td>
                                            <td><%= assigned %></td>
                                            <td><%= completed %></td>
                                            <td><%= inProgress %></td>
                                            <td><%= pending %></td>
                                            <td>
                                                <div class="progress" style="height: 20px;">
                                                    <div class="progress-bar bg-success" role="progressbar" style="width: <%= completionRate %>%" aria-valuenow="<%= completionRate %>" aria-valuemin="0" aria-valuemax="100">
                                                        <%= String.format("%.1f", completionRate) %>%
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <%       }
                                               }
                                           } else { %>
                                        <tr>
                                            <td colspan="7" class="text-center text-muted py-4">
                                                <i class="bi bi-people fs-1 mb-2"></i>
                                                <p>No staff users available.</p>
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
            
            // User Distribution Chart
            const userCtx = document.getElementById('userChart').getContext('2d');
            const userChart = new Chart(userCtx, {
                type: 'pie',
                data: {
                    labels: ['Admin', 'Staff'],
                    datasets: [{
                        data: [
                            <%= request.getAttribute("totalUsers") != null && request.getAttribute("activeUsers") != null ? 
                                Integer.parseInt(request.getAttribute("totalUsers").toString()) - Integer.parseInt(request.getAttribute("activeUsers").toString()) : 0 %>,
                            <%= request.getAttribute("activeUsers") != null ? request.getAttribute("activeUsers") : 0 %>
                        ],
                        backgroundColor: [
                            'rgba(220, 53, 69, 0.7)',
                            'rgba(40, 167, 69, 0.7)'
                        ],
                        borderColor: [
                            'rgba(220, 53, 69, 1)',
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
                            text: 'User Distribution'
                        }
                    }
                }
            });
            
            // Task Completion Chart
            const taskCompletionCtx = document.getElementById('taskCompletionChart').getContext('2d');
            
            // Prepare data for the chart
            const userLabels = [];
            const completedData = [];
            const inProgressData = [];
            const pendingData = [];
            
            <%
            List<User> chartUsers = (List<User>) request.getAttribute("users");
            List<Allocation> chartAllocations = (List<Allocation>) request.getAttribute("allocations");
            
            if (chartUsers != null) {
                for (User user : chartUsers) {
                    if ("staff".equals(user.getRole())) {
                        int completed = 0;
                        int inProgress = 0;
                        int pending = 0;
                        
                        if (chartAllocations != null) {
                            for (Allocation alloc : chartAllocations) {
                                if (alloc.getUserId() == user.getUserId()) {
                                    if ("Completed".equals(alloc.getStatus())) {
                                        completed++;
                                    } else if ("In-Progress".equals(alloc.getStatus())) {
                                        inProgress++;
                                    } else if ("Pending".equals(alloc.getStatus())) {
                                        pending++;
                                    }
                                }
                            }
                        }
                        
                        String userName = user.getName() != null ? user.getName() : "User " + user.getUserId();
                        // Escape quotes for JavaScript
                        userName = userName.replace("'", "\\'");
            %>
                        userLabels.push('<%= userName %>');
                        completedData.push(<%= completed %>);
                        inProgressData.push(<%= inProgress %>);
                        pendingData.push(<%= pending %>);
            <%
                    }
                }
            }
            %>
            
            // Task Completion Chart
            const taskCompletionChart = new Chart(taskCompletionCtx, {
                type: 'bar',
                data: {
                    labels: userLabels,
                    datasets: [
                        {
                            label: 'Completed',
                            data: completedData,
                            backgroundColor: 'rgba(40, 167, 69, 0.7)',
                            borderColor: 'rgba(40, 167, 69, 1)',
                            borderWidth: 1
                        },
                        {
                            label: 'In Progress',
                            data: inProgressData,
                            backgroundColor: 'rgba(255, 193, 7, 0.7)',
                            borderColor: 'rgba(255, 193, 7, 1)',
                            borderWidth: 1
                        },
                        {
                            label: 'Pending',
                            data: pendingData,
                            backgroundColor: 'rgba(220, 53, 69, 0.7)',
                            borderColor: 'rgba(220, 53, 69, 1)',
                            borderWidth: 1
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        x: {
                            stacked: false,
                            title: {
                                display: true,
                                text: 'Users'
                            }
                        },
                        y: {
                            beginAtZero: true,
                            title: {
                                display: true,
                                text: 'Number of Tasks'
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            position: 'top',
                        },
                        title: {
                            display: true,
                            text: 'Task Completion by User'
                        }
                    }
                }
            });
        });
    </script>
</body>
</html>