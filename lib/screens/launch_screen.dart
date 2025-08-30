import 'package:flutter/material.dart';

class LaunchScreen extends StatelessWidget {
  final VoidCallback onInitializationComplete;

  const LaunchScreen({super.key, required this.onInitializationComplete});

  @override
  Widget build(BuildContext context) {
    // Start the timer to transition after 3 seconds
    Future.delayed(const Duration(seconds: 3), onInitializationComplete);

    return Scaffold(
      backgroundColor: const Color(0xFF7F3DFF), // Purple background
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Single container with glow and centered logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withAlpha((0.7 * 255).round()),
                      blurRadius: 60,
                      spreadRadius: 30,
                    ),
                    BoxShadow(
                      color: Colors.amber.withAlpha((0.5 * 255).round()),
                      blurRadius: 40,
                      spreadRadius: 15,
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 70,
                    height: 70,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.account_balance_wallet,
                        size: 50,
                        color: Color(0xFF7F3DFF),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // App title
              const Text(
                'montra',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
