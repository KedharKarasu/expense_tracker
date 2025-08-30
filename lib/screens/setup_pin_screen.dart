import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'setup_account_screen.dart';

class SetupPinScreen extends StatefulWidget {
  const SetupPinScreen({super.key});

  @override
  State<SetupPinScreen> createState() => _SetupPinScreenState();
}

class _SetupPinScreenState extends State<SetupPinScreen> {
  final List<String> _pin = ['', '', '', ''];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Rectangle
          Positioned(
            left: -1,
            top: 0,
            width: 376,
            height: 812,
            child: Container(
              color: const Color(0xFF7F3DFF), // Violet background
            ),
          ),

          // Title
          Positioned(
            left: 108,
            top: 90,
            width: 178,
            height: 22,
            child: Text(
              'Let\'s setup your PIN',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: const Color(0xFFFCFCFC),
              ),
            ),
          ),

          // PIN Circle Group
          Positioned(
            left: 100,
            top: 204,
            width: 176,
            height: 32,
            child: Row(
              children: List.generate(4, (index) {
                return Container(
                  width: 32,
                  height: 32,
                  margin: EdgeInsets.only(right: index < 3 ? 16 : 0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _pin[index].isNotEmpty 
                        ? const Color(0xFFFCFCFC) // White when filled
                        : Colors.transparent,
                    border: Border.all(
                      color: const Color(0xFFEEE5FF).withOpacity(0.4),
                      width: 4,
                    ),
                  ),
                );
              }),
            ),
          ),

          // Custom Keyboard
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 271.46,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x85939393),
                    Color(0x87565659),
                  ],
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 5.6),
                  _buildKeyboardRow(['1', '2', '3']),
                  const SizedBox(height: 7.46),
                  _buildKeyboardRow(['4', '5', '6']),
                  const SizedBox(height: 7.46),
                  _buildKeyboardRow(['7', '8', '9']),
                  const SizedBox(height: 7.46),
                  _buildKeyboardRow(['', '0', 'delete']),
                  const SizedBox(height: 24.25),
                ],
              ),
            ),
          ),

          // Home Indicator
          Positioned(
            left: 0,
            right: 0,
            bottom: 0.46,
            height: 24.25,
            child: Center(
              child: Container(
                width: 134.33,
                height: 4.66,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(93.28),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyboardRow(List<String> keys) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.6),
      child: Row(
        children: keys.map((key) {
          return Expanded(
            child: key.isEmpty 
                ? const SizedBox()
                : GestureDetector(
                    onTap: () => _onKeyTap(key),
                    child: Container(
                      height: 42.91,
                      margin: const EdgeInsets.symmetric(horizontal: 2.8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.29),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.35),
                            offset: const Offset(0, 0.93),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Center(
                        child: key == 'delete'
                            ? const Icon(
                                Icons.backspace_outlined,
                                color: Colors.black,
                                size: 22.37,
                              )
                            : Text(
                                key,
                                style: GoogleFonts.inter(
                                  fontSize: 23.32,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                      ),
                    ),
                  ),
          );
        }).toList(),
      ),
    );
  }

  void _onKeyTap(String key) {
    setState(() {
      if (key == 'delete') {
        if (_currentIndex > 0) {
          _currentIndex--;
          _pin[_currentIndex] = '';
        }
      } else {
        if (_currentIndex < 4) {
          _pin[_currentIndex] = key;
          _currentIndex++;
          
          if (_currentIndex == 4) {
            _onPinComplete();
          }
        }
      }
    });
  }

  void _onPinComplete() async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SetupAccountScreen()),
      );
    }
  }
}
