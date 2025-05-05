import 'dart:io';

import 'package:ecommers_app/controller/home_controller.dart';
import 'package:ecommers_app/models/ItemModel.dart';
import 'package:ecommers_app/widgets/CustomButton.dart';
import 'package:ecommers_app/widgets/DotWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ItemDetail extends StatefulWidget {
  final int itemId;

  const ItemDetail({Key? key, required this.itemId}) : super(key: key);

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  int selectedSize = 0;

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.find<HomeController>();
    ShopItemModel model = controller.getItem(widget.itemId);
    bool isAdded = controller.isAlreadyInCart(model.id);

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
            builder: (value) => IconButton(
              icon: Icon(
                model.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: model.isFavorite ? Colors.red : Colors.white,
              ),
              onPressed: () => controller.setToFav(model.id),
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
                            tag: 'item_${model.id}',
                            child: model.image.toString().substring(0,5) == "https"
                              ? Image.network(
                                  model.image,
                                  height: 250,
                                  fit: BoxFit.contain,
                                )
                              : Image.file(
                                  File(model.image),
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
                          model.name,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "\$${model.price}",
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
                        Row(
                          children: List.generate(
                            4,
                            (index) => GestureDetector(
                              onTap: () => setState(() => selectedSize = index),
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: selectedSize == index
                                      ? Colors.deepPurple
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    "${index + 7}",
                                    style: GoogleFonts.poppins(
                                      color: selectedSize == index
                                          ? Colors.white
                                          : Colors.deepPurple,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
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
                          model.description ?? "",
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
                      try {
                        if (isAdded) {
                          await controller.removeFromCart(model.id);
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
                          await controller.addToCart(model.id);
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
