import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opulent_prime_properties/core/constants/app_constants.dart';
import 'package:opulent_prime_properties/core/utils/validators.dart';
import 'package:opulent_prime_properties/features/admin/consultants/data/repositories/consultants_repository_impl.dart';
import 'package:opulent_prime_properties/shared/models/consultant_model.dart';

class ConsultantFormPage extends StatefulWidget {
  final String? consultantId;
  
  const ConsultantFormPage({super.key, this.consultantId});

  @override
  State<ConsultantFormPage> createState() => _ConsultantFormPageState();
}

class _ConsultantFormPageState extends State<ConsultantFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  
  final _repository = ConsultantsRepository();
  bool _isActive = true;
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.consultantId != null) {
      _loadConsultant();
    }
  }

  Future<void> _loadConsultant() async {
    setState(() => _isLoading = true);
    try {
      final consultants = await _repository.getConsultantsOnce();
      final consultant = consultants.firstWhere((c) => c.consultantId == widget.consultantId);
      _nameController.text = consultant.name;
      _emailController.text = consultant.email;
      _phoneController.text = consultant.phone;
      _isActive = consultant.isActive;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading consultant: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    
    try {
      if (widget.consultantId == null) {
        // Create new consultant
        final docRef = FirebaseFirestore.instance
            .collection(AppConstants.consultantsCollection)
            .doc();
        
        final consultant = ConsultantModel(
          consultantId: docRef.id,
          name: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          isActive: _isActive,
        );
        
        await _repository.createConsultant(consultant);
      } else {
        // Update existing consultant
        final consultant = ConsultantModel(
          consultantId: widget.consultantId!,
          name: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          isActive: _isActive,
        );
        
        await _repository.updateConsultant(consultant);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.consultantId == null
                ? 'Consultant created successfully'
                : 'Consultant updated successfully'),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving consultant: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.consultantId == null ? 'New Consultant' : 'Edit Consultant'),
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
                border: OutlineInputBorder(),
              ),
              validator: (value) => Validators.required(value, fieldName: 'Name'),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: Validators.email,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: Validators.phone,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Active'),
              subtitle: const Text('Consultant will be available if active'),
              value: _isActive,
              onChanged: (value) {
                setState(() => _isActive = value);
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const CircularProgressIndicator()
                    : const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

