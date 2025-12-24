import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opulent_prime_properties/core/constants/app_constants.dart';
import 'package:opulent_prime_properties/features/admin/categories/data/repositories/categories_repository_impl.dart';
import 'package:opulent_prime_properties/shared/models/category_model.dart';

class CategoryFormPage extends StatefulWidget {
  final String? categoryId;
  
  const CategoryFormPage({super.key, this.categoryId});

  @override
  State<CategoryFormPage> createState() => _CategoryFormPageState();
}

class _CategoryFormPageState extends State<CategoryFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _iconController = TextEditingController();
  final _orderController = TextEditingController();
  
  final _repository = CategoriesRepository();
  bool _isActive = true;
  bool _isLoading = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.categoryId != null) {
      _loadCategory();
    } else {
      _orderController.text = '0';
    }
  }

  Future<void> _loadCategory() async {
    setState(() => _isLoading = true);
    try {
      final categories = await _repository.getCategoriesOnce();
      final category = categories.firstWhere((c) => c.categoryId == widget.categoryId);
      _nameController.text = category.name;
      _iconController.text = category.icon;
      _orderController.text = category.order.toString();
      _isActive = category.isActive;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading category: $e')),
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
    _iconController.dispose();
    _orderController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    
    try {
      final category = CategoryModel(
        categoryId: widget.categoryId ?? '',
        name: _nameController.text,
        icon: _iconController.text,
        order: int.tryParse(_orderController.text) ?? 0,
        isActive: _isActive,
      );

      if (widget.categoryId == null) {
        // Create new category
        final docRef = FirebaseFirestore.instance
            .collection(AppConstants.categoriesCollection)
            .doc();
        final newCategory = CategoryModel(
          categoryId: docRef.id,
          name: category.name,
          icon: category.icon,
          order: category.order,
          isActive: category.isActive,
        );
        await _repository.createCategory(newCategory);
      } else {
        // Update existing category
        final updatedCategory = CategoryModel(
          categoryId: widget.categoryId!,
          name: category.name,
          icon: category.icon,
          order: category.order,
          isActive: category.isActive,
        );
        await _repository.updateCategory(updatedCategory);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.categoryId == null
                ? 'Category created successfully'
                : 'Category updated successfully'),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving category: $e')),
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
        title: Text(widget.categoryId == null ? 'New Category' : 'Edit Category'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Category Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _iconController,
              decoration: const InputDecoration(
                labelText: 'Icon (icon name or emoji)',
                hintText: 'e.g., apartment, home, 🏠',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Icon is required';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _orderController,
              decoration: const InputDecoration(
                labelText: 'Display Order',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Order is required';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Active'),
              subtitle: const Text('Category will be visible if active'),
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

