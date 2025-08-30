import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import 'signup_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
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

  void _handleSignIn() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        SignInRequested(
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
      body: Form(
        key: _formKey,
        child: Stack(
          children: [
            // Top Navigation (starts at top: 0, height: 64px)
            Positioned(
              top: 0,
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
                        'Login',
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

            // Email Input Field (positioned at top: 120px - adjusted without status bar)
            Positioned(
              top: 120,
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

            // Password Input Field (positioned at top: 200px - adjusted without status bar)
            Positioned(
              top: 200,
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

            // Login Button (positioned at top: 296px - adjusted without status bar)
            Positioned(
              top: 296,
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
                      onPressed: _isLoading ? null : _handleSignIn,
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
                              'Login',
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

            // Forgot Password (positioned at top: 385px - adjusted without status bar)
            Positioned(
              top: 385,
              left: 109,
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Forgot Password feature coming soon!'),
                    ),
                  );
                },
                child: SizedBox(
                  width: 157,
                  height: 22,
                  child: Text(
                    'Forgot Password?',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF7F3DFF),
                    ),
                  ),
                ),
              ),
            ),

            // Don't have account text (positioned at top: 445px - adjusted without status bar)
            Positioned(
              top: 445,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 271,
                    height: 19,
                    child: Text(
                      "Don't have an account yet? Sign Up",
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
    );
  }
}
