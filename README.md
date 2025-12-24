# Opulent Prime Properties – Investor Mobile App (MVP)

A premium, investor-focused mobile app (Android & iOS) with a Flutter Web admin panel.

## Tech Stack

- **Flutter** (latest stable) for mobile
- **Flutter Web** for admin panel
- **Firebase**:
  - Authentication
  - Cloud Firestore
  - Cloud Functions (Node.js LTS)
  - Firebase Cloud Messaging
  - Firebase Storage

## Architecture

- **Clean Architecture** (Presentation → Domain → Data)
- **Bloc** for state management
- **go_router** for navigation
- No business logic in UI
- No direct Firestore calls from UI
- All writes that create leads must go through Cloud Functions

## Project Structure

```
lib/
├── core/                    # Shared utilities, constants, errors
├── features/                # Feature modules (Clean Architecture)
├── shared/                  # Shared widgets, models
└── main.dart
```

## Getting Started

1. Install Flutter dependencies:
```bash
flutter pub get
```

2. Set up Firebase:
   - Add `google-services.json` (Android) to `android/app/`
   - Add `GoogleService-Info.plist` (iOS) to `ios/Runner/`
   - Configure Firebase in `lib/core/firebase/firebase_config.dart`

3. Run the app:
```bash
flutter run
```

4. For web admin panel:
```bash
flutter run -d chrome --web-port=8080
```

## Cloud Functions

See `functions/` directory for Cloud Functions setup.

To deploy Cloud Functions:
```bash
cd functions
npm install
firebase deploy --only functions
```

## Firestore Schema

See `docs/firestore_schema.md` for collection structures.

## Security Rules

See `docs/firestore_rules.md` for Firestore security rules.

## Mobile App Screens

1. Splash
2. Onboarding
3. Home Dashboard
4. Opportunity Categories
5. Category Listing
6. Opportunity Detail
7. Shortlist
8. Book Consultation
9. Booking Confirmation
10. Trust & Education Hub
11. Education Detail
12. Services
13. Contact / WhatsApp
14. Profile (basic)

## Admin Panel Screens

1. Admin Login
2. Dashboard (KPIs + recent leads)
3. Opportunities List
4. Add/Edit Opportunity
5. Categories & Areas Management
6. Leads & Bookings List
7. Lead Detail + Status Update
8. Consultant Assignment
9. Settings

## Core User Flows

- Investor → Book Consultation in under 30 seconds
- Investor → Shortlist → Share → Lead created
- Investor → Trust Hub → Book Consultation

## Backend Rules

- Firestore collections:
  users, opportunities, categories, areas, shortlists,
  consultations, leads, consultants, notifications
- Lead status pipeline:
  New → Contacted → Qualified → Won / Lost
- Notifications:
  - Booking confirmation
  - Consultant assigned
  - Appointment reminders
