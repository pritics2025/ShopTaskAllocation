<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
    .sidebar {
        position: fixed;
        top: 56px;
        left: 0;
        height: calc(100vh - 56px);
        width: 250px;
        background-color: var(--primary-color);
        color: white;
        transition: all 0.3s ease;
        z-index: 1000;
        overflow-y: auto;
        box-shadow: 2px 0 10px rgba(0,0,0,0.1);
    }
    
    .sidebar.collapsed {
        margin-left: -250px;
    }
    
    .sidebar .nav-link {
        color: rgba(255,255,255,0.8);
        padding: 0.8rem 1rem;
        border-radius: 0;
        transition: all 0.3s ease;
        display: flex;
        align-items: center;
    }
    
    .sidebar .nav-link:hover {
        background-color: var(--accent-color);
        color: white;
    }
    
    .sidebar .nav-link.active {
        background-color: var(--accent-color);
        color: white;
        border-left: 4px solid white;
    }
    
    .sidebar .nav-link i {
        margin-right: 10px;
        width: 20px;
        text-align: center;
    }
    
    .sidebar .nav-header {
        padding: 1rem;
        text-transform: uppercase;
        font-size: 0.8rem;
        font-weight: 600;
        color: rgba(255,255,255,0.6);
        letter-spacing: 1px;
    }
    
    .sidebar .divider {
        height: 1px;
        background-color: rgba(255,255,255,0.1);
        margin: 0.5rem 0;
    }
    
    @media (max-width: 768px) {
        .sidebar {
            margin-left: -250px;
        }
        .sidebar.show {
            margin-left: 0;
        }
    }
</style>

<div id="sidebar" class="sidebar">
    <div class="position-sticky pt-3">
        <div class="px-3 mb-4">
            <h5 class="text-white"><i class="fas fa-user-tie me-2"></i>Staff Panel</h5>
        </div>
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link <%= "staff".equals(request.getAttribute("activePage")) ? "active" : "" %>" href="staff">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= "staffAllocations".equals(request.getAttribute("activePage")) ? "active" : "" %>" href="staffAllocations">
                    <i class="fas fa-tasks"></i> My Allocations
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= "staffNotifications".equals(request.getAttribute("activePage")) ? "active" : "" %>" href="staffNotifications">
                    <i class="fas fa-bell"></i> Notifications
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link <%= "staffProfile".equals(request.getAttribute("activePage")) ? "active" : "" %>" href="staffProfile">
                    <i class="fas fa-user-circle"></i> My Profile
                </a>
            </li>
            <li class="nav-item mt-auto">
                <a class="nav-link" href="logout">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </a>
            </li>
        </ul>
    </div>
</div>

<!-- Sidebar Toggle Button -->
<button class="btn btn-primary position-fixed top-0 start-0 mt-5 ms-3 d-md-none" id="sidebarToggleMobile">
    <i class="fas fa-bars"></i>
</button>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const sidebarToggle = document.getElementById('sidebarToggle');
        const sidebarToggleMobile = document.getElementById('sidebarToggleMobile');
        const sidebar = document.getElementById('sidebar');
        
        if (sidebarToggle) {
            sidebarToggle.addEventListener('click', function() {
                sidebar.classList.toggle('collapsed');
            });
        }
        
        if (sidebarToggleMobile) {
            sidebarToggleMobile.addEventListener('click', function() {
                sidebar.classList.toggle('show');
            });
        }
    });
</script>