import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String userId;
  final String email;
  final String name;
  final String? phone;
  final bool isAdmin;
  
  const UserEntity({
    required this.userId,
    required this.email,
    required this.name,
    this.phone,
    this.isAdmin = false,
  });
  
  @override
  List<Object?> get props => [userId, email, name, phone, isAdmin];
}

