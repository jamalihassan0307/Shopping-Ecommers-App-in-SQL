import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class DotWidget extends StatelessWidget {
  final int activeIndex;
  final int dotIndex;
  final Color? activeColor;
  final Color? inactiveColor;

  const DotWidget({
    Key? key,
    required this.activeIndex,
    required this.dotIndex,
    this.activeColor,
    this.inactiveColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isActive = dotIndex == activeIndex;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: isActive ? 12.0 : 8.0,
        width: isActive ? 12.0 : 8.0,
        decoration: BoxDecoration(
          color: isActive 
              ? (activeColor ?? Colors.deepPurple)
              : (inactiveColor ?? Colors.grey.shade300),
          shape: BoxShape.circle,
          boxShadow: isActive ? [
            BoxShadow(
              color: (activeColor ?? Colors.deepPurple).withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
      ).animate(
        target: isActive ? 1 : 0,
      ).scale(
        duration: 300.ms,
        curve: Curves.easeInOut,
      ),
    );
  }
}