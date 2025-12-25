import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:opulent_prime_properties/core/constants/route_names.dart';
import 'package:opulent_prime_properties/core/utils/validators.dart';
import 'package:opulent_prime_properties/core/widgets/loading_widget.dart';
import 'package:opulent_prime_properties/features/auth/presentation/bloc/auth_bloc.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isCreatingAccount = false;

  // Colors matching the design
  static const Color teal = Color(0xFF2D7A8C);
  static const Color orange = Color(0xFFFF6B35);
  static const Color lightGray = Color(0xFFE0E0E0);
  static const Color grayBorder = Color(0xFFBDBDBD);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_isCreatingAccount) {
        context.read<AuthBloc>().add(
              SignUpRequested(
                email: _emailController.text,
                password: _passwordController.text,
                name: _nameController.text,
                isAdmin: true,
              ),
            );
      } else {
        context.read<AuthBloc>().add(
              SignInRequested(
                email: _emailController.text,
                password: _passwordController.text,
              ),
            );
      }
    }
  }

  Widget _buildLogo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Stylized leaf/flame logo with gradient
        // Container(
        //   width: 80,
        //   height: 100,
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(20),
        //     gradient: const LinearGradient(
        //       begin: Alignment.centerLeft,
        //       end: Alignment.centerRight,
        //       colors: [teal, orange],
        //     ),
        //     boxShadow: [
        //       BoxShadow(
        //         color: Colors.black.withOpacity(0.2),
        //         blurRadius: 10,
        //         offset: const Offset(0, 5),
        //       ),
        //     ],
        //   ),
        //   child: CustomPaint(
        //     painter: _LogoPainter(),
        //   ),
        // ),
        const SizedBox(height: 24),
        Image.asset(
          'assets/Opulent Prime Properties logo-03.png',
          height: 120,
          width: 350,
          fit: BoxFit.contain,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1F3A), // Dark navy blue background
        ),
        child: BlocListener<AuthBloc, AuthState>(
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
                color: Colors.transparent,
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
                color: Colors.transparent,
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
                          Text(
                            _isCreatingAccount
                                ? 'CREATE ADMIN ACCOUNT'
                                : 'PLEASE LOGIN TO ADMIN DASHBOARD.',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 40),
                          // Toggle between login and create account
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.all(4),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildToggleButton(
                                  'Login',
                                  !_isCreatingAccount,
                                  () {
                                    setState(() {
                                      _isCreatingAccount = false;
                                    });
                                  },
                                ),
                                _buildToggleButton(
                                  'Create Account',
                                  _isCreatingAccount,
                                  () {
                                    setState(() {
                                      _isCreatingAccount = true;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          // Name field (only shown when creating account)
                          if (_isCreatingAccount) ...[
                            TextFormField(
                              controller: _nameController,
                              style: const TextStyle(color: Colors.black87),
                              decoration: InputDecoration(
                                hintText: 'FULL NAME',
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
                              validator: (value) => Validators.required(value, fieldName: 'Name'),
                            ),
                            const SizedBox(height: 20),
                          ],
                          // Email field
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
                          // Login/Create Account button
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
                                      ? const CompactLoadingIndicator(
                                          size: 20,
                                          color: Colors.white,
                                        )
                                      : Text(
                                          _isCreatingAccount ? 'CREATE ACCOUNT' : 'LOGIN',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),
                          if (!_isCreatingAccount) ...[
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
    ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? orange : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            letterSpacing: 1.0,
          ),
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

