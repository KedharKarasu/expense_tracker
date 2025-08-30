import '../models/transaction.dart';

abstract class TransactionEvent {}

class AddTransaction extends TransactionEvent {
  final Transaction transaction;
  
  AddTransaction(this.transaction);
}

class LoadTransactions extends TransactionEvent {}

class DeleteTransaction extends TransactionEvent {
  final String transactionId;
  
  DeleteTransaction(this.transactionId);
}

class EditTransaction extends TransactionEvent {
  final Transaction transaction;
  
  EditTransaction(this.transaction);
}
