part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  
  @override
  List<Object> get props => [];
}

class CheckAuthStatus extends AuthEvent {}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;
  
  const SignInRequested({required this.email, required this.password});
  
  @override
  List<Object> get props => [email, password];
}

class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;
  final bool isAdmin;
  
  const SignUpRequested({
    required this.email,
    required this.password,
    required this.name,
    this.isAdmin = false,
  });
  
  @override
  List<Object> get props => [email, password, name, isAdmin];
}

class SignOutRequested extends AuthEvent {}

class AuthStatusChanged extends AuthEvent {
  final UserEntity? user;
  
  const AuthStatusChanged(this.user);
  
  @override
  List<Object> get props => [user ?? ''];
}

