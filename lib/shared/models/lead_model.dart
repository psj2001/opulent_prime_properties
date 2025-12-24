import 'package:cloud_firestore/cloud_firestore.dart';

class LeadModel {
  final String leadId;
  final String userId;
  final String source;
  final String status;
  final String? consultantId;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  LeadModel({
    required this.leadId,
    required this.userId,
    required this.source,
    required this.status,
    this.consultantId,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory LeadModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LeadModel(
      leadId: doc.id,
      userId: data['userId'] ?? '',
      source: data['source'] ?? '',
      status: data['status'] ?? 'new',
      consultantId: data['consultantId'],
      notes: data['notes'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }
  
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'source': source,
      'status': status,
      'consultantId': consultantId,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}

