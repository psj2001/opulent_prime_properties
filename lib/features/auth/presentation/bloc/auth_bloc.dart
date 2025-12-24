import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:opulent_prime_properties/core/errors/exceptions.dart';
import 'package:opulent_prime_properties/features/auth/domain/entities/user_entity.dart';
import 'package:opulent_prime_properties/features/auth/domain/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  
  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<SignInRequested>(_onSignInRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<SignOutRequested>(_onSignOutRequested);
    on<AuthStatusChanged>(_onAuthStatusChanged);
    
    // Listen to auth state changes
    authRepository.authStateChanges().listen((user) {
      if (user != null) {
        add(AuthStatusChanged(user));
      } else {
        add(AuthStatusChanged(null));
      }
    });
  }
  
  void _onCheckAuthStatus(CheckAuthStatus event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.getCurrentUser();
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      print('AuthBloc - CheckAuthStatus Error: $e');
      print('AuthBloc - Error Type: ${e.runtimeType}');
      if (e is AuthException) {
        print('AuthBloc - AuthException Message: ${e.message}');
      }
      emit(AuthError(_getErrorMessage(e)));
    }
  }
  
  void _onSignInRequested(SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.signInWithEmailAndPassword(
        event.email,
        event.password,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      print('AuthBloc - SignInRequested Error: $e');
      print('AuthBloc - Error Type: ${e.runtimeType}');
      if (e is AuthException) {
        print('AuthBloc - AuthException Message: ${e.message}');
      }
      emit(AuthError(_getErrorMessage(e)));
    }
  }
  
  void _onSignUpRequested(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await authRepository.signUpWithEmailAndPassword(
        event.email,
        event.password,
        event.name,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      print('AuthBloc - SignUpRequested Error: $e');
      print('AuthBloc - Error Type: ${e.runtimeType}');
      if (e is AuthException) {
        print('AuthBloc - AuthException Message: ${e.message}');
      }
      emit(AuthError(_getErrorMessage(e)));
    }
  }
  
  void _onSignOutRequested(SignOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await authRepository.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      print('AuthBloc - SignOutRequested Error: $e');
      print('AuthBloc - Error Type: ${e.runtimeType}');
      if (e is AuthException) {
        print('AuthBloc - AuthException Message: ${e.message}');
      }
      emit(AuthError(_getErrorMessage(e)));
    }
  }
  
  void _onAuthStatusChanged(AuthStatusChanged event, Emitter<AuthState> emit) {
    if (event.user != null) {
      emit(AuthAuthenticated(event.user!));
    } else {
      emit(AuthUnauthenticated());
    }
  }
  
  String _getErrorMessage(dynamic error) {
    if (error is AuthException) {
      return error.message;
    }
    return error.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
  }
}

