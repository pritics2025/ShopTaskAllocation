<%@page import="model.Allocation"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.text.SimpleDateFormat" %>
<%@ include file="/includes/navbar.jsp" %>
<%@ include file="/includes/sidebar-staff.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Allocations - STASYNC</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="includes/style.css" rel="stylesheet">
</head>
<body>
    <div class="main-content" id="mainContent">
        <div class="container-fluid mt-5 pt-4">

            <div class="row">
                <div class="col-12">
                    <h2 class="mb-4 text-success page-title"><i class="bi bi-list-task me-2"></i>My Allocations</h2>
                </div>
            </div>

            <% if (request.getAttribute("success") != null) { %>
                <div class="alert alert-success d-flex align-items-center" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i>
                    <div><%= request.getAttribute("success") %></div>
                </div>
            <% } %>

            <% if (request.getAttribute("error") != null) { %>
                <div class="alert alert-danger d-flex align-items-center" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>
                    <div><%= request.getAttribute("error") %></div>
                </div>
            <% } %>

            <!-- Allocations Table -->
            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-header table-header-success">
                            <h5 class="mb-0"><i class="bi bi-clipboard-check me-2"></i>All My Allocations</h5>
                        </div>

                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Task Name</th>
                                            <th>Status</th>
                                            <th>Assigned Date</th>
                                            <th>Deadline</th>
                                            <th>Priority</th>
                                            <th>Comments</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>

                                        <% 
                                           List<Allocation> allocations = (List<Allocation>) request.getAttribute("allocations");
                                           SimpleDateFormat dateFormat = (SimpleDateFormat) request.getAttribute("dateFormat");

                                           if (allocations != null && !allocations.isEmpty()) {
                                               for (Allocation alloc : allocations) { 
                                        %>

                                            <tr class="<%= 
                                                "high".equals(alloc.getTaskPriority()) ? "priority-high" :
                                                "medium".equals(alloc.getTaskPriority()) ? "priority-medium" :
                                                "priority-low" 
                                            %>">

                                                <td><%= alloc.getAllocationId() %></td>

                                                <td>
                                                    <strong><%= alloc.getTaskName() != null ? alloc.getTaskName() : "Unknown Task" %></strong>
                                                </td>

                                                <td>
                                                    <span class="badge status-badge-<%= alloc.getStatus() %>">
                                                        <%= alloc.getStatus() != null ? alloc.getStatus() : "Pending" %>
                                                    </span>
                                                </td>

                                                <td><%= alloc.getAssignedDate() != null ? dateFormat.format(alloc.getAssignedDate()) : "N/A" %></td>
                                                <td><%= alloc.getTaskDeadline() != null ? dateFormat.format(alloc.getTaskDeadline()) : "No Deadline" %></td>

                                                <td>
                                                    <span class="badge priority-badge-<%= alloc.getTaskPriority() %>">
                                                        <%= alloc.getTaskPriority() != null ? alloc.getTaskPriority() : "N/A" %>
                                                    </span>
                                                </td>

                                                <td><%= alloc.getComments() != null ? alloc.getComments() : "" %></td>

                                                <td>
                                                    <% if (!"Completed".equals(alloc.getStatus())) { %>

                                                        <form method="post" action="staffAllocations" class="status-form">
                                                            <input type="hidden" name="action" value="updateStatus">
                                                            <input type="hidden" name="allocationId" value="<%= alloc.getAllocationId() %>">

                                                            <select name="status" class="form-select form-select-sm"></select>

                                                            <input type="text" 
                                                                   name="comments" 
                                                                   class="form-control form-control-sm comment-input"
                                                                   placeholder="Comments"
                                                                   value="<%= alloc.getComments() != null ? alloc.getComments() : "" %>">

                                                            <button type="submit" class="btn btn-sm btn-primary">Update</button>
                                                        </form>

                                                    <% } else { %>
                                                        <span class="text-success"><i class="bi bi-check-circle-fill"></i> Completed</span>
                                                    <% } %>
                                                </td>
                                            </tr>

                                        <%   }
                                           } else { %>

                                            <tr>
                                                <td colspan="8" class="text-center no-data-cell">
                                                    <i class="bi bi-inbox no-data-icon"></i>
                                                    <p>No allocations assigned yet.</p>
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

            <!-- Summary Cards -->
            <div class="row summary-row">

                <div class="col-md-4 mb-3">
                    <div class="card allocation-card bg-primary text-white text-center">
                        <div class="card-body">
                            <i class="bi bi-list-task info-icon"></i>
                            <h5>Total Allocations</h5>
                            <% int totalCount = allocations != null ? allocations.size() : 0; %>
                            <h3><%= totalCount %></h3>
                        </div>
                    </div>
                </div>

                <div class="col-md-4 mb-3">
                    <div class="card allocation-card bg-warning text-white text-center">
                        <div class="card-body">
                            <i class="bi bi-clock-history info-icon"></i>
                            <h5>Pending Tasks</h5>
                            <% int pending = 0;
                               if (allocations != null)
                                   for (Allocation a : allocations)
                                       if ("Pending".equals(a.getStatus())) pending++;
                            %>
                            <h3><%= pending %></h3>
                        </div>
                    </div>
                </div>

                <div class="col-md-4 mb-3">
                    <div class="card allocation-card bg-success text-white text-center">
                        <div class="card-body">
                            <i class="bi bi-check2-square info-icon"></i>
                            <h5>Completed Tasks</h5>
                            <% int completed = 0;
                               if (allocations != null)
                                   for (Allocation a : allocations)
                                       if ("Completed".equals(a.getStatus())) completed++;
                            %>
                            <h3><%= completed %></h3>
                        </div>
                    </div>
                </div>

            </div>

        </div>
    </div>
</body>
</html>
