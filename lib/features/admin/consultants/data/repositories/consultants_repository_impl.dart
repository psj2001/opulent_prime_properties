import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:opulent_prime_properties/core/constants/app_constants.dart';
import 'package:opulent_prime_properties/core/firebase/firebase_config.dart';
import 'package:opulent_prime_properties/shared/models/consultant_model.dart';

class ConsultantsRepository {
  final FirebaseFirestore _firestore;

  ConsultantsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseConfig.firestore;

  Stream<List<ConsultantModel>> getConsultants() {
    return _firestore
        .collection(AppConstants.consultantsCollection)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ConsultantModel.fromFirestore(doc))
            .toList())
        .asBroadcastStream();
  }

  Future<List<ConsultantModel>> getConsultantsOnce() async {
    final snapshot = await _firestore
        .collection(AppConstants.consultantsCollection)
        .orderBy('name')
        .get();
    return snapshot.docs
        .map((doc) => ConsultantModel.fromFirestore(doc))
        .toList();
  }

  Future<int> getConsultantsCount() async {
    final snapshot = await _firestore
        .collection(AppConstants.consultantsCollection)
        .count()
        .get();
    return snapshot.count ?? 0;
  }

  Future<void> createConsultant(ConsultantModel consultant) async {
    await _firestore
        .collection(AppConstants.consultantsCollection)
        .doc(consultant.consultantId)
        .set(consultant.toFirestore());
  }

  Future<void> updateConsultant(ConsultantModel consultant) async {
    await _firestore
        .collection(AppConstants.consultantsCollection)
        .doc(consultant.consultantId)
        .update(consultant.toFirestore());
  }

  Future<void> deleteConsultant(String consultantId) async {
    await _firestore
        .collection(AppConstants.consultantsCollection)
        .doc(consultantId)
        .delete();
  }
}

