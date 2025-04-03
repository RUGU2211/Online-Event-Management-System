<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Event Details - Event Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/styles.css">
    <style>
        .event-banner {
            height: 400px;
            object-fit: cover;
            border-radius: 10px;
        }
        .event-details {
            padding-top: 30px;
        }
        .booking-card {
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.05);
            padding: 25px;
            position: sticky;
            top: 100px;
        }
        .reviews-section {
            margin-top: 50px;
        }
        .review-card {
            margin-bottom: 20px;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
        }
        .reviewer-img {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            object-fit: cover;
        }
        .organizer-info {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }
        .organizer-img {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            object-fit: cover;
            margin-right: 15px;
        }
        .event-meta {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
            color: #6c757d;
        }
        .event-meta i {
            margin-right: 10px;
            font-size: 1.2rem;
            color: #6c63ff;
        }
        .event-category {
            display: inline-block;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
            color: #fff;
            background-color: #6c63ff;
            margin-bottom: 20px;
        }
        .btn-book {
            background-color: #6c63ff;
            border-color: #6c63ff;
            font-size: 1.1rem;
            padding: 10px 20px;
        }
        .btn-book:hover {
            background-color: #5a52d5;
            border-color: #5a52d5;
        }
        .rating-stars {
            color: #ffc107;
        }
        #review-form {
            margin-top: 30px;
            padding: 20px;
            border-radius: 10px;
            background-color: #f8f9fa;
        }
    </style>
</head>
<body class="d-flex flex-column min-vh-100">

<jsp:include page="common/header.jsp" />

<div class="container my-5">
    <div id="error-alert" class="alert alert-danger d-none" role="alert"></div>
    <div id="success-alert" class="alert alert-success d-none" role="alert"></div>

    <div id="event-container">
        <!-- Event details will be loaded here -->
        <div class="text-center py-5">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
            <p class="mt-3">Loading event details...</p>
        </div>
    </div>
</div>

<jsp:include page="common/footer.jsp" />

<!-- Booking Modal -->
<div class="modal fade" id="bookingModal" tabindex="-1" aria-labelledby="bookingModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="bookingModalLabel">Book Tickets</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="booking-form">
                    <div class="mb-3">
                        <label for="event-title" class="form-label">Event</label>
                        <input type="text" class="form-control" id="event-title" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="event-date" class="form-label">Date & Time</label>
                        <input type="text" class="form-control" id="event-date" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="ticket-count" class="form-label">Number of Tickets</label>
                        <input type="number" class="form-control" id="ticket-count" min="1" value="1" required>
                        <div class="form-text">Available seats: <span id="available-seats">0</span></div>
                    </div>
                    <div class="mb-3">
                        <label for="ticket-price" class="form-label">Price per Ticket</label>
                        <input type="text" class="form-control" id="ticket-price" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="total-amount" class="form-label">Total Amount</label>
                        <input type="text" class="form-control" id="total-amount" readonly>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="confirm-booking-btn">Confirm Booking</button>
            </div>
        </div>
    </div>
</div>

<!-- Review Modal -->
<div class="modal fade" id="reviewModal" tabindex="-1" aria-labelledby="reviewModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="reviewModalLabel">Write a Review</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="review-modal-form">
                    <div class="mb-3">
                        <label class="form-label">Rating</label>
                        <div class="rating-input">
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="rating" id="rating-5" value="5" checked>
                                <label class="form-check-label" for="rating-5">5 - Excellent</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="rating" id="rating-4" value="4">
                                <label class="form-check-label" for="rating-4">4 - Very Good</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="rating" id="rating-3" value="3">
                                <label class="form-check-label" for="rating-3">3 - Good</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="rating" id="rating-2" value="2">
                                <label class="form-check-label" for="rating-2">2 - Fair</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="rating" id="rating-1" value="1">
                                <label class="form-check-label" for="rating-1">1 - Poor</label>
                            </div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="review-comment" class="form-label">Comment</label>
                        <textarea class="form-control" id="review-comment" rows="4" placeholder="Share your experience about this event"></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="submit-review-btn">Submit Review</button>
            </div>
        </div>
    </div>
</div>

<!-- Payment Modal -->
<div class="modal fade" id="paymentModal" tabindex="-1" aria-labelledby="paymentModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="paymentModalLabel">Complete Payment</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div id="payment-details">
                    <p>Event: <span id="payment-event-title"></span></p>
                    <p>Tickets: <span id="payment-ticket-count"></span></p>
                    <p>Total Amount: <span id="payment-total-amount"></span></p>
                </div>
                <div id="razorpay-button-container" class="text-center mt-3"></div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://checkout.razorpay.com/v1/checkout.js"></script>
<script>
    let currentEvent = null;
    let currentBooking = null;
    const eventId = window.location.pathname.split('/').pop();

    document.addEventListener('DOMContentLoaded', function() {
        // Load event details
        loadEventDetails();

        // Ticket count change handler (to calculate total amount)
        document.getElementById('ticket-count').addEventListener('input', function() {
            updateTotalAmount();
        });

        // Confirm booking button handler
        document.getElementById('confirm-booking-btn').addEventListener('click', function() {
            createBooking();
        });

        // Submit review button handler
        document.getElementById('submit-review-btn').addEventListener('click', function() {
            submitReview();
        });
    });

    function loadEventDetails() {
        const token = localStorage.getItem('token');
        const headers = token ? { 'Authorization': 'Bearer ' + token } : {};

        fetch('${pageContext.request.contextPath}/api/reviews', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ' + token
            },
            body: JSON.stringify({
                eventId: currentEvent.id,
                rating: parseInt(rating),
                comment: comment
            })
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Failed to submit review');
                }
                return response.json();
            })
            .then(data => {
                // Close review modal
                bootstrap.Modal.getInstance(document.getElementById('reviewModal')).hide();

                // Show success message
                showSuccess('Review submitted successfully!');

                // Reload reviews
                loadEventReviews();

                // Reload event details to update average rating
                loadEventDetails();
            })
            .catch(error => {
                console.error('Error submitting review:', error);
                showError('Failed to submit review. You may have already reviewed this event or did not attend it.');
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
</html>${pageContext.request.contextPath}/api/public/events/' + eventId, {
method: 'GET',
headers: headers
})
.then(response => {
if (!response.ok) {
throw new Error('Event not found');
}
return response.json();
})
.then(data => {
currentEvent = data;
renderEventDetails(data);
loadEventReviews();
})
.catch(error => {
console.error('Error loading event details:', error);
document.getElementById('event-container').innerHTML =
'<div class="alert alert-danger">Failed to load event details. The event may not exist or has been removed.</div>';
});
}

function renderEventDetails(event) {
const startDate = new Date(event.startDateTime);
const endDate = new Date(event.endDateTime);

const formattedStartDate = startDate.toLocaleDateString('en-US', {
weekday: 'long',
year: 'numeric',
month: 'long',
day: 'numeric',
hour: '2-digit',
minute: '2-digit'
});

const formattedEndDate = endDate.toLocaleDateString('en-US', {
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

const html = `
<div class="row">
    <div class="col-lg-8">
        <img src="${event.bannerImage || '${pageContext.request.contextPath}/resources/images/event-placeholder.jpg'}"
             class="img-fluid event-banner w-100" alt="${event.title}">

        <div class="event-details">
            <div class="d-flex justify-content-between align-items-start mb-3">
                <div>
                    <span class="event-category ${badgeColor}">${event.category}</span>
                    <h1 class="mt-2">${event.title}</h1>
                </div>
                <div class="text-end">
                    <div class="d-flex align-items-center mb-2">
                        <div class="rating-stars me-2">
                            ${getRatingStars(event.averageRating || 0)}
                        </div>
                        <span>${event.averageRating ? event.averageRating.toFixed(1) : 'No ratings yet'}</span>
                    </div>
                </div>
            </div>

            <div class="organizer-info">
                <img src="${pageContext.request.contextPath}/resources/images/default-profile.png" class="organizer-img" alt="Organizer">
                <div>
                    <p class="mb-0 fw-bold">Organized by</p>
                    <p class="mb-0">${event.organizerName}</p>
                </div>
            </div>

            <div class="event-meta">
                <i class="bi bi-calendar-event"></i>
                <div>
                    <p class="mb-0">${formattedStartDate}</p>
                    <p class="mb-0">to ${formattedEndDate}</p>
                </div>
            </div>

            <div class="event-meta">
                <i class="bi bi-geo-alt"></i>
                <div>
                    <p class="mb-0">${event.venue}</p>
                    <p class="mb-0">${event.venueAddress || ''}</p>
                </div>
            </div>

            <hr class="my-4">

            <h4>About This Event</h4>
            <p>${event.description || 'No description provided.'}</p>

            <div class="reviews-section">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h4>Reviews</h4>
                    <button id="write-review-btn" class="btn btn-outline-primary">Write a Review</button>
                </div>

                <div id="reviews-container">
                    <div class="text-center py-3">
                        <div class="spinner-border text-primary" role="status">
                            <span class="visually-hidden">Loading reviews...</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="col-lg-4">
        <div class="booking-card">
            <h4 class="mb-3">Book Tickets</h4>

            <div class="d-flex justify-content-between align-items-center mb-3">
                <span>Price per ticket</span>
                <span class="fw-bold">$${event.ticketPrice}</span>
            </div>

            <div class="d-flex justify-content-between align-items-center mb-3">
                <span>Available seats</span>
                <span class="fw-bold">${event.availableSeats} / ${event.totalSeats}</span>
            </div>

            ${event.availableSeats > 0 ?
                    `<button id="book-now-btn" class="btn btn-primary btn-book w-100">Book Now</button>` :
                    `<button class="btn btn-secondary w-100" disabled>Sold Out</button>`
                    }

            <hr class="my-4">

            <div class="share-event">
                <p class="mb-2 fw-bold">Share this event</p>
                <div class="d-flex gap-2">
                    <a href="#" class="btn btn-outline-primary btn-sm"><i class="bi bi-facebook"></i></a>
                    <a href="#" class="btn btn-outline-primary btn-sm"><i class="bi bi-twitter"></i></a>
                    <a href="#" class="btn btn-outline-primary btn-sm"><i class="bi bi-linkedin"></i></a>
                    <a href="#" class="btn btn-outline-primary btn-sm"><i class="bi bi-envelope"></i></a>
                </div>
            </div>
        </div>
    </div>
</div>
`;

document.getElementById('event-container').innerHTML = html;

// Add event listeners after rendering
const bookNowBtn = document.getElementById('book-now-btn');
if (bookNowBtn) {
bookNowBtn.addEventListener('click', openBookingModal);
}

const writeReviewBtn = document.getElementById('write-review-btn');
if (writeReviewBtn) {
writeReviewBtn.addEventListener('click', openReviewModal);
}
}

function getRatingStars(rating) {
const fullStars = Math.floor(rating);
const halfStar = rating % 1 >= 0.5;
const emptyStars = 5 - fullStars - (halfStar ? 1 : 0);

let stars = '';

// Add full stars
for (let i = 0; i < fullStars; i++) {
stars += '<i class="bi bi-star-fill"></i>';
}

// Add half star if needed
if (halfStar) {
stars += '<i class="bi bi-star-half"></i>';
}

// Add empty stars
for (let i = 0; i < emptyStars; i++) {
stars += '<i class="bi bi-star"></i>';
}

return stars;
}

function loadEventReviews() {
const token = localStorage.getItem('token');
const headers = token ? { 'Authorization': 'Bearer ' + token } : {};

fetch('${pageContext.request.contextPath}/api/public/reviews/event/' + eventId, {
method: 'GET',
headers: headers
})
.then(response => response.json())
.then(data => {
renderReviews(data.content);
})
.catch(error => {
console.error('Error loading reviews:', error);
document.getElementById('reviews-container').innerHTML =
'<p class="text-muted">Failed to load reviews. Please try again later.</p>';
});
}

function renderReviews(reviews) {
const container = document.getElementById('reviews-container');

if (!reviews || reviews.length === 0) {
container.innerHTML = '<p class="text-muted">No reviews yet. Be the first to review this event!</p>';
return;
}

let html = '';

reviews.forEach(review => {
const reviewDate = new Date(review.reviewDate).toLocaleDateString('en-US', {
year: 'numeric',
month: 'short',
day: 'numeric'
});

html += `
<div class="review-card">
    <div class="d-flex align-items-center mb-3">
        <img src="${review.userProfilePicture || '${pageContext.request.contextPath}/resources/images/default-profile.png'}"
             class="reviewer-img me-3" alt="${review.userName}">
        <div>
            <h6 class="mb-0">${review.userName}</h6>
            <div class="d-flex align-items-center">
                <div class="rating-stars me-2">
                    ${getRatingStars(review.rating)}
                </div>
                <small class="text-muted">${reviewDate}</small>
            </div>
        </div>
    </div>
    <p class="mb-0">${review.comment || 'No comment provided.'}</p>
</div>
`;
});

container.innerHTML = html;
}

function openBookingModal() {
// Check if user is logged in
const token = localStorage.getItem('token');
if (!token) {
window.location.href = '${pageContext.request.contextPath}/login?redirect=' + window.location.pathname;
return;
}

// Populate booking modal with event details
document.getElementById('event-title').value = currentEvent.title;
document.getElementById('event-date').value = new Date(currentEvent.startDateTime).toLocaleString();
document.getElementById('available-seats').textContent = currentEvent.availableSeats;
document.getElementById('ticket-price').value = '$' + currentEvent.ticketPrice;

// Set max tickets to available seats
const ticketCountInput = document.getElementById('ticket-count');
ticketCountInput.max = currentEvent.availableSeats;
ticketCountInput.value = 1;

// Calculate initial total amount
updateTotalAmount();

// Show the modal
const bookingModal = new bootstrap.Modal(document.getElementById('bookingModal'));
bookingModal.show();
}

function updateTotalAmount() {
const ticketCount = parseInt(document.getElementById('ticket-count').value);
const totalAmount = ticketCount * currentEvent.ticketPrice;
document.getElementById('total-amount').value = '$' + totalAmount.toFixed(2);
}

function createBooking() {
const token = localStorage.getItem('token');
if (!token) {
window.location.href = '${pageContext.request.contextPath}/login';
return;
}

const ticketCount = parseInt(document.getElementById('ticket-count').value);

// Validate ticket count
if (ticketCount <= 0 || ticketCount > currentEvent.availableSeats) {
showError('Invalid ticket count. Please select a number between 1 and ' + currentEvent.availableSeats);
return;
}

// Create booking
fetch('${pageContext.request.contextPath}/api/bookings', {
method: 'POST',
headers: {
'Content-Type': 'application/json',
'Authorization': 'Bearer ' + token
},
body: JSON.stringify({
eventId: currentEvent.id,
numberOfTickets: ticketCount
})
})
.then(response => {
if (!response.ok) {
throw new Error('Failed to create booking');
}
return response.json();
})
.then(data => {
currentBooking = data;

// Close booking modal
bootstrap.Modal.getInstance(document.getElementById('bookingModal')).hide();

// Show payment modal
openPaymentModal();
})
.catch(error => {
console.error('Error creating booking:', error);
showError('Failed to create booking. Please try again later.');
});
}

function openPaymentModal() {
// Populate payment details
document.getElementById('payment-event-title').textContent = currentEvent.title;
document.getElementById('payment-ticket-count').textContent = currentBooking.numberOfTickets;
document.getElementById('payment-total-amount').textContent = '$' + currentBooking.totalAmount;

// Create payment order
createPaymentOrder();

// Show the modal
const paymentModal = new bootstrap.Modal(document.getElementById('paymentModal'));
paymentModal.show();
}

function createPaymentOrder() {
const token = localStorage.getItem('token');

fetch('${pageContext.request.contextPath}/api/bookings/' + currentBooking.id + '/create-payment-order', {
method: 'POST',
headers: {
'Authorization': 'Bearer ' + token
}
})
.then(response => {
if (!response.ok) {
throw new Error('Failed to create payment order');
}
return response.json();
})
.then(data => {
// Initialize Razorpay
initRazorpayPayment(data.orderId);
})
.catch(error => {
console.error('Error creating payment order:', error);
showError('Failed to create payment order. Please try again later.');
bootstrap.Modal.getInstance(document.getElementById('paymentModal')).hide();
});
}

function initRazorpayPayment(orderId) {
const user = JSON.parse(localStorage.getItem('user'));

const options = {
key: 'YOUR_RAZORPAY_KEY_ID', // Replace with your actual Razorpay key ID
amount: currentBooking.totalAmount * 100, // Amount in smallest currency unit (paise)
currency: 'USD',
name: 'Event Management System',
description: 'Booking for ' + currentEvent.title,
order_id: orderId,
handler: function(response) {
processPayment(response);
},
prefill: {
name: user.name,
email: user.email
},
theme: {
color: '#6c63ff'
}
};

const rzp = new Razorpay(options);

// Create a button to open Razorpay
document.getElementById('razorpay-button-container').innerHTML =
`<button id="rzp-button" class="btn btn-primary btn-lg">Pay Now</button>`;

document.getElementById('rzp-button').onclick = function(e) {
rzp.open();
e.preventDefault();
};
}

function processPayment(response) {
const token = localStorage.getItem('token');

fetch('${pageContext.request.contextPath}/api/bookings/' + currentBooking.id + '/process-payment', {
method: 'POST',
headers: {
'Content-Type': 'application/json',
'Authorization': 'Bearer ' + token
},
body: JSON.stringify({
paymentId: response.razorpay_payment_id,
orderId: response.razorpay_order_id,
signature: response.razorpay_signature
})
})
.then(response => {
if (!response.ok) {
throw new Error('Payment verification failed');
}
return response.json();
})
.then(data => {
// Close payment modal
bootstrap.Modal.getInstance(document.getElementById('paymentModal')).hide();

// Show success message
showSuccess('Payment successful! Your booking is confirmed.');

// Reload event details to update available seats
setTimeout(() => {
loadEventDetails();
}, 2000);
})
.catch(error => {
console.error('Error processing payment:', error);
showError('Payment processing failed. Please try again later.');
bootstrap.Modal.getInstance(document.getElementById('paymentModal')).hide();
});
}

function openReviewModal() {
// Check if user is logged in
const token = localStorage.getItem('token');
if (!token) {
window.location.href = '${pageContext.request.contextPath}/login?redirect=' + window.location.pathname;
return;
}

// Reset form
document.getElementById('rating-5').checked = true;
document.getElementById('review-comment').value = '';

// Show the modal
const reviewModal = new bootstrap.Modal(document.getElementById('reviewModal'));
reviewModal.show();
}

function submitReview() {
const token = localStorage.getItem('token');
if (!token) {
window.location.href = '${pageContext.request.contextPath}/login';
return;
}

const rating = document.querySelector('input[name="rating"]:checked').value;
const comment = document.getElementById('review-comment').value;

fetch('