import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:opulent_prime_properties/core/constants/app_constants.dart';
import 'package:opulent_prime_properties/core/firebase/firebase_config.dart';
import 'package:opulent_prime_properties/shared/models/shortlist_model.dart';

class ShortlistRepository {
  final FirebaseFirestore _firestore;

  ShortlistRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseConfig.firestore;

  /// Get or create shortlist for a user
  Future<ShortlistModel> getOrCreateShortlist(String userId) async {
    final querySnapshot = await _firestore
        .collection(AppConstants.shortlistsCollection)
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return ShortlistModel.fromFirestore(querySnapshot.docs.first);
    }

    // Create new shortlist
    final now = DateTime.now();
    final shortlist = ShortlistModel(
      shortlistId: '',
      userId: userId,
      opportunityIds: [],
      createdAt: now,
      updatedAt: now,
    );

    final docRef = await _firestore
        .collection(AppConstants.shortlistsCollection)
        .add(shortlist.toFirestore());

    return shortlist.copyWith(shortlistId: docRef.id);
  }

  /// Get shortlist for a user (stream)
  Stream<ShortlistModel?> getShortlistStream(String userId) {
    return _firestore
        .collection(AppConstants.shortlistsCollection)
        .where('userId', isEqualTo: userId)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      return ShortlistModel.fromFirestore(snapshot.docs.first);
    });
  }

  /// Get shortlist for a user (once)
  Future<ShortlistModel?> getShortlist(String userId) async {
    final querySnapshot = await _firestore
        .collection(AppConstants.shortlistsCollection)
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) return null;
    return ShortlistModel.fromFirestore(querySnapshot.docs.first);
  }

  /// Add opportunity to shortlist
  Future<void> addToShortlist(String userId, String opportunityId) async {
    final shortlist = await getOrCreateShortlist(userId);

    if (shortlist.opportunityIds.contains(opportunityId)) {
      // Already in shortlist
      return;
    }

    final updatedIds = [...shortlist.opportunityIds, opportunityId];

    await _firestore
        .collection(AppConstants.shortlistsCollection)
        .doc(shortlist.shortlistId)
        .update({
      'opportunityIds': updatedIds,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Remove opportunity from shortlist
  Future<void> removeFromShortlist(String userId, String opportunityId) async {
    final shortlist = await getShortlist(userId);

    if (shortlist == null) return;

    final updatedIds = shortlist.opportunityIds
        .where((id) => id != opportunityId)
        .toList();

    await _firestore
        .collection(AppConstants.shortlistsCollection)
        .doc(shortlist.shortlistId)
        .update({
      'opportunityIds': updatedIds,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Check if opportunity is in shortlist
  Future<bool> isInShortlist(String userId, String opportunityId) async {
    final shortlist = await getShortlist(userId);
    if (shortlist == null) return false;
    return shortlist.opportunityIds.contains(opportunityId);
  }

  /// Get shortlist count
  Future<int> getShortlistCount(String userId) async {
    final shortlist = await getShortlist(userId);
    if (shortlist == null) return 0;
    return shortlist.opportunityIds.length;
  }

  /// Share shortlist - creates a lead
  Future<String> shareShortlist(String userId) async {
    final shortlist = await getShortlist(userId);
    if (shortlist == null || shortlist.opportunityIds.isEmpty) {
      throw Exception('Shortlist is empty');
    }

    // Create lead for shared shortlist
    final leadRef = await _firestore.collection(AppConstants.leadsCollection).add({
      'userId': userId,
      'source': 'shortlist',
      'status': 'new',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return leadRef.id;
  }
}

