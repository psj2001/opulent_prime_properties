import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:opulent_prime_properties/core/constants/route_names.dart';
import 'package:opulent_prime_properties/core/firebase/firebase_config.dart';
import 'package:opulent_prime_properties/core/theme/app_theme.dart';
import 'package:opulent_prime_properties/features/admin/opportunities/data/repositories/opportunities_repository_impl.dart';
import 'package:opulent_prime_properties/features/admin/opportunities/data/repositories/areas_repository_impl.dart';
import 'package:opulent_prime_properties/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:opulent_prime_properties/features/shortlist/data/repositories/shortlist_repository_impl.dart';
import 'package:opulent_prime_properties/shared/models/opportunity_model.dart';

class OpportunityDetailPage extends StatefulWidget {
  final String opportunityId;
  
  const OpportunityDetailPage({super.key, required this.opportunityId});

  @override
  State<OpportunityDetailPage> createState() => _OpportunityDetailPageState();
}

class _OpportunityDetailPageState extends State<OpportunityDetailPage> {
  final _shortlistRepo = ShortlistRepository();
  bool _isInShortlist = false;
  bool _isLoadingShortlist = false;

  @override
  void initState() {
    super.initState();
    _checkShortlistStatus();
  }

  Future<void> _checkShortlistStatus() async {
    final user = FirebaseConfig.auth.currentUser;
    if (user == null) return;

    setState(() {
      _isLoadingShortlist = true;
    });

    try {
      final isInShortlist = await _shortlistRepo.isInShortlist(
        user.uid,
        widget.opportunityId,
      );
      if (mounted) {
        setState(() {
          _isInShortlist = isInShortlist;
          _isLoadingShortlist = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingShortlist = false;
        });
      }
    }
  }

  Future<void> _showAuthDialog(String action) async {
    if (!mounted) return;
    
    final result = await showDialog<String>(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.lock_outline,
                  size: 48,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 20),
              // Title
              const Text(
                'Account Required',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              // Message
              Text(
                'You need an account to $action. Would you like to create an account or login?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              // Buttons
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context, 'signup'),
                  icon: const Icon(Icons.person_add, size: 20),
                  label: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context, 'login'),
                  icon: const Icon(Icons.login, size: 20),
                  label: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.primaryColor,
                    side: BorderSide(
                      color: AppTheme.primaryColor,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context, 'cancel'),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
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

  Future<void> _handleShortlistToggle() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is! AuthAuthenticated) {
      await _showAuthDialog('add items to your shortlist');
      return;
    }

    final user = FirebaseConfig.auth.currentUser;
    if (user == null) {
      await _showAuthDialog('add items to your shortlist');
      return;
    }

    setState(() {
      _isLoadingShortlist = true;
    });

    try {
      if (_isInShortlist) {
        await _shortlistRepo.removeFromShortlist(user.uid, widget.opportunityId);
        if (mounted) {
          setState(() {
            _isInShortlist = false;
            _isLoadingShortlist = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Removed from shortlist'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        await _shortlistRepo.addToShortlist(user.uid, widget.opportunityId);
        if (mounted) {
          setState(() {
            _isInShortlist = true;
            _isLoadingShortlist = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Added to shortlist'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingShortlist = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final opportunitiesRepo = OpportunitiesRepository();
    final areasRepo = AreasRepository();
    final priceFormat = NumberFormat.currency(
      symbol: 'AED ',
      decimalDigits: 0,
    );
    
    return FutureBuilder<OpportunityModel?>(
      future: opportunitiesRepo.getOpportunity(widget.opportunityId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        
        if (snapshot.hasError || snapshot.data == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Text('Error loading opportunity: ${snapshot.error ?? "Not found"}'),
            ),
          );
        }
        
        final opportunity = snapshot.data!;
        
        return FutureBuilder(
          future: areasRepo.getArea(opportunity.areaId),
          builder: (context, areaSnapshot) {
            final areaName = areaSnapshot.data?.name ?? 'Unknown Area';
            
            return Scaffold(
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    expandedHeight: 300,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: opportunity.images.isNotEmpty
                          ? Image.network(
                              opportunity.images.first,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade300,
                                  child: const Center(
                                    child: Icon(Icons.home, size: 100, color: Colors.grey),
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: Colors.grey.shade300,
                              child: const Center(
                                child: Icon(Icons.home, size: 100, color: Colors.grey),
                              ),
                            ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            opportunity.title,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            areaName,
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            priceFormat.format(opportunity.price),
                            style: TextStyle(
                              color: AppTheme.secondaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            opportunity.description,
                            style: const TextStyle(fontSize: 16),
                          ),
                          if (opportunity.images.length > 1) ...[
                            const SizedBox(height: 24),
                            const Text(
                              'Gallery',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: opportunity.images.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        opportunity.images[index],
                                        fit: BoxFit.cover,
                                        width: 200,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            width: 200,
                                            color: Colors.grey.shade300,
                                            child: const Icon(Icons.image, size: 50),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                          if (opportunity.features.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            const Text(
                              'Features',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: opportunity.features
                                  .map((feature) => _FeatureChip(feature))
                                  .toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _isLoadingShortlist ? null : _handleShortlistToggle,
                          icon: _isLoadingShortlist
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Icon(_isInShortlist ? Icons.favorite : Icons.favorite_border),
                          label: Text(_isInShortlist ? 'In Shortlist' : 'Shortlist'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: _isInShortlist ? Colors.red : null,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, authState) {
                            return ElevatedButton(
                              onPressed: () {
                                if (authState is AuthAuthenticated) {
                                  context.push('${RouteNames.bookConsultation}?opportunityId=${widget.opportunityId}');
                                } else {
                                  _showAuthDialog('book a consultation');
                                }
                              },
                              child: const Text('Book Consultation'),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final String label;

  const _FeatureChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: AppTheme.backgroundColor,
    );
  }
}

