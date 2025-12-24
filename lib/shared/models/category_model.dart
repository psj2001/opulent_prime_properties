import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String categoryId;
  final String name;
  final String icon;
  final int order;
  final bool isActive;
  
  CategoryModel({
    required this.categoryId,
    required this.name,
    required this.icon,
    required this.order,
    required this.isActive,
  });
  
  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      categoryId: doc.id,
      name: data['name'] ?? '',
      icon: data['icon'] ?? '',
      order: data['order'] ?? 0,
      isActive: data['isActive'] ?? true,
    );
  }
  
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'icon': icon,
      'order': order,
      'isActive': isActive,
    };
  }
}

