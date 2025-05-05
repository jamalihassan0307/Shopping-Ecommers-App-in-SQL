import 'dart:io';

import 'package:ecommers_app/controller/home_controller.dart';
import 'package:ecommers_app/models/ItemModel.dart';
import 'package:ecommers_app/widgets/CustomButton.dart';
import 'package:ecommers_app/widgets/DotWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/auth_controller.dart';

class ItemDetail extends StatefulWidget {
  final int itemId;

  const ItemDetail({Key? key, required this.itemId}) : super(key: key);

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  String? selectedSize;
  final controller = Get.find<HomeController>();
  final authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final item = Get.arguments as ShopItemModel;
    bool isAdded = controller.isAlreadyInCart(item.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Product Details",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          GetBuilder<HomeController>(
            builder: (_) => IconButton(
              icon: Icon(
                item.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: item.isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                if (!authController.isAuthenticated) {
                  Get.snackbar(
                    'Login Required',
                    'Please login to add items to favorites',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.deepPurple,
                    colorText: Colors.white,
                    duration: const Duration(seconds: 2),
                    mainButton: TextButton(
                      onPressed: () => Get.toNamed('/login'),
                      child: const Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                  return;
                }
                controller.setToFav(item.id);
              },
            ),
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
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Hero(
                            tag: 'item_${item.id}',
                            child: item.image.toString().substring(0,5) == "https"
                              ? Image.network(
                                  item.image,
                                  height: 250,
                                  fit: BoxFit.contain,
                                )
                              : Image.file(
                                  File(item.image),
                                  height: 250,
                                  fit: BoxFit.contain,
                                ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              3,
                              (index) => DotWidget(
                                active: index == 0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "\$${item.price.toStringAsFixed(2)}",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Select Size",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          children: ['US 7', 'US 8', 'US 9', 'US 10', 'US 11'].map((size) {
                            final isSelected = size == selectedSize;
                            return ChoiceChip(
                              label: Text(size),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  selectedSize = selected ? size : null;
                                });
                              },
                              backgroundColor: Colors.white,
                              selectedColor: Colors.deepPurple.shade100,
                              labelStyle: GoogleFonts.poppins(
                                color: isSelected ? Colors.deepPurple : Colors.black87,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Description",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item.description ?? "",
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: GetBuilder<HomeController>(
                builder: (controller) {
                  return CustomButton(
                    text: isAdded ? "Remove from Cart" : "Add to Cart",
                    onPressed: () async {
                      if (!authController.isAuthenticated) {
                        Get.snackbar(
                          'Login Required',
                          'Please login to add items to cart',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.deepPurple,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 2),
                          mainButton: TextButton(
                            onPressed: () => Get.toNamed('/login'),
                            child: const Text(
                              'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                        return;
                      }
                      if (selectedSize == null) {
                        Get.snackbar(
                          'Size Required',
                          'Please select a size before adding to cart',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.deepPurple,
                          colorText: Colors.white,
                        );
                        return;
                      }
                      try {
                        if (isAdded) {
                          await controller.removeFromCart(item.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Item removed from cart successfully"),
                              backgroundColor: Colors.deepPurple,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        } else {
                          await controller.addToCart(item.id);
                          await controller.fetchCartList(); // Refresh cart list
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Item added to cart successfully"),
                              backgroundColor: Colors.deepPurple,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Error: ${e.toString()}"),
                            backgroundColor: Colors.red,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
