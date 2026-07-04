<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>STASYNC - Staff Task Allocation System</title>
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Custom CSS -->
    <link href="css/styles.css" rel="stylesheet">
    
    <style>
        :root {
            --primary-color: #001F3F;    /* Navy Blue */
            --primary-dark: #001730;   /* Dark Navy */
            --primary-light: #E6EBF5;  /* Extra Light Navy */
            --accent-color: #334466;   /* Medium Blue */
            --card-color: #B3C0D9;     /* Light Blue */
            --success-color: #28a745;  /* Green */
            --danger-color: #dc3545;   /* Red */
            --warning-color: #ffc107;  /* Yellow */
            --info-color: #17a2b8;     /* Light Blue */
        }
        
        body {
            font-family: 'Roboto', sans-serif;
            background-color: var(--primary-light);
            color: var(--primary-dark);
            min-height: 100vh;
        }
        
        h1, h2, h3, h4, h5, h6 {
            font-family: 'Montserrat', sans-serif;
            font-weight: 600;
            color: var(--primary-color);
        }
        
        .navbar {
            background-color: var(--primary-color);
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 0.8rem 1rem;
        }
        
        .navbar-brand {
            font-family: 'Montserrat', sans-serif;
            font-weight: 700;
            color: white !important;
            font-size: 1.5rem;
        }
        
        .navbar-nav .nav-link {
            color: rgba(255,255,255,0.85) !important;
            font-weight: 500;
            margin: 0 0.5rem;
            border-radius: 4px;
            transition: all 0.3s ease;
        }
        
        .navbar-nav .nav-link:hover {
            background-color: var(--accent-color);
            color: white !important;
        }
        
        .user-dropdown .dropdown-toggle {
            display: flex;
            align-items: center;
            color: white;
            font-weight: 500;
        }
        
        .user-dropdown .dropdown-toggle:hover {
            color: white;
        }
        
        .user-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            margin-right: 8px;
            border: 2px solid rgba(255,255,255,0.3);
        }
        
        .dropdown-menu {
            border: none;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            border-radius: 8px;
            padding: 0.5rem;
        }
        
        .dropdown-item {
            padding: 0.5rem 1rem;
            border-radius: 4px;
            transition: all 0.2s ease;
        }
        
        .dropdown-item:hover {
            background-color: var(--primary-light);
            color: var(--primary-color);
        }
        
        .dropdown-item i {
            margin-right: 8px;
            width: 16px;
            text-align: center;
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark fixed-top">
        <div class="container-fluid">
            <button id="sidebarToggle" class="btn btn-link text-white d-lg-none">
                <i class="fas fa-bars fs-4"></i>
            </button>
            <a class="navbar-brand" href="<%= "admin".equals(session.getAttribute("role")) ? "admin" : "staff" %>">
                <i class="fas fa-tasks me-2"></i>STASYNC
            </a>
            <div class="ms-auto">
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                            <img src="https://picsum.photos/seed/<%= session.getAttribute("name") != null ? session.getAttribute("name") : "user" %>/32/32.jpg" alt="User Avatar" class="user-avatar">
                            <%= session.getAttribute("name") != null ? session.getAttribute("name") : "User" %>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                            <li><a class="dropdown-item" href="<%= "admin".equals(session.getAttribute("role")) ? "admin" : "staff" %>"><i class="fas fa-tachometer-alt me-2"></i> Dashboard</a></li>
                            <li><a class="dropdown-item" href="<%= "admin".equals(session.getAttribute("role")) ? "adminProfile" : "staffProfile" %>"><i class="fas fa-user-circle me-2"></i> Profile</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item" href="logout"><i class="fas fa-sign-out-alt me-2"></i> Logout</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
    
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>