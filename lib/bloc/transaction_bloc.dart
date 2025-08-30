import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/transaction.dart';

// Events
abstract class TransactionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTransactions extends TransactionEvent {}

class AddTransaction extends TransactionEvent {
  final Transaction transaction;
  AddTransaction(this.transaction);
  @override
  List<Object?> get props => [transaction];
}

class DeleteTransaction extends TransactionEvent {
  final String id;
  DeleteTransaction(this.id);
  @override
  List<Object?> get props => [id];
}

// States
abstract class TransactionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<Transaction> transactions;
  final double totalIncome;
  final double totalExpense;
  final double balance;
  
  TransactionLoaded({
    required this.transactions,
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
  });
  
  @override
  List<Object?> get props => [transactions, totalIncome, totalExpense, balance];
}

class TransactionError extends TransactionState {
  final String message;
  TransactionError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc() : super(TransactionInitial()) {
    on<LoadTransactions>(_onLoadTransactions);
    on<AddTransaction>(_onAddTransaction);
    on<DeleteTransaction>(_onDeleteTransaction);
  }
  
  Future<void> _onLoadTransactions(LoadTransactions event, Emitter<TransactionState> emit) async {
    emit(TransactionLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final transactionsJson = prefs.getString('transactions') ?? '[]';
      final List<dynamic> transactionsList = json.decode(transactionsJson);
      
      final transactions = transactionsList.map((json) => Transaction.fromJson(json)).toList();
      final totalIncome = transactions.where((t) => t.type == 'income').fold(0.0, (sum, t) => sum + t.amount);
      final totalExpense = transactions.where((t) => t.type == 'expense').fold(0.0, (sum, t) => sum + t.amount);
      final balance = totalIncome - totalExpense;
      
      emit(TransactionLoaded(
        transactions: transactions,
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        balance: balance,
      ));
    } catch (e) {
      emit(TransactionError('Failed to load transactions: $e'));
    }
  }
  
  Future<void> _onAddTransaction(AddTransaction event, Emitter<TransactionState> emit) async {
    if (state is TransactionLoaded) {
      final currentState = state as TransactionLoaded;
      final updatedTransactions = List<Transaction>.from(currentState.transactions)..add(event.transaction);
      await _saveTransactions(updatedTransactions);
      
      final totalIncome = updatedTransactions.where((t) => t.type == 'income').fold(0.0, (sum, t) => sum + t.amount);
      final totalExpense = updatedTransactions.where((t) => t.type == 'expense').fold(0.0, (sum, t) => sum + t.amount);
      final balance = totalIncome - totalExpense;
      
      emit(TransactionLoaded(
        transactions: updatedTransactions,
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        balance: balance,
      ));
    }
  }
  
  Future<void> _onDeleteTransaction(DeleteTransaction event, Emitter<TransactionState> emit) async {
    if (state is TransactionLoaded) {
      final currentState = state as TransactionLoaded;
      final updatedTransactions = currentState.transactions.where((t) => t.id != event.id).toList();
      await _saveTransactions(updatedTransactions);
      
      final totalIncome = updatedTransactions.where((t) => t.type == 'income').fold(0.0, (sum, t) => sum + t.amount);
      final totalExpense = updatedTransactions.where((t) => t.type == 'expense').fold(0.0, (sum, t) => sum + t.amount);
      final balance = totalIncome - totalExpense;
      
      emit(TransactionLoaded(
        transactions: updatedTransactions,
        totalIncome: totalIncome,
        totalExpense: totalExpense,
        balance: balance,
      ));
    }
  }
  
  Future<void> _saveTransactions(List<Transaction> transactions) async {
    final prefs = await SharedPreferences.getInstance();
    final transactionsJson = json.encode(transactions.map((t) => t.toJson()).toList());
    await prefs.setString('transactions', transactionsJson);
  }
}
