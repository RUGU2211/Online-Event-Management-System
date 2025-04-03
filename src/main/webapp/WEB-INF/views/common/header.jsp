<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<header class="header">
    <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
        <div class="container">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/">
                <img src="${pageContext.request.contextPath}/resources/images/logo.png" alt="EventMS" height="40">
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                    aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/events">Events</a>
                    </li>
                    <li class="nav-item dropdown" id="categories-dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="categoriesDropdown" role="button"
                           data-bs-toggle="dropdown" aria-expanded="false">
                            Categories
                        </a>
                        <ul class="dropdown-menu" aria-labelledby="categoriesDropdown">
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/events/category/CONFERENCE">Conferences</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/events/category/WORKSHOP">Workshops</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/events/category/SEMINAR">Seminars</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/events/category/CULTURAL">Cultural</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/events/category/SPORTS">Sports</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/events/category/MUSIC">Music</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/events/category/TECH">Tech</a></li>
                            <li><a class="dropdown-item" href="${pageContext.request.contextPath}/events/category/OTHER">Others</a></li>
                        </ul>
                    </li>
                    <li class="nav-item d-none" id="organizer-nav">
                        <a class="nav-link" href="${pageContext.request.contextPath}/organizer/dashboard">Organizer Dashboard</a>
                    </li>
                    <li class="nav-item d-none" id="admin-nav">
                        <a class="nav-link" href="${pageContext.request.contextPath}/admin/dashboard">Admin Dashboard</a>
                    </li>
                </ul>

                <form class="d-flex me-3" action="${pageContext.request.contextPath}/events/search" method="GET">
                    <div class="input-group">
                        <input class="form-control" type="search" name="keyword" placeholder="Search events" aria-label="Search">
                        <button class="btn btn-outline-primary" type="submit">
                            <i class="bi bi-search"></i>
                        </button>
                    </div>
                </form>

                <div class="d-flex" id="user-not-logged-in">
                    <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-primary me-2">Login</a>
                    <a href="${pageContext.request.contextPath}/register" class="btn btn-primary">Register</a>
                </div>

                <div class="d-none" id="user-logged-in">
                    <ul class="navbar-nav">
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" id="userDropdown"
                               role="button" data-bs-toggle="dropdown" aria-expanded="false">
                                <img id="user-profile-pic" src="" alt="Profile" class="rounded-circle me-2" style="width: 32px; height: 32px; object-fit: cover;">
                                <span id="user-name"></span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/profile">My Profile</a></li>
                                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/bookings">My Bookings</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="#" id="logout-btn">Logout</a></li>
                            </ul>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </nav>
</header>

<script>
    // Check if user is logged in
    document.addEventListener('DOMContentLoaded', function() {
        const token = localStorage.getItem('token');
        const user = JSON.parse(localStorage.getItem('user'));

        if (token && user) {
            // User is logged in
            document.getElementById('user-not-logged-in').classList.add('d-none');
            document.getElementById('user-logged-in').classList.remove('d-none');

            // Set user info
            document.getElementById('user-name').textContent = user.name;
            if (user.profilePicture) {
                document.getElementById('user-profile-pic').src = user.profilePicture;
            } else {
                document.getElementById('user-profile-pic').src = '${pageContext.request.contextPath}/resources/images/default-profile.png';
            }

            // Show role-specific navigation
            if (user.roles.includes('ROLE_ORGANIZER')) {
                document.getElementById('organizer-nav').classList.remove('d-none');
            }

            if (user.roles.includes('ROLE_ADMIN')) {
                document.getElementById('admin-nav').classList.remove('d-none');
            }
        }

        // Logout functionality
        document.getElementById('logout-btn').addEventListener('click', function(e) {
            e.preventDefault();
            localStorage.removeItem('token');
            localStorage.removeItem('user');
            window.location.href = '${pageContext.request.contextPath}/login';
        });
    });
</script>