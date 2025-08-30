import 'package:equatable/equatable.dart';

class Transaction extends Equatable {
  final String id;
  final String title;
  final double amount;
  final String type; // 'income' or 'expense'
  final String category;
  final DateTime date;
  
  const Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
  });
  
  // ✅ Add these missing getters
  bool get isExpense => type.toLowerCase() == 'expense';
  bool get isIncome => type.toLowerCase() == 'income';
  
  // Format amount for display
  String get formattedAmount => '\$${amount.toStringAsFixed(2)}';
  
  // Get formatted amount with sign
  String get signedAmount {
    final sign = isIncome ? '+' : '-';
    return '$sign$formattedAmount';
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'type': type,
      'category': category,
      'date': date.toIso8601String(),
    };
  }
  
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] as String,
      category: json['category'] as String,
      date: DateTime.parse(json['date'] as String),
    );
  }
  
  // Copy method for updating transactions
  Transaction copyWith({
    String? id,
    String? title,
    double? amount,
    String? type,
    String? category,
    DateTime? date,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      category: category ?? this.category,
      date: date ?? this.date,
    );
  }
  
  @override
  List<Object?> get props => [id, title, amount, type, category, date];
  
  @override
  String toString() {
    return 'Transaction(id: $id, title: $title, amount: $amount, type: $type, category: $category, date: $date)';
  }
}
