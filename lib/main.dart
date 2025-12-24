import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opulent_prime_properties/core/firebase/firebase_config.dart';
import 'package:opulent_prime_properties/core/router/app_router.dart';
import 'package:opulent_prime_properties/core/theme/app_theme.dart';
import 'package:opulent_prime_properties/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:opulent_prime_properties/features/auth/presentation/bloc/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await FirebaseConfig.initialize();
  } catch (e, stackTrace) {
    print('Firebase initialization error: $e');
    print('Stack trace: $stackTrace');
    // Continue anyway - app should still work
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepositoryImpl>(
          create: (_) => AuthRepositoryImpl(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepositoryImpl>(),
            )..add(CheckAuthStatus()),
          ),
        ],
        child: MaterialApp.router(
          title: 'Opulent Prime Properties',
          theme: AppTheme.lightTheme,
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
