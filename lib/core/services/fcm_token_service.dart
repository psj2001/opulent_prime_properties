import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:opulent_prime_properties/core/constants/app_constants.dart';
import 'package:opulent_prime_properties/core/firebase/firebase_config.dart';

class FCMTokenService {
  static final FirebaseFirestore _firestore = FirebaseConfig.firestore;
  static final FirebaseMessaging _messaging = FirebaseConfig.messaging;

  /// Save FCM token for the current user
  /// This should be called after user logs in or signs up
  static Future<void> saveFCMToken(String userId) async {
    try {
      print('Attempting to get FCM token for user: $userId');
      final token = await _messaging.getToken();
      print('FCM token received: ${token != null ? "YES" : "NO"}');
      
      if (token != null && token.isNotEmpty) {
        print('Saving FCM token to Firestore: ${token.substring(0, 20)}...');
        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(userId)
            .update({
          'fcmToken': token,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        print('✅ FCM token saved successfully for user: $userId');
        
        // Verify the token was saved
        final userDoc = await _firestore
            .collection(AppConstants.usersCollection)
            .doc(userId)
            .get();
        final savedToken = userDoc.data()?['fcmToken'];
        if (savedToken == token) {
          print('✅ FCM token verified in Firestore');
        } else {
          print('⚠️ FCM token save verification failed');
        }
      } else {
        print('⚠️ FCM token is null or empty');
      }
    } catch (e, stackTrace) {
      print('❌ Error saving FCM token: $e');
      print('Stack trace: $stackTrace');
      // Don't throw - FCM token saving shouldn't block user operations
    }
  }

  /// Listen for FCM token refresh and update in Firestore
  static void listenForTokenRefresh(String userId) {
    _messaging.onTokenRefresh.listen((newToken) async {
      try {
        print('🔄 FCM token refreshed for user: $userId');
        print('New token: ${newToken.substring(0, 20)}...');
        await _firestore
            .collection(AppConstants.usersCollection)
            .doc(userId)
            .update({
          'fcmToken': newToken,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        print('✅ FCM token refresh saved successfully');
      } catch (e, stackTrace) {
        print('❌ Error refreshing FCM token: $e');
        print('Stack trace: $stackTrace');
      }
    });
  }
}

