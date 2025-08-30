import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'setup_pin_screen.dart';

class VerificationScreen extends StatefulWidget {
  final String email;
  
  const VerificationScreen({super.key, required this.email});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isLoading = false;
  int _resendTimer = 299;
  bool _canResend = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    _canResend = false;
    _resendTimer = 299;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  String _formatTimer(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation
            Container(
              width: 375,
              height: 64,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFF212325)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF7F3DFF),
                        size: 16,
                      ),
                    ),
                  ),
                  
                  Expanded(
                    child: Text(
                      'Verification',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF212325),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 32),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 120),
                    
                    Text(
                      'Enter your\nVerification Code',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 36,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF0D0E0F),
                        height: 44/36,
                      ),
                    ),
                    
                    const SizedBox(height: 50),
                    
                    // 6-digit OTP input fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (index) {
                        return Container(
                          width: 48,
                          height: 56,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _controllers[index].text.isNotEmpty 
                                  ? const Color(0xFF7F3DFF) 
                                  : const Color(0xFFE3E5E5),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextFormField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            style: GoogleFonts.inter(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                            decoration: const InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) {
                              setState(() {});
                              if (value.isNotEmpty && index < 5) {
                                _focusNodes[index + 1].requestFocus();
                              }
                              if (value.isEmpty && index > 0) {
                                _focusNodes[index - 1].requestFocus();
                              }
                              
                              if (_isAllFieldsFilled()) {
                                _verifyCode();
                              }
                            },
                          ),
                        );
                      }),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    Text(
                      _formatTimer(_resendTimer),
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF7F3DFF),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'We send verification code to your email ',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF292B2D),
                            ),
                          ),
                          TextSpan(
                            text: widget.email,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF7F3DFF),
                            ),
                          ),
                          TextSpan(
                            text: '. You can check your inbox.',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF292B2D),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    TextButton(
                      onPressed: _canResend ? _resendCode : null,
                      child: Text(
                        'I didn\'t received the code? Send again',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF7F3DFF),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Continue button at bottom
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 50),
              child: SizedBox(
                width: 343,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isAllFieldsFilled() ? _verifyCode : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isAllFieldsFilled()
                        ? const Color(0xFF7F3DFF)
                        : const Color(0xFFEEE5FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          'Verify',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: _isAllFieldsFilled() ? Colors.white : const Color(0xFF91919F),
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isAllFieldsFilled() {
    return _controllers.every((controller) => controller.text.isNotEmpty);
  }

  void _verifyCode() async {
    if (!_isAllFieldsFilled()) return;

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SetupPinScreen()),
      );
    }
  }

  void _resendCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Verification code sent to ${widget.email}',
          style: GoogleFonts.inter(),
        ),
        backgroundColor: Colors.green,
      ),
    );
    
    _startResendTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }
}
