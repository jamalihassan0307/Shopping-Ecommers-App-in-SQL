import 'package:get/get.dart';
import '../models/ItemModel.dart';
import '../services/database_service.dart';
import 'auth_controller.dart';

class HomeController extends GetxController {
  final DatabaseService _databaseService = DatabaseService();
  final RxList<ShopItemModel> items = <ShopItemModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchItems();
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

  ShopItemModel getItemById(int id) {
    return items.firstWhere((item) => item.id == id);
  }

  Future<void> toggleFavorite(int itemId) async {
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

      Get.snackbar(
        'Success',
        isFavorite ? 'Removed from favorites' : 'Added to favorites',
        snackPosition: SnackPosition.BOTTOM,
      );
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