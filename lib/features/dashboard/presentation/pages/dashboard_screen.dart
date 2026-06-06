import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_manage/core/constants/app_colors.dart';
import 'package:moto_manage/features/dashboard/presentation/widgets/owner_card_widget.dart';
import 'package:moto_manage/features/owner_management/presentation/state_management/owner_notifier.dart';
import 'package:provider/provider.dart';

import '../../../authentication/presentation/statemanagement/auth_notifier.dart';
import '../../../vehicles_management/presentation/state_management/vehicles_notifier.dart';
import '../widgets/vehicle_list_tile.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  void _refreshData() {
    final token = context.read<AuthNotifier>().accessToken;
    if (token != null) {
      context.read<OwnerNotifier>().loadOwners(token);
      context.read<VehicleNotifier>().loadVehicles(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = context.watch<AuthNotifier>();
    final ownerNotifier = context.watch<OwnerNotifier>();
    final vehicleNotifier = context.watch<VehicleNotifier>();

    // Calculate Vehicle Breakdown
    final vehicles = vehicleNotifier.vehicles;
    final twoWheelers = vehicles.where((v) => v.vehicleType == 'two_wheeler').length;
    final fourWheelers = vehicles.where((v) => v.vehicleType == 'four_wheeler').length;
    final heavy = vehicles.where((v) => v.vehicleType == 'heavy').length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB), // Subtle light grey background
      appBar: AppBar(
        title: const Text('Admin Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _refreshData(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Greeting Card
              _buildGreetingCard(authNotifier.auth?.username ?? "Admin"),
              const SizedBox(height: 24),

              // 2. Statistics Overview
              const _SectionHeader(title: 'System Overview'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Owners',
                      value: ownerNotifier.owners.length.toString(),
                      icon: Icons.people_alt_rounded,
                      color: AppColors.primary,
                      onTap: () => context.go('/owners'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _StatCard(
                      label: 'Vehicles',
                      value: vehicleNotifier.vehicles.length.toString(),
                      icon: Icons.directions_car_filled_rounded,
                      color: AppColors.primary,
                      onTap: () => context.go('/vehicles'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 3. Quick Actions Grid
              const _SectionHeader(title: 'Quick Actions'),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.5,
                children: [
                  _QuickActionTile(
                    label: 'Add Owner',
                    icon: Icons.person_add_alt_1_rounded,
                    color: AppColors.primary,
                    onTap: () => context.push('/owners/create'),
                  ),
                  _QuickActionTile(
                    label: 'Add Vehicle',
                    icon: Icons.add_circle_outline_rounded,
                    color: AppColors.primary,
                    onTap: () => context.push('/vehicles/create'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 4. Vehicle Types Breakdown (Linear Progress Bars)
              const _SectionHeader(title: 'Vehicle Breakdown'),
              const SizedBox(height: 12),
              _buildBreakdownCard(twoWheelers, fourWheelers, heavy, vehicles.length),
              const SizedBox(height: 24),

              // 5. Recent Owners Section (Horizontal)
              _SectionHeader(
                title: 'Recent Owners',
                onSeeAll: () => context.go('/owners'),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 180,
                child: _buildOwnerSection(ownerNotifier),
              ),
              const SizedBox(height: 24),

              // 6. Recent Vehicles Section (Horizontal)
              _SectionHeader(
                title: 'Recent Vehicles',
                onSeeAll: () => context.go('/vehicles'),
              ),
              const SizedBox(height: 12),
              _buildVehicleSection(vehicleNotifier),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildGreetingCard(String name) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.dark, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Welcome back,', style: TextStyle(color: Colors.white70, fontSize: 14)),
          Text(name, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(20)),
            child: const Text('System Administrator', style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownCard(int two, int four, int heavy, int total) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _BreakdownRow(label: 'Two Wheelers', count: two, total: total, color: AppColors.primary),
          const Divider(height: 24),
          _BreakdownRow(label: 'Four Wheelers', count: four, total: total, color: const Color(0xFF00838F)),
          const Divider(height: 24),
          _BreakdownRow(label: 'Heavy Vehicles', count: heavy, total: total, color: Colors.orange),
        ],
      ),
    );
  }

  Widget _buildOwnerSection(OwnerNotifier notifier) {
    if (notifier.isLoading && notifier.owners.isEmpty) return const Center(child: CircularProgressIndicator());
    if (notifier.owners.isEmpty) return const Center(child: Text("No owners found."));

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: notifier.owners.length,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (context, index) {
        final owner = notifier.owners[index];
        return GestureDetector(
          onTap: () => context.push('/vehicles/${owner.id}'),
          child: OwnerCardWidget(owner: owner),
        );
      },
    );
  }

  Widget _buildVehicleSection(VehicleNotifier notifier) {
    if (notifier.isLoading && notifier.vehicles.isEmpty) return const Center(child: CircularProgressIndicator());
    if (notifier.vehicles.isEmpty) return const Center(child: Text("No vehicles found."));

    // We take only the latest 4 vehicles for the dashboard view
    final recentVehicles = notifier.vehicles.take(4).toList();

    return ListView.separated(
      shrinkWrap: true, // Crucial: allows it to work inside SingleChildScrollView
      physics: const NeverScrollableScrollPhysics(), // Main screen handles scrolling
      itemCount: recentVehicles.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final vehicle = recentVehicles[index];
        return VehicleListTile(
          vehicle: vehicle,
          onTap: () => context.push('/vehicles/${vehicle.ownerId}'),
        );
      },
    );
  }
}

// --- HELPER COMPONENTS ---

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;
  const _SectionHeader({required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
        if (onSeeAll != null)
          TextButton(onPressed: onSeeAll, child: const Text('See all', style: TextStyle(color: AppColors.primary))),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _StatCard({required this.label, required this.value, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionTile({required this.label, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _BreakdownRow extends StatelessWidget {
  final String label;
  final int count, total;
  final Color color;

  const _BreakdownRow({required this.label, required this.count, required this.total, required this.color});

  @override
  Widget build(BuildContext context) {
    final double progress = total == 0 ? 0 : count / total;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 13, color: Colors.black87)),
            Text('$count', style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}