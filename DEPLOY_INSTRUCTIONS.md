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

---

## Deploy Admin Dashboard to Firebase Hosting

The admin dashboard can be hosted on Firebase Hosting to make it accessible via a public URL.

### Prerequisites

1. **Firebase CLI installed and logged in** (see steps above)
2. **Flutter SDK installed** and in your PATH
3. **Firebase project selected** (see step 4 above)

### Step 1: Build Flutter Web App

Build the Flutter web app for production:

```bash
flutter build web --release
```

This will create optimized web files in the `build/web/` directory.

**Note:** Make sure you have:
- All assets properly configured in `pubspec.yaml`
- Firebase configuration files set up correctly
- Web support enabled (already configured)

### Step 2: Initialize Firebase Hosting (First Time Only)

If you haven't initialized Firebase Hosting yet:

```bash
firebase init hosting
```

When prompted:
- **What do you want to use as your public directory?** → `build/web`
- **Configure as a single-page app (rewrite all urls to /index.html)?** → `Yes`
- **Set up automatic builds and deploys with GitHub?** → `No` (or `Yes` if you want CI/CD)

**Note:** The `firebase.json` file is already configured, so you can skip this step if the hosting section exists.

### Step 3: Deploy to Firebase Hosting

Deploy the built web app:

```bash
firebase deploy --only hosting
```

After deployment, you'll see output like:
```
✔  Deploy complete!

Project Console: https://console.firebase.google.com/project/opulent-prime-app/overview
Hosting URL: https://opulent-prime-app.web.app
```

### Step 4: Access Your Admin Dashboard

Your admin dashboard will be available at:
- **Primary URL:** `https://<your-project-id>.web.app`
- **Alternative URL:** `https://<your-project-id>.firebaseapp.com`

The app will automatically redirect web users to the admin login page.

### Step 5: Test the Deployment

1. Open the hosting URL in a browser
2. You should see the admin login page
3. Log in with admin credentials
4. Verify all admin dashboard features work correctly:
   - Dashboard overview
   - Categories management
   - Opportunities management
   - Leads management
   - Consultants management
   - Settings

### Updating the Deployment

To update the dashboard after making changes:

```bash
# 1. Build the web app again
flutter build web --release

# 2. Deploy to Firebase Hosting
firebase deploy --only hosting
```

### Deploy Everything at Once

To deploy Firestore rules, indexes, functions, and hosting together:

```bash
firebase deploy
```

Or deploy specific services:

```bash
# Deploy only hosting
firebase deploy --only hosting

# Deploy hosting and functions
firebase deploy --only hosting,functions

# Deploy everything
firebase deploy
```

### Troubleshooting

**Build errors:**
- Ensure Flutter web is enabled: `flutter config --enable-web`
- Check that all dependencies support web platform
- Verify assets are properly configured in `pubspec.yaml`

**Deployment errors:**
- Verify you're logged in: `firebase login`
- Check project selection: `firebase use`
- Ensure `build/web` directory exists after building

**Runtime errors:**
- Check browser console for errors
- Verify Firebase configuration is correct
- Ensure Firestore security rules allow admin access
- Check that admin users have `isAdmin: true` in Firestore

**Routing issues:**
- The `firebase.json` is configured to rewrite all routes to `index.html` for client-side routing
- If routes don't work, verify the rewrite rule is present

### Security Notes

- The admin dashboard uses Firebase Authentication for access control
- Only users with `isAdmin: true` in Firestore can access admin routes
- Ensure Firestore security rules properly restrict admin-only data
- Consider adding additional security measures if needed (IP whitelisting, etc.)

### Custom Domain (Optional)

To use a custom domain:

1. Go to [Firebase Console](https://console.firebase.google.com) → Your Project → Hosting
2. Click "Add custom domain"
3. Follow the instructions to verify domain ownership
4. Update DNS records as instructed
5. Wait for SSL certificate provisioning (automatic)

