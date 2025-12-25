import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opulent_prime_properties/core/services/fcm_token_service.dart';
import 'package:opulent_prime_properties/features/auth/presentation/bloc/auth_bloc.dart';

/// Widget that handles FCM token saving when user is authenticated
class FCMTokenHandler extends StatelessWidget {
  final Widget child;

  const FCMTokenHandler({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // Save FCM token when user is authenticated
          final userId = state.user.userId;
          FCMTokenService.saveFCMToken(userId);
          FCMTokenService.listenForTokenRefresh(userId);
          print('🔔 FCM token handler: Saving token for authenticated user: $userId');
        }
      },
      child: child,
    );
  }
}

