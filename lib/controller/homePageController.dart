import 'dart:convert';
import 'dart:io';

import 'package:ecommers_app/models/ItemModel.dart';
import 'package:ecommers_app/services/itemService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';


class HomePageController extends GetxController {
  static HomePageController get to => Get.find();
  final ItemServices _itemServices = ItemServices();
  final RxList<ShopItemModel> items = <ShopItemModel>[].obs;
  final RxList<ShopItemModel> cartItems = <ShopItemModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchItems();
    fetchCartList();
  }

  Future<void> fetchItems() async {
    isLoading.value = true;
    try {
      final fetchedItems = await _itemServices.getItems();
      items.assignAll(fetchedItems);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load items: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCartList() async {
    try {
      final fetchedCartItems = await _itemServices.getCartList();
      cartItems.assignAll(fetchedCartItems);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load cart: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> addToCart(int itemId) async {
    try {
      await _itemServices.addToCart(itemId);
      await fetchCartList();
      Get.snackbar(
        'Success',
        'Item added to cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add item to cart: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> removeFromCart(int itemId) async {
    try {
      await _itemServices.removeFromCart(itemId);
      await fetchCartList();
      Get.snackbar(
        'Success',
        'Item removed from cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to remove item from cart: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> setToFav(int itemId) async {
    try {
      await _itemServices.setToFav(itemId);
      final index = items.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        items[index].isFavorite = !items[index].isFavorite;
        items.refresh();
      }
      Get.snackbar(
        'Success',
        items[index].isFavorite ? 'Item added to favorites' : 'Item removed from favorites',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update favorite status: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  bool isAlreadyInCart(int itemId) {
    return cartItems.any((item) => item.id == itemId);
  }

  ShopItemModel getItem(int id) {
    return items.firstWhere((item) => item.id == id);
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