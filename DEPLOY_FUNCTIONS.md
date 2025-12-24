# Deploy Cloud Functions

## Quick Deployment

To deploy Cloud Functions so that leads are automatically created when consultations are booked:

### Step 1: Install Dependencies
```bash
cd functions
npm install
```

### Step 2: Deploy Functions
```bash
firebase deploy --only functions
```

Or deploy specific functions:
```bash
firebase deploy --only functions:onCreateConsultation
firebase deploy --only functions:createLeadForConsultation
```

### Step 3: Verify Deployment
Check Firebase Console → Functions to see if functions are deployed.

## Troubleshooting

### If leads are not being created:

1. **Check if functions are deployed:**
   - Go to Firebase Console → Functions
   - Verify `onCreateConsultation` and `createLeadForConsultation` are listed

2. **Check function logs:**
   ```bash
   firebase functions:log
   ```

3. **Test the callable function:**
   - The app now calls `createLeadForConsultation` as a backup
   - This should work even if the trigger function isn't deployed

4. **Check Firestore rules:**
   - Ensure leads collection allows Cloud Functions to create documents
   - Current rule: `allow create: if false;` (only Cloud Functions can create)

## How It Works Now

1. **Primary Method (Trigger):**
   - When a consultation is created, `onCreateConsultation` trigger automatically creates a lead
   - This is the preferred method

2. **Backup Method (Callable):**
   - After creating a consultation, the app calls `createLeadForConsultation`
   - This ensures leads are created even if the trigger function isn't deployed
   - Prevents duplicate leads by checking for recent leads

## Testing

After deployment, test by:
1. Creating a consultation in the app
2. Checking Firebase Console → Firestore → `leads` collection
3. Checking Admin Panel → Leads page

