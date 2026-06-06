import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_manage/core/constants/app_colors.dart';
import 'package:moto_manage/core/constants/app_text_styles.dart';
import 'package:moto_manage/features/authentication/presentation/statemanagement/auth_notifier.dart';
import 'package:moto_manage/features/owner_management/domain/entities/owner.dart';
import 'package:moto_manage/features/owner_management/presentation/state_management/owner_notifier.dart';
import 'package:provider/provider.dart';

class OwnerScreen extends StatefulWidget {
  const OwnerScreen({super.key});

  @override
  State<OwnerScreen> createState() => _OwnerScreenState();
}

class _OwnerScreenState extends State<OwnerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadOwners();
    });
  }

  void _loadOwners() {
    final token = context.read<AuthNotifier>().accessToken;
    if (token != null) {
      context.read<OwnerNotifier>().loadOwners(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<OwnerNotifier>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB), // Modern light background
       appBar: AppBar(
         title: const Text('Vehicle Owners', style: TextStyle(fontWeight: FontWeight.bold)),
         centerTitle: false,
         elevation: 0,
         backgroundColor: Colors.white,
         foregroundColor: AppColors.primary,
         actions: [
           IconButton(
             icon: const Icon(Icons.refresh_rounded),
             onPressed: _loadOwners,
           ),
         ],
       ),
      body: RefreshIndicator(
        onRefresh: () async => _loadOwners(),
        child: _buildBody(notifier),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>context.push('/owners/create'),
        label: const Text('Add Owner'),
        icon: const Icon(Icons.person_add_alt_1_rounded),
        backgroundColor: AppColors.primary,
      ),
    );
  }

  Widget _buildBody(OwnerNotifier notifier) {
    if (notifier.isLoading && notifier.owners.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (notifier.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text("Error: ${notifier.errorMessage}", textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _loadOwners, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    if (notifier.owners.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline_rounded, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text("No registered owners found.", style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80), // Padding for FAB
      itemCount: notifier.owners.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final owner = notifier.owners[index];
        return _buildOwnerTile(owner);
      },
    );
  }

  Widget _buildOwnerTile(OwnerEntity owner) {
    return GestureDetector(
      onTap: () => context.push('/vehicles/${owner.id}'),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            // Icon Bubble instead of SVG
            Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                  Icons.person_rounded,
                  color: AppColors.primary,
                  size: 28
              ),
            ),
            const SizedBox(width: 16),
            // Owner Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    owner.fullName ?? owner.username,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${owner.email} • ${owner.mobileNumber}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Edit Action Button
            IconButton(
              icon: const Icon(Icons.edit_note_rounded, color: Colors.grey),
              onPressed: () {
                context.push('/owners/edit/${owner.id}').then((_) => _loadOwners());
              },
            ),
          ],
        ),
      ),
    );
  }
}