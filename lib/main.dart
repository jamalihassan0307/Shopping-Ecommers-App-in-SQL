import 'package:ecommers_app/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/drawer_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/profile_settings_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/settings_screen.dart';
import 'pages/CartPage.dart';
import 'pages/ItemDetail.dart';
import 'controller/auth_controller.dart';
import 'controller/home_controller.dart';
import 'controller/cart_controller.dart';
import 'controller/profile_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize controllers
  Get.put(AuthController());
  Get.put(HomeController());
  Get.put(CartController());
  Get.put(ProfileController());
  DatabaseService().init();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ShopEase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: true,
      ),
      initialRoute: '/welcome',
      getPages: [
        GetPage(name: '/welcome', page: () => const WelcomeScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/signup', page: () => const SignupScreen()),
        GetPage(name: '/home', page: () => const DrawerScreen()),
        GetPage(name: '/profile', page: () => const ProfileSettingsScreen()),
        GetPage(name: '/favorites', page: () => FavoritesScreen()),
          GetPage(name: '/cart', page: () => CartPage()),
          GetPage(name: '/item-detail', page: () => const ItemDetail(itemId: 0)),
        GetPage(name: '/settings', page: () => const SettingsScreen()),
      ],
    );
  }
}
