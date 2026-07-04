<% request.setAttribute("activePage", "reports"); %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/includes/navbar.jsp" %>
<%@ include file="/includes/sidebar-admin.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports - STASYNC</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="includes/style.css" rel="stylesheet">
</head>

<body>
    <div class="main-content" id="mainContent">
        <div class="container-fluid page-container">

            <div class="row">
                <div class="col-12">
                    <h2 class="page-title">
                        <i class="bi bi-file-earmark-text me-2"></i>Reports
                    </h2>
                </div>
            </div>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger d-flex align-items-center" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>
                    <div><%= request.getAttribute("error") %></div>
                </div>
            <% } %>

            <div class="row">
                <div class="col-md-6 mb-4">
                    <div class="card report-card" onclick="window.location.href='reports?type=taskSummary'">
                        <div class="card-body text-center">
                            <i class="bi bi-list-task report-icon-primary"></i>
                            <h5 class="card-title">Task Summary Report</h5>
                            <p class="card-text">Generate a comprehensive report of all tasks including their status, priority, and completion rates.</p>
                            <button class="btn btn-primary">Generate Report</button>
                        </div>
                    </div>
                </div>

                <div class="col-md-6 mb-4">
                    <div class="card report-card" onclick="window.location.href='reports?type=userPerformance'">
                        <div class="card-body text-center">
                            <i class="bi bi-people report-icon-success"></i>
                            <h5 class="card-title">User Performance Report</h5>
                            <p class="card-text">Analyze staff performance based on task completion rates and efficiency metrics.</p>
                            <button class="btn btn-success">Generate Report</button>
                        </div>
                    </div>
                </div>
            </div>

            <div class="row section-spacing">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header report-info-header">
                            <h5 class="mb-0">
                                <i class="bi bi-info-circle me-2"></i>Report Information
                            </h5>
                        </div>

                        <div class="card-body">
                            <h6>Task Summary Report</h6>
                            <p>This report provides an overview of all tasks in the system, including:</p>
                            <ul>
                                <li>Total number of tasks by priority level</li>
                                <li>Task completion rates</li>
                                <li>Tasks by status (Pending, In-Progress, Completed)</li>
                                <li>Task distribution by type</li>
                            </ul>

                            <h6>User Performance Report</h6>
                            <p>This report analyzes staff performance based on:</p>
                            <ul>
                                <li>Number of tasks assigned to each staff member</li>
                                <li>Task completion rates by staff member</li>
                                <li>Average time to complete tasks</li>
                                <li>Staff efficiency metrics</li>
                            </ul>

                            <div class="alert alert-info mt-3">
                                <i class="bi bi-lightbulb me-2"></i>
                                <strong>Tip:</strong> Reports can be exported to PDF or Excel for sharing with management.
                            </div>

                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
