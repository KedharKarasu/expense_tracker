import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup_success_screen.dart';

class AddNewAccountScreen extends StatefulWidget {
  const AddNewAccountScreen({super.key});

  @override
  State<AddNewAccountScreen> createState() => _AddNewAccountScreenState();
}

class _AddNewAccountScreenState extends State<AddNewAccountScreen> {
  final TextEditingController _accountNameController = TextEditingController();
  String? _selectedBank;
  bool _isLoading = false;

  final List<String> _banks = [
    'State Bank of India',
    'HDFC Bank',
    'ICICI Bank',
    'Axis Bank',
    'Punjab National Bank',
    'Bank of Baroda',
    'Kotak Mahindra Bank',
    'Yes Bank',
    'IndusInd Bank',
    'Canara Bank',
    'Union Bank of India',
    'IDBI Bank',
    'Central Bank of India',
    'Indian Bank',
    'Bank of India',
    'UCO Bank',
    'Indian Overseas Bank',
    'Federal Bank',
    'South Indian Bank',
    'Karnataka Bank',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Container(color: const Color(0xFF7F3DFF)),
          ),

          // Top Navigation
          Positioned(
            left: 0,
            top: 44,
            width: 375,
            height: 64,
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white, size: 16),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Add new account',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 32),
                ],
              ),
            ),
          ),

          // Balance Section
          Positioned(
            left: (375 - 179) / 2,
            top: 188,
            width: 179,
            height: 112,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Balance',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withAlpha((0.64 * 255).round()),
                  ),
                ),
                const SizedBox(height: 13),
                Text(
                  '₹00.0',
                  style: GoogleFonts.inter(
                    fontSize: 64,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // White Bottom Sheet
          Positioned(
            left: 0,
            top: 514,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Account Name Input
                  TextFormField(
                    controller: _accountNameController,
                    decoration: InputDecoration(
                      hintText: 'Name',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 16,
                        color: const Color(0xFF91919F),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFF1F1FA)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFF1F1FA)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    style: GoogleFonts.inter(fontSize: 16),
                    onChanged: (value) => setState(() {}),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Bank Selection Dropdown
                  DropdownButtonFormField<String>(
                    initialValue: _selectedBank,
                    decoration: InputDecoration(
                      hintText: 'Select Bank',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 16,
                        color: const Color(0xFF91919F),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFF1F1FA)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFF1F1FA)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    style: GoogleFonts.inter(fontSize: 16, color: Colors.black),
                    icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF91919F)),
                    items: _banks.map((bank) {
                      return DropdownMenuItem<String>(
                        value: bank,
                        child: Text(bank, style: GoogleFonts.inter(fontSize: 16)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedBank = value;
                      });
                    },
                  ),
                  
                  const Spacer(),
                  
                  // Continue Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: (_accountNameController.text.isNotEmpty && _selectedBank != null)
                          ? _addAccount
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: (_accountNameController.text.isNotEmpty && _selectedBank != null)
                            ? const Color(0xFF7F3DFF)
                            : const Color(0xFFEEE5FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : Text(
                              'Continue',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: (_accountNameController.text.isNotEmpty && _selectedBank != null)
                                    ? Colors.white
                                    : const Color(0xFF91919F),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _addAccount() async {
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
        MaterialPageRoute(builder: (context) => const SignUpSuccessScreen()),
      );
    }
  }

  @override
  void dispose() {
    _accountNameController.dispose();
    super.dispose();
  }
}
