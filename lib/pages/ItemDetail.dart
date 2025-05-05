import 'dart:io';

import 'package:ecommers_app/controller/homePageController.dart';
import 'package:ecommers_app/models/ItemModel.dart';
import 'package:ecommers_app/widgets/CustomButton.dart';
import 'package:ecommers_app/widgets/DotWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ItemDetailPage extends StatefulWidget {
  final int itemId;

  const ItemDetailPage({Key? key, required this.itemId}) : super(key: key);

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  late PageController pageController;
  int active = 0;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    HomePageController controller = Get.find<HomePageController>();
    ShopItemModel model = controller.getItem(widget.itemId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          GetBuilder<HomePageController>(
            builder: (value) => IconButton(
              icon: Icon(
                model.fav ? Icons.favorite : Icons.favorite_border,
                color: model.fav ? Colors.red : Colors.black,
              ),
              onPressed: () {
                controller.setToFav(model.id, !model.fav);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      model.fav ? "${model.name} marked as favourite" : "${model.name} removed from favourite"
                    ),
                    backgroundColor: Colors.deepPurple,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Carousel
            Container(
              height: 300,
              child: Stack(
                children: [
                  PageView(
                    controller: pageController,
                    onPageChanged: (index) {
                      setState(() {
                        active = index;
                      });
                    },
                    children: List.generate(
                      4,
                      (index) => Container(
                        padding: const EdgeInsets.all(16),
                        child: Hero(
                          tag: 'product_${model.id}',
                          child: model.image.toString().substring(0,5) == "https"
                            ? Image.network(
                                model.image,
                                fit: BoxFit.contain,
                              )
                            : Image.file(
                                File(model.image),
                                fit: BoxFit.contain,
                              ),
                        ),
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
                        4,
                        (index) => DotWidget(
                          activeIndex: active,
                          dotIndex: index,
                          activeColor: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate()
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.2, end: 0),

            // Product Details
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ).animate()
                    .fadeIn(delay: 200.ms)
                    .slideX(begin: -0.2, end: 0),

                  const SizedBox(height: 8),

                  Text(
                    "\$${model.price.toString()}",
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.deepPurple,
                    ),
                  ).animate()
                    .fadeIn(delay: 400.ms)
                    .slideX(begin: -0.2, end: 0),

                  const SizedBox(height: 24),

                  Text(
                    "Description",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ).animate()
                    .fadeIn(delay: 600.ms),

                  const SizedBox(height: 8),

                  Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      height: 1.5,
                    ),
                  ).animate()
                    .fadeIn(delay: 800.ms),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: GetBuilder<HomePageController>(
          builder: (_) {
            bool isAdded = controller.isAlreadyInCart(model.id);
            return CustomButton(
              name: isAdded ? "REMOVE FROM CART" : "ADD TO CART",
              onTap: () async {
                try {
                  if (isAdded) {
                    controller.removeFromCart(model.id);
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
                    await controller.addToCart(model);
                    controller.getCardList();
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
                  print(e);
                }
              },
              backgroundColor: isAdded ? Colors.red : Colors.deepPurple,
              width: double.infinity,
              height: 50,
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}
