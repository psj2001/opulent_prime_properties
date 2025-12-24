# Firebase Deployment Instructions

## Deploy Firestore Rules

The app is getting `PERMISSION_DENIED` errors because Firestore rules haven't been deployed yet.

### Option 1: Using Firebase CLI (Recommended)

1. **Install Firebase CLI** (if not already installed):
   ```bash
   npm install -g firebase-tools
   ```

2. **Login to Firebase**:
   ```bash
   firebase login
   ```
   This will open a browser for authentication.

3. **List your Firebase projects**:
   ```bash
   firebase projects:list
   ```

4. **Select your project**:
   ```bash
   firebase use <your-project-id>
   ```
   Or to add a new project:
   ```bash
   firebase use --add
   ```

5. **Deploy Firestore Rules**:
   ```bash
   firebase deploy --only firestore:rules
   ```

6. **Deploy Firestore Indexes** (required for the queries):
   ```bash
   firebase deploy --only firestore:indexes
   ```

### Option 2: Using Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project
3. Navigate to **Firestore Database** → **Rules** tab
4. Copy the contents of `firestore.rules` file
5. Paste into the console editor
6. Click **Publish**

7. For indexes, go to **Firestore Database** → **Indexes** tab
8. The indexes should be automatically created when you run queries, or you can add them manually based on `firestore.indexes.json`

## Verify Deployment

After deploying, restart your Flutter app. The `PERMISSION_DENIED` errors should be resolved.

## Troubleshooting

- If you still get permission errors, verify:
  - The rules file is correctly formatted
  - The project ID matches your Firebase project
  - You're logged in with the correct Firebase account
  - The rules have been published (check the timestamp in Firebase Console)

