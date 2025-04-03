# Advanced Online Event Management System

A comprehensive web-based event management solution that allows users to create, manage, and book events. The system facilitates event organization with features like Google login integration, ticket booking, email notifications, and more.

## Features

### User Management
- **Multiple User Roles**: Admin, Event Organizer, and Attendee
- **Google Login Integration**: Sign in using Google accounts
- **JWT Authentication**: Secure token-based authentication
- **Role-based Access Control**: Different features for each user type

### Event Management
- **Create and Manage Events**: Complete CRUD operations for events
- **Event Categories**: Organize events by type (conferences, workshops, etc.)
- **Event Scheduling**: Set date, time, and venue details
- **Publishing Controls**: Publish/unpublish events as needed

### Booking System
- **Ticket Booking**: Book tickets for available events
- **Payment Integration**: Razorpay payment gateway for secure transactions
- **E-Tickets**: Automatic generation of QR code tickets
- **Email Confirmations**: Get booking confirmations via email

### Dashboard & Analytics
- **Admin Dashboard**: Monitor user activity, event statistics, and revenue
- **Organizer Dashboard**: Track registrations, sales, and event analytics
- **User Dashboard**: View and manage personal bookings

### Reviews & Feedback
- **Rating System**: Rate events on a 5-star scale
- **Review Comments**: Share detailed feedback about events
- **Analytics**: Organizers can view and analyze feedback

## Technology Stack

### Backend
- **Spring Boot**: Core framework for the application
- **Spring MVC**: Web layer implementation
- **Spring Security**: Authentication and authorization
- **Spring Data JPA**: Database access and ORM
- **Hibernate**: Object-relational mapping

### Frontend
- **JSP**: Java Server Pages for view rendering
- **Bootstrap**: Responsive UI components
- **HTML/CSS/JavaScript**: Web fundamentals
- **jQuery**: DOM manipulation and AJAX

### Database
- **MySQL**: Relational database storage

### Additional Tools & Libraries
- **Google OAuth2.0 API**: For social login
- **JavaMailSender**: Email notifications
- **ZXing**: QR code generation
- **Thymeleaf**: Email templates
- **Razorpay API**: Payment processing
- **JWT**: JSON Web Tokens for authentication
- **Maven**: Dependency management

## Project Structure

```
eventms/
├── src/
│   ├── main/
│   │   ├── java/com/eventmanagement/eventms/
│   │   │   ├── controller/       # Request handlers
│   │   │   ├── dto/              # Data Transfer Objects
│   │   │   ├── exception/        # Custom exceptions
│   │   │   ├── model/            # Entity classes
│   │   │   ├── repository/       # Data access layer
│   │   │   ├── security/         # Auth & security config
│   │   │   ├── service/          # Business logic
│   │   │   └── EventmsApplication.java
│   │   ├── resources/
│   │   │   ├── templates/        # Email templates
│   │   │   ├── static/           # Static resources
│   │   │   └── application.properties
│   │   └── webapp/
│   │       └── WEB-INF/views/    # JSP views
│   └── test/                     # Unit tests
└── pom.xml                       # Maven configuration
```

## Getting Started

### Prerequisites
- JDK 17 or later
- Maven 3.6+
- MySQL 8.0+
- IntelliJ IDEA (recommended)

### Installation

1. **Clone the repository**:
   ```
   git clone https://github.com/yourusername/eventms.git
   cd eventms
   ```

2. **Configure the database**:
    - Create a MySQL database named `eventms`
    - Update `src/main/resources/application.properties` with your database credentials

3. **Configure OAuth2 (optional)**:
    - Create a project in the Google Developer Console
    - Get client ID and secret
    - Update OAuth2 properties in `application.properties`

4. **Configure email settings**:
    - Update email configuration in `application.properties`

5. **Configure payment gateway**:
    - Get Razorpay API keys
    - Update payment properties in `application.properties`

6. **Build and run the application**:
   ```
   mvn clean install
   mvn spring-boot:run
   ```

7. **Initialize roles and admin account**:
    - Access `/api/admin/system/initialize-roles` once to set up roles
    - Default admin credentials: admin@example.com / admin123

8. **Access the application**:
    - Open a browser and navigate to `http://localhost:8080/eventms`

## API Documentation

The application provides RESTful APIs for all core functionalities. Main API endpoints include:

- **Authentication**: `/api/auth/*`
- **Events**: `/api/events/*` and `/api/public/events/*`
- **Bookings**: `/api/bookings/*`
- **Users**: `/api/users/*`
- **Admin Operations**: `/api/admin/*`
- **Organizer Operations**: `/api/organizer/*`

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements

- Spring Framework team for the excellent documentation
- Bootstrap team for the responsive UI components
- All open-source libraries used in this project