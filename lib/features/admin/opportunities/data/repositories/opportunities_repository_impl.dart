import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:opulent_prime_properties/core/constants/app_constants.dart';
import 'package:opulent_prime_properties/core/firebase/firebase_config.dart';
import 'package:opulent_prime_properties/shared/models/opportunity_model.dart';

class OpportunitiesRepository {
  final FirebaseFirestore _firestore;

  OpportunitiesRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseConfig.firestore;

  Stream<List<OpportunityModel>> getOpportunities() {
    return _firestore
        .collection(AppConstants.opportunitiesCollection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OpportunityModel.fromFirestore(doc))
            .toList())
        .asBroadcastStream();
  }

  Future<List<OpportunityModel>> getOpportunitiesOnce() async {
    final snapshot = await _firestore
        .collection(AppConstants.opportunitiesCollection)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => OpportunityModel.fromFirestore(doc))
        .toList();
  }

  Future<int> getOpportunitiesCount() async {
    final snapshot = await _firestore
        .collection(AppConstants.opportunitiesCollection)
        .count()
        .get();
    return snapshot.count ?? 0;
  }

  Future<void> createOpportunity(OpportunityModel opportunity) async {
    await _firestore
        .collection(AppConstants.opportunitiesCollection)
        .doc(opportunity.opportunityId)
        .set(opportunity.toFirestore());
  }

  Future<void> updateOpportunity(OpportunityModel opportunity) async {
    await _firestore
        .collection(AppConstants.opportunitiesCollection)
        .doc(opportunity.opportunityId)
        .update(opportunity.toFirestore());
  }

  Future<OpportunityModel?> getOpportunity(String opportunityId) async {
    final doc = await _firestore
        .collection(AppConstants.opportunitiesCollection)
        .doc(opportunityId)
        .get();
    if (!doc.exists) return null;
    return OpportunityModel.fromFirestore(doc);
  }

  Future<void> deleteOpportunity(String opportunityId) async {
    await _firestore
        .collection(AppConstants.opportunitiesCollection)
        .doc(opportunityId)
        .delete();
  }

  Stream<List<OpportunityModel>> getOpportunitiesByCategory(String categoryId) {
    return _firestore
        .collection(AppConstants.opportunitiesCollection)
        .where('categoryId', isEqualTo: categoryId)
        .where('status', isEqualTo: AppConstants.opportunityStatusActive)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OpportunityModel.fromFirestore(doc))
            .toList())
        .asBroadcastStream();
  }

  Future<List<OpportunityModel>> getOpportunitiesByCategoryOnce(String categoryId) async {
    final snapshot = await _firestore
        .collection(AppConstants.opportunitiesCollection)
        .where('categoryId', isEqualTo: categoryId)
        .where('status', isEqualTo: AppConstants.opportunityStatusActive)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => OpportunityModel.fromFirestore(doc))
        .toList();
  }

  Stream<List<OpportunityModel>> getActiveOpportunities({int? limit}) {
    var query = _firestore
        .collection(AppConstants.opportunitiesCollection)
        .where('status', isEqualTo: AppConstants.opportunityStatusActive)
        .orderBy('createdAt', descending: true);
    
    if (limit != null) {
      query = query.limit(limit);
    }
    
    return query
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OpportunityModel.fromFirestore(doc))
            .toList())
        .asBroadcastStream();
  }

  Future<List<OpportunityModel>> getActiveOpportunitiesOnce({int? limit}) async {
    var query = _firestore
        .collection(AppConstants.opportunitiesCollection)
        .where('status', isEqualTo: AppConstants.opportunityStatusActive)
        .orderBy('createdAt', descending: true);
    
    if (limit != null) {
      query = query.limit(limit);
    }
    
    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => OpportunityModel.fromFirestore(doc))
        .toList();
  }
}

