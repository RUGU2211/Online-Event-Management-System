<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<footer class="footer mt-auto py-4 bg-dark text-white">
    <div class="container">
        <div class="row">
            <div class="col-md-4 mb-4 mb-md-0">
                <h5>Event Management System</h5>
                <p class="text-muted">Find, book, and manage events with ease. Create memorable experiences and connect with people who share your interests.</p>
                <div class="social-icons mt-3">
                    <a href="#" class="text-white me-3"><i class="bi bi-facebook"></i></a>
                    <a href="#" class="text-white me-3"><i class="bi bi-twitter"></i></a>
                    <a href="#" class="text-white me-3"><i class="bi bi-instagram"></i></a>
                    <a href="#" class="text-white"><i class="bi bi-linkedin"></i></a>
                </div>
            </div>

            <div class="col-md-2 mb-4 mb-md-0">
                <h6>Quick Links</h6>
                <ul class="list-unstyled">
                    <li><a href="${pageContext.request.contextPath}/" class="text-decoration-none text-white-50">Home</a></li>
                    <li><a href="${pageContext.request.contextPath}/events" class="text-decoration-none text-white-50">Events</a></li>
                    <li><a href="${pageContext.request.contextPath}/about" class="text-decoration-none text-white-50">About Us</a></li>
                    <li><a href="${pageContext.request.contextPath}/contact" class="text-decoration-none text-white-50">Contact</a></li>
                </ul>
            </div>

            <div class="col-md-2 mb-4 mb-md-0">
                <h6>Event Categories</h6>
                <ul class="list-unstyled">
                    <li><a href="${pageContext.request.contextPath}/events/category/CONFERENCE" class="text-decoration-none text-white-50">Conferences</a></li>
                    <li><a href="${pageContext.request.contextPath}/events/category/WORKSHOP" class="text-decoration-none text-white-50">Workshops</a></li>
                    <li><a href="${pageContext.request.contextPath}/events/category/CULTURAL" class="text-decoration-none text-white-50">Cultural</a></li>
                    <li><a href="${pageContext.request.contextPath}/events/category/TECH" class="text-decoration-none text-white-50">Tech</a></li>
                </ul>
            </div>

            <div class="col-md-4">
                <h6>Subscribe to our Newsletter</h6>
                <p class="text-muted">Stay updated with the latest events and offers</p>
                <form class="mb-3">
                    <div class="input-group">
                        <input type="email" class="form-control" placeholder="Your email" aria-label="Subscribe" required>
                        <button class="btn btn-primary" type="submit">Subscribe</button>
                    </div>
                </form>
                <p class="small text-muted">
                    By subscribing, you agree to our <a href="${pageContext.request.contextPath}/terms" class="text-white-50">Terms</a> and
                    <a href="${pageContext.request.contextPath}/privacy" class="text-white-50">Privacy Policy</a>.
                </p>
            </div>
        </div>

        <hr class="my-4 bg-secondary">

        <div class="row align-items-center">
            <div class="col-md-6 text-center text-md-start">
                <p class="mb-0 text-muted">&copy; <%= java.time.Year.now().getValue() %> Event Management System. All rights reserved.</p>
            </div>
            <div class="col-md-6 text-center text-md-end mt-3 mt-md-0">
                <ul class="list-inline mb-0">
                    <li class="list-inline-item"><a href="${pageContext.request.contextPath}/terms" class="text-decoration-none text-white-50">Terms of Service</a></li>
                    <li class="list-inline-item"><span class="text-muted">|</span></li>
                    <li class="list-inline-item"><a href="${pageContext.request.contextPath}/privacy" class="text-decoration-none text-white-50">Privacy Policy</a></li>
                </ul>
            </div>
        </div>
    </div>
</footer>