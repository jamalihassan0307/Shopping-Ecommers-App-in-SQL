// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuScreen extends StatelessWidget {
  final VoidCallback onItemSelected;
  const MenuScreen({
    Key? key,
    required this.onItemSelected,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade700,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar with animation
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                  "https://plus.unsplash.com/premium_photo-1689568126014-06fea9d5d341?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D",
                ),
              ).animate()
                .scale(duration: 600.ms)
                .fadeIn(duration: 600.ms),

              const SizedBox(height: 16),
              Text(
                "Hello, User",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ).animate()
                .fadeIn(delay: 200.ms)
                .slideX(begin: -0.2, end: 0),

              const SizedBox(height: 30),

              // Menu items with hover effect
              _buildMenuItem(
                icon: Icons.home,
                title: "Home",
                onTap: () {
                  onItemSelected();
                  Get.offAllNamed('/home');
                },
              ),
              _buildMenuItem(
                icon: Icons.favorite,
                title: "Favorites",
                onTap: () {
                  onItemSelected();
                  Get.toNamed('/favorites');
                },
              ),
              _buildMenuItem(
                icon: Icons.shopping_cart,
                title: "Cart",
                onTap: () {
                  onItemSelected();
                  Get.toNamed('/cart');
                },
              ),
              _buildMenuItem(
                icon: Icons.person,
                title: "Profile",
                onTap: () {
                  onItemSelected();
                  Get.toNamed('/profile');
                },
              ),
              _buildMenuItem(
                icon: Icons.settings,
                title: "Settings",
                onTap: () {
                  onItemSelected();
                  Get.toNamed('/settings');
                },
              ),
              const Spacer(),
              const Divider(color: Colors.white54),
              _buildMenuItem(
                icon: Icons.logout,
                title: "Logout",
                onTap: () {
                  onItemSelected();
                  // Add logout logic here
                },
              ),

              const SizedBox(height: 12),
              Text(
                "v1.0.0",
                style: GoogleFonts.poppins(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.transparent,
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 16),
              Text(
                title,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate()
      .fadeIn(delay: 200.ms)
      .slideX(begin: -0.2, end: 0);
  }
} 
