import 'package:cloud_firestore/cloud_firestore.dart';

class AreaModel {
  final String areaId;
  final String name;
  final bool isActive;
  
  AreaModel({
    required this.areaId,
    required this.name,
    required this.isActive,
  });
  
  factory AreaModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AreaModel(
      areaId: doc.id,
      name: data['name'] ?? '',
      isActive: data['isActive'] ?? true,
    );
  }
  
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'isActive': isActive,
    };
  }
}

