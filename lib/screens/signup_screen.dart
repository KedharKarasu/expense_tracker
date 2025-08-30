import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import 'signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _agreeToTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'Please enter your password';
    }
    if (password.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateName(String? name) {
    if (name == null || name.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  void _handleSignUp() {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_agreeToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please agree to the Terms and Privacy Policy'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      context.read<AuthBloc>().add(
        SignUpRequested(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // #FFFFFF
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              // Status Bar Area (44px height)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  width: 375,
                  height: 44,
                  color: const Color(0xFFFFFFFF),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '9:41',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF161719),
                            letterSpacing: -0.165,
                          ),
                        ),
                        // Status icons placeholder
                        const SizedBox(width: 67, height: 11.5),
                      ],
                    ),
                  ),
                ),
              ),

              // Top Navigation (64px height, positioned at top: 44px)
              Positioned(
                top: 44,
                left: 0,
                right: 0,
                child: Container(
                  width: 375,
                  height: 64,
                  color: const Color(0xFFFFFFFF),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      // Back button (32x32px)
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: const Color(0xFF7F3DFF),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(0xFF212325),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                      // Title - centered
                      Expanded(
                        child: Text(
                          'Sign Up',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF212325),
                          ),
                        ),
                      ),
                      // Right space (same as back button)
                      const SizedBox(width: 32),
                    ],
                  ),
                ),
              ),

              // Name Input Field (positioned at top: 164px)
              Positioned(
                top: 164,
                left: 16,
                child: Container(
                  width: 343,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    border: Border.all(
                      color: const Color(0xFFF1F1FA),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextFormField(
                    controller: _nameController,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF212325),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Name',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF91919F),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                    ),
                    validator: _validateName,
                  ),
                ),
              ),

              // Email Input Field (positioned at top: 244px)
              Positioned(
                top: 244,
                left: 16,
                child: Container(
                  width: 343,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    border: Border.all(
                      color: const Color(0xFFF1F1FA),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF212325),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF91919F),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                    ),
                    validator: _validateEmail,
                  ),
                ),
              ),

              // Password Input Field (positioned at top: 324px)
              Positioned(
                top: 324,
                left: 16,
                child: Container(
                  width: 343,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    border: Border.all(
                      color: const Color(0xFFF1F1FA),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF212325),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF91919F),
                      ),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          margin: const EdgeInsets.all(12),
                          child: Icon(
                            _obscurePassword 
                                ? Icons.visibility_off_outlined 
                                : Icons.visibility_outlined,
                            color: const Color(0xFF91919F),
                            size: 20,
                          ),
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                    ),
                    validator: _validatePassword,
                  ),
                ),
              ),

              // Checkbox and Terms (positioned at top: 397px)
              Positioned(
                top: 397,
                left: 16,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _agreeToTerms = !_agreeToTerms;
                        });
                      },
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: _agreeToTerms 
                              ? const Color(0xFF7F3DFF) 
                              : Colors.transparent,
                          border: Border.all(
                            color: const Color(0xFF7F3DFF),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _agreeToTerms
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 20,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      width: 291,
                      height: 36,
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.29,
                            color: const Color(0xFF000000),
                          ),
                          children: [
                            const TextSpan(
                              text: 'By signing up, you agree to the ',
                            ),
                            TextSpan(
                              text: 'Terms of Service',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF7F3DFF),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF7F3DFF),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Sign Up Button (positioned at top: 460px)
              Positioned(
                top: 460,
                left: 16,
                child: BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthSuccess) {
                      Navigator.pushReplacementNamed(context, '/dashboard');
                    } else if (state is AuthFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    _isLoading = state is AuthLoading;
                    
                    return Container(
                      width: 343,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF7F3DFF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading || !_agreeToTerms 
                            ? null 
                            : _handleSignUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7F3DFF),
                          foregroundColor: const Color(0xFFFCFCFC),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFFFCFCFC),
                                  ),
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                'Sign Up',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFFFCFCFC),
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ),

              // Already have account text (positioned at top: 543px)
              Positioned(
                top: 543,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInScreen(),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: 244,
                      height: 19,
                      child: Text(
                        'Already have an account? Login',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF91919F),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Home Indicator (positioned at bottom)
              Positioned(
                bottom: 8,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    width: 134,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFF000000),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
