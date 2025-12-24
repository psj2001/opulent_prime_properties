import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:opulent_prime_properties/core/constants/route_names.dart';
import 'package:opulent_prime_properties/core/theme/app_theme.dart';
import 'package:opulent_prime_properties/features/auth/presentation/bloc/auth_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is AuthAuthenticated) {
            final user = state.user;
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 16),
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: AppTheme.primaryColor,
                    child: Text(
                      user.name[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 36,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    user.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    user.email,
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                _ProfileMenuItem(
                  icon: Icons.person,
                  title: 'Edit Profile',
                  onTap: () {
                    // TODO: Navigate to edit profile
                  },
                ),
                _ProfileMenuItem(
                  icon: Icons.favorite,
                  title: 'My Shortlist',
                  onTap: () {
                    context.push(RouteNames.shortlist);
                  },
                ),
                _ProfileMenuItem(
                  icon: Icons.event,
                  title: 'My Consultations',
                  onTap: () {
                    // TODO: Navigate to consultations
                  },
                ),
                _ProfileMenuItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () {
                    // TODO: Navigate to settings
                  },
                ),
                const SizedBox(height: 32),
                BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthUnauthenticated) {
                      context.go(RouteNames.home);
                    }
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(SignOutRequested());
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                      ),
                      child: const Text('Sign Out'),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  // TODO: Navigate to login
                },
                child: const Text('Sign In'),
              ),
            );
          }
        },
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

