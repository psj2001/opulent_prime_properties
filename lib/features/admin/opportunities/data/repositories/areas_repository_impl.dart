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
}

