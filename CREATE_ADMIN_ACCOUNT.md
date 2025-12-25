# How to Create an Admin Account

## ⚠️ IMPORTANT: If you get "User data not found" error

This means the Firebase Authentication UID doesn't match the Firestore document ID. Follow these steps:

### Quick Fix:
1. **Go to Firebase Console > Authentication > Users**
2. **Check if the user exists** with email `pranavputhoor91@gmail.com`
3. **If the user doesn't exist**, create it:
   - Click "Add user"
   - Email: `pranavputhoor91@gmail.com`
   - Password: `123456`
   - Copy the UID shown
4. **Go to Firestore > users collection**
5. **Check the document ID** - it should match the UID from step 3
6. **If it doesn't match**:
   - Either update the document ID to match the Auth UID, OR
   - Delete the old document and create a new one with the correct UID

---

# How to Create an Admin Account

## Option 1: Manual Creation (Fastest - Recommended)

### Step 1: Create User in Firebase Authentication
1. Go to [Firebase Console](https://console.firebase.google.com/project/opulent-prime-app/authentication/users)
2. Click **"Add user"**
3. Enter:
   - Email: `pranavputhoor91@gmail.com`
   - Password: `123456`
4. Click **"Add user"**

### Step 2: Create User Document in Firestore
1. Go to [Firestore Database](https://console.firebase.google.com/project/opulent-prime-app/firestore)
2. Navigate to the `users` collection
3. Click **"Add document"**
4. Set the Document ID to the **UID** from Step 1 (you can find it in Authentication > Users)
5. Add the following fields:
   - `email` (string): `pranavputhoor91@gmail.com`
   - `name` (string): `Pranav Puthoor` (or your preferred name)
   - `userId` (string): Same as the Document ID (UID)
   - `isAdmin` (boolean): `true`
   - `createdAt` (timestamp): Current timestamp
   - `updatedAt` (timestamp): Current timestamp
6. Click **"Save"**

### Step 3: Verify
Try logging in with:
- Email: `pranavputhoor91@gmail.com`
- Password: `123456`

---

## Option 2: Using Cloud Function (After Deployment)

### Step 1: Deploy the Cloud Function
```bash
cd functions
firebase deploy --only functions:createAdminAccount
```

### Step 2: Call the Function
You can call this function from your Flutter app or using a tool like Postman:

```javascript
// Example using Firebase Functions SDK
const functions = getFunctions();
const createAdmin = httpsCallable(functions, 'createAdminAccount');

const result = await createAdmin({
  email: 'pranavputhoor91@gmail.com',
  password: '123456',
  name: 'Pranav Puthoor'
});

console.log(result.data);
```

**Note:** For security, you may want to remove or protect this function after creating your admin account.

---

## Option 3: Using the Script (Requires Service Account)

If you have a Firebase service account key:

1. Download service account key from [Firebase Console](https://console.firebase.google.com/project/opulent-prime-app/settings/serviceaccounts/adminsdk)
2. Save it as `serviceAccountKey.json` in the `functions` directory
3. Update `create_admin.js` to use the service account:

```javascript
const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: 'opulent-prime-app',
});
```

4. Run:
```bash
cd functions
node create_admin.js pranavputhoor91@gmail.com 123456 "Pranav Puthoor"
```

---

## Quick Manual Steps Summary

1. **Firebase Console > Authentication > Add user**
   - Email: `pranavputhoor91@gmail.com`
   - Password: `123456`

2. **Copy the UID** from the created user

3. **Firebase Console > Firestore > users collection > Add document**
   - Document ID: (paste the UID)
   - Fields:
     - `email`: `pranavputhoor91@gmail.com`
     - `name`: `Pranav Puthoor`
     - `userId`: (same as Document ID)
     - `isAdmin`: `true`
     - `createdAt`: (current timestamp)
     - `updatedAt`: (current timestamp)

4. **Done!** You can now log in with the admin credentials.

