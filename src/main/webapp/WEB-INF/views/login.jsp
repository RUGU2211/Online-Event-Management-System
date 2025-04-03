<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Event Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/styles.css">
    <style>
        .login-container {
            max-width: 450px;
            margin: 50px auto;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            background-color: #fff;
        }
        .social-login {
            margin-top: 20px;
            text-align: center;
        }
        .google-btn {
            background-color: #fff;
            color: #757575;
            border: 1px solid #ddd;
            padding: 10px 20px;
            border-radius: 5px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto;
            transition: all 0.3s;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }
        .google-btn:hover {
            background-color: #f1f1f1;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }
        .google-icon {
            margin-right: 10px;
            width: 20px;
        }
        .or-divider {
            display: flex;
            align-items: center;
            margin: 25px 0;
            color: #757575;
        }
        .or-divider::before, .or-divider::after {
            content: "";
            flex: 1;
            border-bottom: 1px solid #ddd;
        }
        .or-divider::before {
            margin-right: 10px;
        }
        .or-divider::after {
            margin-left: 10px;
        }
        .form-control:focus {
            border-color: #6c63ff;
            box-shadow: 0 0 0 0.25rem rgba(108, 99, 255, 0.25);
        }
        .btn-primary {
            background-color: #6c63ff;
            border-color: #6c63ff;
        }
        .btn-primary:hover {
            background-color: #5a52d5;
            border-color: #5a52d5;
        }
        .register-link {
            text-align: center;
            margin-top: 20px;
        }
    </style>
</head>
<body class="bg-light">
<div class="container">
    <div class="login-container">
        <h2 class="text-center mb-4">Log in to Your Account</h2>

        <div id="error-message" class="alert alert-danger d-none" role="alert"></div>

        <form id="login-form">
            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" class="form-control" id="email" name="email" required>
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" id="password" name="password" required>
            </div>
            <div class="mb-3 form-check">
                <input type="checkbox" class="form-check-input" id="remember-me">
                <label class="form-check-label" for="remember-me">Remember me</label>
            </div>
            <div class="mb-3 text-end">
                <a href="${pageContext.request.contextPath}/forgot-password">Forgot password?</a>
            </div>
            <button type="submit" class="btn btn-primary w-100">Login</button>
        </form>

        <div class="or-divider">OR</div>

        <div class="social-login">
            <a href="${pageContext.request.contextPath}/oauth2/authorization/google" class="google-btn">
                <img src="${pageContext.request.contextPath}/resources/images/google-icon.svg" alt="Google" class="google-icon">
                Continue with Google
            </a>
        </div>

        <div class="register-link">
            Don't have an account? <a href="${pageContext.request.contextPath}/register">Register</a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('login-form').addEventListener('submit', function(e) {
        e.preventDefault();

        const email = document.getElementById('email').value;
        const password = document.getElementById('password').value;
        const errorMessage = document.getElementById('error-message');

        // Clear previous error
        errorMessage.classList.add('d-none');

        fetch('${pageContext.request.contextPath}/api/auth/login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                email: email,
                password: password
            })
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Invalid credentials');
                }
                return response.json();
            })
            .then(data => {
                // Save token to localStorage
                localStorage.setItem('token', data.token);
                localStorage.setItem('user', JSON.stringify({
                    id: data.id,
                    name: data.name,
                    email: data.email,
                    profilePicture: data.profilePicture,
                    roles: data.roles
                }));

                // Redirect based on role
                if (data.roles.includes('ROLE_ADMIN')) {
                    window.location.href = '${pageContext.request.contextPath}/admin/dashboard';
                } else if (data.roles.includes('ROLE_ORGANIZER')) {
                    window.location.href = '${pageContext.request.contextPath}/organizer/dashboard';
                } else {
                    window.location.href = '${pageContext.request.contextPath}/';
                }
            })
            .catch(error => {
                errorMessage.textContent = error.message;
                errorMessage.classList.remove('d-none');
            });
    });
</script>
</body>
</html>