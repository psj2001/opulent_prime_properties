import 'package:cloud_firestore/cloud_firestore.dart';

class BlogModel {
  final String blogId;
  final String title;
  final String content;
  final String excerpt;
  final String category;
  final String? imageUrl;
  final String author;
  final DateTime publishedDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isPublished;
  
  BlogModel({
    required this.blogId,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.category,
    this.imageUrl,
    required this.author,
    required this.publishedDate,
    required this.createdAt,
    required this.updatedAt,
    this.isPublished = true,
  });
  
  factory BlogModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BlogModel(
      blogId: doc.id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      excerpt: data['excerpt'] ?? '',
      category: data['category'] ?? '',
      imageUrl: data['imageUrl'],
      author: data['author'] ?? 'admin',
      publishedDate: (data['publishedDate'] as Timestamp).toDate(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      isPublished: data['isPublished'] ?? true,
    );
  }
  
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'content': content,
      'excerpt': excerpt,
      'category': category,
      'imageUrl': imageUrl,
      'author': author,
      'publishedDate': Timestamp.fromDate(publishedDate),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isPublished': isPublished,
    };
  }
  
  BlogModel copyWith({
    String? blogId,
    String? title,
    String? content,
    String? excerpt,
    String? category,
    String? imageUrl,
    String? author,
    DateTime? publishedDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isPublished,
  }) {
    return BlogModel(
      blogId: blogId ?? this.blogId,
      title: title ?? this.title,
      content: content ?? this.content,
      excerpt: excerpt ?? this.excerpt,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      author: author ?? this.author,
      publishedDate: publishedDate ?? this.publishedDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPublished: isPublished ?? this.isPublished,
    );
  }
}

