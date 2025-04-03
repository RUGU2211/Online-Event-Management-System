document.getElementById('reports-tab').addEventListener('click', function() {
initializeCharts();
});

// Refresh button handler
document.getElementById('refresh-btn').addEventListener('click', function() {
// Refresh current tab data
const activeTab = document.querySelector('#dashboardTabs .nav-link.active').getAttribute('id');

switch(activeTab) {
case 'users-tab':
loadUsers(currentPage.users);
break;
case 'events-tab':
loadEvents(currentPage.events);
break;
case 'bookings-tab':
loadBookings(currentPage.bookings);
break;
case 'reports-tab':
initializeCharts();
break;
}

// Refresh dashboard stats
loadDashboardStats();

// Show success message
showSuccess('Data refreshed successfully!');
});

// Filter and search handlers
document.getElementById('user-role-filter').addEventListener('change', function() {
loadUsers(0);
});

document.getElementById('event-status-filter').addEventListener('change', function() {
loadEvents(0);
});

document.getElementById('booking-status-filter').addEventListener('change', function() {
loadBookings(0);
});

document.getElementById('user-search-btn').addEventListener('click', function() {
loadUsers(0);
});

document.getElementById('event-search-btn').addEventListener('click', function() {
loadEvents(0);
});

document.getElementById('booking-search-btn').addEventListener('click', function() {
loadBookings(0);
});

// Edit user form handlers
document.getElementById('edit-user-btn').addEventListener('click', function() {
// Close user details modal
bootstrap.Modal.getInstance(document.getElementById('userDetailsModal')).hide();

// Open edit user modal with current user data
openEditUserModal();
});

document.getElementById('save-user-btn').addEventListener('click', function() {
saveUserChanges();
});

// Event action handlers
document.getElementById('publish-event-btn').addEventListener('click', function() {
publishEvent(currentEventId);
});

document.getElementById('unpublish-event-btn').addEventListener('click', function() {
unpublishEvent(currentEventId);
});
});

function loadDashboardStats() {
const token = localStorage.getItem('token');

fetch('${pageContext.request.contextPath}/api/admin/dashboard/stats', {
method: 'GET',
headers: {
'Authorization': 'Bearer ' + token
}
})
.then(response => {
if (!response.ok) {
throw new Error('Failed to load dashboard stats');
}
return response.json();
})
.then(data => {
// Update dashboard stats
document.getElementById('total-users').textContent = data.totalUsers;
document.getElementById('total-events').textContent = data.totalEvents;
document.getElementById('total-bookings').textContent = data.totalBookings;
document.getElementById('total-revenue').textContent = '<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Event Management System</title>
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
        .status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        .action-buttons .btn {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
        }
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">

<jsp:include page="../common/header.jsp" />

<div class="container dashboard-container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>Admin Dashboard</h2>
        <div>
            <button class="btn btn-outline-primary me-2" id="refresh-btn">
                <i class="bi bi-arrow-clockwise me-2"></i>Refresh Data
            </button>
            <a href="${pageContext.request.contextPath}/admin/system-settings" class="btn btn-primary">
                <i class="bi bi-gear me-2"></i>System Settings
            </a>
        </div>
    </div>

    <div id="error-alert" class="alert alert-danger d-none" role="alert"></div>
    <div id="success-alert" class="alert alert-success d-none" role="alert"></div>

    <!-- Stats Row -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="stats-card text-center">
                <div class="stats-icon">
                    <i class="bi bi-people"></i>
                </div>
                <div class="stats-value" id="total-users">0</div>
                <div class="stats-label">Total Users</div>
            </div>
        </div>
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
    </div>

    <!-- Tabs Navigation -->
    <ul class="nav nav-pills dashboard-tabs" id="dashboardTabs" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active" id="users-tab" data-bs-toggle="tab" data-bs-target="#users" type="button" role="tab" aria-controls="users" aria-selected="true">Users</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="events-tab" data-bs-toggle="tab" data-bs-target="#events" type="button" role="tab" aria-controls="events" aria-selected="false">Events</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="bookings-tab" data-bs-toggle="tab" data-bs-target="#bookings" type="button" role="tab" aria-controls="bookings" aria-selected="false">Bookings</button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="reports-tab" data-bs-toggle="tab" data-bs-target="#reports" type="button" role="tab" aria-controls="reports" aria-selected="false">Reports</button>
        </li>
    </ul>

    <!-- Tabs Content -->
    <div class="tab-content" id="dashboardTabsContent">
        <!-- Users Tab -->
        <div class="tab-pane fade show active" id="users" role="tabpanel" aria-labelledby="users-tab">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <div>
                    <select class="form-select w-auto" id="user-role-filter">
                        <option value="all">All Users</option>
                        <option value="ROLE_ADMIN">Admins</option>
                        <option value="ROLE_ORGANIZER">Organizers</option>
                        <option value="ROLE_ATTENDEE">Attendees</option>
                    </select>
                </div>
                <div class="d-flex">
                    <input type="text" class="form-control me-2" id="user-search" placeholder="Search users...">
                    <button class="btn btn-primary" id="user-search-btn">
                        <i class="bi bi-search"></i>
                    </button>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th>User</th>
                        <th>Email</th>
                        <th>Role</th>
                        <th>Provider</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody id="users-container">
                    <tr>
                        <td colspan="6" class="text-center py-4">
                            <div class="spinner-border text-primary" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                            <p class="mt-3">Loading users...</p>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="text-center mt-3" id="users-pagination"></div>
        </div>

        <!-- Events Tab -->
        <div class="tab-pane fade" id="events" role="tabpanel" aria-labelledby="events-tab">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <div>
                    <select class="form-select w-auto" id="event-status-filter">
                        <option value="all">All Events</option>
                        <option value="published">Published</option>
                        <option value="draft">Draft</option>
                    </select>
                </div>
                <div class="d-flex">
                    <input type="text" class="form-control me-2" id="event-search" placeholder="Search events...">
                    <button class="btn btn-primary" id="event-search-btn">
                        <i class="bi bi-search"></i>
                    </button>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th>Title</th>
                        <th>Organizer</th>
                        <th>Date</th>
                        <th>Venue</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody id="events-container">
                    <tr>
                        <td colspan="6" class="text-center py-4">
                            <div class="spinner-border text-primary" role="status">
                                <span class="visually-hidden">Loading...</span>
                            </div>
                            <p class="mt-3">Loading events...</p>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
            <div class="text-center mt-3" id="events-pagination"></div>
        </div>

        <!-- Bookings Tab -->
        <div class="tab-pane fade" id="bookings" role="tabpanel" aria-labelledby="bookings-tab">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <div>
                    <select class="form-select w-auto" id="booking-status-filter">
                        <option value="all">All Bookings</option>
                        <option value="PENDING">Pending</option>
                        <option value="CONFIRMED">Confirmed</option>
                        <option value="COMPLETED">Completed</option>
                        <option value="CANCELLED">Cancelled</option>
                    </select>
                </div>
                <div class="d-flex">
                    <input type="text" class="form-control me-2" id="booking-search" placeholder="Search bookings...">
                    <button class="btn btn-primary" id="booking-search-btn">
                        <i class="bi bi-search"></i>
                    </button>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>Event</th>
                        <th>Customer</th>
                        <th>Date</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody id="bookings-container">
                    <tr>
                        <td colspan="7" class="text-center py-4">
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

        <!-- Reports Tab -->
        <div class="tab-pane fade" id="reports" role="tabpanel" aria-labelledby="reports-tab">
            <div class="row">
                <div class="col-md-6 mb-4">
                    <div class="card h-100">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Monthly Revenue</h5>
                        </div>
                        <div class="card-body">
                            <canvas id="revenueChart" height="250"></canvas>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 mb-4">
                    <div class="card h-100">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Event Categories Distribution</h5>
                        </div>
                        <div class="card-body">
                            <canvas id="categoriesChart" height="250"></canvas>
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-6 mb-4">
                    <div class="card h-100">
                        <div class="card-header">
                            <h5 class="card-title mb-0">User Registrations</h5>
                        </div>
                        <div class="card-body">
                            <canvas id="registrationsChart" height="250"></canvas>
                        </div>
                    </div>
                </div>
                <div class="col-md-6 mb-4">
                    <div class="card h-100">
                        <div class="card-header">
                            <h5 class="card-title mb-0">Top Events (by Bookings)</h5>
                        </div>
                        <div class="card-body">
                            <canvas id="topEventsChart" height="250"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- User Details Modal -->
<div class="modal fade" id="userDetailsModal" tabindex="-1" aria-labelledby="userDetailsModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="userDetailsModalLabel">User Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="user-details-container">
                <!-- User details will be loaded here -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" id="edit-user-btn" class="btn btn-primary">Edit User</button>
            </div>
        </div>
    </div>
</div>

<!-- Edit User Modal -->
<div class="modal fade" id="editUserModal" tabindex="-1" aria-labelledby="editUserModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editUserModalLabel">Edit User</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="edit-user-form">
                    <div class="mb-3">
                        <label for="edit-user-name" class="form-label">Name</label>
                        <input type="text" class="form-control" id="edit-user-name" required>
                    </div>
                    <div class="mb-3">
                        <label for="edit-user-email" class="form-label">Email</label>
                        <input type="email" class="form-control" id="edit-user-email" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Roles</label>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="role-admin">
                            <label class="form-check-label" for="role-admin">Admin</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="role-organizer">
                            <label class="form-check-label" for="role-organizer">Organizer</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="checkbox" id="role-attendee">
                            <label class="form-check-label" for="role-attendee">Attendee</label>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Status</label>
                        <div class="form-check form-switch">
                            <input class="form-check-input" type="checkbox" id="user-enabled">
                            <label class="form-check-label" for="user-enabled">Enabled</label>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" id="save-user-btn" class="btn btn-primary">Save Changes</button>
            </div>
        </div>
    </div>
</div>

<!-- Event Details Modal -->
<div class="modal fade" id="eventDetailsModal" tabindex="-1" aria-labelledby="eventDetailsModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="eventDetailsModalLabel">Event Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="event-details-container">
                <!-- Event details will be loaded here -->
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" id="publish-event-btn" class="btn btn-success">Publish</button>
                <button type="button" id="unpublish-event-btn" class="btn btn-warning">Unpublish</button>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    let currentUserId = null;
    let currentEventId = null;
    let currentBookingId = null;
    let currentPage = {
        users: 0,
        events: 0,
        bookings: 0
    };
    let charts = {};

    document.addEventListener('DOMContentLoaded', function() {
        // Check if user is logged in as admin
        const token = localStorage.getItem('token');
        const user = JSON.parse(localStorage.getItem('user'));

        if (!token || !user || !user.roles.includes('ROLE_ADMIN')) {
            window.location.href = '${pageContext.request.contextPath}/login';
            return;
        }

        // Load dashboard data
        loadDashboardStats();
        loadUsers(0);

        // Tab change handlers
        document.getElementById('events-tab').addEventListener('click', function() {
            loadEvents(0);
        });

        document.getElementById('bookings-tab').addEventListener('click', function() {
            loadBookings(0);
        });

        + data.totalRevenue.toFixed(2);
    })
        .catch(error => {
            console.error('Error loading dashboard stats:', error);
            // Use placeholder values
            document.getElementById('total-users').textContent = '-';
            document.getElementById('total-events').textContent = '-';
            document.getElementById('total-bookings').textContent = '-';
            document.getElementById('total-revenue').textContent = '-';
        });
    }

    function loadUsers(page) {
        const token = localStorage.getItem('token');
        currentPage.users = page;

        const roleFilter = document.getElementById('user-role-filter').value;
        const searchQuery = document.getElementById('user-search').value;

        let url = '${pageContext.request.contextPath}/api/admin/users?page=' + page + '&size=10';

        if (roleFilter !== 'all') {
            url += '&role=' + roleFilter;
        }

        if (searchQuery) {
            url += '&search=' + encodeURIComponent(searchQuery);
        }

        fetch(url, {
            method: 'GET',
            headers: {
                'Authorization': 'Bearer ' + token
            }
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Failed to load users');
                }
                return response.json();
            })
            .then(data => {
                renderUsers(data.content);
                renderPagination('users-pagination', data, loadUsers);
            })
            .catch(error => {
                console.error('Error loading users:', error);
                document.getElementById('users-container').innerHTML =
                    '<tr><td colspan="6" class="text-center py-4">Failed to load users. Please try again later.</td></tr>';
            });
    }

    function renderUsers(users) {
        const container = document.getElementById('users-container');

        if (!users || users.length === 0) {
            container.innerHTML = `
                    <tr>
                        <td colspan="6" class="text-center py-4">
                            <div class="alert alert-info mb-0">
                                <i class="bi bi-info-circle me-2"></i>
                                No users found matching the criteria.
                            </div>
                        </td>
                    </tr>
                `;
            return;
        }

        let html = '';

        users.forEach(user => {
            // Get roles as comma-separated string
            const roles = user.roles.map(role => {
                const roleName = role.charAt(0).toUpperCase() + role.slice(1);
                return roleName;
            }).join(', ');

            html += `
                    <tr>
                        <td>
                            <div class="d-flex align-items-center">
                                <img src="${user.profilePicture || '${pageContext.request.contextPath}/resources/images/default-profile.png'}"
                                    alt="${user.name}" class="user-avatar me-3">
                                <div>
                                    <h6 class="mb-0">${user.name}</h6>
                                </div>
                            </div>
                        </td>
                        <td>${user.email}</td>
                        <td>${roles}</td>
                        <td>${user.provider || 'Local'}</td>
                        <td>
                            <span class="badge ${user.enabled ? 'bg-success' : 'bg-danger'} status-badge">
                                ${user.enabled ? 'Active' : 'Inactive'}
                            </span>
                        </td>
                        <td class="action-buttons">
                            <button type="button" class="btn btn-sm btn-outline-primary" onclick="viewUserDetails(${user.id})">
                                <i class="bi bi-eye"></i>
                            </button>
                            <button type="button" class="btn btn-sm btn-outline-danger" onclick="deleteUser(${user.id})">
                                <i class="bi bi-trash"></i>
                            </button>
                        </td>
                    </tr>
                `;
        });

        container.innerHTML = html;
    }

    function loadEvents(page) {
        const token = localStorage.getItem('token');
        currentPage.events = page;

        const statusFilter = document.getElementById('event-status-filter').value;
        const searchQuery = document.getElementById('event-search').value;

        let url = '${pageContext.request.contextPath}/api/admin/events?page=' + page + '&size=10';

        if (statusFilter !== 'all') {
            url += '&status=' + statusFilter;
        }

        if (searchQuery) {
            url += '&search=' + encodeURIComponent(searchQuery);
        }

        fetch(url, {
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
            })
            .catch(error => {
                console.error('Error loading events:', error);
                document.getElementById('events-container').innerHTML =
                    '<tr><td colspan="6" class="text-center py-4">Failed to load events. Please try again later.</td></tr>';
            });
    }

    function renderEvents(events) {
        const container = document.getElementById('events-container');

        if (!events || events.length === 0) {
            container.innerHTML = `
                    <tr>
                        <td colspan="6" class="text-center py-4">
                            <div class="alert alert-info mb-0">
                                <i class="bi bi-info-circle me-2"></i>
                                No events found matching the criteria.
                            </div>
                        </td>
                    </tr>
                `;
            return;
        }

        let html = '';

        events.forEach(event => {
            const eventDate = new Date(event.startDateTime).toLocaleDateString('en-US', {
                year: 'numeric',
                month: 'short',
                day: 'numeric',
                hour: '2-digit',
                minute: '2-digit'
            });

            html += `
                    <tr>
                        <td>
                            <div class="d-flex align-items-center">
                                <div style="width: 40px; height: 40px; border-radius: 5px; background-color: #f0f0f0; overflow: hidden; margin-right: 10px;">
                                    <img src="${event.bannerImage || '${pageContext.request.contextPath}/resources/images/event-placeholder.jpg'}"
                                        alt="${event.title}" class="img-fluid">
                                </div>
                                <div>
                                    <h6 class="mb-0">${event.title}</h6>
                                    <small class="text-muted">${event.category}</small>
                                </div>
                            </div>
                        </td>
                        <td>${event.organizerName}</td>
                        <td>${eventDate}</td>
                        <td>${event.venue}</td>
                        <td>
                            <span class="badge ${event.published ? 'bg-success' : 'bg-secondary'} status-badge">
                                ${event.published ? 'Published' : 'Draft'}
                            </span>
                        </td>
                        <td class="action-buttons">
                            <button type="button" class="btn btn-sm btn-outline-primary" onclick="viewEventDetails(${event.id})">
                                <i class="bi bi-eye"></i>
                            </button>
                            <button type="button" class="btn btn-sm btn-outline-danger" onclick="deleteEvent(${event.id})">
                                <i class="bi bi-trash"></i>
                            </button>
                        </td>
                    </tr>
                `;
        });

        container.innerHTML = html;
    }

    function loadBookings(page) {
        const token = localStorage.getItem('token');
        currentPage.bookings = page;

        const statusFilter = document.getElementById('booking-status-filter').value;
        const searchQuery = document.getElementById('booking-search').value;

        let url = '${pageContext.request.contextPath}/api/admin/bookings?page=' + page + '&size=10';

        if (statusFilter !== 'all') {
            url += '&status=' + statusFilter;
        }

        if (searchQuery) {
            url += '&search=' + encodeURIComponent(searchQuery);
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
            })
            .catch(error => {
                console.error('Error loading bookings:', error);
                document.getElementById('bookings-container').innerHTML =
                    '<tr><td colspan="7" class="text-center py-4">Failed to load bookings. Please try again later.</td></tr>';
            });
    }

    function renderBookings(bookings) {
        const container = document.getElementById('bookings-container');

        if (!bookings || bookings.length === 0) {
            container.innerHTML = `
                    <tr>
                        <td colspan="7" class="text-center py-4">
                            <div class="alert alert-info mb-0">
                                <i class="bi bi-info-circle me-2"></i>
                                No bookings found matching the criteria.
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
                        <td>${booking.totalAmount}</td>
                        <td><span class="badge ${statusBadgeClass} status-badge">${booking.status}</span></td>
                        <td class="action-buttons">
                            <button type="button" class="btn btn-sm btn-outline-primary" onclick="viewBookingDetails(${booking.id})">
                                <i class="bi bi-eye"></i>
                            </button>
                        </td>
                    </tr>
                `;
        });

        container.innerHTML = html;
    }

    function initializeCharts() {
        // Initialize charts if not already created
        if (!charts.revenue) {
            createRevenueChart();
            createCategoriesChart();
            createRegistrationsChart();
            createTopEventsChart();
        } else {
            // Update chart data
            updateCharts();
        }
    }

    function createRevenueChart() {
        const ctx = document.getElementById('revenueChart').getContext('2d');

        // Sample data (replace with real data from API)
        const data = {
            labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
            datasets: [{
                label: 'Revenue ($)',
                data: [5000, 7500, 6200, 8100, 9500, 11000],
                backgroundColor: 'rgba(108, 99, 255, 0.2)',
                borderColor: 'rgba(108, 99, 255, 1)',
                borderWidth: 2,
                tension: 0.4
            }]
        };

        charts.revenue = new Chart(ctx, {
            type: 'line',
            data: data,
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'top'
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    }

    function createCategoriesChart() {
        const ctx = document.getElementById('categoriesChart').getContext('2d');

        // Sample data (replace with real data from API)
        const data = {
            labels: ['Conference', 'Workshop', 'Seminar', 'Cultural', 'Sports', 'Music', 'Tech', 'Other'],
            datasets: [{
                label: 'Number of Events',
                data: [15, 12, 8, 10, 5, 7, 18, 4],
                backgroundColor: [
                    'rgba(108, 99, 255, 0.7)',
                    'rgba(54, 162, 235, 0.7)',
                    'rgba(255, 206, 86, 0.7)',
                    'rgba(75, 192, 192, 0.7)',
                    'rgba(153, 102, 255, 0.7)',
                    'rgba(255, 159, 64, 0.7)',
                    'rgba(255, 99, 132, 0.7)',
                    'rgba(199, 199, 199, 0.7)'
                ],
                borderWidth: 1
            }]
        };

        charts.categories = new Chart(ctx, {
            type: 'pie',
            data: data,
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'right'
                    }
                }
            }
        });
    }

    function createRegistrationsChart() {
        const ctx = document.getElementById('registrationsChart').getContext('2d');

        // Sample data (replace with real data from API)
        const data = {
            labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
            datasets: [{
                label: 'New Users',
                data: [25, 35, 40, 30, 45, 55],
                backgroundColor: 'rgba(75, 192, 192, 0.7)',
                borderColor: 'rgba(75, 192, 192, 1)',
                borderWidth: 1
            }]
        };

        charts.registrations = new Chart(ctx, {
            type: 'bar',
            data: data,
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'top'
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    }

    function createTopEventsChart() {
        const ctx = document.getElementById('topEventsChart').getContext('2d');

        // Sample data (replace with real data from API)
        const data = {
            labels: ['Annual Tech Conference', 'Music Festival', 'Career Fair', 'Art Exhibition', 'Workshop Series'],
            datasets: [{
                label: 'Number of Bookings',
                data: [120, 95, 85, 70, 65],
                backgroundColor: 'rgba(255, 99, 132, 0.7)',
                borderColor: 'rgba(255, 99, 132, 1)',
                borderWidth: 1
            }]
        };

        charts.topEvents = new Chart(ctx, {
            type: 'horizontalBar',
            data: data,
            options: {
                indexAxis: 'y',
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'top'
                    }
                },
                scales: {
                    x: {
                        beginAtZero: true
                    }
                }
            }
        });
    }

    function updateCharts() {
        // This would fetch new data from API and update the charts
        // For now, just redraw with the same data
        charts.revenue.update();
        charts.categories.update();
        charts.registrations.update();
        charts.topEvents.update();
    }

    function viewUserDetails(userId) {
        currentUserId = userId;
        const token = localStorage.getItem('token');

        fetch('${pageContext.request.contextPath}/api/admin/users/' + userId, {
            method: 'GET',
            headers: {
                'Authorization': 'Bearer ' + token
            }
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Failed to load user details');
                }
                return response.json();
            })
            .then(user => {
                renderUserDetails(user);

                // Show the modal
                const modal = new bootstrap.Modal(document.getElementById('userDetailsModal'));
                modal.show();
            })
            .catch(error => {
                console.error('Error loading user details:', error);
                showError('Failed to load user details. Please try again later.');
            });
    }

    function renderUserDetails(user) {
        const container = document.getElementById('user-details-container');

        // Get roles as comma-separated string
        const roles = user.roles.map(role => {
            const roleName = role.charAt(0).toUpperCase() + role.slice(1);
            return roleName;
        }).join(', ');

        container.innerHTML = `
                <div class="text-center mb-4">
                    <img src="${user.profilePicture || '${pageContext.request.contextPath}/resources/images/default-profile.png'}"
                        alt="${user.name}" class="img-fluid rounded-circle mb-3" style="width: 100px; height: 100px; object-fit: cover;">
                    <h5>${user.name}</h5>
                    <p class="text-muted">${user.email}</p>
                </div>

                <div class="mb-3">
                    <h6>Account Information</h6>
                    <p class="mb-1"><strong>User ID:</strong> ${user.id}</p>
                    <p class="mb-1"><strong>Roles:</strong> ${roles}</p>
                    <p class="mb-1"><strong>Status:</strong>
                        <span class="badge ${user.enabled ? 'bg-success' : 'bg-danger'}">
                            ${user.enabled ? 'Active' : 'Inactive'}
                        </span>
                    </p>
                    <p class="mb-1"><strong>Authentication Provider:</strong> ${user.provider || 'Local'}</p>
                </div>

                <div class="mb-3">
                    <h6>Statistics</h6>
                    <p class="mb-1"><strong>Events Created:</strong> ${user.eventsCreated || 0}</p>
                    <p class="mb-1"><strong>Events Attended:</strong> ${user.eventsAttended || 0}</p>
                    <p class="mb-1"><strong>Total Bookings:</strong> ${user.totalBookings || 0}</p>
                </div>
            `;
    }

    function openEditUserModal() {
        const token = localStorage.getItem('token');

        fetch('${pageContext.request.contextPath}/api/admin/users/' + currentUserId, {
            method: 'GET',
            headers: {
                'Authorization': 'Bearer ' + token
            }
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Failed to load user details');
                }
                return response.json();
            })
            .then(user => {
                // Populate form with user data
                document.getElementById('edit-user-name').value = user.name;
                document.getElementById('edit-user-email').value = user.email;

                // Set role checkboxes
                document.getElementById('role-admin').checked = user.roles.includes('admin');
                document.getElementById('role-organizer').checked = user.roles.includes('organizer');
                document.getElementById('role-attendee').checked = user.roles.includes('attendee');

                // Set enabled switch
                document.getElementById('user-enabled').checked = user.enabled;

                // Show the modal
                const modal = new bootstrap.Modal(document.getElementById('editUserModal'));
                modal.show();
            })
            .catch(error => {
                console.error('Error loading user details for edit:', error);
                showError('Failed to load user details. Please try again later.');
            });
    }

    function saveUserChanges() {
        const token = localStorage.getItem('token');

        // Get form data
        const name = document.getElementById('edit-user-name').value;
        const email = document.getElementById('edit-user-email').value;

        // Get selected roles
        const roles = [];
        if (document.getElementById('role-admin').checked) roles.push('admin');
        if (document.getElementById('role-organizer').checked) roles.push('organizer');
        if (document.getElementById('role-attendee').checked) roles.push('attendee');

        // Get enabled status
        const enabled = document.getElementById('user-enabled').checked;

        // Validate form
        if (!name || !email) {
            showError('Name and email are required');
            return;
        }

        if (roles.length === 0) {
            showError('At least one role must be selected');
            return;
        }

        // Prepare user data
        const userData = {
            id: currentUserId,
            name: name,
            email: email,
            roles: roles,
            enabled: enabled
        };

        // Send update request
        fetch('${pageContext.request.contextPath}/api/admin/users/' + currentUserId, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + token
            },
            body: JSON.stringify(userData)
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Failed to update user');
                }
                return response.json();
            })
            .then(data => {
                // Close the modal
                bootstrap.Modal.getInstance(document.getElementById('editUserModal')).hide();

                // Show success message
                showSuccess('User updated successfully!');

                // Reload users
                loadUsers(currentPage.users);
            })
            .catch(error => {
                console.error('Error updating user:', error);
                showError('Failed to update user. Please try again later.');
            });
    }

    function deleteUser(userId) {
        // Confirm deletion
        if (!confirm('Are you sure you want to delete this user? This action cannot be undone.')) {
            return;
        }

        const token = localStorage.getItem('token');

        fetch('${pageContext.request.contextPath}/api/admin/users/' + userId, {
            method: 'DELETE',
            headers: {
                'Authorization': 'Bearer ' + token
            }
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Failed to delete user');
                }
                return response.text();
            })
            .then(data => {
                // Show success message
                showSuccess('User deleted successfully!');

                // Reload users
                loadUsers(currentPage.users);
            })
            .catch(error => {
                console.error('Error deleting user:', error);
                showError('Failed to delete user. They may have associated data or you do not have permission.');
            });
    }

    function viewEventDetails(eventId) {
        currentEventId = eventId;
        const token = localStorage.getItem('token');

        fetch('${pageContext.request.contextPath}/api/admin/events/' + eventId, {
            method: 'GET',
            headers: {
                'Authorization': 'Bearer ' + token
            }
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Failed to load event details');
                }
                return response.json();
            })
            .then(event => {
                renderEventDetails(event);

                // Show the modal
                const modal = new bootstrap.Modal(document.getElementById('eventDetailsModal'));
                modal.show();

                // Show/hide publish/unpublish buttons based on current status
                document.getElementById('publish-event-btn').style.display = event.published ? 'none' : 'inline-block';
                document.getElementById('unpublish-event-btn').style.display = event.published ? 'inline-block' : 'none';
            })
            .catch(error => {
                console.error('Error loading event details:', error);
                showError('Failed to load event details. Please try again later.');
            });
    }

    function renderEventDetails(event) {
        const container = document.getElementById('event-details-container');

        const startDate = new Date(event.startDateTime).toLocaleDateString('en-US', {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });

        const endDate = new Date(event.endDateTime).toLocaleDateString('en-US', {
            hour: '2-digit',
            minute: '2-digit'
        });

        container.innerHTML = `
                <div class="row">
                    <div class="col-md-4">
                        <img src="${event.bannerImage || '${pageContext.request.contextPath}/resources/images/event-placeholder.jpg'}"
                            alt="${event.title}" class="img-fluid rounded mb-3">

                        <div class="mb-3">
                            <h6>Event Status</h6>
                            <p class="mb-1">
                                <span class="badge ${event.published ? 'bg-success' : 'bg-secondary'} status-badge">
                                    ${event.published ? 'Published' : 'Draft'}
                                </span>
                            </p>
                        </div>

                        <div class="mb-3">
                            <h6>Tickets</h6>
                            <p class="mb-1"><strong>Price:</strong> ${event.ticketPrice}</p>
                            <p class="mb-1"><strong>Total Seats:</strong> ${event.totalSeats}</p>
                            <p class="mb-1"><strong>Available Seats:</strong> ${event.availableSeats}</p>
                        </div>
                <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Event Management System</title>
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
        .status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        .action-buttons .btn {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
        }
        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            object-fit: cover;
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">

    <jsp:include page="../common/header.jsp" />

    <div class="container dashboard-container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Admin Dashboard</h2>
            <div>
                <button class="btn btn-outline-primary me-2" id="refresh-btn">
                    <i class="bi bi-arrow-clockwise me-2"></i>Refresh Data
                </button>
                <a href="${pageContext.request.contextPath}/admin/system-settings" class="btn btn-primary">
                    <i class="bi bi-gear me-2"></i>System Settings
                </a>
            </div>
        </div>

        <div id="error-alert" class="alert alert-danger d-none" role="alert"></div>
        <div id="success-alert" class="alert alert-success d-none" role="alert"></div>

        <!-- Stats Row -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="stats-card text-center">
                    <div class="stats-icon">
                        <i class="bi bi-people"></i>
                    </div>
                    <div class="stats-value" id="total-users">0</div>
                    <div class="stats-label">Total Users</div>
                </div>
            </div>
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
        </div>

        <!-- Tabs Navigation -->
        <ul class="nav nav-pills dashboard-tabs" id="dashboardTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="users-tab" data-bs-toggle="tab" data-bs-target="#users" type="button" role="tab" aria-controls="users" aria-selected="true">Users</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="events-tab" data-bs-toggle="tab" data-bs-target="#events" type="button" role="tab" aria-controls="events" aria-selected="false">Events</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="bookings-tab" data-bs-toggle="tab" data-bs-target="#bookings" type="button" role="tab" aria-controls="bookings" aria-selected="false">Bookings</button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="reports-tab" data-bs-toggle="tab" data-bs-target="#reports" type="button" role="tab" aria-controls="reports" aria-selected="false">Reports</button>
            </li>
        </ul>

        <!-- Tabs Content -->
        <div class="tab-content" id="dashboardTabsContent">
            <!-- Users Tab -->
            <div class="tab-pane fade show active" id="users" role="tabpanel" aria-labelledby="users-tab">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div>
                        <select class="form-select w-auto" id="user-role-filter">
                            <option value="all">All Users</option>
                            <option value="ROLE_ADMIN">Admins</option>
                            <option value="ROLE_ORGANIZER">Organizers</option>
                            <option value="ROLE_ATTENDEE">Attendees</option>
                        </select>
                    </div>
                    <div class="d-flex">
                        <input type="text" class="form-control me-2" id="user-search" placeholder="Search users...">
                        <button class="btn btn-primary" id="user-search-btn">
                            <i class="bi bi-search"></i>
                        </button>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>User</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Provider</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="users-container">
                            <tr>
                                <td colspan="6" class="text-center py-4">
                                    <div class="spinner-border text-primary" role="status">
                                        <span class="visually-hidden">Loading...</span>
                                    </div>
                                    <p class="mt-3">Loading users...</p>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="text-center mt-3" id="users-pagination"></div>
            </div>

            <!-- Events Tab -->
            <div class="tab-pane fade" id="events" role="tabpanel" aria-labelledby="events-tab">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div>
                        <select class="form-select w-auto" id="event-status-filter">
                            <option value="all">All Events</option>
                            <option value="published">Published</option>
                            <option value="draft">Draft</option>
                        </select>
                    </div>
                    <div class="d-flex">
                        <input type="text" class="form-control me-2" id="event-search" placeholder="Search events...">
                        <button class="btn btn-primary" id="event-search-btn">
                            <i class="bi bi-search"></i>
                        </button>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Title</th>
                                <th>Organizer</th>
                                <th>Date</th>
                                <th>Venue</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="events-container">
                            <tr>
                                <td colspan="6" class="text-center py-4">
                                    <div class="spinner-border text-primary" role="status">
                                        <span class="visually-hidden">Loading...</span>
                                    </div>
                                    <p class="mt-3">Loading events...</p>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div class="text-center mt-3" id="events-pagination"></div>
            </div>

            <!-- Bookings Tab -->
            <div class="tab-pane fade" id="bookings" role="tabpanel" aria-labelledby="bookings-tab">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div>
                        <select class="form-select w-auto" id="booking-status-filter">
                            <option value="all">All Bookings</option>
                            <option value="PENDING">Pending</option>
                            <option value="CONFIRMED">Confirmed</option>
                            <option value="COMPLETED">Completed</option>
                            <option value="CANCELLED">Cancelled</option>
                        </select>
                    </div>
                    <div class="d-flex">
                        <input type="text" class="form-control me-2" id="booking-search" placeholder="Search bookings...">
                        <button class="btn btn-primary" id="booking-search-btn">
                            <i class="bi bi-search"></i>
                        </button>
                    </div>
                </div>

                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>Booking ID</th>
                                <th>Event</th>
                                <th>Customer</th>
                                <th>Date</th>
                                <th>Amount</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody id="bookings-container">
                            <tr>
                                <td colspan="7" class="text-center py-4">
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

            <!-- Reports Tab -->
            <div class="tab-pane fade" id="reports" role="tabpanel" aria-labelledby="reports-tab">
                <div class="row">
                    <div class="col-md-6 mb-4">
                        <div class="card h-100">
                            <div class="card-header">
                                <h5 class="card-title mb-0">Monthly Revenue</h5>
                            </div>
                            <div class="card-body">
                                <canvas id="revenueChart" height="250"></canvas>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 mb-4">
                        <div class="card h-100">
                            <div class="card-header">
                                <h5 class="card-title mb-0">Event Categories Distribution</h5>
                            </div>
                            <div class="card-body">
                                <canvas id="categoriesChart" height="250"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6 mb-4">
                        <div class="card h-100">
                            <div class="card-header">
                                <h5 class="card-title mb-0">User Registrations</h5>
                            </div>
                            <div class="card-body">
                                <canvas id="registrationsChart" height="250"></canvas>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 mb-4">
                        <div class="card h-100">
                            <div class="card-header">
                                <h5 class="card-title mb-0">Top Events (by Bookings)</h5>
                            </div>
                            <div class="card-body">
                                <canvas id="topEventsChart" height="250"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- User Details Modal -->
    <div class="modal fade" id="userDetailsModal" tabindex="-1" aria-labelledby="userDetailsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="userDetailsModalLabel">User Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="user-details-container">
                    <!-- User details will be loaded here -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" id="edit-user-btn" class="btn btn-primary">Edit User</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit User Modal -->
    <div class="modal fade" id="editUserModal" tabindex="-1" aria-labelledby="editUserModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editUserModalLabel">Edit User</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="edit-user-form">
                        <div class="mb-3">
                            <label for="edit-user-name" class="form-label">Name</label>
                            <input type="text" class="form-control" id="edit-user-name" required>
                        </div>
                        <div class="mb-3">
                            <label for="edit-user-email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="edit-user-email" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Roles</label>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="role-admin">
                                <label class="form-check-label" for="role-admin">Admin</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="role-organizer">
                                <label class="form-check-label" for="role-organizer">Organizer</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="role-attendee">
                                <label class="form-check-label" for="role-attendee">Attendee</label>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Status</label>
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" id="user-enabled">
                                <label class="form-check-label" for="user-enabled">Enabled</label>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" id="save-user-btn" class="btn btn-primary">Save Changes</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Event Details Modal -->
    <div class="modal fade" id="eventDetailsModal" tabindex="-1" aria-labelledby="eventDetailsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="eventDetailsModalLabel">Event Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="event-details-container">
                    <!-- Event details will be loaded here -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <button type="button" id="publish-event-btn" class="btn btn-success">Publish</button>
                    <button type="button" id="unpublish-event-btn" class="btn btn-warning">Unpublish</button>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../common/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    let currentUserId = null;
    let currentEventId = null;
    let currentBookingId = null;
    let currentPage = {
        users: 0,
        events: 0,
        bookings: 0
    };
    let charts = {};

    document.addEventListener('DOMContentLoaded', function() {
        // Check if user is logged in as admin
        const token = localStorage.getItem('token');
        const user = JSON.parse(localStorage.getItem('user'));

        if (!token || !user || !user.roles.includes('ROLE_ADMIN')) {
            window.location.href = '${pageContext.request.contextPath}/login';
            return;
        }

        // Load dashboard data
        loadDashboardStats();
        loadUsers(0);

        // Tab change handlers
        document.getElementById('events-tab').addEventListener('click', function() {
            loadEvents(0);
        });

        document.getElementById('bookings-tab').addEventListener('click', function() {
            loadBookings(0);
        });