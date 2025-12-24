import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:opulent_prime_properties/core/constants/route_names.dart';
import 'package:opulent_prime_properties/core/utils/validators.dart';
import 'package:opulent_prime_properties/features/auth/presentation/bloc/auth_bloc.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Colors matching the design
  static const Color darkTeal = Color(0xFF1E4D5C);
  static const Color teal = Color(0xFF2D7A8C);
  static const Color orange = Color(0xFFFF6B35);
  static const Color amber = Color(0xFFFFA500);
  static const Color lightGray = Color(0xFFE0E0E0);
  static const Color grayBorder = Color(0xFFBDBDBD);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            SignInRequested(
              email: _emailController.text,
              password: _passwordController.text,
            ),
          );
    }
  }

  Widget _buildLogo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Stylized leaf/flame logo with gradient
        Container(
          width: 80,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [teal, orange],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: CustomPaint(
            painter: _LogoPainter(),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Bailey and Co.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkTeal,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            if (state.user.isAdmin) {
              context.go(RouteNames.adminDashboard);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Access denied. Admin only.')),
              );
            }
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Row(
          children: [
            // Left side - Logo and Company Name
            Expanded(
              child: Container(
                color: darkTeal,
                child: Center(
                  child: _buildLogo(),
                ),
              ),
            ),
            // Vertical divider
            Container(
              width: 1,
              color: lightGray,
            ),
            // Right side - Login Form
            Expanded(
              child: Container(
                color: darkTeal,
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Welcome',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'PLEASE LOGIN TO ADMIN DASHBOARD.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 60),
                          // Username field
                          TextFormField(
                            controller: _emailController,
                            style: const TextStyle(color: Colors.black87),
                            decoration: InputDecoration(
                              hintText: 'USERNAME',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                                letterSpacing: 1.0,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                  color: grayBorder,
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                  color: grayBorder,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                  color: grayBorder,
                                  width: 1,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: Validators.email,
                          ),
                          const SizedBox(height: 20),
                          // Password field
                          TextFormField(
                            controller: _passwordController,
                            style: const TextStyle(color: Colors.black87),
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'PASSWORD',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                                letterSpacing: 1.0,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                  color: grayBorder,
                                  width: 1,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                  color: grayBorder,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                  color: grayBorder,
                                  width: 1,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                            validator: Validators.password,
                          ),
                          const SizedBox(height: 40),
                          // Login button
                          BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              return SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: state is AuthLoading ? null : _submit,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: orange,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: state is AuthLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                          ),
                                        )
                                      : const Text(
                                          'LOGIN',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 30),
                          // Forgot password link
                          TextButton(
                            onPressed: () {
                              // TODO: Implement forgot password functionality
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'FORGOTTEN YOUR PASSWORD?',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom painter for the logo (stylized leaf/flame shape)
class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Create a stylized leaf/flame shape
    // Starting from bottom left
    path.moveTo(size.width * 0.2, size.height * 0.9);
    
    // Left curve going up
    path.quadraticBezierTo(
      size.width * 0.1,
      size.height * 0.6,
      size.width * 0.3,
      size.height * 0.3,
    );
    
    // Top curve
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.1,
      size.width * 0.7,
      size.height * 0.3,
    );
    
    // Right curve going down
    path.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.6,
      size.width * 0.8,
      size.height * 0.9,
    );
    
    // Close the path
    path.close();

    // Draw the shape with gradient
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: const [
        Color(0xFF2D7A8C), // Teal
        Color(0xFFFF6B35), // Orange
      ],
    );
    paint.shader = gradient.createShader(rect);
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

