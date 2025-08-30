import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/preferences_utils.dart'; // ✅ Use safe wrapper
import '../models/onboarding_content.dart';
import 'signup_screen.dart';
import 'signin_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<OnboardingContent> _contents = [
    OnboardingContent(
      title: "Gain total control of your money",
      description: "Become your own money manager and make every cent count",
      imagePath: "assets/images/onboarding_1.png",
    ),
    OnboardingContent(
      title: "Know where your money goes",
      description: "Track your transaction easily, with categories and financial report",
      imagePath: "assets/images/onboarding_2.png",
    ),
    OnboardingContent(
      title: "Planning ahead",
      description: "Setup your budget for each category so you are in control",
      imagePath: "assets/images/onboarding_3.png",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 60),
                  Text(
                    '${_currentIndex + 1} of ${_contents.length}',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF91919F),
                    ),
                  ),
                  TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(
                      'Skip',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF7F3DFF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // PageView content
            Expanded(
              flex: 6,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: _contents.length,
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Illustration
                          Container(
                            height: 280,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Image.asset(
                              _contents[index].imagePath,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 280,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF7F3DFF).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          _getIllustrationIcon(index),
                                          size: 80,
                                          color: const Color(0xFF7F3DFF),
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Illustration ${index + 1}',
                                          style: GoogleFonts.inter(
                                            fontSize: 14,
                                            color: const Color(0xFF91919F),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 40),
                          
                          // Page indicators
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              _contents.length,
                              (dotIndex) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                height: 8,
                                width: _currentIndex == dotIndex ? 32 : 8,
                                decoration: BoxDecoration(
                                  color: _currentIndex == dotIndex
                                      ? const Color(0xFF7F3DFF)
                                      : const Color(0xFFEEE5FF),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          // Title
                          Text(
                            _contents[index].title,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF212325),
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Description
                          Text(
                            _contents[index].description,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF91919F),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom buttons
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_currentIndex < _contents.length - 1) ...[
                    // Next button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7F3DFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Next',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ] else ...[
                    // Final page buttons
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _goToSignUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7F3DFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: _goToSignIn,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: Color(0xFF7F3DFF),
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor: Colors.white,
                        ),
                        child: Text(
                          'Login',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF7F3DFF),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _nextPage() {
    if (_currentIndex < _contents.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() async {
    await _markOnboardingComplete();
    _goToSignIn();
  }

  Future<void> _markOnboardingComplete() async {
    // ✅ Use safe wrapper
    await PreferencesUtils.setBool('hasSeenOnboarding', true);
  }

  void _goToSignUp() async {
    await _markOnboardingComplete();
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignUpScreen()),
      );
    }
  }

  void _goToSignIn() async {
    await _markOnboardingComplete();
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
    }
  }

  IconData _getIllustrationIcon(int index) {
    switch (index) {
      case 0:
        return Icons.account_balance_wallet;
      case 1:
        return Icons.analytics;
      case 2:
        return Icons.savings;
      default:
        return Icons.monetization_on;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
