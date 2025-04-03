<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - Event Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/styles.css">
    <style>
        .hero-section {
            background: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.6)), url('${pageContext.request.contextPath}/resources/images/hero-bg.jpg');
            background-size: cover;
            background-position: center;
            padding: 100px 0;
            color: white;
            text-align: center;
        }
        .event-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            height: 100%;
        }
        .event-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }
        .event-img {
            height: 200px;
            object-fit: cover;
        }
        .category-badge {
            position: absolute;
            top: 10px;
            right: 10px;
        }
        .search-section {
            background-color: rgba(255, 255, 255, 0.1);
            padding: 30px;
            border-radius: 10px;
            backdrop-filter: blur(5px);
            max-width: 800px;
            margin: 30px auto 0;
        }
        .features-section {
            padding: 80px 0;
            background-color: #f8f9fa;
        }
        .feature-icon {
            font-size: 40px;
            margin-bottom: 20px;
            color: #6c63ff;
        }
        .testimonial-section {
            padding: 80px 0;
        }
        .testimonial-card {
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            margin: 20px 10px;
        }
        .testimonial-img {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 20px;
        }
        .cta-section {
            background: linear-gradient(to right, #6c63ff, #5a52d5);
            padding: 80px 0;
            color: white;
            text-align: center;
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">

<jsp:include page="common/header.jsp" />

<!-- Hero Section -->
<section class="hero-section">
    <div class="container">
        <h1 class="display-4 fw-bold mb-4">Discover Amazing Events</h1>
        <p class="lead mb-5">Find and book events that match your interests. Create and manage your own events.</p>
        <div class="d-flex justify-content-center gap-3">
            <a href="${pageContext.request.contextPath}/events" class="btn btn-primary btn-lg">Explore Events</a>
            <a href="${pageContext.request.contextPath}/organizer/events/create" class="btn btn-outline-light btn-lg organizer-only d-none">Create Event</a>
        </div>

        <!-- Search Box -->
        <div class="search-section">
            <form action="${pageContext.request.contextPath}/events/search" method="GET">
                <div class="row g-3">
                    <div class="col-md-5">
                        <input type="text" class="form-control form-control-lg" name="keyword" placeholder="Search events...">
                    </div>
                    <div class="col-md-3">
                        <select class="form-select form-select-lg" name="category">
                            <option value="">All Categories</option>
                            <option value="CONFERENCE">Conferences</option>
                            <option value="WORKSHOP">Workshops</option>
                            <option value="SEMINAR">Seminars</option>
                            <option value="CULTURAL">Cultural</option>
                            <option value="SPORTS">Sports</option>
                            <option value="MUSIC">Music</option>
                            <option value="TECH">Tech</option>
                            <option value="OTHER">Others</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <input type="date" class="form-control form-control-lg" name="date" placeholder="Date">
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary btn-lg w-100">Search</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
</section>

<!-- Featured Events Section -->
<section class="py-5">
    <div class="container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="mb-0">Featured Events</h2>
            <a href="${pageContext.request.contextPath}/events" class="btn btn-outline-primary">View All</a>
        </div>

        <div class="row g-4" id="featured-events-container">
            <!-- Events will be loaded dynamically -->
            <div class="col-12 text-center py-5">
                <div class="spinner-border text-primary" role="status">
                    <span class="visually-hidden">Loading...</span>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Features Section -->
<section class="features-section">
    <div class="container">
        <h2 class="text-center mb-5">Why Choose Our Platform</h2>

        <div class="row g-4">
            <div class="col-md-4 text-center">
                <div class="feature-icon">
                    <i class="bi bi-search"></i>
                </div>
                <h4>Find Events Easily</h4>
                <p class="text-muted">Search and filter events based on your interests, location, and schedule.</p>
            </div>
            <div class="col-md-4 text-center">
                <div class="feature-icon">
                    <i class="bi bi-ticket-perforated"></i>
                </div>
                <h4>Secure Booking</h4>
                <p class="text-muted">Book tickets securely with our integrated payment system and receive instant confirmations.</p>
            </div>
            <div class="col-md-4 text-center">
                <div class="feature-icon">
                    <i class="bi bi-calendar-event"></i>
                </div>
                <h4>Create & Manage Events</h4>
                <p class="text-muted">Easily create and manage your own events with our comprehensive organizer tools.</p>
            </div>
        </div>

        <div class="row g-4 mt-4">
            <div class="col-md-4 text-center">
                <div class="feature-icon">
                    <i class="bi bi-qr-code"></i>
                </div>
                <h4>QR Code Tickets</h4>
                <p class="text-muted">Get QR code e-tickets for easy access and paperless entry to events.</p>
            </div>
            <div class="col-md-4 text-center">
                <div class="feature-icon">
                    <i class="bi bi-graph-up"></i>
                </div>
                <h4>Analytics Dashboard</h4>
                <p class="text-muted">Track event performance with detailed analytics and attendee insights.</p>
            </div>
            <div class="col-md-4 text-center">
                <div class="feature-icon">
                    <i class="bi bi-bell"></i>
                </div>
                <h4>Notifications & Reminders</h4>
                <p class="text-muted">Stay updated with event notifications and timely reminders.</p>
            </div>
        </div>
    </div>
</section>

<!-- Testimonial Section -->
<section class="testimonial-section">
    <div class="container">
        <h2 class="text-center mb-5">What Our Users Say</h2>

        <div class="row">
            <div class="col-md-4">
                <div class="testimonial-card">
                    <img src="${pageContext.request.contextPath}/resources/images/testimonial-1.jpg" alt="User" class="testimonial-img">
                    <h5>John Doe</h5>
                    <p class="text-muted">Event Attendee</p>
                    <p>"I've discovered so many amazing events through this platform. The booking process is smooth, and I love getting instant e-tickets."</p>
                    <div class="text-warning">
                        <i class="bi bi-star-fill"></i>
                        <i class="bi bi-star-fill"></i>
                        <i class="bi bi-star-fill"></i>
                        <i class="bi bi-star-fill"></i>
                        <i class="bi bi-star-fill"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="testimonial-card">
                    <img src="${pageContext.request.contextPath}/resources/images/testimonial-2.jpg" alt="User" class="testimonial-img">
                    <h5>Jane Smith</h5>
                    <p class="text-muted">Event Organizer</p>
                    <p>"As an event organizer, this platform has made my life so much easier. The tools for creating and managing events are intuitive and powerful."</p>
                    <div class="text-warning">
                        <i class="bi bi-star-fill"></i>
                        <i class="bi bi-star-fill"></i>
                        <i class="bi bi-star-fill"></i>
                        <i class="bi bi-star-fill"></i>
                        <i class="bi bi-star-half"></i>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="testimonial-card">
                    <img src="${pageContext.request.contextPath}/resources/images/testimonial-3.jpg" alt="User" class="testimonial-img">
                    <h5>Robert Johnson</h5>
                    <p class="text-muted">Corporate Client</p>
                    <p>"We've been using this platform for our corporate events, and it has streamlined our entire event management process. Highly recommended!"</p>
                    <div class="text-warning">
                        <i class="bi bi-star-fill"></i>
                        <i class="bi bi-star-fill"></i>
                        <i class="bi bi-star-fill"></i>
                        <i class="bi bi-star-fill"></i>
                        <i class="bi bi-star-fill"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- CTA Section -->
<section class="cta-section">
    <div class="container">
        <h2 class="mb-4">Ready to Start?</h2>
        <p class="lead mb-4">Join thousands of users who are exploring exciting events or creating their own.</p>
        <div class="d-flex justify-content-center gap-3">
            <a href="${pageContext.request.contextPath}/register" class="btn btn-light btn-lg" id="cta-register-btn">Register Now</a>
            <a href="${pageContext.request.contextPath}/organizer/register" class="btn btn-outline-light btn-lg" id="cta-organizer-btn">Become an Organizer</a>
        </div>
    </div>
</section>

<jsp:include page="common/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Check if user is logged in and has organizer role
        const user = JSON.parse(localStorage.getItem('user'));
        if (user && user.roles.includes('ROLE_ORGANIZER')) {
            document.querySelectorAll('.organizer-only').forEach(el => el.classList.remove('d-none'));
        }

        // Get the CTA buttons
        const registerBtn = document.getElementById('cta-register-btn');
        const organizerBtn = document.getElementById('cta-organizer-btn');

        // If user is logged in, change CTA buttons
        if (user) {
            registerBtn.textContent = 'Explore Events';
            registerBtn.href = '${pageContext.request.contextPath}/events';

            if (user.roles.includes('ROLE_ORGANIZER')) {
                organizerBtn.textContent = 'Create Event';
                organizerBtn.href = '${pageContext.request.contextPath}/organizer/events/create';
            } else {
                organizerBtn.textContent = 'Manage Bookings';
                organizerBtn.href = '${pageContext.request.contextPath}/user/bookings';
            }
        }

        // Load featured events
        loadFeaturedEvents();
    });

    function loadFeaturedEvents() {
        const token = localStorage.getItem('token');
        const headers = token ? { 'Authorization': 'Bearer ' + token } : {};

        fetch('${pageContext.request.contextPath}/api/public/events?page=0&size=6&sort=startDateTime,asc', {
            method: 'GET',
            headers: headers
        })
            .then(response => response.json())
            .then(data => {
                const container = document.getElementById('featured-events-container');
                container.innerHTML = '';

                if (data.content && data.content.length > 0) {
                    data.content.forEach(event => {
                        container.appendChild(createEventCard(event));
                    });
                } else {
                    container.innerHTML = '<div class="col-12 text-center py-5"><p>No events found.</p></div>';
                }
            })
            .catch(error => {
                console.error('Error loading events:', error);
                document.getElementById('featured-events-container').innerHTML =
                    '<div class="col-12 text-center py-5"><p>Failed to load events. Please try again later.</p></div>';
            });
    }

    function createEventCard(event) {
        const col = document.createElement('div');
        col.className = 'col-md-4';

        const formattedDate = new Date(event.startDateTime).toLocaleDateString('en-US', {
            year: 'numeric',
            month: 'short',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });

        // Get badge color based on category
        let badgeColor = 'bg-primary';
        switch(event.category) {
            case 'CONFERENCE': badgeColor = 'bg-primary'; break;
            case 'WORKSHOP': badgeColor = 'bg-success'; break;
            case 'SEMINAR': badgeColor = 'bg-info'; break;
            case 'CULTURAL': badgeColor = 'bg-danger'; break;
            case 'SPORTS': badgeColor = 'bg-warning'; break;
            case 'MUSIC': badgeColor = 'bg-secondary'; break;
            case 'TECH': badgeColor = 'bg-dark'; break;
            default: badgeColor = 'bg-primary';
        }

        col.innerHTML = `
                <div class="card event-card">
                    <div class="position-relative">
                        <img src="${event.bannerImage || '${pageContext.request.contextPath}/resources/images/event-placeholder.jpg'}"
                            class="card-img-top event-img" alt="${event.title}">
                        <span class="badge ${badgeColor} category-badge">${event.category}</span>
                    </div>
                    <div class="card-body">
                        <h5 class="card-title">${event.title}</h5>
                        <p class="card-text text-muted">
                            <i class="bi bi-calendar-event me-2"></i>${formattedDate}
                        </p>
                        <p class="card-text text-muted">
                            <i class="bi bi-geo-alt me-2"></i>${event.venue}
                        </p>
                        <div class="d-flex justify-content-between align-items-center mt-3">
                            <span class="fw-bold">$${event.ticketPrice}</span>
                            <a href="${pageContext.request.contextPath}/events/${event.id}" class="btn btn-outline-primary btn-sm">View Details</a>
                        </div>
                    </div>
                </div>
            `;

        return col;
    }
</script>
</body>
</html>