import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:opulent_prime_properties/core/constants/app_constants.dart';
import 'package:opulent_prime_properties/core/constants/route_names.dart';
import 'package:opulent_prime_properties/core/theme/app_theme.dart';
import 'package:opulent_prime_properties/features/auth/presentation/bloc/auth_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkOnboardingAndAuth();
  }

  Future<void> _checkOnboardingAndAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    // If running on web, redirect to admin login or dashboard
    if (kIsWeb) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated && authState.user.isAdmin) {
        context.go(RouteNames.adminDashboard);
      } else {
        context.go(RouteNames.adminLogin);
      }
      return;
    }
    
    // Mobile app logic
    final prefs = await SharedPreferences.getInstance();
    final onboardingCompleted = prefs.getBool(AppConstants.onboardingCompletedKey) ?? false;
    
    if (!onboardingCompleted) {
      context.go(RouteNames.onboarding);
      return;
    }
    
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      final user = authState.user;
      if (user.isAdmin) {
        context.go(RouteNames.adminDashboard);
      } else {
        context.go(RouteNames.home);
      }
    } else {
      context.go(RouteNames.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.home_work,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            const Text(
              'Opulent Prime Properties',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

