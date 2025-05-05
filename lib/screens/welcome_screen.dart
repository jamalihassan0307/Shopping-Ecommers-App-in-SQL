import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple.shade700,
              Colors.deepPurple.shade900,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Animation
              SizedBox(
                height: 200,
                child: Lottie.asset(
                  'assets/animations/shopping.json',
                  repeat: true,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.shopping_cart,
                      size: 100,
                      color: Colors.white,
                    );
                  },
                ),
              ).animate()
                .fadeIn(duration: 600.ms)
                .scale(delay: 200.ms),

              const SizedBox(height: 40),

              // Animated Text
              AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Welcome to ShopEase',
                    textStyle: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    speed: const Duration(milliseconds: 100),
                  ),
                ],
                totalRepeatCount: 1,
              ),

              const SizedBox(height: 20),

              // Subtitle
              Text(
                'Your one-stop shopping destination',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ).animate()
                .fadeIn(delay: 1000.ms)
                .slideY(begin: 0.3, end: 0),

              const SizedBox(height: 60),

              // Get Started Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Get Started',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ).animate()
                .fadeIn(delay: 1500.ms)
                .slideY(begin: 0.3, end: 0),

              const SizedBox(height: 20),

              // Sign Up Link
              TextButton(
                onPressed: () {
                  Get.toNamed('/signup');
                },
                child: Text(
                  'Don\'t have an account? Sign Up',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ).animate()
                .fadeIn(delay: 1800.ms),
            ],
          ),
        ),
      ),
    );
  }
} 