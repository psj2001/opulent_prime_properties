import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:opulent_prime_properties/core/constants/app_constants.dart';
import 'package:opulent_prime_properties/core/constants/route_names.dart';
import 'package:opulent_prime_properties/core/theme/app_theme.dart';
import 'package:opulent_prime_properties/core/utils/date_formatter.dart';
import 'package:opulent_prime_properties/features/admin/opportunities/data/repositories/opportunities_repository_impl.dart';
import 'package:opulent_prime_properties/features/admin/leads/data/repositories/leads_repository_impl.dart';
import 'package:opulent_prime_properties/features/admin/consultants/data/repositories/consultants_repository_impl.dart';
import 'package:opulent_prime_properties/features/consultation/data/repositories/consultation_repository_impl.dart';
import 'package:opulent_prime_properties/shared/models/lead_model.dart';
import 'package:opulent_prime_properties/shared/models/consultation_model.dart';
import 'package:opulent_prime_properties/shared/models/opportunity_model.dart';
import 'package:opulent_prime_properties/shared/models/consultant_model.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  final OpportunitiesRepository _opportunitiesRepo = OpportunitiesRepository();
  final LeadsRepository _leadsRepo = LeadsRepository();
  final ConsultantsRepository _consultantsRepo = ConsultantsRepository();
  final ConsultationRepository _consultationRepo = ConsultationRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push(RouteNames.adminSettings),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeader(),
              const SizedBox(height: 24),

              // KPI Cards Grid
              _buildKPICards(),
              const SizedBox(height: 24),

              // Status Breakdown Section
              _buildStatusBreakdown(),
              const SizedBox(height: 24),

              // Recent Leads Section
              _buildRecentLeads(),
              const SizedBox(height: 24),

              // Quick Actions Section
              _buildQuickActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome Back!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    DateFormatter.formatDate(DateTime.now()),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.dashboard,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKPICards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 800 ? 4 : 2;
            return StreamBuilder<List<LeadModel>>(
              stream: _leadsRepo.getLeads(),
              builder: (context, leadsSnapshot) {
                return StreamBuilder<List<OpportunityModel>>(
                  stream: _opportunitiesRepo.getOpportunities(),
                  builder: (context, opportunitiesSnapshot) {
                    return StreamBuilder<List<ConsultationModel>>(
                      stream: _consultationRepo.getAllConsultations(),
                      builder: (context, consultationsSnapshot) {
                        final leadsCount = leadsSnapshot.data?.length ?? 0;
                        final opportunitiesCount = opportunitiesSnapshot.data?.length ?? 0;
                        final consultationsCount = consultationsSnapshot.data?.length ?? 0;
                        
                        // Get new leads count (last 7 days)
                        final newLeadsCount = leadsSnapshot.data
                            ?.where((lead) => lead.createdAt.isAfter(
                                  DateTime.now().subtract(const Duration(days: 7)),
                                ))
                            .length ?? 0;

                        return GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.3,
                          children: [
                            _StatCard(
                              title: 'Total Opportunities',
                              value: opportunitiesCount.toString(),
                              icon: Icons.home_work,
                              color: AppTheme.primaryColor,
                              onTap: () => context.push(RouteNames.adminOpportunities),
                            ),
                            _StatCard(
                              title: 'Total Leads',
                              value: leadsCount.toString(),
                              icon: Icons.people,
                              color: AppTheme.successColor,
                              onTap: () => context.push(RouteNames.adminLeads),
                              subtitle: '$newLeadsCount new this week',
                            ),
                            _StatCard(
                              title: 'Consultations',
                              value: consultationsCount.toString(),
                              icon: Icons.event_note,
                              color: AppTheme.secondaryColor,
                              onTap: () => context.push(RouteNames.adminLeads),
                            ),
                            StreamBuilder<List<ConsultantModel>>(
                              stream: _consultantsRepo.getConsultants(),
                              builder: (context, snapshot) {
                                final consultantsCount = snapshot.data?.length ?? 0;
                                return _StatCard(
                                  title: 'Consultants',
                                  value: consultantsCount.toString(),
                                  icon: Icons.person,
                                  color: AppTheme.accentColor,
                                  onTap: () => context.push(RouteNames.adminConsultants),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatusBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lead Status Overview',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        StreamBuilder<List<LeadModel>>(
          stream: _leadsRepo.getLeads(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final leads = snapshot.data ?? [];
            final statusCounts = <String, int>{
              AppConstants.leadStatusNew: 0,
              AppConstants.leadStatusContacted: 0,
              AppConstants.leadStatusQualified: 0,
              AppConstants.leadStatusWon: 0,
              AppConstants.leadStatusLost: 0,
            };

            for (var lead in leads) {
              statusCounts[lead.status] = (statusCounts[lead.status] ?? 0) + 1;
            }

            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _StatusItem(
                    label: 'New',
                    count: statusCounts[AppConstants.leadStatusNew]!,
                    color: Colors.blue,
                    icon: Icons.fiber_new,
                  ),
                  const Divider(),
                  _StatusItem(
                    label: 'Contacted',
                    count: statusCounts[AppConstants.leadStatusContacted]!,
                    color: Colors.orange,
                    icon: Icons.phone,
                  ),
                  const Divider(),
                  _StatusItem(
                    label: 'Qualified',
                    count: statusCounts[AppConstants.leadStatusQualified]!,
                    color: Colors.purple,
                    icon: Icons.verified,
                  ),
                  const Divider(),
                  _StatusItem(
                    label: 'Won',
                    count: statusCounts[AppConstants.leadStatusWon]!,
                    color: AppTheme.successColor,
                    icon: Icons.check_circle,
                  ),
                  const Divider(),
                  _StatusItem(
                    label: 'Lost',
                    count: statusCounts[AppConstants.leadStatusLost]!,
                    color: AppTheme.errorColor,
                    icon: Icons.cancel,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentLeads() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Leads',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () => context.push(RouteNames.adminLeads),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        StreamBuilder<List<LeadModel>>(
          stream: _leadsRepo.getLeads(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            final leads = snapshot.data ?? [];
            if (leads.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text('No leads yet'),
                ),
              );
            }

            final recentLeads = leads.take(5).toList();

            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: recentLeads.asMap().entries.map((entry) {
                  final index = entry.key;
                  final lead = entry.value;
                  return Column(
                    children: [
                      _RecentLeadItem(
                        lead: lead,
                        onTap: () {
                          context.push('${RouteNames.adminLeadDetail}/${lead.leadId}');
                        },
                      ),
                      if (index < recentLeads.length - 1) const Divider(height: 1),
                    ],
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 2.5,
          children: [
            _QuickActionCard(
              title: 'Add Opportunity',
              icon: Icons.add_business,
              color: AppTheme.primaryColor,
              onTap: () => context.push(RouteNames.adminOpportunityNew),
            ),
            _QuickActionCard(
              title: 'Manage Categories',
              icon: Icons.category,
              color: AppTheme.secondaryColor,
              onTap: () => context.push(RouteNames.adminCategories),
            ),
            _QuickActionCard(
              title: 'Manage Consultants',
              icon: Icons.person_add,
              color: AppTheme.accentColor,
              onTap: () => context.push(RouteNames.adminConsultants),
            ),
            _QuickActionCard(
              title: 'View All Leads',
              icon: Icons.list_alt,
              color: AppTheme.successColor,
              onTap: () => context.push(RouteNames.adminLeads),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String? subtitle;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        color: color.withOpacity(0.7),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final IconData icon;

  const _StatusItem({
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentLeadItem extends StatelessWidget {
  final LeadModel lead;
  final VoidCallback onTap;

  const _RecentLeadItem({
    required this.lead,
    required this.onTap,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case AppConstants.leadStatusNew:
        return Colors.blue;
      case AppConstants.leadStatusContacted:
        return Colors.orange;
      case AppConstants.leadStatusQualified:
        return Colors.purple;
      case AppConstants.leadStatusWon:
        return AppTheme.successColor;
      case AppConstants.leadStatusLost:
        return AppTheme.errorColor;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getStatusColor(lead.status).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.person,
                color: _getStatusColor(lead.status),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lead #${lead.leadId.substring(0, 8)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.label_outline,
                        size: 14,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        lead.status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          color: _getStatusColor(lead.status),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormatter.formatDate(lead.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppTheme.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: color),
            ],
          ),
        ),
      ),
    );
  }
}