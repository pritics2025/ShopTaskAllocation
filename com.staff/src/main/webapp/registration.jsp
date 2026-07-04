<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>STASYNC - Register | Pooja Computer Shop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="css/styles.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
            min-height: 100vh;
        }
        
        .register-container {
        margin-top;100px;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 0;
        }
        
        .register-card {
        margin-top:50px;
            width: 500px;
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
        
        .form-control, .form-select {
            border-radius: 8px;
            border: 1px solid #ddd;
            padding: 0.75rem;
            transition: all 0.3s ease;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0,123,255,0.25);
            transform: translateY(-2px);
        }
        
        .btn-register {
            background: linear-gradient(90deg, #007bff, #0056b3);
            border: none;
            border-radius: 8px;
            padding: 0.75rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-register:hover {
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
        
        .form-floating label {
            color: #6c757d;
        }
        
        @keyframes slideInDown {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        @media (max-width: 768px) {
            .register-card {
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
    
    <div class="register-container">
        <div class="card register-card">
            <div class="card-header">
                <h3 class="mb-0"><i class="bi bi-person-plus me-2"></i>STASYNC Registration</h3>
            </div>
            <div class="card-body">
                <p class="text-center text-muted mb-4">Join Pooja Computer Shop's task management system</p>
                <form method="post" action="register">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Full Name</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-person-badge"></i></span>
                            <input type="text" class="form-control" name="name" placeholder="Enter your full name" required>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold">Username</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-person"></i></span>
                            <input type="text" class="form-control" name="username" placeholder="Choose a username" required>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold">Password</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-lock"></i></span>
                            <input type="password" class="form-control" name="password" placeholder="Enter a secure password" required>
                        </div>
                    </div>
                    
                    <div class="mb-3">
                        <label class="form-label fw-bold">Role</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-person-workspace"></i></span>
                            <select class="form-select" name="role" required>
                                <option value="">Select Role</option>
                                <option value="staff">Staff Member</option>
                                <option value="admin">Admin (Shop Owner)</option>
                            </select>
                        </div>
                    </div>
                    
                    <div class="mb-4">
                        <label class="form-label fw-bold">Contact Email/Phone</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                            <input type="text" class="form-control" name="contact" placeholder="e.g., email@poojashop.com or +91-XXXXXXXXXX" required>
                        </div>
                    </div>
                    
                    <button type="submit" class="btn btn-primary btn-register w-100 mb-3">
                        Register <i class="bi bi-check-circle ms-2"></i>
                    </button>
                </form>
                
                <% if (request.getParameter("error") != null) { %>
                    <div class="alert alert-danger d-flex align-items-center" role="alert">
                        <i class="bi bi-exclamation-triangle me-2"></i>
                        <div><%= request.getParameter("error") %></div>
                    </div>
                <% } %>
                
                <% if (request.getAttribute("success") != null) { %>
                    <div class="alert alert-success d-flex align-items-center" role="alert">
                        <i class="bi bi-check-circle me-2"></i>
                        <div><%= request.getAttribute("success") %></div>
                    </div>
                <% } %>
                
                <div class="text-center mt-4">
                    <small class="text-muted">Already registered? <a href="login.jsp" class="text-primary">Login here</a></small>
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