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
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Income', 'Expense'];

  @override
  void initState() {
    super.initState();
    // Reload transactions when page opens
    context.read<TransactionBloc>().add(LoadTransactions());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Transactions',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF212325),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF7F3DFF)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.add, color: Color(0xFF7F3DFF)),
            onSelected: (value) {
              if (value == 'income') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddIncomeScreen()),
                ).then((_) => context.read<TransactionBloc>().add(LoadTransactions()));
              } else if (value == 'expense') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
                ).then((_) => context.read<TransactionBloc>().add(LoadTransactions()));
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'income',
                child: Row(
                  children: [
                    const Icon(Icons.add, color: Color(0xFF00A86B)),
                    const SizedBox(width: 8),
                    Text('Add Income', style: GoogleFonts.inter()),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'expense',
                child: Row(
                  children: [
                    const Icon(Icons.remove, color: Color(0xFFFD3C4A)),
                    const SizedBox(width: 8),
                    Text('Add Expense', style: GoogleFonts.inter()),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter Tabs
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: _filters.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedFilter = filter;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? const Color(0xFF7F3DFF) 
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            filter,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isSelected 
                                  ? Colors.white 
                                  : const Color(0xFF91919F),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Transactions List
          Expanded(
            child: BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                if (state is TransactionLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF7F3DFF)),
                  );
                } else if (state is TransactionLoaded) {
                  List<Transaction> filteredTransactions = state.transactions;
                  
                  if (_selectedFilter != 'All') {
                    filteredTransactions = state.transactions
                        .where((t) => t.type == _selectedFilter.toLowerCase())
                        .toList();
                  }

                  if (filteredTransactions.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'No transactions yet',
                            style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start adding your income and expenses',
                            style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final transaction = filteredTransactions[index];
                      return _buildTransactionItem(transaction);
                    },
                  );
                }
                return const Center(child: Text('No transactions available'));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Transaction transaction) {
    final isIncome = transaction.type == 'income';
    final formattedDate = DateFormat('MMM dd, yyyy').format(transaction.date);
    
    return Dismissible(
      key: Key(transaction.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 24),
      ),
      onDismissed: (direction) {
        context.read<TransactionBloc>().add(DeleteTransaction(transaction.id));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${transaction.title} deleted'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F1FA)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Category Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isIncome 
                    ? Colors.green.withOpacity(0.1) 
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getCategoryIcon(transaction.category),
                color: isIncome ? Colors.green : Colors.red,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            // Transaction Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF212325),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        transaction.category,
                        style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF91919F)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFF91919F),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formattedDate,
                        style: GoogleFonts.inter(fontSize: 12, color: const Color(0xFF91919F)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Amount
            Text(
              '${isIncome ? '+' : '-'}\$${transaction.amount.toStringAsFixed(2)}',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isIncome ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_bag;
      case 'entertainment':
        return Icons.movie;
      case 'bills':
        return Icons.receipt;
      case 'health':
        return Icons.local_hospital;
      case 'education':
        return Icons.school;
      case 'travel':
        return Icons.flight;
      case 'salary':
        return Icons.work;
      case 'business':
        return Icons.business;
      case 'investment':
        return Icons.trending_up;
      default:
        return Icons.category;
    }
  }
}
