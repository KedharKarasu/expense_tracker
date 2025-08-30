import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'add_new_account_screen.dart';

class SetupAccountScreen extends StatefulWidget {
  const SetupAccountScreen({super.key});

  @override
  State<SetupAccountScreen> createState() => _SetupAccountScreenState();
}

class _SetupAccountScreenState extends State<SetupAccountScreen> {
  final TextEditingController _accountNameController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Stack(
          children: [
            // Title
            Positioned(
              left: 16,
              top: 111,
              width: 343,
              height: 88,
              child: Text(
                'Let\'s setup your account!',
                style: GoogleFonts.inter(
                  fontSize: 36,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF212325),
                  height: 44/36,
                ),
              ),
            ),

            // Description Text
            Positioned(
              left: 16,
              top: 236,
              width: 276,
              height: 36,
              child: Text(
                'Account can be your bank, credit card or your wallet.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF292B2D),
                  height: 18/14,
                ),
              ),
            ),

            // Account Name Input Field
            Positioned(
              left: 16,
              top: 300,
              right: 16,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  border: Border.all(color: const Color(0xFFF1F1FA)),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextFormField(
                  controller: _accountNameController,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Name',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF91919F),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),

            // Continue Button
            Positioned(
              left: 16,
              top: 706,
              width: 343,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _confirmAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7F3DFF),
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
                        'Continue',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFFCFCFC),
                        ),
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
      ),
    );
  }

  void _confirmAccount() async {
    if (_accountNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter an account name',
            style: GoogleFonts.inter(),
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

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
        MaterialPageRoute(builder: (context) => const AddNewAccountScreen()),
      );
    }
  }

  @override
  void dispose() {
    _accountNameController.dispose();
    super.dispose();
  }
}
