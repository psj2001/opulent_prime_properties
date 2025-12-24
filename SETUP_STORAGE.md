# Firebase Storage Setup Instructions

## Step 1: Enable Firebase Storage

1. Go to: https://console.firebase.google.com/project/opulent-prime-app/storage
2. Click **"Get Started"**
3. Choose a **location** for your storage bucket (e.g., `us-central1`, `asia-south1`)
4. Choose **"Start in production mode"** (this will use your security rules)
5. Click **"Done"**

## Step 2: Deploy Storage Rules

After Storage is enabled, run this command in PowerShell:

```powershell
cd "C:\Users\prana\Downloads\U legendary\opulent_prime_properties"
firebase deploy --only storage
```

## Step 3: Verify Your User is Admin

Make sure your user document in Firestore has `isAdmin: true`:

1. Go to: https://console.firebase.google.com/project/opulent-prime-app/firestore
2. Navigate to the `users` collection
3. Find your user document (by your user ID: `2DTOVcFdVwObZwErbfeQsqzS3bf2`)
4. Check that `isAdmin` field is set to `true`
5. If not, edit the document and set `isAdmin: true`

## Step 4: Test Image Upload

After completing the above steps, try uploading an image again in your app.

