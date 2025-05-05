// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/home_controller.dart';
import '../widgets/shop_item_listing.dart';

class MainScreen extends StatelessWidget {
  final VoidCallback onMenuPressed;
  const MainScreen({
    Key? key,
    required this.onMenuPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ShopEase",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: onMenuPressed,
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () => Get.toNamed('/cart'),
          ),
        ],
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Featured Products",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ).animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: -0.2, end: 0),
            ),
            Expanded(
              child: GetBuilder<HomeController>(
                builder: (_) => controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.deepPurple,
                      ),
                    )
                  : ShopItemListing(items: controller.items),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
