# Firebase Storage Setup - Billing Plan Upgrade

## Current Situation
Your Firebase project is on the **Spark (free) plan**, which does not include Firebase Storage.

## Solution: Upgrade to Blaze Plan

### Why Blaze Plan?
- **Pay-as-you-go** pricing
- **Generous free tier** that covers most development/testing needs
- **No charges** unless you exceed the free tier limits

### Free Tier Limits (Blaze Plan)
- **Storage**: 5 GB
- **Downloads**: 1 GB/day
- **Uploads**: 20,000/day
- **Downloads**: 50,000/day

### Steps to Upgrade

1. **Click "Upgrade project"** button in Firebase Console
2. **Select Blaze plan** (pay-as-you-go)
3. **Add payment method** (required, but won't be charged unless you exceed free tier)
4. **Complete upgrade**

### After Upgrading

1. **Enable Storage**:
   - Go to: https://console.firebase.google.com/project/opulent-prime-app/storage
   - Click "Get Started"
   - Choose location (e.g., `us-central1`)
   - Select "Start in production mode"
   - Click "Done"

2. **Deploy Storage Rules**:
   ```powershell
   firebase deploy --only storage
   ```

3. **Verify Admin Status**:
   - Ensure your user document in Firestore has `isAdmin: true`
   - Go to: https://console.firebase.google.com/project/opulent-prime-app/firestore
   - Navigate to `users` collection
   - Find your user document and set `isAdmin: true` if needed

4. **Test Image Upload**:
   - Try uploading an image in your app
   - It should work now!

## Alternative: Use Different Storage Service

If you prefer not to upgrade, we can integrate:
- **Cloudinary** (free tier available)
- **AWS S3** (pay-as-you-go)
- **ImgBB** (free API)
- **Other cloud storage services**

This would require code changes to the storage service.

