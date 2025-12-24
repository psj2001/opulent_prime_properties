import 'package:flutter/material.dart';
import 'package:opulent_prime_properties/features/admin/consultants/data/repositories/consultants_repository_impl.dart';
import 'package:opulent_prime_properties/features/admin/consultants/presentation/pages/consultant_form_page.dart';
import 'package:opulent_prime_properties/shared/models/consultant_model.dart';

class ConsultantsPage extends StatelessWidget {
  const ConsultantsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = ConsultantsRepository();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consultants'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConsultantFormPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<ConsultantModel>>(
        stream: repository.getConsultants(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          
          final consultants = snapshot.data ?? [];
          
          if (consultants.isEmpty) {
            return const Center(
              child: Text('No consultants found'),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: consultants.length,
            itemBuilder: (context, index) {
              final consultant = consultants[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: consultant.isActive
                        ? Colors.blue.shade100
                        : Colors.grey.shade300,
                    child: Icon(
                      Icons.person,
                      color: consultant.isActive
                          ? Colors.blue.shade700
                          : Colors.grey.shade700,
                    ),
                  ),
                  title: Text(consultant.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(consultant.email),
                      Text(consultant.phone),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: consultant.isActive
                              ? Colors.green.shade100
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          consultant.isActive ? 'Active' : 'Inactive',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: consultant.isActive
                                ? Colors.green.shade700
                                : Colors.grey.shade700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ConsultantFormPage(
                                consultantId: consultant.consultantId,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Consultant'),
                              content: Text('Are you sure you want to delete ${consultant.name}?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true) {
                            try {
                              await repository.deleteConsultant(consultant.consultantId);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Consultant deleted')),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error deleting consultant: $e')),
                                );
                              }
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

