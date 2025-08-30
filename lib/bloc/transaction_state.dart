import '../models/transaction.dart';

class TransactionState {
  final List<Transaction> transactions;
  final bool isLoading;
  final String? errorMessage;

  TransactionState({
    required this.transactions,
    this.isLoading = false,
    this.errorMessage,
  });

  factory TransactionState.empty() {
    return TransactionState(transactions: []);
  }

  TransactionState copyWith({
    List<Transaction>? transactions,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  // Calculate total income
  double get totalIncome {
    return transactions
        .where((tx) => !tx.isExpense)
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  // Calculate total expenses
  double get totalExpense {
    return transactions
        .where((tx) => tx.isExpense)
        .fold(0.0, (sum, tx) => sum + tx.amount);
  }

  // Calculate current balance
  double get currentBalance {
    return totalIncome - totalExpense;
  }
}
