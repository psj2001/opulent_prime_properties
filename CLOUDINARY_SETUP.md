# Cloudinary Setup Guide

## Step 1: Create Cloudinary Account

1. Go to: https://cloudinary.com/users/register/free
2. Sign up for a free account
3. Verify your email

## Step 2: Get Your Credentials

1. After logging in, go to: https://console.cloudinary.com/settings/api-keys
2. You'll see:
   - **Cloud Name** (e.g., `dxyz1234`)
   - **API Key** (e.g., `123456789012345`)
   - **API Secret** (e.g., `abcdefghijklmnopqrstuvwxyz123456`)

## Step 3: Create Upload Preset (Recommended for Unsigned Uploads)

1. Go to: https://console.cloudinary.com/settings/upload
2. Scroll down to "Upload presets"
3. Click "Add upload preset"
4. Configure:
   - **Preset name**: `opportunity_images` (or any name you prefer)
   - **Signing mode**: Select "Unsigned" (for client-side uploads)
   - **Folder**: `opportunities` (optional, for organization)
   - **Allowed formats**: `jpg, png, webp` (optional)
   - **Max file size**: Set a limit (e.g., 10MB)
5. Click "Save"

## Step 4: Update App Constants

Open `lib/core/constants/app_constants.dart` and replace the placeholder values:

```dart
// Cloudinary Configuration
static const String cloudinaryCloudName = 'your_cloud_name_here';
static const String cloudinaryApiKey = 'your_api_key_here';
static const String cloudinaryApiSecret = 'your_api_secret_here'; // Only needed for signed uploads
static const String cloudinaryUploadPreset = 'opportunity_images'; // Your upload preset name
```

## Step 5: Install Dependencies

Run:
```bash
flutter pub get
```

## Step 6: Test Upload

Try uploading an image in your app. It should now work with Cloudinary!

## Security Notes

⚠️ **Important**: 
- For production apps, **never expose your API Secret** in client-side code
- Use **unsigned upload presets** for client-side uploads (recommended)
- For signed uploads, generate signatures on your backend server
- Consider using Cloudinary's server-side SDK for sensitive operations

## Free Tier Limits

Cloudinary's free tier includes:
- 25 GB storage
- 25 GB monthly bandwidth
- 25,000 monthly transformations
- Perfect for development and small projects!

## Troubleshooting

### Error: "Invalid API Key"
- Double-check your API Key in `app_constants.dart`
- Make sure there are no extra spaces

### Error: "Invalid upload preset"
- Verify the upload preset name matches exactly
- Make sure the preset is set to "Unsigned" mode

### Images not uploading
- Check your internet connection
- Verify Cloudinary credentials are correct
- Check browser console for detailed error messages

