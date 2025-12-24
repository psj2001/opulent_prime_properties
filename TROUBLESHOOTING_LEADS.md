# Troubleshooting: Leads Not Appearing in Admin

## Quick Checks

### 1. Verify Consultation Was Created
- Go to Firebase Console → Firestore → `consultations` collection
- Check if your consultation document exists
- Note the `userId` and `consultationId`

### 2. Verify Cloud Functions Are Deployed
- Go to Firebase Console → Functions
- Check if these functions are listed:
  - `onCreateConsultation` (trigger function)
  - `createLeadForConsultation` (callable function)

### 3. Check Function Logs
Run this command to see function logs:
```bash
firebase functions:log
```

Look for:
- "Lead created for consultation: [consultationId]"
- Any error messages

### 4. Check Firestore Rules
- Go to Firebase Console → Firestore → Rules
- Ensure leads collection allows Cloud Functions to create:
  ```
  match /leads/{leadId} {
    allow read: if isAdmin();
    allow create: if false; // Only Cloud Functions can create
    allow update: if isAdmin();
  }
  ```

### 5. Manual Check in Firestore
- Go to Firebase Console → Firestore → `leads` collection
- Check if any leads exist
- If leads exist but not showing in admin, check:
  - Lead has `userId` field
  - Lead has `source: "consultation"`
  - Lead has `status: "new"`

## Common Issues

### Issue 1: Cloud Functions Not Deployed
**Solution:** Deploy functions
```bash
cd functions
npm install
firebase deploy --only functions
```

### Issue 2: Function Permission Error
**Symptom:** Error in logs about permission denied
**Solution:** Check that the consultation's `userId` matches the authenticated user's `uid`

### Issue 3: Function Not Triggering
**Symptom:** No logs in Firebase Functions
**Solution:** 
- Verify the trigger function is deployed
- Check if consultation document was created successfully
- Wait a few seconds (triggers can take time)

### Issue 4: Callable Function Failing
**Symptom:** Error in app console about function not found
**Solution:**
- Deploy the `createLeadForConsultation` function
- Check Firebase Console → Functions to verify it's deployed

## Testing Steps

1. **Create a test consultation:**
   - Login to the app
   - Book a consultation
   - Note the consultation ID from Firestore

2. **Check if lead was created:**
   - Wait 10-30 seconds
   - Check Firestore → `leads` collection
   - Look for a lead with matching `userId`

3. **Check admin panel:**
   - Login as admin
   - Go to Leads page
   - Refresh the page
   - Check if lead appears

## Debug Mode

To see detailed logs in the app:
1. Run app in debug mode
2. Check console for:
   - "Lead created successfully via callable function"
   - "Warning: Could not create lead via callable function"
   - Any error messages

## Manual Lead Creation (Temporary Fix)

If functions aren't working, you can manually create a lead in Firestore:
1. Go to Firestore → `leads` collection
2. Click "Add document"
3. Add fields:
   - `userId`: (the user's ID from consultations)
   - `source`: "consultation"
   - `status`: "new"
   - `createdAt`: (current timestamp)
   - `updatedAt`: (current timestamp)

