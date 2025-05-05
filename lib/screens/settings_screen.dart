import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple,
              Colors.deepPurple.shade50,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSettingCard(
              icon: Icons.person_outline,
              title: "Account Settings",
              subtitle: "Manage your account details",
              onTap: () {
                Get.snackbar(
                  "Coming Soon",
                  "This feature will be available soon!",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.deepPurple,
                  colorText: Colors.white,
                );
              },
            ),
            _buildSettingCard(
              icon: Icons.notifications_outlined,
              title: "Notifications",
              subtitle: "Manage your notification preferences",
              onTap: () {
                Get.snackbar(
                  "Coming Soon",
                  "This feature will be available soon!",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.deepPurple,
                  colorText: Colors.white,
                );
              },
            ),
            _buildSettingCard(
              icon: Icons.payment_outlined,
              title: "Payment Methods",
              subtitle: "Manage your payment options",
              onTap: () {
                Get.snackbar(
                  "Coming Soon",
                  "This feature will be available soon!",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.deepPurple,
                  colorText: Colors.white,
                );
              },
            ),
            _buildSettingCard(
              icon: Icons.language_outlined,
              title: "Language",
              subtitle: "Change app language",
              onTap: () {
                Get.snackbar(
                  "Coming Soon",
                  "This feature will be available soon!",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.deepPurple,
                  colorText: Colors.white,
                );
              },
            ),
            _buildSettingCard(
              icon: Icons.dark_mode_outlined,
              title: "Dark Mode",
              subtitle: "Toggle dark mode",
              onTap: () {
                Get.snackbar(
                  "Coming Soon",
                  "This feature will be available soon!",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.deepPurple,
                  colorText: Colors.white,
                );
              },
            ),
            _buildSettingCard(
              icon: Icons.help_outline,
              title: "Help & Support",
              subtitle: "Get help and contact support",
              onTap: () {
                Get.snackbar(
                  "Coming Soon",
                  "This feature will be available soon!",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.deepPurple,
                  colorText: Colors.white,
                );
              },
            ),
            _buildSettingCard(
              icon: Icons.info_outline,
              title: "About",
              subtitle: "App version and information",
              onTap: () {
                Get.snackbar(
                  "About ShopEase",
                  "Version 1.0.0",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.deepPurple,
                  colorText: Colors.white,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.deepPurple, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    ).animate()
      .fadeIn(duration: 600.ms)
      .slideX(begin: 0.2, end: 0);
  }
} 