<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - STASYNC</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <div class="alert alert-danger text-center">
            <h2>Oops! Something went wrong.</h2>
            <p><%= request.getAttribute("error") != null ? request.getAttribute("error") : "An unexpected error occurred." %></p>
            <a href="login.jsp" class="btn btn-primary">Back to Login</a>
        </div>
    </div>
</body>
</html>