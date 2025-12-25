# Opulent Prime Properties - Project Documentation

Welcome to the Opulent Prime Properties project documentation. This document provides an overview of the application for testing and evaluation purposes.

## Project Overview

Opulent Prime Properties is a premium real estate application designed for Dubai property investors. The application consists of two main components:

1. **Mobile Application** - Available for both Android and iOS platforms
2. **Web Admin Panel** - A comprehensive administrative interface for managing the platform

Both the mobile app and web admin panel are built using Flutter, allowing for a unified codebase across all platforms. This means the same project powers both mobile and web experiences.

## Technology Stack

### Frontend Technologies
- **Flutter** - Cross-platform framework (version 3.8.1 or higher)
- **Dart** - Programming language used with Flutter
- **Flutter Bloc** - State management solution for handling app data and UI state
- **go_router** - Navigation system for seamless screen transitions
- **Material Design** - Google's design system for consistent UI/UX

### Backend Services

**Firebase Services (Google Cloud Platform)**
- **Firebase Authentication** - Handles user authentication, login, and signup processes
- **Cloud Firestore** - NoSQL database storing all application data including properties, users, leads, and bookings
- **Firebase Cloud Functions** - Serverless backend functions written in Node.js 20 that handle business logic
- **Firebase Cloud Messaging (FCM)** - Push notification service for real-time user notifications
- **Firebase Storage** - Additional file storage solution
- **Firebase Hosting** - Web hosting service for the admin panel

**Cloudinary**
- Primary image storage and management service
- Handles property image uploads, optimization, and delivery
- Provides automatic image transformations and CDN (Content Delivery Network) for fast global delivery
- Images are automatically optimized and resized for better performance

**Node.js**
- Runtime environment for Firebase Cloud Functions
- Powers the backend logic and automated processes

## Application Architecture

The project follows Clean Architecture principles, which means the code is organized into clear layers:
- **Core Layer** - Shared utilities, services, and configurations used throughout the app
- **Feature Modules** - Individual features organized as separate modules
- **Shared Components** - Reusable models and widgets

The application uses:
- **BLoC Pattern** - For managing application state and business logic
- **Repository Pattern** - For data abstraction and management

## Supported Platforms

### Mobile Applications
- **Android** - Full support for Android phones and tablets
- **iOS** - Full support for iPhones and iPads

### Web Application
- **Flutter Web** - Admin panel accessible through web browsers

**Important Note**: The web version (admin panel) is designed for desktop and large screen devices. It is not optimized for mobile phone viewing. For the best testing experience, please access the admin panel on a desktop computer or large screen tablet.

## Backend Functionality

### Automated Lead Management
The backend automatically handles lead generation:
- When a user books a consultation, a lead is automatically created in the system
- When a user shares their shortlist, a lead is also generated
- Administrators receive automatic notifications when new leads are created

### Consultation Management
- Users receive confirmation notifications when their consultation is confirmed
- The system tracks consultation status and updates users accordingly

### Consultant Assignment
- Administrators can assign consultants to specific leads
- Users are notified when a consultant is assigned to their lead

### Notification System
- Push notifications are sent automatically for important events
- Administrators can send custom notifications to users
- All notifications are managed through Firebase Cloud Messaging

### Image Management
- Property images are uploaded to Cloudinary
- Images are automatically optimized and organized
- The system uses unsigned upload presets for direct client-side uploads

## Admin Panel Access

### Login Credentials
- **Email**: pranavputhoor91@gmail.com
- **Password**: 123456

### Admin Panel Features
Once logged in, administrators have access to:

- **Dashboard** - Overview of key performance indicators (KPIs) and recent leads
- **Opportunities Management** - Create, edit, and delete property listings
- **Categories & Areas Management** - Manage property categories and location areas
- **Leads & Bookings Management** - View and manage all leads and booking requests
- **Lead Details** - Detailed view of each lead with status update capabilities
- **Consultant Assignment** - Assign consultants to leads
- **Notification Management** - Send custom notifications to users
- **Settings** - Configure application settings

## Mobile Application Features

The mobile application includes the following features for end users:

1. **Splash Screen** - Initial app loading screen
2. **Onboarding** - Introduction screens for first-time users
3. **Home Dashboard** - Main navigation hub and entry point
4. **Opportunity Categories** - Browse properties by different categories
5. **Category Listings** - View all properties within a selected category
6. **Opportunity Details** - Comprehensive property information pages
7. **Shortlist** - Save favorite properties for later viewing
8. **Book Consultation** - Schedule consultations for properties
9. **Booking Confirmation** - Confirmation screen after booking
10. **Trust & Education Hub** - Educational content about real estate investing
11. **Education Articles** - Detailed educational articles and guides
12. **Services** - Information about company services
13. **Contact/WhatsApp** - Direct communication options
14. **Profile** - User account management
15. **Notifications** - Push notification center

## Data Structure

The application uses Firebase Firestore as its primary database. The main data collections include:

- **Users** - User accounts including both regular users and administrators
- **Opportunities** - Property listings with full details
- **Categories** - Property categories (e.g., Luxury, Investment, Residential)
- **Areas** - Location areas (e.g., Downtown Dubai, Palm Jumeirah)
- **Shortlists** - Properties saved by users
- **Consultations** - Booking requests and consultation records
- **Leads** - Automatically generated leads from consultations and shared shortlists
- **Consultants** - Consultant information and profiles
- **Notifications** - User notification records

### Lead Management Workflow
Leads progress through a status pipeline:
- **New** - Initial lead creation
- **Contacted** - Lead has been contacted
- **Qualified** - Lead has been qualified
- **Won/Lost** - Final outcome

## Security Features

The application implements several security measures:

- **Firestore Security Rules** - Control access to data based on user roles
- **Storage Security Rules** - Restrict file uploads and access
- **Firebase Authentication** - Secure user authentication and authorization
- **Role-Based Access Control** - Admin-only access to sensitive features
- **Secure Backend Functions** - All critical operations go through secure Cloud Functions

## Key Functionalities to Test

### Mobile App Testing
- User registration and login
- Browsing properties by category
- Viewing property details
- Creating and managing shortlists
- Booking consultations
- Receiving push notifications
- Profile management
- Educational content access

### Admin Panel Testing
- Admin login and authentication
- Dashboard metrics and data visualization
- Creating and editing property opportunities
- Managing categories and areas
- Viewing and updating lead statuses
- Assigning consultants to leads
- Sending notifications to users
- System settings configuration

### Backend Functionality Testing
- Automatic lead generation from consultations
- Automatic lead generation from shared shortlists
- Admin notifications for new leads
- User notifications for confirmed consultations
- Image upload and storage functionality
- Push notification delivery

## Important Notes for Testing

### Web Admin Panel
⚠️ **Critical**: The web version (admin panel) is not optimized for mobile phone viewing. Please test the admin panel on a desktop computer or large screen tablet for the best experience. Mobile phone browsers may display the interface incorrectly.

### Image Storage
- Primary image storage is handled by Cloudinary
- Firebase Storage is available as an additional storage option
- Images are automatically organized by property ID

### Lead Generation
Leads are automatically created when:
- A user books a consultation
- A user shares their shortlist

All lead creation is handled securely through Cloud Functions.

### Notifications
- Push notifications are delivered through Firebase Cloud Messaging
- Local notifications are used for in-app engagement
- Administrators receive automatic notifications for new leads

## Testing Recommendations

### Initial Setup
1. Ensure you have access to the admin panel credentials provided above
2. Test the admin panel on a desktop or large screen device
3. Install the mobile app on both Android and iOS devices if possible
4. Test the complete user journey from registration to booking

### Functional Testing
- Test all user flows in the mobile application
- Verify admin panel functionality and data management
- Test image uploads and property creation
- Verify lead generation and notification systems
- Test cross-platform compatibility

### User Experience Testing
- Evaluate the mobile app's user interface and navigation
- Test the admin panel's usability and efficiency
- Verify notification delivery and timing
- Test responsive design on different screen sizes (for mobile app)

## Version Information

- **Application Version**: 1.0.0+1
- **Flutter SDK**: 3.8.1 or higher
- **Node.js**: Version 20 (for Cloud Functions)
- **Firebase Services**: Latest stable versions

## Additional Resources

The project includes several documentation files that may be helpful:
- Setup guides for various services
- Troubleshooting documentation
- Deployment instructions
- Database schema documentation

## Support

For questions or issues during testing, please refer to the troubleshooting documentation included in the project files.

---

**Last Updated**: 2025  
**Project Type**: Company Testing Project  
**Maintained By**: Opulent Prime Properties Development Team

---

Thank you for testing the Opulent Prime Properties application. We appreciate your time and feedback!
