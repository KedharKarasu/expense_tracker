import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../bloc/auth_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF7F3DFF),
              ),
            ),
          );
        }

        final User? user = snapshot.data;
        
        return Scaffold(
          backgroundColor: const Color(0xFFFFFFFF),
          body: SafeArea(
            child: Stack(
              children: [
                // Background Gray Area
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 150,
                  child: Container(
                    color: const Color(0xFFF7F7F7),
                  ),
                ),
                // Profile Image with double border
                Positioned(
                  top: 74,
                  left: 34,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF5F5F5),
                          offset: const Offset(0, 0),
                          blurRadius: 0,
                          spreadRadius: 4,
                        ),
                        BoxShadow(
                          color: const Color(0xFFAD00FF),
                          offset: const Offset(0, 0),
                          blurRadius: 0,
                          spreadRadius: 6,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: const Color(0xFFC4C4C4),
                      child: Text(
                        _getUserInitial(user),
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                // Username Text
                Positioned(
                  left: 133,
                  top: 87,
                  child: Text(
                    'Username',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF91919F),
                    ),
                  ),
                ),
                // Display Name
                Positioned(
                  left: 133,
                  top: 112,
                  child: Text(
                    _getUserDisplayName(user),
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF161719),
                    ),
                  ),
                ),
                // Edit Button
                Positioned(
                  right: 16,
                  top: 92,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFF1F1FA)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: Color(0xFF212325),
                        size: 20,
                      ),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Edit profile feature coming soon!'),
                            backgroundColor: Color(0xFF7F3DFF),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Menu Items Container
                Positioned(
                  left: 20,
                  top: 194,
                  child: Column(
                    children: [
                      _buildMenuItem(
                        width: 336,
                        height: 89,
                        icon: Icons.account_balance_wallet,
                        iconBackground: const Color(0xFFEEE5FF),
                        iconColor: const Color(0xFF7F3DFF),
                        title: 'Account',
                        isFirst: true,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Account settings coming soon!'),
                              backgroundColor: Color(0xFF7F3DFF),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        width: 336,
                        height: 89,
                        icon: Icons.settings,
                        iconBackground: const Color(0xFFEEE5FF),
                        iconColor: const Color(0xFF7F3DFF),
                        title: 'Settings',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Settings coming soon!'),
                              backgroundColor: Color(0xFF7F3DFF),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        width: 336,
                        height: 89,
                        icon: Icons.upload_file_outlined,
                        iconBackground: const Color(0xFFEEE5FF),
                        iconColor: const Color(0xFF7F3DFF),
                        title: 'Export Data',
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Export data feature coming soon!'),
                              backgroundColor: Color(0xFF7F3DFF),
                            ),
                          );
                        },
                      ),
                      _buildMenuItem(
                        width: 336,
                        height: 89,
                        icon: Icons.logout,
                        iconBackground: const Color(0xFFFFE2E4),
                        iconColor: const Color(0xFFFD3C4A),
                        title: 'Logout',
                        isLast: true,
                        onTap: () {
                          _showLogoutDialog(context); // ✅ Enhanced logout
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<User?> _getCurrentUser() async {
    try {
      return FirebaseAuth.instance.currentUser;
    } catch (e) {
      return null;
    }
  }

  String _getUserInitial(User? user) {
    if (user?.displayName?.isNotEmpty == true) {
      return user!.displayName![0].toUpperCase();
    }
    if (user?.email?.isNotEmpty == true) {
      return user!.email![0].toUpperCase();
    }
    return 'U';
  }

  String _getUserDisplayName(User? user) {
    return user?.displayName ?? 
           user?.email?.split('@')[0] ?? 
           'User';
  }

  Widget _buildMenuItem({
    required double width,
    required double height,
    required IconData icon,
    required Color iconBackground,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: isFirst
            ? const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              )
            : isLast
                ? const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  )
                : BorderRadius.zero,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, -1),
            blurRadius: 0,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: isFirst
              ? const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                )
              : isLast
                  ? const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    )
                  : BorderRadius.zero,
          child: Padding(
            padding: const EdgeInsets.all(17),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: iconBackground,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF292B2D),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFF91919F),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ✅ Enhanced logout dialog with proper navigation
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Logout',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Are you sure you want to logout? You will be redirected to the sign-in page.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: const Color(0xFF91919F),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF91919F),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog first
                _handleLogout(context); // ✅ Trigger logout
              },
              child: Text(
                'Logout',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFFFD3C4A),
                ),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        );
      },
    );
  }

  // ✅ Handle logout - triggers AuthBloc event
void _handleLogout(BuildContext context) {
  // Close any loading dialog first
  Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst);

    // Dispatch logout event to AuthBloc
    context.read<AuthBloc>().add(SignOutRequested());
    
    // The BlocListener in AuthWrapper will handle navigation
    // when AuthSignedOut state is emitted
  }
}
