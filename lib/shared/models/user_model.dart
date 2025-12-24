import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String email;
  final String name;
  final String? phone;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? fcmToken;
  final bool isAdmin;
  
  UserModel({
    required this.userId,
    required this.email,
    required this.name,
    this.phone,
    required this.createdAt,
    required this.updatedAt,
    this.fcmToken,
    this.isAdmin = false,
  });
  
  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      userId: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phone: data['phone'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      fcmToken: data['fcmToken'],
      isAdmin: data['isAdmin'] ?? false,
    );
  }
  
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'fcmToken': fcmToken,
      'isAdmin': isAdmin,
    };
  }
  
  UserModel copyWith({
    String? userId,
    String? email,
    String? name,
    String? phone,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? fcmToken,
    bool? isAdmin,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      fcmToken: fcmToken ?? this.fcmToken,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }
}

