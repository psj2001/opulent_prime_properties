import 'package:cloud_firestore/cloud_firestore.dart';

class ConsultantModel {
  final String consultantId;
  final String name;
  final String email;
  final String phone;
  final bool isActive;
  
  ConsultantModel({
    required this.consultantId,
    required this.name,
    required this.email,
    required this.phone,
    required this.isActive,
  });
  
  factory ConsultantModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ConsultantModel(
      consultantId: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phone: data['phone'] ?? '',
      isActive: data['isActive'] ?? true,
    );
  }
  
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'isActive': isActive,
    };
  }
}

