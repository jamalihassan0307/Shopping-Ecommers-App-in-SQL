import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/drawer_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/profile_settings_screen.dart';
import 'screens/favorites_screen.dart';
import 'pages/CartPage.dart';
import 'pages/ItemDetail.dart';
import 'controller/homePageController.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(HomePageController()); // Initialize the controller
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
        GetPage(name: '/item-detail', page: () => const ItemDetailPage(itemId: 0)),
      ],
    );
  }
}
