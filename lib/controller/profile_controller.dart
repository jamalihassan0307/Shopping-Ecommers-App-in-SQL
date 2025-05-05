import 'package:get/get.dart';
import '../services/database_service.dart';
import 'auth_controller.dart';

class ProfileController extends GetxController {
  final DatabaseService _databaseService = DatabaseService();
  final RxBool isLoading = false.obs;
  final RxMap<String, dynamic> userProfile = RxMap<String, dynamic>();

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;
      final authController = Get.find<AuthController>();
      if (!authController.isAuthenticated) {
        userProfile.clear();
        return;
      }

      userProfile.value = authController.user;
    } catch (e) {
      print('Error loading profile: $e');
      Get.snackbar(
        'Error',
        'Failed to load profile',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateProfile({
    String? name,
    String? phone,
    String? address,
    String? profileImage,
  }) async {
    try {
      isLoading.value = true;
      final authController = Get.find<AuthController>();
      if (!authController.isAuthenticated) {
        return false;
      }

      final updatedData = Map<String, dynamic>.from(userProfile);
      if (name != null) updatedData['name'] = name;
      if (phone != null) updatedData['phone'] = phone;
      if (address != null) updatedData['address'] = address;
      if (profileImage != null) updatedData['profile_image'] = profileImage;

      final success = await authController.updateProfile(updatedData);
      if (success) {
        userProfile.value = updatedData;
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return success;
    } catch (e) {
      print('Error updating profile: $e');
      Get.snackbar(
        'Error',
        'Failed to update profile',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      final authController = Get.find<AuthController>();
      authController.logout();
      userProfile.clear();
      Get.offAllNamed('/welcome');
    } catch (e) {
      print('Error logging out: $e');
      Get.snackbar(
        'Error',
        'Failed to logout',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
} 