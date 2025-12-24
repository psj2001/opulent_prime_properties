import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:opulent_prime_properties/core/constants/app_constants.dart';
import 'package:opulent_prime_properties/core/firebase/firebase_config.dart';
import 'package:opulent_prime_properties/shared/models/category_model.dart';

class CategoriesRepository {
  final FirebaseFirestore _firestore;

  CategoriesRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseConfig.firestore;

  Stream<List<CategoryModel>> getCategories() {
    return _firestore
        .collection(AppConstants.categoriesCollection)
        .orderBy('order')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CategoryModel.fromFirestore(doc))
            .toList())
        .asBroadcastStream();
  }

  Future<List<CategoryModel>> getCategoriesOnce() async {
    final snapshot = await _firestore
        .collection(AppConstants.categoriesCollection)
        .orderBy('order')
        .get();
    return snapshot.docs
        .map((doc) => CategoryModel.fromFirestore(doc))
        .toList();
  }

  Future<int> getCategoriesCount() async {
    final snapshot = await _firestore
        .collection(AppConstants.categoriesCollection)
        .count()
        .get();
    return snapshot.count ?? 0;
  }

  Future<void> createCategory(CategoryModel category) async {
    await _firestore
        .collection(AppConstants.categoriesCollection)
        .doc(category.categoryId)
        .set(category.toFirestore());
  }

  Future<void> updateCategory(CategoryModel category) async {
    await _firestore
        .collection(AppConstants.categoriesCollection)
        .doc(category.categoryId)
        .update(category.toFirestore());
  }

  Future<void> deleteCategory(String categoryId) async {
    await _firestore
        .collection(AppConstants.categoriesCollection)
        .doc(categoryId)
        .delete();
  }
}

