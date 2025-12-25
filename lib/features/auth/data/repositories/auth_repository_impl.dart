import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:opulent_prime_properties/core/constants/app_constants.dart';
import 'package:opulent_prime_properties/core/errors/exceptions.dart';
import 'package:opulent_prime_properties/core/firebase/firebase_config.dart';
import 'package:opulent_prime_properties/core/services/fcm_token_service.dart';
import 'package:opulent_prime_properties/features/auth/domain/entities/user_entity.dart';
import 'package:opulent_prime_properties/features/auth/domain/repositories/auth_repository.dart';
import 'package:opulent_prime_properties/shared/models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final firebase_auth.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl({
    firebase_auth.FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  }) : _auth = auth ?? FirebaseConfig.auth,
       _firestore = firestore ?? FirebaseConfig.firestore;

  @override
  Future<UserEntity> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    String? userId;
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw AuthException('Sign in failed');
      }

      userId = credential.user!.uid;

      // Use default behavior - tries server first, falls back to cache automatically
      final userDoc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        throw AuthException('User data not found');
      }

      final userModel = UserModel.fromFirestore(userDoc);
      
      // Save FCM token asynchronously (don't block login)
      FCMTokenService.saveFCMToken(userId);
      FCMTokenService.listenForTokenRefresh(userId);
      
      return UserEntity(
        userId: userModel.userId,
        email: userModel.email,
        name: userModel.name,
        phone: userModel.phone,
        isAdmin: userModel.isAdmin,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      print('AuthRepository - SignIn FirebaseAuthException:');
      print('  Code: ${e.code}');
      print('  Message: ${e.message}');
      print('  StackTrace: ${e.stackTrace}');
      throw AuthException(_getFirebaseErrorMessage(e));
    } on FirebaseException catch (e) {
      // Handle Firestore offline errors
      print('AuthRepository - SignIn FirebaseException:');
      print('  Code: ${e.code}');
      print('  Message: ${e.message}');
      if (e.code == 'unavailable' && userId != null) {
        print(
          'AuthRepository - Firestore unavailable, attempting to enable network and retry...',
        );
        try {
          // Enable network and wait for it
          await _firestore.enableNetwork();
          print('AuthRepository - Network enabled, waiting for connection...');
          
          // Wait for connection to be established with exponential backoff
          for (int attempt = 0; attempt < 3; attempt++) {
            await Future.delayed(Duration(milliseconds: 500 * (attempt + 1)));
            try {
              // Use default behavior - no source specified, will try server then cache
              final userDoc = await _firestore
                  .collection(AppConstants.usersCollection)
                  .doc(userId)
                  .get();
              if (!userDoc.exists) {
                throw AuthException('User data not found');
              }
              print('AuthRepository - Successfully retrieved user data on attempt ${attempt + 1}');
              final userModel = UserModel.fromFirestore(userDoc);
              return UserEntity(
                userId: userModel.userId,
                email: userModel.email,
                name: userModel.name,
                phone: userModel.phone,
                isAdmin: userModel.isAdmin,
              );
            } catch (retryError) {
              if (attempt == 2) {
                // Last attempt failed
                print('AuthRepository - All retry attempts failed: $retryError');
                rethrow;
              }
              print('AuthRepository - Retry attempt ${attempt + 1} failed, retrying...');
            }
          }
        } catch (retryError) {
          print('AuthRepository - Retry failed: $retryError');
          throw AuthException(
            'Network error. Please check your internet connection and try again.',
          );
        }
      }
      throw AuthException('Sign in failed: ${e.message ?? e.toString()}');
    } catch (e) {
      print('AuthRepository - SignIn Error: $e');
      print('AuthRepository - Error Type: ${e.runtimeType}');
      if (e is AuthException) rethrow;
      throw AuthException('Sign in failed: ${e.toString()}');
    }
  }

  @override
  Future<UserEntity> signUpWithEmailAndPassword(
    String email,
    String password,
    String name, {
    bool isAdmin = false,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw AuthException('Sign up failed');
      }

      final now = DateTime.now();
      final userModel = UserModel(
        userId: credential.user!.uid,
        email: email,
        name: name,
        createdAt: now,
        updatedAt: now,
        isAdmin: isAdmin,
      );

      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(credential.user!.uid)
          .set(userModel.toFirestore());

      // Save FCM token asynchronously (don't block signup)
      FCMTokenService.saveFCMToken(credential.user!.uid);
      FCMTokenService.listenForTokenRefresh(credential.user!.uid);

      return UserEntity(
        userId: userModel.userId,
        email: userModel.email,
        name: userModel.name,
        phone: userModel.phone,
        isAdmin: userModel.isAdmin,
      );
    } on firebase_auth.FirebaseAuthException catch (e) {
      print('AuthRepository - SignUp FirebaseAuthException:');
      print('  Code: ${e.code}');
      print('  Message: ${e.message}');
      print('  StackTrace: ${e.stackTrace}');
      throw AuthException(_getFirebaseErrorMessage(e));
    } on FirebaseException catch (e) {
      // Handle Firestore offline errors
      print('AuthRepository - SignUp FirebaseException:');
      print('  Code: ${e.code}');
      print('  Message: ${e.message}');
      if (e.code == 'unavailable') {
        print('AuthRepository - Firestore unavailable, retrying...');
        try {
          // Enable network and wait for it
          await _firestore.enableNetwork();
          print('AuthRepository - Network enabled for sign up, waiting...');
          
          // Wait a bit for connection to be established
          await Future.delayed(const Duration(seconds: 2));

          // Retry creating user document
          final currentUser = await _auth.currentUser;
          if (currentUser == null) {
            throw AuthException('User not found after sign up');
          }
          final now = DateTime.now();
          final userModel = UserModel(
            userId: currentUser.uid,
            email: email,
            name: name,
            createdAt: now,
            updatedAt: now,
            isAdmin: isAdmin,
          );
          await _firestore
              .collection(AppConstants.usersCollection)
              .doc(userModel.userId)
              .set(userModel.toFirestore());
          
          // Save FCM token asynchronously (don't block signup)
          FCMTokenService.saveFCMToken(userModel.userId);
          FCMTokenService.listenForTokenRefresh(userModel.userId);
          
          return UserEntity(
            userId: userModel.userId,
            email: userModel.email,
            name: userModel.name,
            phone: userModel.phone,
            isAdmin: userModel.isAdmin,
          );
        } catch (retryError) {
          print('AuthRepository - Retry failed: $retryError');
          throw AuthException(
            'Network error. Please check your internet connection and try again.',
          );
        }
      }
      throw AuthException('Sign up failed: ${e.message ?? e.toString()}');
    } catch (e) {
      print('AuthRepository - SignUp Error: $e');
      print('AuthRepository - Error Type: ${e.runtimeType}');
      if (e is AuthException) rethrow;
      throw AuthException('Sign up failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('AuthRepository - SignOut Error: $e');
      print('AuthRepository - Error Type: ${e.runtimeType}');
      throw AuthException('Sign out failed: ${e.toString()}');
    }
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      Future<UserEntity?> getUserData() async {
        // Use default behavior - tries server first, falls back to cache
        final userDoc = await _firestore
            .collection(AppConstants.usersCollection)
            .doc(user.uid)
            .get();

        if (!userDoc.exists) return null;

        final userModel = UserModel.fromFirestore(userDoc);
        return UserEntity(
          userId: userModel.userId,
          email: userModel.email,
          name: userModel.name,
          phone: userModel.phone,
          isAdmin: userModel.isAdmin,
        );
      }

      try {
        return await getUserData();
      } on FirebaseException catch (e) {
        if (e.code == 'unavailable') {
          print(
            'AuthRepository - Firestore unavailable in getCurrentUser, retrying...',
          );
          try {
            await _firestore.enableNetwork();
            // Retry with exponential backoff
            for (int attempt = 0; attempt < 3; attempt++) {
              await Future.delayed(Duration(milliseconds: 500 * (attempt + 1)));
              try {
                return await getUserData();
              } catch (retryError) {
                if (attempt == 2) {
                  print('AuthRepository - Retry in getCurrentUser failed: $retryError');
                  rethrow;
                }
                print('AuthRepository - Retry attempt ${attempt + 1} in getCurrentUser failed, retrying...');
              }
            }
          } catch (retryError) {
            print('AuthRepository - All retries in getCurrentUser failed: $retryError');
            // Return null - user data not available
            return null;
          }
        }
        rethrow;
      }
    } on FirebaseException catch (e) {
      print('AuthRepository - getCurrentUser FirebaseException:');
      print('  Code: ${e.code}');
      print('  Message: ${e.message}');
      // Log error but continue - cache might have data
      return null;
    } catch (e) {
      print('AuthRepository - getCurrentUser Error: $e');
      print('AuthRepository - Error Type: ${e.runtimeType}');
      return null;
    }
  }

  @override
  Stream<UserEntity?> authStateChanges() {
    return _auth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;

      Future<UserEntity?> getUserData() async {
        // Use default behavior - tries server first, falls back to cache
        final userDoc = await _firestore
            .collection(AppConstants.usersCollection)
            .doc(firebaseUser.uid)
            .get();

        if (!userDoc.exists) return null;

        final userModel = UserModel.fromFirestore(userDoc);
        return UserEntity(
          userId: userModel.userId,
          email: userModel.email,
          name: userModel.name,
          phone: userModel.phone,
          isAdmin: userModel.isAdmin,
        );
      }

      try {
        return await getUserData();
      } on FirebaseException catch (e) {
        print('AuthRepository - authStateChanges FirebaseException:');
        print('  Code: ${e.code}');
        print('  Message: ${e.message}');

        if (e.code == 'unavailable') {
          print(
            'AuthRepository - Firestore unavailable in authStateChanges, retrying...',
          );
          try {
            await _firestore.enableNetwork();
            // Retry with exponential backoff
            for (int attempt = 0; attempt < 3; attempt++) {
              await Future.delayed(Duration(milliseconds: 500 * (attempt + 1)));
              try {
                return await getUserData();
              } catch (retryError) {
                if (attempt == 2) {
                  print('AuthRepository - Retry in authStateChanges failed: $retryError');
                  // Return null - user data not available
                  return null;
                }
                print('AuthRepository - Retry attempt ${attempt + 1} in authStateChanges failed, retrying...');
              }
            }
          } catch (retryError) {
            print('AuthRepository - All retries in authStateChanges failed: $retryError');
            // Return null - user data not available
            return null;
          }
        }

        // Log error but return null - cache might not have data yet
        print(
          'AuthRepository - Firestore error in authStateChanges: ${e.code}',
        );
        return null;
      } catch (e) {
        print('AuthRepository - authStateChanges Error: $e');
        print('AuthRepository - Error Type: ${e.runtimeType}');
        return null;
      }
    });
  }

  String _getFirebaseErrorMessage(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'weak-password':
        return 'The password is too weak. Please use a stronger password.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'network-request-failed':
        return 'Network error. Please check your internet connection.';
      case 'invalid-credential':
        return 'Invalid email or password. Please try again.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}
