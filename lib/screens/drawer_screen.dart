import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'menu_screen.dart';
import 'main_screen.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({Key? key}) : super(key: key);



  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final ZoomDrawerController _drawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: _drawerController,
      menuScreen: MenuScreen(
        onItemSelected: () {
          _drawerController.toggle!();
        },
      ),
      mainScreen: MainScreen(
        onMenuPressed: () {
          _drawerController.toggle!();
        },
      ),
      borderRadius: 24.0,
      showShadow: true,
      angle: -12.0,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      menuBackgroundColor: Colors.deepPurple.shade700,
      mainScreenScale: 0.2,
      mainScreenTapClose: true,
      menuScreenWidth: MediaQuery.of(context).size.width * 0.65,
      openCurve: Curves.easeInOut,
      closeCurve: Curves.easeInOut,
      duration: const Duration(milliseconds: 300),
    );
  }
} 