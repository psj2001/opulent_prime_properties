// File generated using flutterfire_cli or manually configured
// 
// IMPORTANT: To fix the Firebase web configuration error, you need to:
// 
// Option 1 (Recommended): Use FlutterFire CLI to auto-generate this file:
//   1. Install: dart pub global activate flutterfire_cli
//   2. Run: flutterfire configure
//   3. Select your platforms (web, android, ios, etc.)
//
// Option 2 (Manual): Get web config from Firebase Console:
//   1. Go to https://console.firebase.google.com/
//   2. Select project: opulent-prime-app
//   3. Click the gear icon > Project Settings
//   4. Scroll to "Your apps" section
//   5. If no web app exists, click "Add app" > Web icon
//   6. Copy the apiKey and appId from the config object
//   7. Replace YOUR_WEB_API_KEY and YOUR_WEB_APP_ID below

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAAHC7I76L4y8g4H7LODYmDd0SI2SqILTw',
    appId: '1:408149573750:web:34d8681be80f9e96131f57',
    messagingSenderId: '408149573750',
    projectId: 'opulent-prime-app',
    authDomain: 'opulent-prime-app.firebaseapp.com',
    storageBucket: 'opulent-prime-app.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCg0Pc2XSq9ieJlJMOSfW61REusCc3QMjM',
    appId: '1:408149573750:android:4bdbc8aec0ce9f48131f57',
    messagingSenderId: '408149573750',
    projectId: 'opulent-prime-app',
    storageBucket: 'opulent-prime-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'YOUR_IOS_API_KEY',
    appId: 'YOUR_IOS_APP_ID',
    messagingSenderId: '408149573750',
    projectId: 'opulent-prime-app',
    storageBucket: 'opulent-prime-app.firebasestorage.app',
    iosBundleId: 'com.opulentprimeproperties.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR_MACOS_API_KEY',
    appId: 'YOUR_MACOS_APP_ID',
    messagingSenderId: '408149573750',
    projectId: 'opulent-prime-app',
    storageBucket: 'opulent-prime-app.firebasestorage.app',
    iosBundleId: 'com.opulentprimeproperties.app',
  );
}

