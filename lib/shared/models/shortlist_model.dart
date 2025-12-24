import 'package:cloud_firestore/cloud_firestore.dart';

class ShortlistModel {
  final String shortlistId;
  final String userId;
  final List<String> opportunityIds;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  ShortlistModel({
    required this.shortlistId,
    required this.userId,
    required this.opportunityIds,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory ShortlistModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ShortlistModel(
      shortlistId: doc.id,
      userId: data['userId'] ?? '',
      opportunityIds: List<String>.from(data['opportunityIds'] ?? []),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
  
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'opportunityIds': opportunityIds,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
  
  ShortlistModel copyWith({
    String? shortlistId,
    String? userId,
    List<String>? opportunityIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ShortlistModel(
      shortlistId: shortlistId ?? this.shortlistId,
      userId: userId ?? this.userId,
      opportunityIds: opportunityIds ?? this.opportunityIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

