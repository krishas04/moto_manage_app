import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moto_manage/core/constants/app_colors.dart';
import 'package:moto_manage/features/authentication/presentation/statemanagement/auth_notifier.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authNotifier = context.watch<AuthNotifier>();
    final user = authNotifier.auth;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB), // Consistent light background
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 1. Profile Header Card
            _buildProfileHeader(user?.username ?? "User", authNotifier.isAdmin),

            const SizedBox(height: 24),

            // 2. Account Information Section
            _buildInfoSection(
              title: "Account Details",
              children: [
                _buildInfoTile(Icons.alternate_email_rounded, "Username", user?.username ?? "N/A"),
                _buildInfoTile(Icons.badge_outlined, "Role", authNotifier.isAdmin ? "Administrator" : "Standard User"),
                _buildInfoTile(Icons.lock_outline_rounded, "Security", "JWT Token Active"),
              ],
            ),

            const SizedBox(height: 24),

            // 3. App Settings Section (Placeholders)
            _buildInfoSection(
              title: "Preferences",
              children: [
                _buildActionTile(Icons.notifications_none_rounded, "Notifications", () {}),
                _buildActionTile(Icons.help_outline_rounded, "Help & Support", () {}),
              ],
            ),

            const SizedBox(height: 40),

            // 4. Logout Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton.icon(
                onPressed: () => _showLogoutConfirmation(context, authNotifier),
                icon: const Icon(Icons.logout_rounded, color: Colors.red),
                label: const Text(
                  "Logout Session",
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red, width: 1.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),

            const SizedBox(height: 20),

          ],
        ),
      ),
    );
  }

  // --- UI HELPER METHODS ---

  Widget _buildProfileHeader(String name, bool isAdmin) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.dark, // Using your theme's dark color
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white.withOpacity(0.15),
            child: Text(
              name[0].toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isAdmin ? Colors.orange.withOpacity(0.2) : Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isAdmin ? "System Admin" : "Vehicle Owner",
              style: TextStyle(
                color: isAdmin ? Colors.orange : Colors.blue,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey)),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary, size: 22),
      title: Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
      trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
    );
  }

  Widget _buildActionTile(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Colors.black87, size: 22),
      title: Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right_rounded, size: 20, color: Colors.grey),
    );
  }

  // --- LOGOUT LOGIC ---

  void _showLogoutConfirmation(BuildContext context, AuthNotifier notifier) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Logout"),
        content: const Text("Are you sure you want to end your session?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              await notifier.logout(); // Clear token/state
              if (context.mounted) {
                context.go('/login'); // Redirect to login
              }
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}