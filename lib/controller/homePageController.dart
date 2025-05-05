import 'dart:convert';
import 'dart:io';

import 'package:ecommers_app/models/ItemModel.dart';
import 'package:ecommers_app/services/itemService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';


class HomePageController extends GetxController {
  static HomePageController get to => Get.find();
  final ItemServices itemServices = ItemServices();
  final RxList<ShopItemModel> items = <ShopItemModel>[].obs;
  final RxList<ShopItemModel> cartItems = <ShopItemModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getItems();
    getCardList();
  }

  Future<void> getItems() async {
    isLoading.value = true;
    try {
      final result = await itemServices.getItems();
      items.value = result;
    } catch (e) {
      print('Error getting items: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getCardList() async {
    try {
      final result = await itemServices.getCartList();
      cartItems.value = result;
    } catch (e) {
      print('Error getting cart items: $e');
    }
  }

  Future<void> addToCart(ShopItemModel item) async {
    try {
      await itemServices.addToCart(item);
      await getCardList();
      Get.snackbar(
        'Success',
        'Item added to cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add item to cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> removeFromCart(int itemId) async {
    try {
      await itemServices.removeFromCart(itemId);
      await getCardList();
      Get.snackbar(
        'Success',
        'Item removed from cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to remove item from cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> setToFav(int itemId, bool value) async {
    try {
      await itemServices.setToFav(itemId, value);
      await getItems();
      Get.snackbar(
        'Success',
        value ? 'Item added to favorites' : 'Item removed from favorites',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update favorites',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  bool isAlreadyInCart(int itemId) {
    return cartItems.any((item) => item.id == itemId);
  }

  Future<File> saveImageToFile(String base64String) async {
    List<int> bytes = base64Decode(base64String);

    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    String filePath = '$appDocPath/image.png';

    File file = File(filePath);
    await file.writeAsBytes(bytes);
    print('Image saved to: $filePath');
    update();
    return file;
  }

  File? image64;
}