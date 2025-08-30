import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../bloc/transaction_bloc.dart';
import '../models/transaction.dart';
import 'add_expense_screen.dart';
import 'add_income_screen.dart';
import 'transaction_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String _selectedPeriod = 'Today';

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );
    // Load transactions when dashboard opens
    context.read<TransactionBloc>().add(LoadTransactions());
  }

  // ✅ FIXED: Refresh dashboard when returning from other screens
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload transactions whenever the dashboard becomes visible
    context.read<TransactionBloc>().add(LoadTransactions());
  }

  void _navigateToTransactions() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TransactionPage(),
      ),
    ).then((_) {
      // ✅ FIXED: Reload transactions when returning from transaction page
      if (mounted) {
        context.read<TransactionBloc>().add(LoadTransactions());
      }
    });
  }

  // ✅ FIXED: Navigate to add screens with proper refresh
  void _navigateToAddExpense() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
    ).then((_) {
      // Refresh dashboard when returning from add expense
      if (mounted) {
        context.read<TransactionBloc>().add(LoadTransactions());
      }
    });
  }

  void _navigateToAddIncome() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddIncomeScreen()),
    ).then((_) {
      // Refresh dashboard when returning from add income
      if (mounted) {
        context.read<TransactionBloc>().add(LoadTransactions());
      }
    });
  }

  void _selectPeriod(String period) {
    setState(() {
      _selectedPeriod = period;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Navigation with gradient background
            Container(
              width: screenWidth,
              height: 312,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.0, -1.0),
                  end: Alignment(0.0, 1.2427),
                  colors: [
                    Color(0xFFFFF6E6),
                    Color(0x00F8EDD8),
                  ],
                  stops: [0.0956, 1.2427],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // Top Navigation Bar
                      Container(
                        height: 64,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Avatar
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFF5F5F5),
                                    offset: const Offset(0, 0),
                                    blurRadius: 0,
                                    spreadRadius: 2,
                                  ),
                                  BoxShadow(
                                    color: const Color(0xFFAD00FF),
                                    offset: const Offset(0, 0),
                                    blurRadius: 0,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Color(0xFF7F3DFF),
                                size: 20,
                              ),
                            ),

                            // Month Dropdown
                            Container(
                              width: 107,
                              height: 40,
                              decoration: BoxDecoration(
                                border: Border.all(color: const Color(0xFFF1F1FA)),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Color(0xFF7F3DFF),
                                    size: 24,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Month',
                                    style: GoogleFonts.inter(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF212325),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Notification Icon
                            SizedBox(
                              width: 32,
                              height: 32,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: const Icon(
                                  Icons.notifications_outlined,
                                  color: Color(0xFF7F3DFF),
                                  size: 24,
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Account Balance
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Text(
                              'Account Balance',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF91919F),
                              ),
                            ),
                            const SizedBox(height: 8),
                            BlocBuilder<TransactionBloc, TransactionState>(
                              builder: (context, state) {
                                if (state is TransactionLoaded) {
                                  return AutoSizeText(
                                    '₹${state.balance.toStringAsFixed(0)}',
                                    style: GoogleFonts.inter(
                                      fontSize: 40,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF161719),
                                    ),
                                    maxLines: 1,
                                    minFontSize: 24,
                                    maxFontSize: 40,
                                    textAlign: TextAlign.center,
                                  );
                                }
                                return AutoSizeText(
                                  '₹0',
                                  style: GoogleFonts.inter(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF161719),
                                  ),
                                  maxLines: 1,
                                  minFontSize: 24,
                                  maxFontSize: 40,
                                  textAlign: TextAlign.center,
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      // Income and Expense Cards
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          children: [
                            // Income Card
                            Expanded(
                              child: BlocBuilder<TransactionBloc, TransactionState>(
                                builder: (context, state) {
                                  double income = 0;
                                  if (state is TransactionLoaded) {
                                    income = state.totalIncome;
                                  }
                                  return _buildIncomeExpenseCard(
                                    'Income',
                                    income,
                                    const Color(0xFF00A86B),
                                    Icons.trending_up,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Expense Card
                            Expanded(
                              child: BlocBuilder<TransactionBloc, TransactionState>(
                                builder: (context, state) {
                                  double expense = 0;
                                  if (state is TransactionLoaded) {
                                    expense = state.totalExpense;
                                  }
                                  return _buildIncomeExpenseCard(
                                    'Expenses',
                                    expense,
                                    const Color(0xFFFD3C4A),
                                    Icons.trending_down,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Graph Section (placeholder)
            SizedBox(
              width: screenWidth,
              height: 185.5,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    top: 16,
                    child: Container(
                      width: screenWidth,
                      height: 169.5,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0x3D8B50FF),
                            Color(0x008B50FF),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    top: 16,
                    child: Container(
                      width: screenWidth,
                      height: 140,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF7F3DFF),
                          width: 6,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tabs
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 14),
              height: 34,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFFCFCFC)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTab('Today', _selectedPeriod == 'Today'),
                  _buildTab('Week', _selectedPeriod == 'Week'),
                  _buildTab('Month', _selectedPeriod == 'Month'),
                  _buildTab('Year', _selectedPeriod == 'Year'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Spend Frequency Header with floating action button
            Container(
              width: screenWidth,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFFFFFFFF),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Transactions',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF292B2D),
                    ),
                  ),
                  GestureDetector(
                    onTap: _navigateToTransactions,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEEE5FF),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Text(
                        'See All',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF7F3DFF),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ✅ FIXED: Recent transactions list (all types, not just expenses)
            BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                if (state is TransactionLoading) {
                  return const SizedBox(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF7F3DFF),
                      ),
                    ),
                  );
                } else if (state is TransactionLoaded) {
                  return _buildRecentTransactionsList(state);
                } else if (state is TransactionError) {
                  return _buildErrorState(state.message);
                } else {
                  return _buildEmptyState();
                }
              },
            ),

            // Quick Add Buttons
            Container(
              width: screenWidth,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _navigateToAddExpense,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFD3C4A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.remove, size: 20),
                      label: Text(
                        'Add Expense',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _navigateToAddIncome,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A86B),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      icon: const Icon(Icons.add, size: 20),
                      label: Text(
                        'Add Income',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100), // Space for bottom navigation
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeExpenseCard(String title, double amount, Color color, IconData icon) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFFCFCFC),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFFCFCFC),
                    ),
                  ),
                  const SizedBox(height: 4),
                  AutoSizeText(
                    '₹${amount.toStringAsFixed(0)}',
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFFCFCFC),
                    ),
                    maxLines: 1,
                    minFontSize: 14,
                    maxFontSize: 22,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String text, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _selectPeriod(text),
        child: Container(
          height: 34,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFCEED4) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? const Color(0xFFFCAC12) : const Color(0xFF91919F),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ✅ FIXED: Show recent transactions (all types) matching transaction page
  Widget _buildRecentTransactionsList(TransactionLoaded state) {
    if (state.transactions.isEmpty) {
      return _buildEmptyTransactions();
    }

    // Sort all transactions by date (newest first) and take recent 5
    final recentTransactions = state.transactions
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    
    final displayTransactions = recentTransactions.take(5).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 19),
          itemCount: displayTransactions.length,
          itemBuilder: (context, index) {
            final transaction = displayTransactions[index];
            return _buildTransactionItem(transaction);
          },
        ),
      ],
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    final isIncome = transaction.type == 'income';
    final formattedTime = DateFormat('hh:mm a').format(transaction.date);
    
    // Get category icon and background color
    IconData categoryIcon;
    Color backgroundColor;
    Color iconColor;
    
    switch (transaction.category.toLowerCase()) {
      case 'shopping':
        categoryIcon = Icons.shopping_bag;
        backgroundColor = const Color(0xFFFCEED4);
        iconColor = const Color(0xFFFCAC12);
        break;
      case 'subscription':
      case 'recurring bill':
      case 'bills':
        categoryIcon = Icons.receipt;
        backgroundColor = const Color(0xFFEEE5FF);
        iconColor = const Color(0xFF7F3DFF);
        break;
      case 'food':
      case 'restaurant':
        categoryIcon = Icons.restaurant;
        backgroundColor = const Color(0xFFFDD5D7);
        iconColor = const Color(0xFFFD3C4A);
        break;
      case 'salary':
      case 'income':
        categoryIcon = Icons.work;
        backgroundColor = const Color(0xFFCFFAEA);
        iconColor = const Color(0xFF00A86B);
        break;
      case 'transportation':
      case 'transport':
        categoryIcon = Icons.directions_car;
        backgroundColor = const Color(0xFFBDDCFF);
        iconColor = const Color(0xFF0077FF);
        break;
      default:
        categoryIcon = isIncome ? Icons.trending_up : Icons.category;
        backgroundColor = isIncome ? const Color(0xFFCFFAEA) : const Color(0xFFFCEED4);
        iconColor = isIncome ? const Color(0xFF00A86B) : const Color(0xFFFCAC12);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFCFC),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                categoryIcon,
                color: iconColor,
                size: 40,
              ),
            ),
            const SizedBox(width: 12),
            
            // Transaction Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    transaction.category,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF292B2D),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    transaction.title,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF91919F),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // Amount and Time
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoSizeText(
                  '${isIncome ? '+' : '-'} ₹${transaction.amount.toStringAsFixed(0)}',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isIncome ? const Color(0xFF00A86B) : const Color(0xFFFD3C4A),
                  ),
                  maxLines: 1,
                  minFontSize: 12,
                  maxFontSize: 16,
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 4),
                Text(
                  formattedTime,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF91919F),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyTransactions() {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'No transactions yet',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start adding your income and expenses',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading transactions',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.red[600],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                message,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.red[500],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<TransactionBloc>().add(LoadTransactions());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7F3DFF),
              ),
              child: Text(
                'Retry',
                style: GoogleFonts.inter(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SizedBox(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Welcome to Expense Tracker',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start tracking your expenses today!',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
