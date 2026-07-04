	<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>STASYNC - Login | Pooja Computer Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="css/styles.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }
        
        .login-container {
            min-height: 100vh;
            display: flex;			
            align-items: center;
            justify-content: center;
        }
        
        .login-card {
            width: 450px;
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            overflow: hidden;
            animation: slideInDown 0.8s ease-out;
        }
        
        .card-header {
            background: linear-gradient(90deg, #007bff, #0056b3);
            color: white;
            padding: 1.5rem;
            text-align: center;
        }
        
        .card-body {
            padding: 2rem;
        }
        
        .form-control {
            border-radius: 8px;
            border: 1px solid #ddd;
            padding: 0.75rem;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0,123,255,0.25);
            transform: translateY(-2px);
        }
        
        .btn-login {
            background: linear-gradient(90deg, #007bff, #0056b3);
            border: none;
            border-radius: 8px;
            padding: 0.75rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,123,255,0.3);
        }
        
        .shop-info {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            padding: 1rem;
            background: rgba(255,255,255,0.9);
            border-bottom: 1px solid #ddd;
            text-align: center;
            font-size: 0.9rem;
        }
        
        .shop-info a {
            color: #007bff;
            text-decoration: none;
            font-weight: 500;
        }
        
        .shop-info a:hover {
            text-decoration: underline;
        }
        
        @keyframes slideInDown {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @media (max-width: 768px) {
            .login-card {
                width: 90%;
            }
        }
    </style>
</head>
<body>
    <div class="shop-info">
        <i class="bi bi-building me-1"></i> Pooja Computer Shop | 
        <i class="bi bi-geo-alt me-1"></i> Shop No. 123, Main Market | 
        <i class="bi bi-telephone me-1"></i> +91-XXXXXXXXXX
    </div>
    
    <div class="login-container">
        <div class="card login-card">
            <div class="card-header">
                <h3 class="mb-0"><i class="bi bi-shield-lock me-2"></i>STASYNC Login</h3>
            </div>
            <div class="card-body">
                <p class="text-center text-muted mb-4">Sign in to manage tasks for Pooja Computer Shop</p>
                <form method="post" action="login">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Username</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-person"></i></span>
                            <input type="text" class="form-control" name="username" placeholder="Enter username" required>
                        </div>
                    </div>
                    <div class="mb-4">
                        <label class="form-label fw-bold">Password</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-lock"></i></span>
                            <input type="password" class="form-control" name="password" placeholder="Enter password" required>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary btn-login w-100 mb-3">
                        Login <i class="bi bi-arrow-right ms-2"></i>
                    </button>
                </form>
                
                <% if (request.getParameter("error") != null) { %>
                    <div class="alert alert-danger d-flex align-items-center" role="alert">
                        <i class="bi bi-exclamation-triangle me-2"></i>
                        <div><%= request.getParameter("error") %></div>
                    </div>
                <% } %>
                
                <div class="text-center mt-4">
                    <small class="text-muted">New user? <a href="registration.jsp" class="text-primary">Register here</a></small>
                </div>
                
                <div class="text-center mt-3">
                    <small class="text-muted">© 2023 STASYNC Task Management System</small>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>