import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dashboard_page.dart';

class SignUpSuccessScreen extends StatefulWidget {
  const SignUpSuccessScreen({super.key});

  @override
  State<SignUpSuccessScreen> createState() => _SignUpSuccessScreenState();
}

class _SignUpSuccessScreenState extends State<SignUpSuccessScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const DashboardPage()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Stack(
        children: [
          // Success Icon
          Positioned(
            left: 123,
            top: 319,
            width: 128,
            height: 128,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF00A86B),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 76,
              ),
            ),
          ),

          // Success Text
          Positioned(
            left: 119,
            top: 463,
            width: 136,
            height: 29,
            child: Text(
              'You are set!',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF212325),
                height: 29/24,
              ),
            ),
          ),

          // Home Indicator
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 34,
            child: Center(
              child: Container(
                width: 134,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
