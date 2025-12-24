# Fix: Upload Preset Not Found

## Problem
The upload preset `iy6SLv-07gacxVoC7qTNbFnADxY` doesn't exist in your Cloudinary account.

## Solution: Create a New Upload Preset

### Step 1: Go to Upload Settings
1. Go to: https://console.cloudinary.com/settings/upload
2. Scroll down to "Upload presets" section
3. Click **"+ Add upload preset"**

### Step 2: Configure the Preset
1. **Preset name**: Enter any name (e.g., `opportunity_images` or `opulent_uploads`)
2. **Signing mode**: Select **"Unsigned"** (important!)
3. **Folder**: `opportunities` (optional, for organization)
4. **Allowed formats**: `jpg, png, webp` (optional)
5. **Max file size**: Set a limit (e.g., 10MB)
6. Click **"Save"**

### Step 3: Copy the Preset Name
After saving, you'll see the preset in the list. Copy the **preset name** (not the ID).

### Step 4: Update Your Code
Update `lib/core/constants/app_constants.dart`:
```dart
static const String cloudinaryUploadPreset = 'your_new_preset_name_here';
```

## Alternative: Use Signed Uploads (Not Recommended)

If you can't create an unsigned preset, we can use signed uploads, but this requires exposing your API secret in the client code (not secure for production).

Let me know which approach you prefer!

