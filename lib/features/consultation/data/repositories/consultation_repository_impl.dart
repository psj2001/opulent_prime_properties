import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:opulent_prime_properties/core/constants/app_constants.dart';
import 'package:opulent_prime_properties/core/firebase/firebase_config.dart';
import 'package:opulent_prime_properties/shared/models/consultation_model.dart';

class ConsultationRepository {
  final FirebaseFirestore _firestore;

  ConsultationRepository({
    FirebaseFirestore? firestore,
  }) : _firestore = firestore ?? FirebaseConfig.firestore;

  Future<String> createConsultation(ConsultationModel consultation) async {
    final docRef = await _firestore
        .collection(AppConstants.consultationsCollection)
        .add(consultation.toFirestore());
    
    final consultationId = docRef.id;
    
    // Create lead directly (workaround for Spark plan - no Cloud Functions)
    // Note: In production with Blaze plan, use Cloud Functions instead
    try {
      print('🔄 Starting lead creation process...');
      print('Consultation ID: $consultationId');
      print('User ID: ${consultation.userId}');
      
      // Create lead document directly
      // Note: We create a lead for each consultation to track all bookings
      print('Creating lead document...');
      final leadRef = await _firestore.collection(AppConstants.leadsCollection).add({
        'userId': consultation.userId,
        'source': 'consultation',
        'status': 'new',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      
      print('✅ Lead created successfully!');
      print('Lead ID: ${leadRef.id}');
      print('Consultation ID: $consultationId');
      print('User ID: ${consultation.userId}');
    } catch (e, stackTrace) {
      print('❌ ERROR creating lead: $e');
      print('Error type: ${e.runtimeType}');
      if (e is FirebaseException) {
        print('Firebase error code: ${e.code}');
        print('Firebase error message: ${e.message}');
      }
      print('Stack trace: $stackTrace');
      // Don't fail consultation creation if lead creation fails
      print('⚠️ Consultation created but lead creation failed. Consultation ID: $consultationId');
      // Re-throw to see the error in the UI
      // But don't fail the consultation creation
    }
    
    return consultationId;
  }

  Stream<List<ConsultationModel>> getConsultationsByUser(String userId) {
    return _firestore
        .collection(AppConstants.consultationsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ConsultationModel.fromFirestore(doc))
            .toList())
        .asBroadcastStream();
  }

  Future<List<ConsultationModel>> getConsultationsByUserOnce(String userId) async {
    final snapshot = await _firestore
        .collection(AppConstants.consultationsCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => ConsultationModel.fromFirestore(doc))
        .toList();
  }

  // Admin methods
  Stream<List<ConsultationModel>> getAllConsultations() {
    return _firestore
        .collection(AppConstants.consultationsCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ConsultationModel.fromFirestore(doc))
            .toList())
        .asBroadcastStream();
  }

  Future<List<ConsultationModel>> getAllConsultationsOnce() async {
    final snapshot = await _firestore
        .collection(AppConstants.consultationsCollection)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => ConsultationModel.fromFirestore(doc))
        .toList();
  }

  Future<int> getConsultationsCount() async {
    final snapshot = await _firestore
        .collection(AppConstants.consultationsCollection)
        .count()
        .get();
    return snapshot.count ?? 0;
  }

  Stream<List<ConsultationModel>> getRecentConsultations({int limit = 5}) {
    return _firestore
        .collection(AppConstants.consultationsCollection)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ConsultationModel.fromFirestore(doc))
            .toList())
        .asBroadcastStream();
  }
}

