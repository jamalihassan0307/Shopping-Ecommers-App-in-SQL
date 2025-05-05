import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DotWidget extends StatelessWidget {
  final bool active;
  final Color activeColor;
  final Color inactiveColor;

  const DotWidget({
    Key? key,
    required this.active,
    this.activeColor = Colors.deepPurple,
    this.inactiveColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: active ? 12.0 : 8.0,
      width: active ? 12.0 : 8.0,
      decoration: BoxDecoration(
        color: active ? activeColor : inactiveColor,
        shape: BoxShape.circle,
        boxShadow: active ? [
          BoxShadow(
            color: activeColor.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ] : null,
      ),
    ).animate()
      .scale(duration: 300.ms)
      .fadeIn(duration: 300.ms);
  }
}