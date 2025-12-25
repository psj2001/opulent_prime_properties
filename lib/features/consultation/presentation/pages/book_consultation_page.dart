import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:opulent_prime_properties/core/constants/app_constants.dart';
import 'package:opulent_prime_properties/core/constants/route_names.dart';
import 'package:opulent_prime_properties/core/firebase/firebase_config.dart';
import 'package:opulent_prime_properties/core/utils/validators.dart';
import 'package:opulent_prime_properties/core/widgets/loading_widget.dart';
import 'package:opulent_prime_properties/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:opulent_prime_properties/features/consultation/data/repositories/consultation_repository_impl.dart';
import 'package:opulent_prime_properties/shared/models/consultation_model.dart';

class BookConsultationPage extends StatefulWidget {
  final String? opportunityId;
  
  const BookConsultationPage({super.key, this.opportunityId});

  @override
  State<BookConsultationPage> createState() => _BookConsultationPageState();
}

class _BookConsultationPageState extends State<BookConsultationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _consultationRepository = ConsultationRepository();
  bool _isLoading = false;
  DateTime? _selectedDate;
  String? _selectedTime;
  bool _userDataLoaded = false;

  final List<String> _timeSlots = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    if (_userDataLoaded) return;
    
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      final user = authState.user;
      _nameController.text = user.name;
      _emailController.text = user.email;
      if (user.phone != null) {
        _phoneController.text = user.phone!;
      }
      _userDataLoaded = true;
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _showAuthDialog() async {
    if (!mounted) return;
    
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Account Required'),
        content: const Text(
          'You need an account to book a consultation. Would you like to create an account or login?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'signup'),
            child: const Text('Sign Up'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'login'),
            child: const Text('Login'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'cancel'),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (result == 'signup') {
      if (mounted) {
        context.push(RouteNames.signup);
      }
    } else if (result == 'login') {
      if (mounted) {
        context.push(RouteNames.login);
      }
    }
  }


  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    // Check if user is authenticated
    final authState = context.read<AuthBloc>().state;
    String? userId;
    
    if (authState is AuthAuthenticated) {
      userId = authState.user.userId;
    } else {
      // If not authenticated, try to get current user from Firebase Auth
      final currentUser = FirebaseConfig.auth.currentUser;
      if (currentUser == null) {
        // Show dialog with options to login/signup
        if (mounted) {
          await _showAuthDialog();
        }
        return;
      }
      userId = currentUser.uid;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Create consultation model
      final consultation = ConsultationModel(
        consultationId: '', // Will be set by Firestore
        userId: userId!,
        opportunityId: widget.opportunityId,
        preferredDate: _selectedDate!,
        preferredTime: _selectedTime!,
        status: AppConstants.consultationStatusPending,
        createdAt: DateTime.now(),
      );

      // Save consultation to Firestore
      await _consultationRepository.createConsultation(consultation);

      if (mounted) {
        // Navigate to confirmation page
        context.push(RouteNames.bookingConfirmation);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error booking consultation: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Consultation'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) => Validators.required(value, fieldName: 'Name'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              validator: Validators.phone,
            ),
            const SizedBox(height: 24),
            const Text(
              'Preferred Date',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            InkWell(
              onTap: _selectDate,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 12),
                    Text(
                      _selectedDate == null
                          ? 'Select Date'
                          : DateFormat('MMM dd, yyyy').format(_selectedDate!),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Preferred Time',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _timeSlots.map((time) {
                final isSelected = _selectedTime == time;
                return ChoiceChip(
                  label: Text(time),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedTime = selected ? time : null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const CompactLoadingIndicator(
                        size: 20,
                        color: Colors.white,
                      )
                    : const Text('Book Consultation'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

