import 'package:ecommers_app/pages/HomePage.dart';
import 'package:ecommers_app/screens/welcome_screen.dart';
import 'package:ecommers_app/screens/login_screen.dart';
import 'package:ecommers_app/screens/signup_screen.dart';
import 'package:ecommers_app/screens/profile_settings_screen.dart';
import 'package:ecommers_app/services/sqlService.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SQLService sqlService = SQLService();
  await sqlService.openDB();
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const WelcomeScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/signup', page: () => const SignupScreen()),
        GetPage(name: '/home', page: () => HomePage()),
        GetPage(name: '/profile', page: () => const ProfileSettingsScreen()),
      ],
    );
  }
}
