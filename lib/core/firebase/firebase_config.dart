import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:opulent_prime_properties/core/firebase/firebase_options.dart';

class FirebaseConfig {
  static FirebaseAuth? _auth;
  static FirebaseFirestore? _firestore;
  static FirebaseStorage? _storage;
  static FirebaseMessaging? _messaging;
  static FirebaseFunctions? _functions;

  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;

    // Note: On web, Firestore persistence is handled automatically
    // Settings should be set before any Firestore operations, but
    // persistenceEnabled might not work the same way on web
    if (kIsWeb) {
      try {
        _firestore!.settings = const Settings(
          persistenceEnabled: true,
          sslEnabled: true,
        );
      } catch (e) {
        print('Firestore settings error (may be normal on web): $e');
        // Continue - web persistence works differently
      }
    }

    _storage = FirebaseStorage.instance;
    _messaging = FirebaseMessaging.instance;
    _functions = FirebaseFunctions.instance;

    // Enable network for Firestore on web
    if (kIsWeb) {
      try {
        // Enable network and wait for it to be ready
        await _firestore!.enableNetwork();
        print('Firestore network enabled successfully');
        // Give it a moment to establish connection
        await Future.delayed(const Duration(milliseconds: 500));
      } catch (e) {
        print('Firestore enableNetwork error: $e');
        // Continue anyway - will retry on first use
      }
    }

    // Request notification permissions (skip on web)
    try {
      await _messaging!.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
    } catch (e) {
      // Ignore errors on web platform where notifications may not be supported
    }
  }

  static FirebaseAuth get auth => _auth ?? FirebaseAuth.instance;
  static FirebaseFirestore get firestore =>
      _firestore ?? FirebaseFirestore.instance;
  static FirebaseStorage get storage => _storage ?? FirebaseStorage.instance;
  static FirebaseMessaging get messaging =>
      _messaging ?? FirebaseMessaging.instance;
  static FirebaseFunctions get functions =>
      _functions ?? FirebaseFunctions.instance;
}
