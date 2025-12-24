import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opulent_prime_properties/core/constants/app_constants.dart';
import 'package:opulent_prime_properties/features/admin/opportunities/data/repositories/opportunities_repository_impl.dart';
import 'package:opulent_prime_properties/features/admin/opportunities/data/repositories/areas_repository_impl.dart';
import 'package:opulent_prime_properties/features/admin/categories/data/repositories/categories_repository_impl.dart';
import 'package:opulent_prime_properties/shared/models/opportunity_model.dart';
import 'package:opulent_prime_properties/shared/models/category_model.dart';
import 'package:opulent_prime_properties/shared/models/area_model.dart';

class OpportunityFormPage extends StatefulWidget {
  final String? opportunityId;
  
  const OpportunityFormPage({super.key, this.opportunityId});

  @override
  State<OpportunityFormPage> createState() => _OpportunityFormPageState();
}

class _OpportunityFormPageState extends State<OpportunityFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _featuresController = TextEditingController();
  
  final _opportunitiesRepo = OpportunitiesRepository();
  final _categoriesRepo = CategoriesRepository();
  final _areasRepo = AreasRepository();
  
  String? _selectedCategoryId;
  String? _selectedAreaId;
  String _status = AppConstants.opportunityStatusActive;
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.opportunityId != null) {
      _loadOpportunity();
    }
  }

  Future<void> _loadOpportunity() async {
    setState(() => _isLoading = true);
    try {
      final opportunity = await _opportunitiesRepo.getOpportunity(widget.opportunityId!);
      if (opportunity != null) {
        _titleController.text = opportunity.title;
        _descriptionController.text = opportunity.description;
        _priceController.text = opportunity.price.toString();
        _selectedCategoryId = opportunity.categoryId;
        _selectedAreaId = opportunity.areaId;
        _status = opportunity.status;
        _featuresController.text = opportunity.features.join(', ');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading opportunity: $e')),
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
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _featuresController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }
    
    if (_selectedAreaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an area')),
      );
      return;
    }

    setState(() => _isSaving = true);
    
    try {
      final now = DateTime.now();
      final features = _featuresController.text
          .split(',')
          .map((f) => f.trim())
          .where((f) => f.isNotEmpty)
          .toList();
      
      if (widget.opportunityId == null) {
        // Create new opportunity
        final docRef = FirebaseFirestore.instance
            .collection(AppConstants.opportunitiesCollection)
            .doc();
        
        final opportunity = OpportunityModel(
          opportunityId: docRef.id,
          title: _titleController.text,
          description: _descriptionController.text,
          categoryId: _selectedCategoryId!,
          areaId: _selectedAreaId!,
          price: double.tryParse(_priceController.text) ?? 0,
          images: [], // TODO: Add image upload
          features: features,
          status: _status,
          createdAt: now,
          updatedAt: now,
        );
        
        await _opportunitiesRepo.createOpportunity(opportunity);
      } else {
        // Update existing opportunity - need to load existing to preserve createdAt
        final existing = await _opportunitiesRepo.getOpportunity(widget.opportunityId!);
        if (existing == null) {
          throw Exception('Opportunity not found');
        }
        
        final opportunity = OpportunityModel(
          opportunityId: widget.opportunityId!,
          title: _titleController.text,
          description: _descriptionController.text,
          categoryId: _selectedCategoryId!,
          areaId: _selectedAreaId!,
          price: double.tryParse(_priceController.text) ?? 0,
          images: existing.images, // Keep existing images
          features: features,
          status: _status,
          createdAt: existing.createdAt, // Keep original createdAt
          updatedAt: now,
        );
        
        await _opportunitiesRepo.updateOpportunity(opportunity);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.opportunityId == null
                ? 'Opportunity created successfully'
                : 'Opportunity updated successfully'),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving opportunity: $e')),
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
        title: Text(widget.opportunityId == null ? 'New Opportunity' : 'Edit Opportunity'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Title is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Description is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            StreamBuilder<List<CategoryModel>>(
              stream: _categoriesRepo.getCategories(),
              builder: (context, snapshot) {
                final categories = snapshot.data ?? [];
                return DropdownButtonFormField<String>(
                  value: _selectedCategoryId,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category.categoryId,
                      child: Text(category.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedCategoryId = value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Category is required';
                    }
                    return null;
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            StreamBuilder<List<AreaModel>>(
              stream: _areasRepo.getAreas(),
              builder: (context, snapshot) {
                final areas = snapshot.data ?? [];
                return DropdownButtonFormField<String>(
                  value: _selectedAreaId,
                  decoration: const InputDecoration(
                    labelText: 'Area',
                    border: OutlineInputBorder(),
                  ),
                  items: areas.map((area) {
                    return DropdownMenuItem<String>(
                      value: area.areaId,
                      child: Text(area.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedAreaId = value);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Area is required';
                    }
                    return null;
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Price (AED)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Price is required';
                }
                if (double.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _featuresController,
              decoration: const InputDecoration(
                labelText: 'Features (comma separated)',
                hintText: 'e.g., 3 Bedrooms, 2 Bathrooms, Parking',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem<String>(
                  value: AppConstants.opportunityStatusActive,
                  child: const Text('Active'),
                ),
                DropdownMenuItem<String>(
                  value: AppConstants.opportunityStatusInactive,
                  child: const Text('Inactive'),
                ),
              ],
              onChanged: (value) {
                setState(() => _status = value ?? AppConstants.opportunityStatusActive);
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

