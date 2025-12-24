import 'package:flutter/material.dart';
import 'package:opulent_prime_properties/core/constants/app_constants.dart';
import 'package:opulent_prime_properties/core/theme/app_theme.dart';
import 'package:opulent_prime_properties/features/admin/leads/data/repositories/leads_repository_impl.dart';
import 'package:opulent_prime_properties/features/admin/consultants/data/repositories/consultants_repository_impl.dart';
import 'package:opulent_prime_properties/shared/models/lead_model.dart';
import 'package:opulent_prime_properties/shared/models/consultant_model.dart';
import 'package:opulent_prime_properties/shared/models/user_model.dart';

class LeadDetailPage extends StatefulWidget {
  final String leadId;
  
  const LeadDetailPage({super.key, required this.leadId});

  @override
  State<LeadDetailPage> createState() => _LeadDetailPageState();
}

class _LeadDetailPageState extends State<LeadDetailPage> {
  final LeadsRepository _leadsRepository = LeadsRepository();
  final ConsultantsRepository _consultantsRepository = ConsultantsRepository();
  
  LeadModel? _lead;
  UserModel? _user;
  List<ConsultantModel> _consultants = [];
  String? _selectedStatus;
  String? _selectedConsultantId;
  final TextEditingController _notesController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    // Load lead data
    final lead = await _leadsRepository.getLead(widget.leadId);
    if (lead != null) {
      setState(() {
        _lead = lead;
        _selectedStatus = lead.status;
        _selectedConsultantId = lead.consultantId;
        _notesController.text = lead.notes ?? '';
      });
      
      // Load user data
      final user = await _leadsRepository.getUser(lead.userId);
      if (mounted) {
        setState(() {
          _user = user;
        });
      }
    }

    // Load consultants
    final consultants = await _consultantsRepository.getConsultantsOnce();
    if (mounted) {
      setState(() {
        _consultants = consultants.where((c) => c.isActive).toList();
      });
    }
  }

  Future<void> _updateStatus(String? newStatus) async {
    if (newStatus == null || newStatus == _selectedStatus) return;
    
    setState(() {
      _isSaving = true;
      _selectedStatus = newStatus;
    });

    try {
      await _leadsRepository.updateLeadStatus(widget.leadId, newStatus);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Status updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating status: $e')),
        );
        // Revert on error
        setState(() {
          _selectedStatus = _lead?.status;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _updateConsultant(String? consultantId) async {
    if (consultantId == _selectedConsultantId) return;
    
    setState(() {
      _isSaving = true;
      _selectedConsultantId = consultantId;
    });

    try {
      await _leadsRepository.updateLeadConsultant(widget.leadId, consultantId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Consultant assigned successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error assigning consultant: $e')),
        );
        // Revert on error
        setState(() {
          _selectedConsultantId = _lead?.consultantId;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _saveNotes() async {
    try {
      await _leadsRepository.updateLeadNotes(
        widget.leadId,
        _notesController.text.isEmpty ? null : _notesController.text,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notes saved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving notes: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_lead == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Lead Details'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lead Details'),
      ),
      body: _isSaving
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Contact Information',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _InfoRow(
                          label: 'Name',
                          value: _user?.name ?? 'Loading...',
                        ),
                        _InfoRow(
                          label: 'Email',
                          value: _user?.email ?? 'Loading...',
                        ),
                        _InfoRow(
                          label: 'Phone',
                          value: _user?.phone ?? 'N/A',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Lead Status',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedStatus,
                          decoration: const InputDecoration(
                            labelText: 'Status',
                          ),
                          items: [
                            AppConstants.leadStatusNew,
                            AppConstants.leadStatusContacted,
                            AppConstants.leadStatusQualified,
                            AppConstants.leadStatusWon,
                            AppConstants.leadStatusLost,
                          ].map((status) {
                            return DropdownMenuItem(
                              value: status,
                              child: Text(status.toUpperCase()),
                            );
                          }).toList(),
                          onChanged: _updateStatus,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Assign Consultant',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedConsultantId,
                          decoration: const InputDecoration(
                            labelText: 'Consultant',
                          ),
                          items: [
                            const DropdownMenuItem<String>(
                              value: null,
                              child: Text('None'),
                            ),
                            ..._consultants.map((consultant) {
                              return DropdownMenuItem(
                                value: consultant.consultantId,
                                child: Text(consultant.name),
                              );
                            }),
                          ],
                          onChanged: _updateConsultant,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Notes',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _notesController,
                          decoration: const InputDecoration(
                            hintText: 'Add notes...',
                          ),
                          maxLines: 5,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveNotes,
                    child: const Text('Save Notes'),
                  ),
                ),
              ],
            ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
