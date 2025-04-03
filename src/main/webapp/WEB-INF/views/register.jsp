<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Event Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/styles.css">
    <style>
        .register-container {
            max-width: 500px;
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
        .login-link {
            text-align: center;
            margin-top: 20px;
        }
        .role-selector {
            margin: 20px 0;
            display: flex;
            justify-content: space-between;
        }
        .role-selector .form-check {
            flex: 1;
            padding: 15px;
            border: 1px solid #ddd;
            border-radius: 5px;
            margin: 0 5px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
        }
        .role-selector .form-check:hover {
            background-color: #f9f9f9;
        }
        .role-selector .form-check-input:checked + .form-check-label {
            font-weight: bold;
            color: #6c63ff;
        }
        .role-selector .form-check.selected {
            border-color: #6c63ff;
            background-color: rgba(108, 99, 255, 0.05);
        }
    </style>
</head>
<body class="bg-light">
<div class="container">
    <div class="register-container">
        <h2 class="text-center mb-4">Create Your Account</h2>

        <div id="error-message" class="alert alert-danger d-none" role="alert"></div>
        <div id="success-message" class="alert alert-success d-none" role="alert"></div>

        <form id="register-form">
            <div class="mb-3">
                <label for="name" class="form-label">Full Name</label>
                <input type="text" class="form-control" id="name" name="name" required>
            </div>
            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" class="form-control" id="email" name="email" required>
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" id="password" name="password" required>
                <div class="form-text">Password must be at least 6 characters long.</div>
            </div>
            <div class="mb-3">
                <label for="confirm-password" class="form-label">Confirm Password</label>
                <input type="password" class="form-control" id="confirm-password" name="confirmPassword" required>
            </div>

            <div class="mb-3">
                <label class="form-label">I want to register as:</label>
                <div class="role-selector">
                    <div class="form-check" onclick="selectRole(this, 'attendee')">
                        <input class="form-check-input" type="radio" name="role" id="role-attendee" value="attendee" checked>
                        <label class="form-check-label" for="role-attendee">Attendee</label>
                        <div class="mt-2 small">Find and book events</div>
                    </div>
                    <div class="form-check" onclick="selectRole(this, 'organizer')">
                        <input class="form-check-input" type="radio" name="role" id="role-organizer" value="organizer">
                        <label class="form-check-label" for="role-organizer">Organizer</label>
                        <div class="mt-2 small">Create and manage events</div>
                    </div>
                </div>
            </div>

            <div class="mb-3 form-check">
                <input type="checkbox" class="form-check-input" id="terms" required>
                <label class="form-check-label" for="terms">I agree to the <a href="${pageContext.request.contextPath}/terms">Terms of Service</a> and <a href="${pageContext.request.contextPath}/privacy">Privacy Policy</a></label>
            </div>

            <button type="submit" class="btn btn-primary w-100">Register</button>
        </form>

        <div class="or-divider">OR</div>

        <div class="social-login">
            <a href="${pageContext.request.contextPath}/oauth2/authorization/google" class="google-btn">
                <img src="${pageContext.request.contextPath}/resources/images/google-icon.svg" alt="Google" class="google-icon">
                Continue with Google
            </a>
        </div>

        <div class="login-link">
            Already have an account? <a href="${pageContext.request.contextPath}/login">Login</a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function selectRole(element, role) {
        // Remove selected class from all role options
        document.querySelectorAll('.role-selector .form-check').forEach(el => {
            el.classList.remove('selected');
        });

        // Add selected class to clicked element
        element.classList.add('selected');

        // Check the radio button
        document.getElementById('role-' + role).checked = true;
    }

    document.getElementById('register-form').addEventListener('submit', function(e) {
        e.preventDefault();

        const name = document.getElementById('name').value;
        const email = document.getElementById('email').value;
        const password = document.getElementById('password').value;
        const confirmPassword = document.getElementById('confirm-password').value;
        const role = document.querySelector('input[name="role"]:checked').value;
        const errorMessage = document.getElementById('error-message');
        const successMessage = document.getElementById('success-message');

        // Clear previous messages
        errorMessage.classList.add('d-none');
        successMessage.classList.add('d-none');

        // Validate passwords match
        if (password !== confirmPassword) {
            errorMessage.textContent = 'Passwords do not match';
            errorMessage.classList.remove('d-none');
            return;
        }

        // Validate password length
        if (password.length < 6) {
            errorMessage.textContent = 'Password must be at least 6 characters long';
            errorMessage.classList.remove('d-none');
            return;
        }

        // Prepare roles array
        const roles = [role];

        fetch('${pageContext.request.contextPath}/api/auth/register', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                name: name,
                email: email,
                password: password,
                roles: roles
            })
        })
            .then(response => {
                if (!response.ok) {
                    return response.text().then(text => {
                        throw new Error(text);
                    });
                }
                return response.text();
            })
            .then(data => {
                successMessage.textContent = 'Registration successful! Redirecting to login...';
                successMessage.classList.remove('d-none');

                // Reset form
                document.getElementById('register-form').reset();

                // Redirect to login page after 2 seconds
                setTimeout(() => {
                    window.location.href = '${pageContext.request.contextPath}/login';
                }, 2000);
            })
            .catch(error => {
                try {
                    const errorData = JSON.parse(error.message);
                    errorMessage.textContent = errorData.message || 'Registration failed';
                } catch (e) {
                    errorMessage.textContent = error.message || 'Registration failed';
                }
                errorMessage.classList.remove('d-none');
            });
    });
</script>
</body>
</html>