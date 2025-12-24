import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:opulent_prime_properties/core/constants/app_constants.dart';
import 'package:opulent_prime_properties/core/firebase/firebase_config.dart';
import 'package:opulent_prime_properties/shared/models/lead_model.dart';
import 'package:opulent_prime_properties/shared/models/user_model.dart';

class LeadsRepository {
  final FirebaseFirestore _firestore;

  LeadsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseConfig.firestore;

  Stream<List<LeadModel>> getLeads() {
    return _firestore
        .collection(AppConstants.leadsCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LeadModel.fromFirestore(doc))
            .toList())
        .asBroadcastStream();
  }

  Future<List<LeadModel>> getLeadsOnce() async {
    final snapshot = await _firestore
        .collection(AppConstants.leadsCollection)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => LeadModel.fromFirestore(doc))
        .toList();
  }

  Future<UserModel?> getUser(String userId) async {
    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(userId)
        .get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  Future<int> getLeadsCount() async {
    final snapshot = await _firestore
        .collection(AppConstants.leadsCollection)
        .count()
        .get();
    return snapshot.count ?? 0;
  }

  Future<LeadModel?> getLead(String leadId) async {
    final doc = await _firestore
        .collection(AppConstants.leadsCollection)
        .doc(leadId)
        .get();
    if (!doc.exists) return null;
    return LeadModel.fromFirestore(doc);
  }

  Stream<LeadModel?> getLeadStream(String leadId) {
    return _firestore
        .collection(AppConstants.leadsCollection)
        .doc(leadId)
        .snapshots()
        .map((doc) => doc.exists ? LeadModel.fromFirestore(doc) : null);
  }

  Future<void> updateLeadStatus(String leadId, String status) async {
    await _firestore.collection(AppConstants.leadsCollection).doc(leadId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateLeadConsultant(String leadId, String? consultantId) async {
    await _firestore.collection(AppConstants.leadsCollection).doc(leadId).update({
      'consultantId': consultantId,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateLeadNotes(String leadId, String? notes) async {
    await _firestore.collection(AppConstants.leadsCollection).doc(leadId).update({
      'notes': notes,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}

