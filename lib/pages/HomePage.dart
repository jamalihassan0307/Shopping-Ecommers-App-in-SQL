// import 'dart:convert';
import 'dart:io';

import 'package:ecommers_app/controller/homePageController.dart';
import 'package:ecommers_app/models/ItemModel.dart';
import 'package:ecommers_app/pages/CartPage.dart';
import 'package:ecommers_app/pages/ItemDetail.dart';
import 'package:ecommers_app/services/itemService.dart';
import 'package:ecommers_app/services/sqlService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ItemServices itemServices = ItemServices();
  List<ShopItemModel> items = [];
  File? _image;
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  final HomePageController controller = Get.put(HomePageController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "ShopEase",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: InkResponse(
              onTap: () {
                Get.to(() => CartPage());
              },
              child: Stack(
                children: [
                  const Icon(Icons.shopping_cart, color: Colors.white),
                  GetBuilder<HomePageController>(
                    builder: (_) => controller.cartItems.isNotEmpty
                      ? Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              controller.cartItems.length.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  ),
                ],
              ),
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
              Colors.deepPurple.shade50,
              Colors.white,
            ],
          ),
        ),
        child: GetBuilder<HomePageController>(
          init: controller,
          builder: (_) => controller.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.deepPurple,
                ),
              )
            : ShopItemListing(items: controller.items),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          name.clear();
          price.clear();
          _image = null;
          final formKey = GlobalKey<FormState>();

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                    title: Text(
                      "Add New Item",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    backgroundColor: Colors.white,
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding: const EdgeInsets.all(24.0),
                    content: SizedBox(
                      width: MediaQuery.of(context).size.width - 40,
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Image Picker
                            Container(
                              height: 150,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: _image != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.file(
                                      _image!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add_photo_alternate,
                                        size: 50,
                                        color: Colors.grey.shade400,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "Add Product Image",
                                        style: GoogleFonts.poppins(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                            ),
                            const SizedBox(height: 16),

                            // Image Picker Button
                            ElevatedButton.icon(
                              onPressed: () async {
                                final pickedFile = await ImagePicker()
                                    .pickImage(source: ImageSource.gallery);
                                if (pickedFile != null) {
                                  setState(() {
                                    _image = File(pickedFile.path);
                                  });
                                }
                              },
                              icon: const Icon(Icons.add_photo_alternate),
                              label: Text(
                                _image != null ? 'Change Image' : 'Pick Image',
                                style: GoogleFonts.poppins(),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Name Field
                            TextFormField(
                              controller: name,
                              decoration: InputDecoration(
                                labelText: 'Product Name',
                                labelStyle: GoogleFonts.poppins(),
                                prefixIcon: const Icon(Icons.shopping_bag),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter product name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Price Field
                            TextFormField(
                              controller: price,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Price',
                                labelStyle: GoogleFonts.poppins(),
                                prefixIcon: const Icon(Icons.attach_money),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter product price';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            // Action Buttons
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    'Cancel',
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (formKey.currentState!.validate()) {
                                      Navigator.pop(context);
                                      SQLService sql = await SQLService();
                                      int id = HomePageController.to.items.length + 1;
                                      var model = ShopItemModel(
                                        id: id,
                                        fav: false,
                                        rating: 3.5,
                                        price: double.tryParse(price.text) ?? 0.0,
                                        image: _image!.path,
                                        name: name.text,
                                      );
                                      await sql.saveRecord(model);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 12,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Text(
                                    'Add Product',
                                    style: GoogleFonts.poppins(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class ShopItemListing extends StatelessWidget {
  final List<ShopItemModel> items;

  const ShopItemListing({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (BuildContext context, int index) {
          return ItemView(item: items[index]);
        },
        itemCount: items.length,
      ),
    );
  }
}

class ItemView extends StatelessWidget {
  final ShopItemModel item;

  const ItemView({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ItemDetailPage(itemId: item.id));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  image: DecorationImage(
                    image: item.image.toString().substring(0,5) == "https"
                      ? NetworkImage(item.image) as ImageProvider
                      : FileImage(File(item.image)),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GetBuilder<HomePageController>(
                        builder: (controller) => IconButton(
                          icon: Icon(
                            item.fav ? Icons.favorite : Icons.favorite_border,
                            color: item.fav ? Colors.red : Colors.white,
                          ),
                          onPressed: () {
                            controller.setToFav(item.id, !item.fav);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Product Details
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "\$${item.price.toString()}",
                    style: GoogleFonts.poppins(
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate()
      .fadeIn(duration: 600.ms)
      .scale(delay: 200.ms);
  }
}
