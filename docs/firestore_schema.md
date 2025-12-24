# Firestore Schema Documentation

## Collections Overview

### users
Stores user account information.

**Fields:**
- `email` (string, required): User's email address
- `name` (string, required): User's full name
- `phone` (string, optional): User's phone number
- `createdAt` (timestamp, required): Account creation timestamp
- `updatedAt` (timestamp, required): Last update timestamp
- `fcmToken` (string, optional): Firebase Cloud Messaging token for push notifications
- `isAdmin` (boolean, default: false): Whether user has admin privileges

**Example:**
```json
{
  "email": "user@example.com",
  "name": "John Doe",
  "phone": "+971501234567",
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z",
  "fcmToken": "abc123...",
  "isAdmin": false
}
```

---

### opportunities
Stores real estate investment opportunities.

**Fields:**
- `title` (string, required): Property title
- `description` (string, required): Detailed description
- `categoryId` (string, required): Reference to categories collection
- `areaId` (string, required): Reference to areas collection
- `price` (number, required): Property price in AED
- `images` (array of strings, required): Array of image URLs
- `features` (array of strings, required): Array of property features
- `status` (string, required): "active" or "inactive"
- `createdAt` (timestamp, required): Creation timestamp
- `updatedAt` (timestamp, required): Last update timestamp

**Example:**
```json
{
  "title": "Premium Marina Apartment",
  "description": "Luxury 3-bedroom apartment with sea view",
  "categoryId": "cat_apartments",
  "areaId": "area_dubai_marina",
  "price": 2500000,
  "images": ["https://...", "https://..."],
  "features": ["3 Bedrooms", "2 Bathrooms", "Parking", "Balcony"],
  "status": "active",
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z"
}
```

---

### categories
Stores property categories.

**Fields:**
- `name` (string, required): Category name
- `icon` (string, required): Icon identifier or emoji
- `order` (number, required): Display order
- `isActive` (boolean, required): Whether category is active

**Example:**
```json
{
  "name": "Apartments",
  "icon": "apartment",
  "order": 1,
  "isActive": true
}
```

---

### areas
Stores geographical areas.

**Fields:**
- `name` (string, required): Area name
- `isActive` (boolean, required): Whether area is active

**Example:**
```json
{
  "name": "Dubai Marina",
  "isActive": true
}
```

---

### shortlists
Stores user's shortlisted opportunities.

**Fields:**
- `userId` (string, required): Reference to users collection
- `opportunityIds` (array of strings, required): Array of opportunity IDs
- `createdAt` (timestamp, required): Creation timestamp
- `updatedAt` (timestamp, required): Last update timestamp

**Example:**
```json
{
  "userId": "user_123",
  "opportunityIds": ["opp_1", "opp_2", "opp_3"],
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z"
}
```

---

### consultations
Stores consultation bookings.

**Fields:**
- `userId` (string, required): Reference to users collection
- `opportunityId` (string, optional): Reference to opportunities collection (if booking for specific property)
- `preferredDate` (timestamp, required): Preferred consultation date
- `preferredTime` (string, required): Preferred time slot (e.g., "10:00 AM")
- `status` (string, required): "pending", "confirmed", or "cancelled"
- `consultantId` (string, optional): Reference to consultants collection
- `notes` (string, optional): Additional notes
- `createdAt` (timestamp, required): Creation timestamp

**Example:**
```json
{
  "userId": "user_123",
  "opportunityId": "opp_1",
  "preferredDate": "2024-01-15T00:00:00Z",
  "preferredTime": "10:00 AM",
  "status": "pending",
  "consultantId": null,
  "notes": "Interested in financing options",
  "createdAt": "2024-01-01T00:00:00Z"
}
```

---

### leads
Stores qualified leads. **IMPORTANT: Can only be created through Cloud Functions.**

**Fields:**
- `userId` (string, required): Reference to users collection
- `source` (string, required): Lead source - "consultation", "shortlist", or "share"
- `status` (string, required): "new", "contacted", "qualified", "won", or "lost"
- `consultantId` (string, optional): Assigned consultant
- `notes` (string, optional): Admin notes
- `createdAt` (timestamp, required): Creation timestamp
- `updatedAt` (timestamp, required): Last update timestamp

**Example:**
```json
{
  "userId": "user_123",
  "source": "consultation",
  "status": "new",
  "consultantId": null,
  "notes": null,
  "createdAt": "2024-01-01T00:00:00Z",
  "updatedAt": "2024-01-01T00:00:00Z"
}
```

---

### consultants
Stores consultant information.

**Fields:**
- `name` (string, required): Consultant's name
- `email` (string, required): Consultant's email
- `phone` (string, required): Consultant's phone number
- `isActive` (boolean, required): Whether consultant is active

**Example:**
```json
{
  "name": "Ahmed Al Maktoum",
  "email": "ahmed@opulentprimeproperties.com",
  "phone": "+971501234567",
  "isActive": true
}
```

---

### notifications
Stores user notifications.

**Fields:**
- `userId` (string, required): Reference to users collection
- `title` (string, required): Notification title
- `body` (string, required): Notification body
- `type` (string, required): Notification type (e.g., "consultation_confirmed", "consultant_assigned")
- `isRead` (boolean, required): Whether notification has been read
- `createdAt` (timestamp, required): Creation timestamp

**Example:**
```json
{
  "userId": "user_123",
  "title": "Consultation Confirmed",
  "body": "Your consultation has been confirmed.",
  "type": "consultation_confirmed",
  "isRead": false,
  "createdAt": "2024-01-01T00:00:00Z"
}
```

---

## Indexes Required

Create the following composite indexes in Firestore:

1. **opportunities**: `categoryId` + `status` + `createdAt` (descending)
2. **opportunities**: `areaId` + `status` + `createdAt` (descending)
3. **shortlists**: `userId` + `updatedAt` (descending)
4. **consultations**: `userId` + `createdAt` (descending)
5. **consultations**: `status` + `preferredDate` (ascending)
6. **leads**: `status` + `createdAt` (descending)
7. **leads**: `consultantId` + `status` + `createdAt` (descending)
8. **notifications**: `userId` + `isRead` + `createdAt` (descending)

## Relationships

- `opportunities.categoryId` → `categories.categoryId`
- `opportunities.areaId` → `areas.areaId`
- `shortlists.userId` → `users.userId`
- `shortlists.opportunityIds[]` → `opportunities.opportunityId`
- `consultations.userId` → `users.userId`
- `consultations.opportunityId` → `opportunities.opportunityId` (optional)
- `consultations.consultantId` → `consultants.consultantId` (optional)
- `leads.userId` → `users.userId`
- `leads.consultantId` → `consultants.consultantId` (optional)
- `notifications.userId` → `users.userId`

