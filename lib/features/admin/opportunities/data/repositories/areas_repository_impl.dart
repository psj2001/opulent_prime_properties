import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:opulent_prime_properties/core/constants/app_constants.dart';
import 'package:opulent_prime_properties/core/firebase/firebase_config.dart';
import 'package:opulent_prime_properties/shared/models/area_model.dart';

class AreasRepository {
  final FirebaseFirestore _firestore;

  AreasRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseConfig.firestore;

  Stream<List<AreaModel>> getAreas() {
    return _firestore
        .collection(AppConstants.areasCollection)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => AreaModel.fromFirestore(doc))
            .where((area) => area.isActive) // Filter active areas in code
            .toList())
        .asBroadcastStream();
  }

  Future<List<AreaModel>> getAreasOnce() async {
    final snapshot = await _firestore
        .collection(AppConstants.areasCollection)
        .orderBy('name')
        .get();
    return snapshot.docs
        .map((doc) => AreaModel.fromFirestore(doc))
        .where((area) => area.isActive) // Filter active areas in code
        .toList();
  }

  Future<AreaModel?> getArea(String areaId) async {
    final doc = await _firestore
        .collection(AppConstants.areasCollection)
        .doc(areaId)
        .get();
    if (!doc.exists) return null;
    return AreaModel.fromFirestore(doc);
  }

  Future<AreaModel> createArea(String name) async {
    // Check if area already exists (case-insensitive)
    final existingSnapshot = await _firestore
        .collection(AppConstants.areasCollection)
        .where('name', isEqualTo: name)
        .limit(1)
        .get();
    
    if (existingSnapshot.docs.isNotEmpty) {
      // Return existing area
      return AreaModel.fromFirestore(existingSnapshot.docs.first);
    }
    
    // Create new area
    final docRef = _firestore.collection(AppConstants.areasCollection).doc();
    final area = AreaModel(
      areaId: docRef.id,
      name: name.trim(),
      isActive: true,
    );
    
    await docRef.set(area.toFirestore());
    return area;
  }
}

