# Firestore Security Rules

## Overview
These security rules ensure that:
- Users can only access their own data
- Leads can only be created through Cloud Functions
- Admin operations require admin role
- Public read access for opportunities and categories

## Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Helper function to check if user is authenticated
    function isAuthenticated() {
      return request.auth != null;
    }
    
    // Helper function to check if user is admin
    function isAdmin() {
      return isAuthenticated() && 
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.isAdmin == true;
    }
    
    // Helper function to check if user owns the resource
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }
    
    // Users collection
    match /users/{userId} {
      allow read: if isOwner(userId) || isAdmin();
      allow create: if isAuthenticated() && request.auth.uid == userId;
      allow update: if isOwner(userId) || isAdmin();
      allow delete: if isAdmin();
    }
    
    // Opportunities collection - public read, admin write
    match /opportunities/{opportunityId} {
      allow read: if true; // Public read access
      allow create, update, delete: if isAdmin();
    }
    
    // Categories collection - public read, admin write
    match /categories/{categoryId} {
      allow read: if true; // Public read access
      allow create, update, delete: if isAdmin();
    }
    
    // Areas collection - public read, admin write
    match /areas/{areaId} {
      allow read: if true; // Public read access
      allow create, update, delete: if isAdmin();
    }
    
    // Shortlists collection - users can manage their own
    match /shortlists/{shortlistId} {
      allow read: if isOwner(resource.data.userId) || isAdmin();
      allow create: if isAuthenticated() && request.resource.data.userId == request.auth.uid;
      allow update, delete: if isOwner(resource.data.userId) || isAdmin();
    }
    
    // Consultations collection - users can create their own, read their own
    match /consultations/{consultationId} {
      allow read: if isOwner(resource.data.userId) || isAdmin();
      allow create: if isAuthenticated() && request.resource.data.userId == request.auth.uid;
      allow update: if isAdmin(); // Only admin can update (confirm, cancel, assign consultant)
      allow delete: if isAdmin();
    }
    
    // Leads collection - NO direct client writes, only Cloud Functions
    match /leads/{leadId} {
      allow read: if isAdmin(); // Only admins can read leads
      allow create: if false; // No direct client writes - must go through Cloud Functions
      allow update: if isAdmin(); // Only admins can update lead status
      allow delete: if isAdmin();
    }
    
    // Consultants collection - admin only
    match /consultants/{consultantId} {
      allow read: if isAdmin();
      allow create, update, delete: if isAdmin();
    }
    
    // Notifications collection - users can read their own
    match /notifications/{notificationId} {
      allow read: if isOwner(resource.data.userId) || isAdmin();
      allow create: if false; // Only Cloud Functions can create notifications
      allow update: if isOwner(resource.data.userId); // Users can mark as read
      allow delete: if isAdmin();
    }
  }
}
```

## Important Notes

1. **Lead Creation**: Leads can ONLY be created through Cloud Functions. Direct client writes are blocked.

2. **Admin Access**: Admin status is stored in the user document's `isAdmin` field. Make sure to set this when creating admin users.

3. **User Data**: Users can only read/update their own user document, except admins who have full access.

4. **Public Data**: Opportunities, categories, and areas are publicly readable but only admins can modify them.

5. **Notifications**: Notifications can only be created by Cloud Functions, but users can mark their own notifications as read.

## Testing Rules

Use the Firebase Console Rules Playground to test these rules before deploying to production.

