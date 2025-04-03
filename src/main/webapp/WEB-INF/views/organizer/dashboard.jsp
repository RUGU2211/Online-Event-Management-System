<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Organizer Dashboard - Event Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/styles.css">
    <style>
        .dashboard-container {
            padding: 30px 0;
        }
        .stats-card {
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            padding: 20px;
            margin-bottom: 20px;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .stats-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
        }
        .stats-icon {
            font-size: 2.5rem;
            color: #6c63ff;
            margin-bottom: 10px;
        }
        .stats-value {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .stats-label {
            color: #6c757d;
            font-size: 0.9rem;
        }
        .event-card {
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            margin-bottom: 20px;
            overflow: hidden;
        }
        .event-img {
            height: 150px;
            object-fit: cover;
        }
        .event-status {
            position: absolute;
            top: 10px;
            right: 10px;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        .nav-pills .nav-link.active {
            background-color: #6c63ff;
        }
        .nav-pills .nav-link {
            color: #6c63ff;
        }
        .dashboard-tabs {
            margin-bottom: 30px;
        }
        .table-responsive {
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            overflow: hidden;
        }
        .booking-status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        .action-buttons .btn {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">

<jsp:include page="../common/header.jsp" />

<div class="container dashboard-container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>Organizer Dashboard</h2>
        <a href="${pageContext.request.contextPath}/organizer/events/create" class="btn btn-primary">
            <i class="bi bi-plus-lg me-2"></i>Create New Event
        </a>
    </div>

    <div id="error-alert" class="alert alert-danger d-none" role="alert"></div>
    <div id="success-alert" class="alert alert-success d-none" role="alert"></div>

    <!-- Stats Row -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="stats-card text-center">
                <div class="stats-icon">
                    <i class="bi bi-calendar-event"></i>
                </div>
                <div class="stats-value" id="total-events">0</div>
                <div class="stats-label">Total Events</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stats-card text-center">
                <div class="stats-icon">
                    <i class="bi bi-ticket-perforated"></i>
                </div>
                <div class="stats-value" id="total-bookings">0</div>
                <div class="stats-label">Total Bookings</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stats-card text-center">
                <div class="stats-icon">
                    <i class="bi bi-cash"></i>
                </div>
                <div class="stats-value" id="total-revenue">$0</div>
                <div class="stats-label">Total Revenue</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stats-card text-center">
                <div class="stats-icon">
                    <i class="bi bi-star"></i>
                </div>
                <div class="stats-value" id="average-rating">0.0</div>
                <div class="stats-label">Average Rating</div>
            </div>
        </div>
    </div>

    <!-- Tabs Navigation -->
    <ul class="nav nav-pills dashboard-tabs" id="dashboardTabs" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active" id="events-tab" data-bs-toggle="tab" data-bs-target="#events" type="button" role="tab" aria-controls="events" aria-selected="true">My Events</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="bookings-tab" data-bs-toggle="tab" data-bs-target="#bookings" type="button" role="tab" aria-controls="bookings" aria-selected="false">Bookings</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="reviews-tab" data-bs-toggle="tab" data-bs-target="#reviews" type="button" role="tab" aria-controls="reviews" aria-selected="false">Reviews</button>
        </li>
    </ul>

    <!-- Tabs Content -->
    <div class="tab-content" id="dashboardTabsContent">
        <!-- Events Tab -->
        <div class="tab-pane fade show active" id="events" role="tabpanel" aria-labelledby="events-tab">
            <div class="row" id="events-container">
                <div class="col-12 text-center py-5">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="mt-3">Loading your events...</p>
                </div>
            </div>
            <div class="text-center mt-3" id="events-pagination"></div>
        </div>

        <!-- Bookings Tab -->
        <div class="tab-pane fade" id="bookings" role="tabpanel" aria-labelledby="bookings-tab">
            <div class="mb-3">
                <select class="form-select w-auto" id="booking-filter">
                    <option value="all">All Bookings</option>
                    <option value="PENDING">Pending</option>
                    <option value="CONFIRMED">Confirmed</option>
                    <option value="COMPLETED">Completed</option>
                    <option value="CANCELLED">Cancelled</option>
                </select>
            </div>

            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>Event</th>
                        <th>Customer</th>
                        <th>Date</th>
                        <th>Tickets</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody id="bookings-container">
                    <tr>
                        <td colspan="8" class="text-center py-4">
                            <div class="spinner-border text-primary" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                            <p class="mt-3">Loading bookings...</p>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="text-center mt-3" id="bookings-pagination"></div>
        </div>

        <!-- Reviews Tab -->
        <div class="tab-pane fade" id="reviews" role="tabpanel" aria-labelledby="reviews-tab">
            <div id="reviews-container">
                <div class="text-center py-5">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="mt-3">Loading reviews...</p>
                </div>
            </div>
            <div class="text-center mt-3" id="reviews-pagination"></div>
        </div>
    </div>
</div>

<!-- Event Actions Modal -->
<div class="modal fade" id="eventActionsModal" tabindex="-1" aria-labelledby="eventActionsModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="eventActionsModalLabel">Event Actions</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="d-grid gap-2">
                    <a href="#" id="edit-event-link" class="btn btn-outline-primary">
                        <i class="bi bi-pencil me-2"></i>Edit Event
                    </a>
                    <button type="button" id="publish-event-btn" class="btn btn-success">
                        <i class="bi bi-check-circle me-2"></i>Publish Event
                    </button>
                    <button type="button" id="unpublish-event-btn" class="btn btn-warning">
                        <i class="bi bi-exclamation-circle me-2"></i>Unpublish Event
                    </button>
                    <button type="button" id="delete-event-btn" class="btn btn-danger">
                        <i class="bi bi-trash me-2"></i>Delete Event
                    </button>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>

<!-- Booking Details Modal -->
<div class="modal fade" id="bookingDetailsModal" tabindex="-1" aria-labelledby="bookingDetailsModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="bookingDetailsModalLabel">Booking Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="booking-details-container">
                <!-- Booking details will be loaded here -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" id="complete-booking-btn" class="btn btn-success">Mark as Completed</button>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    let currentEventId = null;
    let currentBookingId = null;
    let currentPage = {
        events: 0,
        bookings: 0,
        reviews: 0
    };

    document.addEventListener('DOMContentLoaded', function() {
        // Check if user is logged in as organizer
        const token = localStorage.getItem('token');
        const user = JSON.parse(localStorage.getItem('user'));

        if (!token || !user || (!user.roles.includes('ROLE_ORGANIZER') && !user.roles.includes('ROLE_ADMIN'))) {
            window.location.href = '${pageContext.request.contextPath}/login';
            return;
        }

        // Load dashboard data
        loadDashboardStats();
        loadEvents(0);

        // Tab change handlers
        document.getElementById('bookings-tab').addEventListener('click', function() {
            loadBookings(0);
        });

        document.getElementById('reviews-tab').addEventListener('click', function() {
            loadReviews(0);
        });

        // Booking filter change handler
        document.getElementById('booking-filter').addEventListener('change', function() {
            loadBookings(0);
        });

        // Event action handlers
        document.getElementById('publish-event-btn').addEventListener('click', function() {
            publishEvent(currentEventId);
        });

        document.getElementById('unpublish-event-btn').addEventListener('click', function() {
            unpublishEvent(currentEventId);
        });

        document.getElementById('delete-event-btn').addEventListener('click', function() {
            deleteEvent(currentEventId);
        });

        // Booking action handlers
        document.getElementById('complete-booking-btn').addEventListener('click', function() {
            completeBooking(currentBookingId);
        });
    });

    function loadDashboardStats() {
        const token = localStorage.getItem('token');

        // This would be replaced with a real API call to get dashboard stats
        // For now, we'll simulate with some fixed data
        document.getElementById('total-events').textContent = '-';
        document.getElementById('total-bookings').textContent = '-';
        document.getElementById('total-revenue').textContent = '-';
        document.getElementById('average-rating').textContent = '-';

        // Example API call to get stats (replace with actual endpoint)
        // fetch('${pageContext.request.contextPath}/api/organizer/stats', {
        //     method: 'GET',
        //     headers: {
        //         'Authorization': 'Bearer ' + token
        //     }
        // })
        // .then(response => response.json())
        // .then(data => {
        //     document.getElementById('total-events').textContent = data.totalEvents;
        //     document.getElementById('total-bookings').textContent = data.totalBookings;
        //     document.getElementById('total-revenue').textContent = '$' + data.totalRevenue;
        //     document.getElementById('average-rating').textContent = data.averageRating.toFixed(1);
        // })
        // .catch(error => {
        //     console.error('Error loading dashboard stats:', error);
        // });
    }

    function loadEvents(page) {
        const token = localStorage.getItem('token');
        currentPage.events = page;

        fetch('${pageContext.request.contextPath}/api/organizer/events?page=' + page + '&size=6', {
            method: 'GET',
            headers: {
                'Authorization': 'Bearer ' + token
            }
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Failed to load events');
                }
                return response.json();
            })
            .then(data => {
                renderEvents(data.content);
                renderPagination('events-pagination', data, loadEvents);

                // Update total events in stats
                document.getElementById('total-events').textContent = data.totalElements;
            })
            .catch(error => {
                console.error('Error loading events:', error);
                document.getElementById('events-container').innerHTML =
                    '<div class="col-12 alert alert-danger">Failed to load events. Please try again later.</div>';
            });
    }

    function renderEvents(events) {
        const container = document.getElementById('events-container');

        if (!events || events.length === 0) {
            container.innerHTML = `
                    <div class="col-12 text-center py-5">
                        <div class="alert alert-info">
                            <i class="bi bi-info-circle me-2"></i>
                            You haven't created any events yet.
                        </div>
                        <a href="${pageContext.request.contextPath}/organizer/events/create" class="btn btn-primary mt-3">
                            <i class="bi bi-plus-lg me-2"></i>Create Your First Event
                        </a>
                    </div>
                `;
            return;
        }

        let html = '';

        events.forEach(event => {
            const startDate = new Date(event.startDateTime).toLocaleDateString('en-US', {
                year: 'numeric',
                month: 'short',
                day: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
            });

            // Determine status badge color
            let statusBadgeClass = 'bg-secondary';
            if (event.published) {
                statusBadgeClass = 'bg-success';
            }

            html += `
                    <div class="col-md-4">
                        <div class="card event-card">
                            <div class="position-relative">
                                <img src="${event.bannerImage || '${pageContext.request.contextPath}/resources/images/event-placeholder.jpg'}"
                                    class="card-img-top event-img" alt="${event.title}">
                                <span class="badge ${statusBadgeClass} event-status">
                                    ${event.published ? 'Published' : 'Draft'}
                                </span>
                            </div>
                            <div class="card-body">
                                <h5 class="card-title">${event.title}</h5>
                                <p class="card-text mb-2">
                                    <i class="bi bi-calendar-event me-2"></i>${startDate}
                                </p>
                                <p class="card-text mb-2">
                                    <i class="bi bi-geo-alt me-2"></i>${event.venue}
                                </p>
                                <div class="d-flex justify-content-between align-items-center mt-3">
                                    <span class="text-muted">${event.availableSeats}/${event.totalSeats} seats available</span>
                                    <div class="btn-group">
                                        <a href="${pageContext.request.contextPath}/events/${event.id}" class="btn btn-sm btn-outline-secondary">View</a>
                                        <button type="button" class="btn btn-sm btn-outline-primary"
                                            onclick="openEventActionsModal(${event.id}, ${event.published})">Actions</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                `;
        });

        container.innerHTML = html;
    }

    function loadBookings(page) {
        const token = localStorage.getItem('token');
        currentPage.bookings = page;

        const filter = document.getElementById('booking-filter').value;
        let url = '${pageContext.request.contextPath}/api/organizer/bookings?page=' + page + '&size=10';

        if (filter !== 'all') {
            url += '&status=' + filter;
        }

        fetch(url, {
            method: 'GET',
            headers: {
                'Authorization': 'Bearer ' + token
            }
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Failed to load bookings');
                }
                return response.json();
            })
            .then(data => {
                renderBookings(data.content);
                renderPagination('bookings-pagination', data, loadBookings);

                // Update total bookings in stats
                document.getElementById('total-bookings').textContent = data.totalElements;

                // Calculate and update total revenue
                let totalRevenue = 0;
                data.content.forEach(booking => {
                    if (booking.status === 'CONFIRMED' || booking.status === 'COMPLETED') {
                        totalRevenue += booking.totalAmount;
                    }
                });
                document.getElementById('total-revenue').textContent = '$' + totalRevenue.toFixed(2);
            })
            .catch(error => {
                console.error('Error loading bookings:', error);
                document.getElementById('bookings-container').innerHTML =
                    '<tr><td colspan="8" class="text-center py-4">Failed to load bookings. Please try again later.</td></tr>';
            });
    }

    function renderBookings(bookings) {
        const container = document.getElementById('bookings-container');

        if (!bookings || bookings.length === 0) {
            container.innerHTML = `
                    <tr>
                        <td colspan="8" class="text-center py-4">
                            <div class="alert alert-info mb-0">
                                <i class="bi bi-info-circle me-2"></i>
                                No bookings found.
                            </div>
                        </td>
                    </tr>
                `;
            return;
        }

        let html = '';

        bookings.forEach(booking => {
            const bookingDate = new Date(booking.bookingDate).toLocaleDateString('en-US', {
                year: 'numeric',
                month: 'short',
                day: 'numeric'
            });

            // Determine status badge color
            let statusBadgeClass = '';
            switch(booking.status) {
                case 'PENDING': statusBadgeClass = 'bg-warning'; break;
                case 'CONFIRMED': statusBadgeClass = 'bg-primary'; break;
                case 'COMPLETED': statusBadgeClass = 'bg-success'; break;
                case 'CANCELLED': statusBadgeClass = 'bg-danger'; break;
                default: statusBadgeClass = 'bg-secondary';
            }

            html += `
                    <tr>
                        <td>${booking.bookingNumber}</td>
                        <td>${booking.eventTitle}</td>
                        <td>${booking.userName}</td>
                        <td>${bookingDate}</td>
                        <td>${booking.numberOfTickets}</td>
                        <td>$${booking.totalAmount}</td>
                        <td><span class="badge ${statusBadgeClass} booking-status-badge">${booking.status}</span></td>
                        <td class="action-buttons">
                            <button type="button" class="btn btn-sm btn-outline-primary" onclick="viewBookingDetails(${booking.id})">
                                <i class="bi bi-eye"></i>
                            </button>
                            ${booking.status === 'CONFIRMED' ?
                                `<button type="button" class="btn btn-sm btn-outline-success" onclick="completeBooking(${booking.id})">
                                    <i class="bi bi-check-circle"></i>
                                </button>` : ''
                            }
                        </td>
                    </tr>
                `;
        });

        container.innerHTML = html;
    }

    function loadReviews(page) {
        const token = localStorage.getItem('token');
        currentPage.reviews = page;

        // Example API call to get reviews (replace with actual endpoint)
        // fetch('${pageContext.request.contextPath}/api/organizer/reviews?page=' + page + '&size=5', {
        //     method: 'GET',
        //     headers: {
        //         'Authorization': 'Bearer ' + token
        //     }
        // })
        // .then(response => response.json())
        // .then(data => {
        //     renderReviews(data.content);
        //     renderPagination('reviews-pagination', data, loadReviews);
        // })
        // .catch(error => {
        //     console.error('Error loading reviews:', error);
        //     document.getElementById('reviews-container').innerHTML =
        //         '<div class="alert alert-danger">Failed to load reviews. Please try again later.</div>';
        // });

        // For now, just show a message
        document.getElementById('reviews-container').innerHTML =
            '<div class="alert alert-info">Review management will be added in a future update.</div>';
    }

    function renderPagination(containerId, data, loadFunction) {
        const container = document.getElementById(containerId);

        if (!data || data.totalPages <= 1) {
            container.innerHTML = '';
            return;
        }

        let html = '<nav><ul class="pagination">';

        // Previous button
        html += `
                <li class="page-item ${data.first ? 'disabled' : ''}">
                    <a class="page-link" href="#" onclick="${data.first ? '' : 'event.preventDefault(); loadFunction(' + (data.number - 1) + ')'}" aria-label="Previous">
                        <span aria-hidden="true">&laquo;</span>
                    </a>
                </li>
            `;

        // Page numbers
        for (let i = 0; i < data.totalPages; i++) {
            html += `
                    <li class="page-item ${i === data.number ? 'active' : ''}">
                        <a class="page-link" href="#" onclick="event.preventDefault(); loadFunction(${i})">${i + 1}</a>
                    </li>
                `;
        }

        // Next button
        html += `
                <li class="page-item ${data.last ? 'disabled' : ''}">
                    <a class="page-link" href="#" onclick="${data.last ? '' : 'event.preventDefault(); loadFunction(' + (data.number + 1) + ')'}" aria-label="Next">
                        <span aria-hidden="true">&raquo;</span>
                    </a>
                </li>
            `;

        html += '</ul></nav>';

        container.innerHTML = html;
    }

    function openEventActionsModal(eventId, isPublished) {
        currentEventId = eventId;

        // Update edit link
        document.getElementById('edit-event-link').href =
            '${pageContext.request.contextPath}/organizer/events/edit/' + eventId;

        // Show/hide publish/unpublish buttons based on current status
        document.getElementById('publish-event-btn').style.display = isPublished ? 'none' : 'block';
        document.getElementById('unpublish-event-btn').style.display = isPublished ? 'block' : 'none';

        // Show the modal
        const modal = new bootstrap.Modal(document.getElementById('eventActionsModal'));
        modal.show();
    }

    function publishEvent(eventId) {
        const token = localStorage.getItem('token');

        fetch('${pageContext.request.contextPath}/api/organizer/events/' + eventId + '/publish', {
            method: 'PUT',
            headers: {
                'Authorization': 'Bearer ' + token
            }
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Failed to publish event');
                }
                return response.json();
            })
            .then(data => {
                // Close the modal
                bootstrap.Modal.getInstance(document.getElementById('eventActionsModal')).hide();

                // Show success message
                showSuccess('Event published successfully!');

                // Reload events
                loadEvents(currentPage.events);
            })
            .catch(error => {
                console.error('Error publishing event:', error);
                showError('Failed to publish event. Please try again later.');
            });
    }

    function unpublishEvent(eventId) {
        const token = localStorage.getItem('token');

        fetch('${pageContext.request.contextPath}/api/organizer/events/' + eventId + '/unpublish', {
            method: 'PUT',
            headers: {
                'Authorization': 'Bearer ' + token
            }
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Failed to unpublish event');
                }
                return response.json();
            })
            .then(data => {
                // Close the modal
                bootstrap.Modal.getInstance(document.getElementById('eventActionsModal')).hide();

                // Show success message
                showSuccess('Event unpublished successfully!');

                // Reload events
                loadEvents(currentPage.events);
            })
            .catch(error => {
                console.error('Error unpublishing event:', error);
                showError('Failed to unpublish event. Please try again later.');
            });
    }

    function deleteEvent(eventId) {
        const token = localStorage.getItem('token');

        // Confirm deletion
        if (!confirm('Are you sure you want to delete this event? This action cannot be undone.')) {
            return;
        }

        fetch('${pageContext.request.contextPath}/api/organizer/events/' + eventId, {
            method: 'DELETE',
            headers: {
                'Authorization': 'Bearer ' + token
            }
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Failed to delete event');
                }
                return response.text();
            })
            .then(data => {
                // Close the modal
                bootstrap.Modal.getInstance(document.getElementById('eventActionsModal')).hide();

                // Show success message
                showSuccess('Event deleted successfully!');

                // Reload events
                loadEvents(currentPage.events);
            })
            .catch(error => {
                console.error('Error deleting event:', error);
                showError('Failed to delete event. It may have existing bookings or you do not have permission.');
            });
    }

    function viewBookingDetails(bookingId) {
        currentBookingId = bookingId;
        const token = localStorage.getItem('token');

        fetch('${pageContext.request.contextPath}/api/bookings/' + bookingId, {
            method: 'GET',
            headers: {
                'Authorization': 'Bearer ' + token
            }
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Failed to load booking details');
                }
                return response.json();
            })
            .then(booking => {
                renderBookingDetails(booking);

                // Show the modal
                const modal = new bootstrap.Modal(document.getElementById('bookingDetailsModal'));
                modal.show();

                // Show/hide complete booking button based on status
                document.getElementById('complete-booking-btn').style.display =
                    booking.status === 'CONFIRMED' ? 'block' : 'none';
            })
            .catch(error => {
                console.error('Error loading booking details:', error);
                showError('Failed to load booking details. Please try again later.');
            });
    }

    function renderBookingDetails(booking) {
        const container = document.getElementById('booking-details-container');

        const bookingDate = new Date(booking.bookingDate).toLocaleDateString('en-US', {
            year: 'numeric',
            month: 'long',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });

        const eventDate = new Date(booking.eventDateTime).toLocaleDateString('en-US', {
            year: 'numeric',
            month: 'long',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });

        // Determine status badge color
        let statusBadgeClass = '';
        switch(booking.status) {
            case 'PENDING': statusBadgeClass = 'bg-warning'; break;
            case 'CONFIRMED': statusBadgeClass = 'bg-primary'; break;
            case 'COMPLETED': statusBadgeClass = 'bg-success'; break;
            case 'CANCELLED': statusBadgeClass = 'bg-danger'; break;
            default: statusBadgeClass = 'bg-secondary';
        }

        container.innerHTML = `
                <div class="mb-3">
                    <p class="mb-1"><strong>Booking ID:</strong> ${booking.bookingNumber}</p>
                    <p class="mb-1"><strong>Status:</strong> <span class="badge ${statusBadgeClass}">${booking.status}</span></p>
                    <p class="mb-1"><strong>Booking Date:</strong> ${bookingDate}</p>
                </div>

                <div class="mb-3">
                    <h6>Event Details</h6>
                    <p class="mb-1"><strong>Event:</strong> ${booking.eventTitle}</p>
                    <p class="mb-1"><strong>Date & Time:</strong> ${eventDate}</p>
                    <p class="mb-1"><strong>Venue:</strong> ${booking.eventVenue}</p>
                </div>

                <div class="mb-3">
                    <h6>Customer Details</h6>
                    <p class="mb-1"><strong>Name:</strong> ${booking.userName}</p>
                    <p class="mb-1"><strong>Email:</strong> ${booking.userEmail}</p>
                </div>

                <div class="mb-3">
                    <h6>Booking Details</h6>
                    <p class="mb-1"><strong>Number of Tickets:</strong> ${booking.numberOfTickets}</p>
                    <p class="mb-1"><strong>Total Amount:</strong> ${booking.totalAmount}</p>
                    ${booking.paymentId ? `<p class="mb-1"><strong>Payment ID:</strong> ${booking.paymentId}</p>` : ''}
                </div>

                ${booking.qrCodePath ? `
                <div class="text-center mt-3">
                    <img src="${pageContext.request.contextPath}/${booking.qrCodePath}" alt="Ticket QR Code" class="img-fluid" style="max-width: 200px;">
                </div>
                ` : ''}
            `;
    }

    function completeBooking(bookingId) {
        const token = localStorage.getItem('token');

        fetch('${pageContext.request.contextPath}/api/organizer/bookings/' + bookingId + '/complete', {
            method: 'PUT',
            headers: {
                'Authorization': 'Bearer ' + token
            }
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Failed to complete booking');
                }
                return response.json();
            })
            .then(data => {
                // Close the modal if open
                const modal = bootstrap.Modal.getInstance(document.getElementById('bookingDetailsModal'));
                if (modal) {
                    modal.hide();
                }

                // Show success message
                showSuccess('Booking marked as completed successfully!');

                // Reload bookings
                loadBookings(currentPage.bookings);
            })
            .catch(error => {
                console.error('Error completing booking:', error);
                showError('Failed to complete booking. Please try again later.');
            });
    }

    function showError(message) {
        const alert = document.getElementById('error-alert');
        alert.textContent = message;
        alert.classList.remove('d-none');

        setTimeout(() => {
            alert.classList.add('d-none');
        }, 5000);
    }

    function showSuccess(message) {
        const alert = document.getElementById('success-alert');
        alert.textContent = message;
        alert.classList.remove('d-none');

        setTimeout(() => {
            alert.classList.add('d-none');
        }, 5000);
    }
</script>
</body>
</html>