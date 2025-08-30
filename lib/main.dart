import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'bloc/transaction_bloc.dart';
import 'bloc/auth_bloc.dart';
import 'screens/dashboard_page.dart';
import 'screens/transaction_page.dart';
import 'screens/add_expense_screen.dart';
import 'screens/add_income_screen.dart';
import 'screens/profile_page.dart';
import 'screens/onboarding_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => TransactionBloc()),
        BlocProvider(create: (context) => AuthBloc()),
      ],
      child: MaterialApp(
        title: 'Expense Tracker',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          fontFamily: GoogleFonts.inter().fontFamily,
        ),
        home: const AuthenticationWrapper(), // ✅ Uses AuthenticationWrapper
        debugShowCheckedModeBanner: false,
        // Optional: Define named routes for navigation
        routes: {
          '/dashboard': (context) => const MainScreen(),
          '/onboarding': (context) => const OnboardingScreen(),
        },
      ),
    );
  }
}

// ✅ CRITICAL: AuthenticationWrapper handles login state
class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // ✅ Show loading only briefly during initialization
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF7F3DFF),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Loading...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // ✅ User authenticated - show main app
        if (snapshot.hasData && snapshot.data != null) {
          print('✅ User authenticated: ${snapshot.data!.uid}');
          return const MainScreen();
        } 
        
        // ✅ User not authenticated - show onboarding
        else {
          print('❌ User not authenticated - showing onboarding');
          return const OnboardingScreen();
        }
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [],
    );
    
    _pages = [
      const DashboardPage(),      // Index 0 - Home
      const TransactionPage(),    // Index 1 - Transaction  
      Container(                  // Index 2 - Budget (placeholder)
        color: Colors.blue[50],
        child: const Center(
          child: Text(
            'Budget Page Coming Soon!', 
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
        ),
      ), 
      const ProfilePage(),        // Index 3 - Profile
    ];
  }

  void _onItemTapped(int index) {
    // Handle the middle "+" button (index 2 in navigation)
    if (index == 2) {
      _showAddOptions();
      return;
    }
    
    // Map navigation indices to page indices
    // Navigation: Home(0), Transaction(1), Add(2), Budget(3), Profile(4)  
    // Pages:     Home(0), Transaction(1),           Budget(2), Profile(3)
    int pageIndex;
    if (index < 2) {
      pageIndex = index; // Home=0, Transaction=1
    } else {
      pageIndex = index - 1; // Budget=2, Profile=3
    }
    
    // Safety check to prevent index out of bounds
    if (pageIndex >= 0 && pageIndex < _pages.length) {
      setState(() {
        _selectedIndex = pageIndex;
      });
    }
  }

  void _showAddOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.add, color: Colors.green),
              ),
              title: const Text('Add Income'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddIncomeScreen()),
                );
              },
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.remove, color: Colors.red),
              ),
              title: const Text('Add Expense'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
          color: Color(0xFFFCFCFC),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home, 'Home'),
            _buildNavItem(1, Icons.swap_horiz, 'Transaction'),
            _buildAddButton(),
            _buildNavItem(3, Icons.pie_chart, 'Budget'),
            _buildNavItem(4, Icons.person, 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    // Determine if this nav item is selected
    bool isSelected = false;
    if (index == 0 && _selectedIndex == 0) isSelected = true;      // Home
    if (index == 1 && _selectedIndex == 1) isSelected = true;      // Transaction
    if (index == 3 && _selectedIndex == 2) isSelected = true;      // Budget
    if (index == 4 && _selectedIndex == 3) isSelected = true;      // Profile
    
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF7F3DFF) : const Color(0xFFC6C6C6),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isSelected ? const Color(0xFF7F3DFF) : const Color(0xFFC6C6C6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: () => _onItemTapped(2),
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          color: Color(0xFF7F3DFF),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
