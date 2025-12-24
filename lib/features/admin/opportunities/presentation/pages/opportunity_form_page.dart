import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opulent_prime_properties/core/constants/app_constants.dart';
import 'package:opulent_prime_properties/core/services/storage_service.dart';
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
  final _areaController = TextEditingController();
  
  final _opportunitiesRepo = OpportunitiesRepository();
  final _categoriesRepo = CategoriesRepository();
  final _areasRepo = AreasRepository();
  
  String? _selectedCategoryId;
  String? _selectedAreaId;
  String _areaName = '';
  String _status = AppConstants.opportunityStatusActive;
  bool _isLoading = false;
  bool _isSaving = false;
  
  // Image management
  final List<XFile> _newImages = []; // New images to upload
  final List<String> _existingImageUrls = []; // Existing image URLs from server
  final ImagePicker _imagePicker = ImagePicker();

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
        _existingImageUrls.clear();
        _existingImageUrls.addAll(opportunity.images);
        _newImages.clear();
        
        // Load area name if editing
        if (opportunity.areaId.isNotEmpty) {
          try {
            final areas = await _areasRepo.getAreasOnce();
            final area = areas.firstWhere(
              (a) => a.areaId == opportunity.areaId,
              orElse: () => AreaModel(areaId: '', name: '', isActive: true),
            );
            _areaController.text = area.name;
            _areaName = area.name;
          } catch (e) {
            // Area not found, leave empty
          }
        }
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
    _areaController.dispose();
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
    
    if (_areaController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an area name')),
      );
      return;
    }

    setState(() => _isSaving = true);
    
    try {
      print('OpportunityForm: Starting save process...');
      final now = DateTime.now();
      final features = _featuresController.text
          .split(',')
          .map((f) => f.trim())
          .where((f) => f.isNotEmpty)
          .toList();
      
      print('OpportunityForm: Creating/getting area...');
      // Create or get area
      final area = await _areasRepo.createArea(_areaController.text.trim());
      final areaId = area.areaId;
      print('OpportunityForm: Area ID: $areaId');
      
      // Determine opportunity ID (new or existing)
      final String opportunityId;
      if (widget.opportunityId == null) {
        final docRef = FirebaseFirestore.instance
            .collection(AppConstants.opportunitiesCollection)
            .doc();
        opportunityId = docRef.id;
        print('OpportunityForm: New opportunity ID: $opportunityId');
      } else {
        opportunityId = widget.opportunityId!;
        print('OpportunityForm: Existing opportunity ID: $opportunityId');
      }
      
      // Upload new images
      List<String> imageUrls = List<String>.from(_existingImageUrls);
      if (_newImages.isNotEmpty) {
        print('OpportunityForm: Uploading ${_newImages.length} images...');
        try {
          final uploadedUrls = await StorageService.uploadOpportunityImages(
            _newImages,
            opportunityId,
          );
          print('OpportunityForm: Successfully uploaded ${uploadedUrls.length} images');
          imageUrls.addAll(uploadedUrls);
        } catch (uploadError) {
          print('OpportunityForm: Image upload error: $uploadError');
          print('OpportunityForm: Error type: ${uploadError.runtimeType}');
          if (mounted) {
            setState(() => _isSaving = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error uploading images: $uploadError'),
                duration: const Duration(seconds: 5),
              ),
            );
          }
          return;
        }
      } else {
        print('OpportunityForm: No new images to upload');
      }
      
      print('OpportunityForm: Total image URLs: ${imageUrls.length}');
      
      print('OpportunityForm: Saving opportunity to Firestore...');
      if (widget.opportunityId == null) {
        // Create new opportunity
        final opportunity = OpportunityModel(
          opportunityId: opportunityId,
          title: _titleController.text,
          description: _descriptionController.text,
          categoryId: _selectedCategoryId!,
          areaId: areaId,
          price: double.tryParse(_priceController.text) ?? 0,
          images: imageUrls,
          features: features,
          status: _status,
          createdAt: now,
          updatedAt: now,
        );
        
        print('OpportunityForm: Creating opportunity in Firestore...');
        await _opportunitiesRepo.createOpportunity(opportunity);
        print('OpportunityForm: Opportunity created successfully');
      } else {
        // Update existing opportunity - need to load existing to preserve createdAt
        print('OpportunityForm: Loading existing opportunity...');
        final existing = await _opportunitiesRepo.getOpportunity(widget.opportunityId!);
        if (existing == null) {
          throw Exception('Opportunity not found');
        }
        
        final opportunity = OpportunityModel(
          opportunityId: widget.opportunityId!,
          title: _titleController.text,
          description: _descriptionController.text,
          categoryId: _selectedCategoryId!,
          areaId: areaId,
          price: double.tryParse(_priceController.text) ?? 0,
          images: imageUrls,
          features: features,
          status: _status,
          createdAt: existing.createdAt, // Keep original createdAt
          updatedAt: now,
        );
        
        print('OpportunityForm: Updating opportunity in Firestore...');
        await _opportunitiesRepo.updateOpportunity(opportunity);
        print('OpportunityForm: Opportunity updated successfully');
      }

      if (mounted) {
        print('OpportunityForm: Save completed successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.opportunityId == null
                ? 'Opportunity created successfully'
                : 'Opportunity updated successfully'),
          ),
        );
        context.pop();
      }
    } catch (e, stackTrace) {
      print('OpportunityForm: Error in save process: $e');
      print('OpportunityForm: Stack trace: $stackTrace');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving opportunity: $e'),
            duration: const Duration(seconds: 5),
          ),
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
            Autocomplete<AreaModel>(
              displayStringForOption: (area) => area.name,
              optionsBuilder: (textEditingValue) async {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<AreaModel>.empty();
                }
                
                final areas = await _areasRepo.getAreasOnce();
                return areas.where((area) {
                  return area.name
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (area) {
                _areaController.text = area.name;
                _selectedAreaId = area.areaId;
                _areaName = area.name;
              },
              fieldViewBuilder: (
                context,
                textEditingController,
                focusNode,
                onFieldSubmitted,
              ) {
                // Sync controller with our controller
                if (_areaController.text != textEditingController.text) {
                  textEditingController.text = _areaController.text;
                }
                
                return TextFormField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    labelText: 'Area (Type to search or add new)',
                    hintText: 'e.g., Dubai Marina, Downtown Dubai',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.location_on),
                  ),
                  onChanged: (value) {
                    _areaController.text = value;
                    _areaName = value;
                    _selectedAreaId = null; // Clear selection when typing
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
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
            // Images Section
            const Text(
              'Photos',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildImagesSection(),
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

  Widget _buildImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display existing and new images
        if (_existingImageUrls.isNotEmpty || _newImages.isNotEmpty)
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _existingImageUrls.length + _newImages.length,
              itemBuilder: (context, index) {
                if (index < _existingImageUrls.length) {
                  // Existing image from server
                  return _buildImageItem(
                    imageUrl: _existingImageUrls[index],
                    isExisting: true,
                    index: index,
                  );
                } else {
                  // New image from picker
                  final newIndex = index - _existingImageUrls.length;
                  return _buildImageItem(
                    imageFile: _newImages[newIndex],
                    isExisting: false,
                    index: newIndex,
                  );
                }
              },
            ),
          ),
        const SizedBox(height: 8),
        // Add image button
        ElevatedButton.icon(
          onPressed: _pickImages,
          icon: const Icon(Icons.add_photo_alternate),
          label: const Text('Add Photos'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildImageItem({
    String? imageUrl,
    XFile? imageFile,
    required bool isExisting,
    required int index,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: isExisting && imageUrl != null
                ? Image.network(
                    imageUrl,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(Icons.broken_image, size: 40),
                      );
                    },
                  )
                : imageFile != null
                    ? kIsWeb
                        ? FutureBuilder<Uint8List>(
                            future: imageFile.readAsBytes(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Image.memory(
                                  snapshot.data!,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                );
                              }
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          )
                        : Image.file(
                            File(imageFile.path),
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                          )
                    : const Center(
                        child: Icon(Icons.image, size: 40),
                      ),
          ),
          Positioned(
            top: 4,
            right: 4,
            child: Material(
              color: Colors.red,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => _removeImage(index, isExisting),
                child: const Padding(
                  padding: EdgeInsets.all(4),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> pickedFiles = await _imagePicker.pickMultiImage();
      
      if (pickedFiles.isNotEmpty) {
        setState(() {
          _newImages.addAll(pickedFiles);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking images: $e')),
        );
      }
    }
  }

  void _removeImage(int index, bool isExisting) {
    setState(() {
      if (isExisting) {
        _existingImageUrls.removeAt(index);
      } else {
        _newImages.removeAt(index);
      }
    });
  }
}

