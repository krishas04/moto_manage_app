import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_manage/core/constants/app_colors.dart';
import 'package:moto_manage/features/authentication/presentation/statemanagement/auth_notifier.dart';

import 'package:moto_manage/features/owner_management/domain/entities/owner.dart';
import 'package:moto_manage/features/owner_management/presentation/state_management/owner_notifier.dart';
import 'package:provider/provider.dart';


class OwnerScreen extends StatelessWidget {
  const OwnerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier= context.watch<OwnerNotifier>();

    return Scaffold(
        appBar: AppBar(
          title: const Text('Vehicle Owners'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: ()=>_loadOwners(context),
            ),
          ],
        ),
        body: _buildBody(context,notifier),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            context.push('/users');
            },
          label: Text('+ Create User'),
        )
    );
  }

  Widget _buildBody(BuildContext context, OwnerNotifier notifier) {
    // Show loading if loading and no data
    if (notifier.isLoading && notifier.owners.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show error if there's an error message
    if (notifier.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Error: ${notifier.errorMessage}",
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _loadOwners(context),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Show empty state if no owners
    if (notifier.owners.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "No owners found.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    // Show list of owners
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: notifier.owners.length,
      separatorBuilder: (context, index) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final owner = notifier.owners[index];
        return _buildOwnerTile(context, owner);
      },
    );
  }

  // Separate method for owner tile
  Widget _buildOwnerTile(BuildContext context, OwnerEntity owner) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.b,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.bluishWhite,
          ),
          padding: const EdgeInsets.all(8),
          child: SvgPicture.asset(
            'assets/images/man.svg',
            width: 30,
            height: 30,
          ),
        ),
        title: Text(
          owner.fullName ?? 'Unknown',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(owner.phoneNumber),
        trailing: IconButton(
          icon: const Icon(Icons.edit_note_outlined),
          onPressed: () {
            context.push('/user/edit/${owner.id}').then((_) {
              if (context.mounted) {
                _loadOwners(context);
              }
            });
          },
        ),
        onTap: () {
          context.push('/vehicles/${owner.id}');
        },
      ),
    );
  }

  // Method to load owners
  void _loadOwners(BuildContext context) {
    final token= context.read<AuthNotifier>().accessToken;
    final notifier = context.read<OwnerNotifier>();
    notifier.loadOwners(token!);
  }
}