import 'package:cloud_firestore/cloud_firestore.dart';

class ConsultationModel {
  final String consultationId;
  final String userId;
  final String? opportunityId;
  final DateTime preferredDate;
  final String preferredTime;
  final String status;
  final String? consultantId;
  final String? notes;
  final DateTime createdAt;
  
  ConsultationModel({
    required this.consultationId,
    required this.userId,
    this.opportunityId,
    required this.preferredDate,
    required this.preferredTime,
    required this.status,
    this.consultantId,
    this.notes,
    required this.createdAt,
  });
  
  factory ConsultationModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ConsultationModel(
      consultationId: doc.id,
      userId: data['userId'] ?? '',
      opportunityId: data['opportunityId'],
      preferredDate: (data['preferredDate'] as Timestamp).toDate(),
      preferredTime: data['preferredTime'] ?? '',
      status: data['status'] ?? 'pending',
      consultantId: data['consultantId'],
      notes: data['notes'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
  
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'opportunityId': opportunityId,
      'preferredDate': Timestamp.fromDate(preferredDate),
      'preferredTime': preferredTime,
      'status': status,
      'consultantId': consultantId,
      'notes': notes,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

