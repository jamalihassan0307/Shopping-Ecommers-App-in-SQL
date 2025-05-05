// ignore_for_file: unused_field

import 'package:get/get.dart';
import '../services/database_service.dart';
import 'auth_controller.dart';
import 'package:flutter/material.dart';

class ProfileController extends GetxController {
  final DatabaseService _databaseService = DatabaseService();
  final RxBool isLoading = false.obs;
  final RxMap<String, dynamic> userProfile = RxMap<String, dynamic>();
  final currentUser = RxMap<String, dynamic>();
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
        currentUser.clear();
        return;
      }

      final userId = authController.user['id'];
      if (userId != null) {
        final user = await _databaseService.getUserById(userId);
        if (user != null) {
          userProfile.value = user;
          currentUser.value = user;
        }
      }
    } catch (e) {
      print('Error loading profile: $e');
      Get.snackbar(
        'Error',
        'Failed to load profile',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateProfile({
    String? name,
  }) async {
    try {
      isLoading.value = true;
      final authController = Get.find<AuthController>();
      if (!authController.isAuthenticated) {
        Get.snackbar(
          'Error',
          'Please login to update profile',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      final userId = authController.user['id'];
      if (userId == null) return false;

      final updatedData = Map<String, dynamic>.from(userProfile);
      if (name != null) updatedData['name'] = name;

      final result = await _databaseService.updateUser(updatedData);
      if (result > 0) {
        userProfile.value = updatedData;
        // Update auth controller's user data
        authController.currentUser.value = updatedData;
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Failed to update profile',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print('Error updating profile: $e');
      Get.snackbar(
        'Error',
        'Failed to update profile',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  Future<bool> updatePassword({
    String? oldPassword,
    String? newPassword,
  }) async {
    // ignore: invalid_use_of_protected_member
    if (currentUser.value['password'] != oldPassword) {
      Get.snackbar(
        'Error',
        'Old password is incorrect',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }


    try {
      isLoading.value = true;
      final authController = Get.find<AuthController>();
      if (!authController.isAuthenticated) {
        Get.snackbar(
          'Error',
          'Please login to update profile',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
      if (oldPassword == null || newPassword == null) {
        Get.snackbar(
          'Error',
          'Please enter both old and new passwords',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      final userId = authController.user['id'];
      if (userId == null) return false;

      final updatedData = Map<String, dynamic>.from(userProfile);
      
      updatedData['password'] = newPassword;

      final result = await _databaseService.updateUser(updatedData);
      if (result > 0) {
        userProfile.value = updatedData;
        // Update auth controller's user data
        authController.currentUser.value = updatedData;
        Get.snackbar(
          'Success',
          'Profile updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          'Failed to update profile',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      print('Error updating profile: $e');
      Get.snackbar(
        'Error',
        'Failed to update profile',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      final authController = Get.find<AuthController>();
      await authController.logout();
      userProfile.clear();
      Get.offAllNamed('/welcome');
    } catch (e) {
      print('Error logging out: $e');
      Get.snackbar(
        'Error',
        'Failed to logout',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
} 