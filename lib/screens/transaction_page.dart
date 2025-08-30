import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/transaction_bloc.dart';
import 'add_income_screen.dart';
import 'add_expense_screen.dart';
import '../models/transaction.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  @override
  void initState() {
    super.initState();
    context.read<TransactionBloc>().add(LoadTransactions());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            // Status Bar - Keep existing for safety
            Container(
              height: 44,
              width: 375,
              color: const Color(0xFFFFFFFF),
              child: const SizedBox.shrink(),
            ),
            
            // Top Navigation - Exact CSS Match
            Container(
              width: 375,
              height: 64,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFFFFFFFF),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Month Dropdown (Left)
                  Container(
                    width: 96,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFF1F1FA)),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
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
                  ),
                  
                  // Sort Button (Right)
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFF1F1FA)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.sort,
                        color: Color(0xFF212325),
                        size: 24,
                      ),
                      onPressed: () {
                        // Add sort functionality
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            // Financial Report Bar - Exact CSS Match
            Container(
              width: 375,
              height: 64,
              padding: const EdgeInsets.all(8),
              child: Container(
                width: 343,
                height: 48,
                padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEE5FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'See your financial report',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF7F3DFF),
                      ),
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Color(0xFF7F3DFF),
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Transactions List - Scrollable Content
            Expanded(
              child: BlocBuilder<TransactionBloc, TransactionState>(
                builder: (context, state) {
                  if (state is TransactionLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF7F3DFF),
                      ),
                    );
                  } else if (state is TransactionLoaded) {
                    if (state.transactions.isEmpty) {
                      return _buildEmptyState();
                    }
                    
                    // Group transactions by date
                    return _buildTransactionsList(state.transactions);
                  } else if (state is TransactionError) {
                    return _buildErrorState(state.message);
                  }
                  return _buildEmptyState();
                },
              ),
            ),
          ],
        ),
      ),
      
      // ✅ REMOVED: No floatingActionButton property = No FAB
      // floatingActionButton: Container(...), // REMOVED THIS
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked, // REMOVED THIS
    );
  }

  Widget _buildTransactionsList(List<Transaction> transactions) {
    // Group by date for section headers
    Map<String, List<Transaction>> groupedTransactions = {};
    
    for (var transaction in transactions) {
      String dateKey = DateFormat('yyyy-MM-dd').format(transaction.date);
      String displayDate;
      
      DateTime now = DateTime.now();
      DateTime yesterday = now.subtract(const Duration(days: 1));
      
      if (DateFormat('yyyy-MM-dd').format(now) == dateKey) {
        displayDate = 'Today';
      } else if (DateFormat('yyyy-MM-dd').format(yesterday) == dateKey) {
        displayDate = 'Yesterday';
      } else {
        displayDate = DateFormat('MMMM d, yyyy').format(transaction.date);
      }
      
      if (!groupedTransactions.containsKey(displayDate)) {
        groupedTransactions[displayDate] = [];
      }
      groupedTransactions[displayDate]!.add(transaction);
    }

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: groupedTransactions.length,
      itemBuilder: (context, index) {
        String dateKey = groupedTransactions.keys.elementAt(index);
        List<Transaction> dayTransactions = groupedTransactions[dateKey]!;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date Header - Exact CSS Match
            Container(
              width: 375,
              height: 48,
              padding: const EdgeInsets.all(8),
              color: const Color(0xFFFFFFFF),
              child: Container(
                width: 359,
                height: 32,
                padding: const EdgeInsets.all(8),
                child: Text(
                  dateKey,
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0D0E0F),
                  ),
                ),
              ),
            ),
            
            // Transaction Cards for this date
            ...dayTransactions.map((transaction) => _buildTransactionCard(transaction)),
          ],
        );
      },
    );
  }

  Widget _buildTransactionCard(Transaction transaction) {
    final isIncome = transaction.type == 'income';
    final formattedTime = DateFormat('hh:mm a').format(transaction.date);
    
    // Get category icon and colors based on transaction category
    Map<String, dynamic> categoryData = _getCategoryData(transaction.category, isIncome);
    
    return Container(
      width: 336,
      height: 89,
      margin: const EdgeInsets.fromLTRB(19, 0, 19, 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFCFC),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Row(
          children: [
            // Icon Container - Exact CSS Match
            Container(
              width: 60,
              height: 60,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: categoryData['backgroundColor'],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                categoryData['icon'],
                color: categoryData['iconColor'],
                size: 40,
              ),
            ),
            
            const SizedBox(width: 9),
            
            // Transaction Details - Exact CSS Match
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    transaction.category,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF292B2D),
                    ),
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
            
            const SizedBox(width: 9),
            
            // Amount and Time - Exact CSS Match
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${isIncome ? '+' : '-'} ₹${transaction.amount.toStringAsFixed(0)}',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isIncome ? const Color(0xFF00A86B) : const Color(0xFFFD3C4A),
                  ),
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

  Map<String, dynamic> _getCategoryData(String category, bool isIncome) {
    switch (category.toLowerCase()) {
      case 'shopping':
        return {
          'icon': Icons.shopping_bag,
          'backgroundColor': const Color(0xFFFCEED4),
          'iconColor': const Color(0xFFFCAC12),
        };
      case 'subscription':
      case 'bills':
        return {
          'icon': Icons.receipt,
          'backgroundColor': const Color(0xFFEEE5FF),
          'iconColor': const Color(0xFF7F3DFF),
        };
      case 'food':
      case 'restaurant':
        return {
          'icon': Icons.restaurant,
          'backgroundColor': const Color(0xFFFDD5D7),
          'iconColor': const Color(0xFFFD3C4A),
        };
      case 'salary':
        return {
          'icon': Icons.work,
          'backgroundColor': const Color(0xFFCFFAEA),
          'iconColor': const Color(0xFF00A86B),
        };
      case 'transportation':
      case 'car':
        return {
          'icon': Icons.directions_car,
          'backgroundColor': const Color(0xFFBDDCFF),
          'iconColor': const Color(0xFF0077FF),
        };
      default:
        return {
          'icon': isIncome ? Icons.trending_up : Icons.trending_down,
          'backgroundColor': isIncome ? const Color(0xFFCFFAEA) : const Color(0xFFFDD5D7),
          'iconColor': isIncome ? const Color(0xFF00A86B) : const Color(0xFFFD3C4A),
        };
    }
  }

  Widget _buildEmptyState() {
    return Center(
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
          const SizedBox(height: 20),
          // Add buttons here instead of FAB
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddIncomeScreen()),
                  ).then((_) => context.read<TransactionBloc>().add(LoadTransactions()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00A86B),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.add, size: 20),
                label: const Text('Add Income'),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
                  ).then((_) => context.read<TransactionBloc>().add(LoadTransactions()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFD3C4A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.remove, size: 20),
                label: const Text('Add Expense'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
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
    );
  }
}
