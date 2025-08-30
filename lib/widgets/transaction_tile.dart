
import 'package:flutter/material.dart';
import '../models/transaction.dart';

class TransactionTile extends StatelessWidget {
  final Transaction tx;
  const TransactionTile({super.key, required this.tx});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: tx.isIncome ? Colors.green : Colors.red,
        child: Icon(tx.isIncome ? Icons.arrow_downward : Icons.arrow_upward, color: Colors.white),
      ),
      title: Text(tx.title),
      subtitle: Text('${tx.category} • ${tx.date.toLocal().toString().split(' ')[0]}'),
      trailing: Text(
        '${tx.isIncome ? '+' : '-'}\$${tx.amount.toStringAsFixed(2)}',
        style: TextStyle(color: tx.isIncome ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
      ),
    );
  }
}
