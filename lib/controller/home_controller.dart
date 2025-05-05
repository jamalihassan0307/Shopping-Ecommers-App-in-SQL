import 'package:get/get.dart';
import '../models/ItemModel.dart';
import '../services/database_service.dart';
import 'auth_controller.dart';

class HomeController extends GetxController {
  final DatabaseService _databaseService = DatabaseService();
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
    try {
      isLoading.value = true;
      final itemsList = await _databaseService.getAllItems();
      items.assignAll(itemsList.map((item) => ShopItemModel.fromMap(item)).toList());
    } catch (e) {
      print('Error fetching items: $e');
      Get.snackbar(
        'Error',
        'Failed to load items',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCartList() async {
    try {
      final authController = Get.find<AuthController>();
      if (!authController.isAuthenticated) return;

      final userId = authController.user['id'];
      final cartItemsList = await _databaseService.getCartItems(userId);
      cartItems.assignAll(cartItemsList.map((item) => ShopItemModel.fromMap(item)).toList());
    } catch (e) {
      print('Error fetching cart: $e');
    }
  }

  ShopItemModel getItem(int id) {
    return items.firstWhere((item) => item.id == id);
  }

  bool isAlreadyInCart(int itemId) {
    return cartItems.any((item) => item.id == itemId);
  }

  Future<void> addToCart(int itemId) async {
    try {
      final authController = Get.find<AuthController>();
      if (!authController.isAuthenticated) {
        Get.snackbar(
          'Error',
          'Please login to add items to cart',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final userId = authController.user['id'];
      await _databaseService.addToCart(userId, itemId);
      await fetchCartList();
    } catch (e) {
      print('Error adding to cart: $e');
      Get.snackbar(
        'Error',
        'Failed to add item to cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> removeFromCart(int itemId) async {
    try {
      final authController = Get.find<AuthController>();
      if (!authController.isAuthenticated) return;

      final userId = authController.user['id'];
      await _databaseService.removeFromCart(userId, itemId);
      await fetchCartList();
    } catch (e) {
      print('Error removing from cart: $e');
      Get.snackbar(
        'Error',
        'Failed to remove item from cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> setToFav(int itemId) async {
    try {
      final authController = Get.find<AuthController>();
      if (!authController.isAuthenticated) {
        Get.snackbar(
          'Error',
          'Please login to add favorites',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final userId = authController.user['id'];
      final isFavorite = await _databaseService.isItemInFavorites(userId, itemId);

      if (isFavorite) {
        await _databaseService.removeFromFavorites(userId, itemId);
      } else {
        await _databaseService.addToFavorites(userId, itemId);
      }

      // Update local state
      final index = items.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        items[index].isFavorite = !items[index].isFavorite;
        items.refresh();
      }
    } catch (e) {
      print('Error toggling favorite: $e');
      Get.snackbar(
        'Error',
        'Failed to update favorite status',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
} 