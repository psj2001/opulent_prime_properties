# Cloudinary Credentials Setup

## ✅ Upload Preset Configured
Your upload preset has been set: `iy6SLv-07gacxVoC7qTNbFnADxY`

## 📋 Still Need These Credentials

You need to add your **Cloud Name** and **API Key** to complete the setup.

### How to Get Your Credentials:

1. **Go to Cloudinary Dashboard**: https://console.cloudinary.com/settings/api-keys

2. **Find these values**:
   - **Cloud Name**: Usually shown at the top of the dashboard (e.g., `dxyz1234`)
   - **API Key**: A long number (e.g., `123456789012345`)
   - **API Secret**: Keep this private (only needed for signed uploads, not required for unsigned preset)

3. **Update `lib/core/constants/app_constants.dart`**:
   ```dart
   static const String cloudinaryCloudName = 'your_cloud_name_here';
   static const String cloudinaryApiKey = 'your_api_key_here';
   ```

## 🔍 Where to Find Cloud Name

The Cloud Name is usually visible:
- At the top of your Cloudinary dashboard
- In the URL: `https://console.cloudinary.com/console/c/[YOUR_CLOUD_NAME]/media_library`
- In your account settings

## ✅ Current Configuration

- ✅ Upload Preset: `iy6SLv-07gacxVoC7qTNbFnADxY` (configured)
- ⏳ Cloud Name: Need to add
- ⏳ API Key: Need to add

Once you add the Cloud Name and API Key, image uploads will work!

