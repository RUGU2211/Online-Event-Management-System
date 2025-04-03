/**
 * Event Management System - Main JavaScript File
 *
 * This file contains common JavaScript functions used across the application.
 */

document.addEventListener('DOMContentLoaded', function() {
    // Initialize Bootstrap components
    initBootstrapComponents();

    // Check authentication status
    checkAuthStatus();

    // Add event listeners for common elements
    addGlobalEventListeners();
});

/**
 * Initialize Bootstrap components like tooltips, popovers, etc.
 */
function initBootstrapComponents() {
    // Initialize tooltips
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });

    // Initialize popovers
    var popoverTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="popover"]'));
    popoverTriggerList.map(function (popoverTriggerEl) {
        return new bootstrap.Popover(popoverTriggerEl);
    });
}

/**
 * Check if the user is authenticated and update UI accordingly
 */
function checkAuthStatus() {
    const token = localStorage.getItem('token');
    const user = JSON.parse(localStorage.getItem('user'));

    if (token && user) {
        // User is logged in
        document.querySelectorAll('.logged-in-only').forEach(el => {
            el.classList.remove('d-none');
        });
        document.querySelectorAll('.logged-out-only').forEach(el => {
            el.classList.add('d-none');
        });

        // Set user info if elements exist
        const userNameElement = document.getElementById('user-name');
        if (userNameElement) {
            userNameElement.textContent = user.name;
        }

        const userProfilePic = document.getElementById('user-profile-pic');
        if (userProfilePic) {
            userProfilePic.src = user.profilePicture || '/resources/images/default-profile.png';
            userProfilePic.alt = user.name;
        }

        // Show role-specific elements
        if (user.roles.includes('ROLE_ADMIN')) {
            document.querySelectorAll('.admin-only').forEach(el => {
                el.classList.remove('d-none');
            });
        }

        if (user.roles.includes('ROLE_ORGANIZER')) {
            document.querySelectorAll('.organizer-only').forEach(el => {
                el.classList.remove('d-none');
            });
        }

        if (user.roles.includes('ROLE_ATTENDEE')) {
            document.querySelectorAll('.attendee-only').forEach(el => {
                el.classList.remove('d-none');
            });
        }
    } else {
        // User is not logged in
        document.querySelectorAll('.logged-in-only').forEach(el => {
            el.classList.add('d-none');
        });
        document.querySelectorAll('.logged-out-only').forEach(el => {
            el.classList.remove('d-none');
        });
        document.querySelectorAll('.admin-only, .organizer-only, .attendee-only').forEach(el => {
            el.classList.add('d-none');
        });
    }
}

/**
 * Add global event listeners for common elements
 */
function addGlobalEventListeners() {
    // Logout button click handler
    const logoutBtn = document.getElementById('logout-btn');
    if (logoutBtn) {
        logoutBtn.addEventListener('click', function(e) {
            e.preventDefault();
            logout();
        });
    }

    // Search form submit handler
    const searchForm = document.getElementById('global-search-form');
    if (searchForm) {
        searchForm.addEventListener('submit', function(e) {
            e.preventDefault();
            const keyword = document.getElementById('global-search-input').value.trim();
            if (keyword) {
                window.location.href = '/events/search?keyword=' + encodeURIComponent(keyword);
            }
        });
    }
}

/**
 * Handle user logout
 */
function logout() {
    // Clear local storage
    localStorage.removeItem('token');
    localStorage.removeItem('user');

    // Redirect to home page
    window.location.href = '/';
}

/**
 * Make authenticated API requests
 *
 * @param {string} url - The API endpoint URL
 * @param {Object} options - Request options
 * @returns {Promise} - Fetch promise
 */
function apiRequest(url, options = {}) {
    const token = localStorage.getItem('token');

    // Set default headers
    if (!options.headers) {
        options.headers = {};
    }

    // Add authorization header if token exists
    if (token) {
        options.headers['Authorization'] = 'Bearer ' + token;
    }

    // Add default content type for POST/PUT requests
    if ((options.method === 'POST' || options.method === 'PUT') && !options.headers['Content-Type']) {
        options.headers['Content-Type'] = 'application/json';
    }

    return fetch(url, options)
        .then(response => {
            // Handle 401 Unauthorized (token expired or invalid)
            if (response.status === 401) {
                // Clear token and redirect to login
                localStorage.removeItem('token');
                localStorage.removeItem('user');
                window.location.href = '/login?redirect=' + encodeURIComponent(window.location.pathname);
                throw new Error('Unauthorized');
            }

            return response;
        });
}

/**
 * Format date and time
 *
 * @param {string} dateString - ISO date string
 * @param {boolean} includeTime - Whether to include time
 * @returns {string} - Formatted date string
 */
function formatDate(dateString, includeTime = true) {
    const date = new Date(dateString);

    const options = {
        weekday: 'long',
        year: 'numeric',
        month: 'long',
        day: 'numeric'
    };

    if (includeTime) {
        options.hour = '2-digit';
        options.minute = '2-digit';
    }

    return date.toLocaleDateString('en-US', options);
}

/**
 * Format currency
 *
 * @param {number} amount - The amount to format
 * @param {string} currency - Currency code (default: USD)
 * @returns {string} - Formatted currency string
 */
function formatCurrency(amount, currency = 'USD') {
    return new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: currency
    }).format(amount);
}

/**
 * Display a notification to the user
 *
 * @param {string} message - The message to display
 * @param {string} type - The type of notification (success, error, warning, info)
 * @param {number} duration - Duration in milliseconds
 */
function showNotification(message, type = 'info', duration = 5000) {
    // Create notification element if it doesn't exist
    let notificationContainer = document.getElementById('notification-container');

    if (!notificationContainer) {
        notificationContainer = document.createElement('div');
        notificationContainer.id = 'notification-container';
        notificationContainer.className = 'notification-container';
        document.body.appendChild(notificationContainer);
    }

    // Create notification
    const notification = document.createElement('div');
    notification.className = 'notification notification-' + type;

    // Add icon based on type
    let icon = '';
    switch (type) {
        case 'success':
            icon = '<i class="bi bi-check-circle"></i>';
            break;
        case 'error':
            icon = '<i class="bi bi-x-circle"></i>';
            break;
        case 'warning':
            icon = '<i class="bi bi-exclamation-triangle"></i>';
            break;
        default:
            icon = '<i class="bi bi-info-circle"></i>';
    }

    // Set notification content
    notification.innerHTML = `
        <div class="notification-icon">${icon}</div>
        <div class="notification-message">${message}</div>
        <button class="notification-close"><i class="bi bi-x"></i></button>
    `;

    // Add to container
    notificationContainer.appendChild(notification);

    // Add show class after a small delay (for animation)
    setTimeout(() => {
        notification.classList.add('show');
    }, 10);

    // Add close button event listener
    const closeButton = notification.querySelector('.notification-close');
    closeButton.addEventListener('click', () => {
        closeNotification(notification);
    });

    // Auto-remove after duration
    setTimeout(() => {
        closeNotification(notification);
    }, duration);
}

/**
 * Close a notification
 *
 * @param {HTMLElement} notification - The notification element to close
 */
function closeNotification(notification) {
    // Remove show class (triggers fade out animation)
    notification.classList.remove('show');

    // Remove element after animation completes
    setTimeout(() => {
        if (notification.parentElement) {
            notification.parentElement.removeChild(notification);
        }
    }, 300); // Match this with CSS transition duration
}

/**
 * Generate star rating HTML
 *
 * @param {number} rating - Rating value (0-5)
 * @param {boolean} interactive - Whether the stars should be interactive
 * @returns {string} - HTML for star rating
 */
function generateStarRating(rating, interactive = false) {
    const fullStars = Math.floor(rating);
    const halfStar = rating % 1 >= 0.5;
    const emptyStars = 5 - fullStars - (halfStar ? 1 : 0);

    let html = '<div class="star-rating">';

    // Full stars
    for (let i = 0; i < fullStars; i++) {
        if (interactive) {
            html += `<i class="bi bi-star-fill" data-rating="${i + 1}"></i>`;
        } else {
            html += '<i class="bi bi-star-fill"></i>';
        }
    }

    // Half star
    if (halfStar) {
        if (interactive) {
            html += `<i class="bi bi-star-half" data-rating="${fullStars + 0.5}"></i>`;
        } else {
            html += '<i class="bi bi-star-half"></i>';
        }
    }

    // Empty stars
    for (let i = 0; i < emptyStars; i++) {
        if (interactive) {
            html += `<i class="bi bi-star" data-rating="${fullStars + (halfStar ? 1 : 0) + i + 1}"></i>`;
        } else {
            html += '<i class="bi bi-star"></i>';
        }
    }

    html += '</div>';

    return html;
}

/**
 * Initialize interactive star rating elements
 *
 * @param {string} containerSelector - Selector for container with star rating
 * @param {function} callback - Callback function when rating changes
 */
function initStarRating(containerSelector, callback) {
    const container = document.querySelector(containerSelector);
    if (!container) return;

    const stars = container.querySelectorAll('.bi');

    stars.forEach(star => {
        // Hover effect
        star.addEventListener('mouseenter', function() {
            const rating = parseFloat(this.getAttribute('data-rating'));

            stars.forEach(s => {
                const starRating = parseFloat(s.getAttribute('data-rating'));

                if (starRating <= rating) {
                    s.classList.remove('bi-star', 'bi-star-half');
                    s.classList.add('bi-star-fill');
                } else if (starRating - 0.5 === rating) {
                    s.classList.remove('bi-star', 'bi-star-fill');
                    s.classList.add('bi-star-half');
                } else {
                    s.classList.remove('bi-star-fill', 'bi-star-half');
                    s.classList.add('bi-star');
                }
            });
        });

        // Click to set rating
        star.addEventListener('click', function() {
            const rating = parseFloat(this.getAttribute('data-rating'));

            // Set hidden input value if exists
            const ratingInput = container.querySelector('input[type="hidden"]');
            if (ratingInput) {
                ratingInput.value = rating;
            }

            // Call callback if provided
            if (typeof callback === 'function') {
                callback(rating);
            }
        });
    });

    // Reset on mouse leave
    container.addEventListener('mouseleave', function() {
        const ratingInput = container.querySelector('input[type="hidden"]');
        const currentRating = ratingInput ? parseFloat(ratingInput.value) : 0;

        stars.forEach(s => {
            const starRating = parseFloat(s.getAttribute('data-rating'));

            if (starRating <= currentRating) {
                s.classList.remove('bi-star', 'bi-star-half');
                s.classList.add('bi-star-fill');
            } else if (starRating - 0.5 === currentRating) {
                s.classList.remove('bi-star', 'bi-star-fill');
                s.classList.add('bi-star-half');
            } else {
                s.classList.remove('bi-star-fill', 'bi-star-half');
                s.classList.add('bi-star');
            }
        });
    });
}