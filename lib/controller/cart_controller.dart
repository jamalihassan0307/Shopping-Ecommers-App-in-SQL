import 'package:get/get.dart';
import '../models/ItemModel.dart';
import '../services/database_service.dart';
import 'auth_controller.dart';

class CartController extends GetxController {
  final DatabaseService _databaseService = DatabaseService();
  final RxList<ShopItemModel> cartItems = <ShopItemModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    try {
      isLoading.value = true;
      final authController = Get.find<AuthController>();
      if (!authController.isAuthenticated) {
        cartItems.clear();
        return;
      }

      final userId = authController.user['id'];
      final itemsList = await _databaseService.getCartItems(userId);
      cartItems.assignAll(itemsList.map((item) => ShopItemModel.fromMap(item)).toList());
    } catch (e) {
      print('Error fetching cart items: $e');
      Get.snackbar(
        'Error',
        'Failed to load cart items',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
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
      await fetchCartItems();

      Get.snackbar(
        'Success',
        'Item added to cart',
        snackPosition: SnackPosition.BOTTOM,
      );
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
      if (!authController.isAuthenticated) {
        return;
      }

      final userId = authController.user['id'];
      await _databaseService.removeFromCart(userId, itemId);
      await fetchCartItems();

      Get.snackbar(
        'Success',
        'Item removed from cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error removing from cart: $e');
      Get.snackbar(
        'Error',
        'Failed to remove item from cart',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  bool isItemInCart(int itemId) {
    return cartItems.any((item) => item.id == itemId);
  }

  double get totalAmount {
    return cartItems.fold(0, (sum, item) => sum + item.price);
  }
} 