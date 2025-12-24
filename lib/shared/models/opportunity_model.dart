import 'package:cloud_firestore/cloud_firestore.dart';

class OpportunityModel {
  final String opportunityId;
  final String title;
  final String description;
  final String categoryId;
  final String areaId;
  final double price;
  final List<String> images;
  final List<String> features;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  OpportunityModel({
    required this.opportunityId,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.areaId,
    required this.price,
    required this.images,
    required this.features,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory OpportunityModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OpportunityModel(
      opportunityId: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      categoryId: data['categoryId'] ?? '',
      areaId: data['areaId'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      images: List<String>.from(data['images'] ?? []),
      features: List<String>.from(data['features'] ?? []),
      status: data['status'] ?? 'active',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }
  
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'categoryId': categoryId,
      'areaId': areaId,
      'price': price,
      'images': images,
      'features': features,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}

