import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/transaction_bloc.dart';
import '../models/transaction.dart';

class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({super.key});

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'Salary';
  bool _repeatTransaction = false;

  final List<String> _incomeCategories = [
    'Salary',
    'Business',
    'Investment',
    'Freelance',
    'Gift',
    'Bonus',
    'Other',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _addIncome() {
    if (_formKey.currentState?.validate() ?? false) {
      final transaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        amount: double.parse(_amountController.text),
        type: 'income',
        category: _selectedCategory,
        date: DateTime.now(),
      );

      context.read<TransactionBloc>().add(AddTransaction(transaction));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Income added successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00A86B),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
            child: Column(
              children: [
                // Top Navigation
                Container(
                  height: 64,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back arrow
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFFFFFFFF),
                          size: 24,
                        ),
                      ),
                      // Title
                      Text(
                        'Income',
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFFFFFFF),
                        ),
                      ),
                      // Placeholder for balance
                      const SizedBox(width: 24),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // How much section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'How much?',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFFCFCFC).withOpacity(0.64),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Currency and amount input
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '₹',
                        style: GoogleFonts.inter(
                          fontSize: 64,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFFFCFCFC),
                        ),
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: GoogleFonts.inter(
                            fontSize: 64,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFFCFCFC),
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: '0',
                            hintStyle: TextStyle(
                              color: Color(0xFFFCFCFC),
                              fontSize: 64,
                              fontWeight: FontWeight.w600,
                            ),
                            contentPadding: EdgeInsets.zero,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter an amount';
                            }
                            if (double.tryParse(value) == null || double.parse(value) <= 0) {
                              return 'Please enter a valid amount';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                // White bottom sheet
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 24),
                            // Category dropdown
                            Container(
                              width: 343,
                              height: 56,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                border: Border.all(color: const Color(0xFFF1F1FA)),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedCategory,
                                    hint: Text(
                                      'Category',
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        color: const Color(0xFF91919F),
                                      ),
                                    ),
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Color(0xFF91919F),
                                    ),
                                    items: _incomeCategories.map((category) {
                                      return DropdownMenuItem(
                                        value: category,
                                        child: Text(
                                          category,
                                          style: GoogleFonts.inter(
                                            fontSize: 16,
                                            color: const Color(0xFF91919F),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedCategory = value!;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Description input
                            Container(
                              width: 343,
                              height: 56,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                border: Border.all(color: const Color(0xFFF1F1FA)),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: TextFormField(
                                  controller: _titleController,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: const Color(0xFF212325),
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Write a description...',
                                    hintStyle: GoogleFonts.inter(
                                      fontSize: 16,
                                      color: const Color(0xFF91919F),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter a description';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Wallet dropdown
                            Container(
                              width: 343,
                              height: 56,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                border: Border.all(color: const Color(0xFFF1F1FA)),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Wallet',
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        color: const Color(0xFF91919F),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Color(0xFF91919F),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Attachment field
                            Container(
                              width: 343,
                              height: 56,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFFFFF),
                                border: Border.all(
                                  color: const Color(0xFFF1F1FA),
                                  style: BorderStyle.solid,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.attach_file,
                                      color: Color(0xFF91919F),
                                      size: 24,
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Add attachment',
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        color: const Color(0xFF91919F),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Repeat transaction switch
                            Container(
                              width: 343,
                              height: 59,
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Repeat',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF292B2D),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Repeat transaction',
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF91919F),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Switch(
                                    value: _repeatTransaction,
                                    onChanged: (value) {
                                      setState(() {
                                        _repeatTransaction = value;
                                      });
                                    },
                                    activeColor: const Color(0xFFFCFCFC),
                                    activeTrackColor: const Color(0xFFEEE5FF),
                                    inactiveThumbColor: const Color(0xFFFCFCFC),
                                    inactiveTrackColor: const Color(0xFFEEE5FF),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            // Continue button
                            Container(
                              width: 343,
                              height: 56,
                              margin: const EdgeInsets.only(bottom: 40),
                              child: ElevatedButton(
                                onPressed: _addIncome,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF7F3DFF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                child: Text(
                                  'Continue',
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFFCFCFC),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
